# Open a menu path in the running original app and list every window/control it creates.
# Read-only: sends WM_COMMAND and enumerates; never clicks OK/Cancel.
#   powershell -File old-open.ps1 -Path "Maintenance|Preferences" -Out x.png -Json x.json
param(
  [Parameter(Mandatory=$true)][string]$Path,
  [string]$Out = '',
  [string]$Json = '',
  [int]$WaitSec = 5
)
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public class OldOpen {
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr p, EnumProc cb, IntPtr l);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int n);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr SendMessage(IntPtr h, uint msg, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr h, uint msg, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr GetMenu(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetMenuItemCount(IntPtr m);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetMenuString(IntPtr m, uint i, StringBuilder s, int n, uint flags);
  [DllImport("user32.dll")] public static extern uint GetMenuItemID(IntPtr m, int i);
  [DllImport("user32.dll")] public static extern IntPtr GetSubMenu(IntPtr m, int i);
  public struct RECT { public int Left, Top, Right, Bottom; }
  public static string Text(IntPtr h) { var s = new StringBuilder(2048); GetWindowText(h, s, s.Capacity); return s.ToString(); }
  public static string Class(IntPtr h) { var s = new StringBuilder(256); GetClassName(h, s, s.Capacity); return s.ToString(); }
  public static string Rect(IntPtr h) { RECT r; if (!GetWindowRect(h, out r)) return ""; return string.Format("{0},{1} {2}x{3}", r.Left, r.Top, r.Right-r.Left, r.Bottom-r.Top); }
  public static List<IntPtr> Tops(uint pid) { var r = new List<IntPtr>(); EnumWindows((h,l)=>{uint p;GetWindowThreadProcessId(h,out p); if(p==pid) r.Add(h); return true;}, IntPtr.Zero); return r; }
  public static List<IntPtr> Kids(IntPtr p) { var r = new List<IntPtr>(); EnumChildWindows(p,(h,l)=>{r.Add(h);return true;},IntPtr.Zero); return r; }
  public static void Click(IntPtr h) { SendMessage(h, 0x00F5, IntPtr.Zero, IntPtr.Zero); }
}
"@
function Norm([string]$s) { return ($s -replace '&','' -replace '\s+',' ').Trim().ToLowerInvariant() }
function Resolve-Menu([IntPtr]$h, [string[]]$parts) {
  $menu = [OldOpen]::GetMenu($h)
  if ($menu -eq [IntPtr]::Zero) { throw 'no menu' }
  $cur = $menu
  for ($p = 0; $p -lt $parts.Count; $p++) {
    $want = Norm $parts[$p]
    $count = [OldOpen]::GetMenuItemCount($cur)
    $found = -1
    for ($i = 0; $i -lt $count; $i++) {
      $sb = New-Object Text.StringBuilder 512
      [OldOpen]::GetMenuString($cur, [uint32]$i, $sb, 512, 0x400) | Out-Null
      if ((Norm $sb.ToString()) -eq $want) { $found = $i; break }
    }
    if ($found -lt 0) {
      $names = @()
      for ($i = 0; $i -lt $count; $i++) { $sb = New-Object Text.StringBuilder 512; [OldOpen]::GetMenuString($cur, [uint32]$i, $sb, 512, 0x400) | Out-Null; $names += (Norm $sb.ToString()) }
      throw "menu part '$($parts[$p])' not found; have: $($names -join ', ')"
    }
    if ($p -eq $parts.Count - 1) { return [OldOpen]::GetMenuItemID($cur, $found) }
    $sub = [OldOpen]::GetSubMenu($cur, $found)
    if ($sub -eq [IntPtr]::Zero) { throw "menu part '$($parts[$p])' has no submenu" }
    $cur = $sub
  }
}
$proc = Get-Process abuzar -ErrorAction Stop | Select-Object -First 1
$h = $proc.MainWindowHandle
if ($h -eq [IntPtr]::Zero) { throw 'main window handle is zero' }
[OldOpen]::ShowWindow($h, 9) | Out-Null
[OldOpen]::SetForegroundWindow($h) | Out-Null
Start-Sleep -Milliseconds 400
$parts = $Path -split '\|' | ForEach-Object { $_.Trim() }
$id = Resolve-Menu $h $parts
"resolved id=$id path=$($parts -join ' > ')"
# PostMessage, not SendMessage: a modal SQL error dialog keeps the menu
# handler in a nested loop, so SendMessage would block this helper forever.
[OldOpen]::PostMessage($h, 0x0111, [IntPtr]$id, [IntPtr]::Zero) | Out-Null
"posted WM_COMMAND $id"
Start-Sleep -Seconds $WaitSec
$tops = [OldOpen]::Tops([uint32]$proc.Id) | Where-Object { [OldOpen]::IsWindowVisible($_) }
$result = @()
foreach ($t in $tops) {
  $title = [OldOpen]::Text($t)
  $cls = [OldOpen]::Class($t)
  $kids = [OldOpen]::Kids($t) | ForEach-Object {
    [pscustomobject]@{ hwnd = [int64]$_; class = [OldOpen]::Class($_); text = [OldOpen]::Text($_); rect = [OldOpen]::Rect($_); visible = [OldOpen]::IsWindowVisible($_) }
  }
  $result += [pscustomobject]@{ hwnd = [int64]$t; class = $cls; title = $title; rect = [OldOpen]::Rect($t); controls = @($kids) }
}
$result | ConvertTo-Json -Depth 6
if ($Json) { $result | ConvertTo-Json -Depth 6 | Set-Content -Encoding utf8 $Json; "wrote $Json" }
if ($Out) {
  $target = $result | Where-Object { $_.class -ne 'FNWND3125' -and $_.title -notmatch 'WASEELA' } | Select-Object -First 1
  if (-not $target) { $target = $result | Select-Object -First 1 }
  $r = New-Object OldOpen+RECT
  [OldOpen]::GetWindowRect([IntPtr]$target.hwnd, [ref]$r) | Out-Null
  $w = $r.Right - $r.Left; $ht = $r.Bottom - $r.Top
  if ($w -gt 0 -and $ht -gt 0) {
    $bmp = New-Object System.Drawing.Bitmap $w, $ht
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen($r.Left, $r.Top, 0, 0, (New-Object System.Drawing.Size $w, $ht))
    $bmp.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
    "saved $Out ($w x $ht) from '$($target.title)'"
  }
}
