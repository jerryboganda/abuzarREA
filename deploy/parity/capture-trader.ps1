param([string]$Out='C:\Projects\Abuzar\deploy\parity\real\50-trader-desktop.png')
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class W {
 [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
 [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
 public struct RECT { public int Left,Top,Right,Bottom; }
}
"@
$p=Get-Process trader-desktop -ErrorAction Stop | Select-Object -First 1
$h=$p.MainWindowHandle
[W]::SetForegroundWindow($h) | Out-Null
Start-Sleep -Milliseconds 800
$r=New-Object W+RECT
[W]::GetWindowRect($h,[ref]$r) | Out-Null
$w=$r.Right-$r.Left; $ht=$r.Bottom-$r.Top
$bmp=New-Object System.Drawing.Bitmap $w,$ht
$g=[System.Drawing.Graphics]::FromImage($bmp)
$g.CopyFromScreen($r.Left,$r.Top,0,0,(New-Object System.Drawing.Size $w,$ht))
$bmp.Save($Out,[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose();$bmp.Dispose()
"title=$($p.MainWindowTitle) rect=$($r.Left),$($r.Top) ${w}x${ht} -> $Out"
