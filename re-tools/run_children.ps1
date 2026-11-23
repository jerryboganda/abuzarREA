# Lists the child controls of the top-level windows of the rebuilt application (class, position, visible, caption of
# buttons and labels only - never the text of edit fields).  -Click "<caption>" presses the button with that caption
# in the window titled -Window (window message, no focus change).
param(
  [string]$Folder = 'C:\Projects\Abuzar\pbrun',
  [string]$Window = '',
  [string]$Click = ''
)
Add-Type @"
using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public class Kid {
  public delegate bool EnumProc(IntPtr hWnd, IntPtr lParam);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr lParam);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr parent, EnumProc cb, IntPtr lParam);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr hWnd);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetWindowText(IntPtr hWnd, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetClassName(IntPtr hWnd, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr hWnd, uint msg, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT r);
  public struct RECT { public int Left, Top, Right, Bottom; }
  public static List<IntPtr> Top(uint pid) {
    var res = new List<IntPtr>();
    EnumWindows((h, l) => { uint p; GetWindowThreadProcessId(h, out p); if (p == pid && IsWindowVisible(h)) res.Add(h); return true; }, IntPtr.Zero);
    return res;
  }
  public static List<IntPtr> Kids(IntPtr parent) {
    var res = new List<IntPtr>();
    EnumChildWindows(parent, (h, l) => { res.Add(h); return true; }, IntPtr.Zero);
    return res;
  }
  public static string Text(IntPtr h) { var s = new StringBuilder(300); GetWindowText(h, s, 300); return s.ToString(); }
  public static string Class(IntPtr h) { var s = new StringBuilder(100); GetClassName(h, s, 100); return s.ToString(); }
}
"@
$full = (Resolve-Path $Folder).Path.TrimEnd('\')
$p = Get-Process abuzar -ErrorAction SilentlyContinue | Where-Object { $_.Path -and $_.Path.StartsWith($full, [StringComparison]::OrdinalIgnoreCase) } | Select-Object -First 1
if (-not $p) { 'not running'; exit 1 }
foreach ($w in [Kid]::Top([uint32]$p.Id)) {
  $title = [Kid]::Text($w)
  if ($Window -and $title -ne $Window) { continue }
  $wr = New-Object Kid+RECT; [Kid]::GetWindowRect($w, [ref]$wr) | Out-Null
  "window '$title' class=$([Kid]::Class($w))"
  foreach ($k in [Kid]::Kids($w)) {
    $c = [Kid]::Class($k)
    $r = New-Object Kid+RECT; [Kid]::GetWindowRect($k, [ref]$r) | Out-Null
    $t = if ($c -match 'Edit') { '<edit>' } else { [Kid]::Text($k) }
    if ($Click) {
      if ($c -match 'Button' -and (($t -replace '&','') -eq $Click)) { [Kid]::PostMessage($k, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null; "  clicked '$t'" }
    } else {
      "  $c visible=$([Kid]::IsWindowVisible($k)) at $($r.Left - $wr.Left),$($r.Top - $wr.Top) $($r.Right - $r.Left)x$($r.Bottom - $r.Top) '$t'"
    }
  }
}
