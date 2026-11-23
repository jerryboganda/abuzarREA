# Lists the top-level windows of the rebuilt application (the abuzar.exe that runs from the given folder, never the
# vendor's copy) and saves a picture of each without bringing it to the front (PrintWindow).
#   powershell -File run_shot.ps1 -Folder C:\Projects\Abuzar\pbrun -Out C:\Projects\Abuzar\pbtest\shots\run
param(
  [string]$Folder = 'C:\Projects\Abuzar\pbrun',
  [string]$Out = 'C:\Projects\Abuzar\pbtest\shots\run'
)
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public class WinList {
  public delegate bool EnumProc(IntPtr hWnd, IntPtr lParam);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr lParam);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr hWnd);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetWindowText(IntPtr hWnd, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetClassName(IntPtr hWnd, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT r);
  [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr hWnd, IntPtr hdc, uint flags);
  public struct RECT { public int Left, Top, Right, Bottom; }
  public static List<IntPtr> Of(uint pid) {
    var res = new List<IntPtr>();
    EnumWindows((h, l) => { uint p; GetWindowThreadProcessId(h, out p); if (p == pid && IsWindowVisible(h)) res.Add(h); return true; }, IntPtr.Zero);
    return res;
  }
}
"@
$full = (Resolve-Path $Folder).Path.TrimEnd('\')
$procs = Get-Process abuzar -ErrorAction SilentlyContinue | Where-Object { $_.Path -and $_.Path.StartsWith($full, [StringComparison]::OrdinalIgnoreCase) }
if (-not $procs) { 'not running'; exit 0 }
New-Item -ItemType Directory -Force (Split-Path -Parent $Out) | Out-Null
$i = 0
foreach ($p in $procs) {
  "process $($p.Id) responding=$($p.Responding) memory=$([math]::Round($p.WorkingSet64/1MB,1))MB started=$($p.StartTime.ToString('HH:mm:ss'))"
  foreach ($h in [WinList]::Of([uint32]$p.Id)) {
    $t = New-Object System.Text.StringBuilder 300; [WinList]::GetWindowText($h, $t, 300) | Out-Null
    $c = New-Object System.Text.StringBuilder 100; [WinList]::GetClassName($h, $c, 100) | Out-Null
    $r = New-Object WinList+RECT; [WinList]::GetWindowRect($h, [ref]$r) | Out-Null
    $w = $r.Right - $r.Left; $ht = $r.Bottom - $r.Top
    $file = ''
    if ($w -gt 0 -and $ht -gt 0) {
      $bmp = New-Object System.Drawing.Bitmap $w, $ht
      $g = [System.Drawing.Graphics]::FromImage($bmp)
      $hdc = $g.GetHdc()
      [WinList]::PrintWindow($h, $hdc, 2) | Out-Null
      $g.ReleaseHdc($hdc); $g.Dispose()
      $file = "$Out-$i.png"
      $bmp.Save($file, [System.Drawing.Imaging.ImageFormat]::Png); $bmp.Dispose()
      $i++
    }
    "  window $h class=$($c.ToString()) title='$($t.ToString())' rect=$($r.Left),$($r.Top) ${w}x$ht $file"
  }
}
