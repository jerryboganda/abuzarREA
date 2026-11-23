# Enumerate the windows/controls of the running original app and optionally click a button.
# Read-only except for the explicit -ClickButton action.
#   powershell -File win-enum.ps1                  # all top-level windows + child controls
#   powershell -File win-enum.ps1 -TitleLike Report
#   powershell -File win-enum.ps1 -ClickButton Ok -InTitleLike "Select Format"
param(
  [string]$TitleLike = '',
  [string]$ClickButton = '',
  [string]$InTitleLike = ''
)
Add-Type @"
using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public class W32 {
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr p, EnumProc cb, IntPtr l);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern IntPtr SendMessage(IntPtr h, uint msg, IntPtr w, IntPtr l);
  public struct RECT { public int Left, Top, Right, Bottom; }
  public static string Text(IntPtr h) { var s = new StringBuilder(1024); GetWindowText(h, s, s.Capacity); return s.ToString(); }
  public static string Class(IntPtr h) { var s = new StringBuilder(256); GetClassName(h, s, s.Capacity); return s.ToString(); }
  public static List<IntPtr> Tops(uint pid) {
    var r = new List<IntPtr>();
    EnumWindows((h, l) => { uint p; GetWindowThreadProcessId(h, out p); if (p == pid) r.Add(h); return true; }, IntPtr.Zero);
    return r;
  }
  public static List<IntPtr> Kids(IntPtr p) {
    var r = new List<IntPtr>();
    EnumChildWindows(p, (h, l) => { r.Add(h); return true; }, IntPtr.Zero);
    return r;
  }
  public static string Rect(IntPtr h) { RECT r; if (!GetWindowRect(h, out r)) return ""; return string.Format("{0},{1} {2}x{3}", r.Left, r.Top, r.Right-r.Left, r.Bottom-r.Top); }
  public static void Click(IntPtr h) { SendMessage(h, 0x00F5, IntPtr.Zero, IntPtr.Zero); }
}
"@
$p = Get-Process abuzar -ErrorAction Stop | Select-Object -First 1
$tops = [W32]::Tops([uint32]$p.Id)
$selected = @()
foreach ($h in $tops) {
  $t = [W32]::Text($h)
  if ($TitleLike -and $t -notlike "*$TitleLike*") { continue }
  if (-not [W32]::IsWindowVisible($h)) { continue }
  $selected += $h
  "TOP hwnd=$h class=$([W32]::Class($h)) rect=$([W32]::Rect($h)) text=$t"
  $kids = [W32]::Kids($h)
  foreach ($k in $kids) {
    $kt = [W32]::Text($k)
    $kc = [W32]::Class($k)
    if (-not $kt -and $kc -notmatch 'Button|Edit|ComboBox') { continue }
    if (-not [W32]::IsWindowVisible($k)) { continue }
    "  hwnd=$k class=$kc rect=$([W32]::Rect($k)) text=$kt"
  }
}
if ($ClickButton) {
  foreach ($h in $selected) {
    if ($InTitleLike -and ([W32]::Text($h) -notlike "*$InTitleLike*")) { continue }
    foreach ($k in [W32]::Kids($h)) {
      $kt = [W32]::Text($k)
      $kc = [W32]::Class($k)
      if ($kt -eq $ClickButton -and $kc -match 'Button') {
        [W32]::Click($k)
        "CLICKED hwnd=$k '$kt' in '$([W32]::Text($h))'"
        return
      }
    }
  }
  "NO BUTTON '$ClickButton' found"
}
