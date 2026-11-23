# Logs in to the rebuilt application (the abuzar.exe running from -Folder, never the vendor's copy) by window messages:
# no keyboard input, no focus change.  The user name and password are read at run time from the local helper
# deploy\login.ps1 (its parameter defaults); they are not stored here and not printed.
param(
  [string]$Folder = 'C:\Projects\Abuzar\pbrun',
  [string]$Source = 'C:\Projects\Abuzar\deploy\login.ps1'
)
Add-Type @"
using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public class Msg {
  public delegate bool EnumProc(IntPtr hWnd, IntPtr lParam);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr lParam);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr parent, EnumProc cb, IntPtr lParam);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr hWnd);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetWindowText(IntPtr hWnd, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetClassName(IntPtr hWnd, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern IntPtr SendMessage(IntPtr hWnd, uint msg, IntPtr w, string l);
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
$src = Get-Content -Raw $Source
$user = [regex]::Match($src, "\`$User\s*=\s*'([^']*)'").Groups[1].Value
$pass = [regex]::Match($src, "\`$Pass\s*=\s*'([^']*)'").Groups[1].Value
if (-not $user -or -not $pass) { 'no login found in the helper'; exit 1 }
$full = (Resolve-Path $Folder).Path.TrimEnd('\')
$p = Get-Process abuzar -ErrorAction SilentlyContinue | Where-Object { $_.Path -and $_.Path.StartsWith($full, [StringComparison]::OrdinalIgnoreCase) } | Select-Object -First 1
if (-not $p) { 'not running'; exit 1 }
$login = [Msg]::Top([uint32]$p.Id) | Where-Object { [Msg]::Text($_) -eq 'Login' } | Select-Object -First 1
if (-not $login) { 'no Login window'; exit 1 }
# The two fields are columns of a DataWindow: one edit box, placed on the current column.  Text goes in as characters,
# Tab moves to the next column.
function Get-Field {
  foreach ($k in [Msg]::Kids($login)) {
    if ([Msg]::Class($k) -match 'Edit' -and [Msg]::IsWindowVisible($k)) { return $k }
  }
  return [IntPtr]::Zero
}
function Send-Text([IntPtr]$h, [string]$text) {
  [Msg]::PostMessage($h, 0x00B1, [IntPtr]::Zero, [IntPtr](-1)) | Out-Null       # EM_SETSEL: replace what is there
  foreach ($ch in $text.ToCharArray()) { [Msg]::PostMessage($h, 0x0102, [IntPtr][int]$ch, [IntPtr]1) | Out-Null; Start-Sleep -Milliseconds 30 }
}
$ok = [Msg]::Kids($login) | Where-Object { [Msg]::Class($_) -match 'Button' -and (([Msg]::Text($_) -replace '&','') -eq 'Ok') } | Select-Object -First 1
$f = Get-Field
if ($f -eq [IntPtr]::Zero -or -not $ok) { 'Login window: field or Ok button not found'; exit 1 }
Send-Text $f $user
Start-Sleep -Milliseconds 200
[Msg]::PostMessage($f, 0x0100, [IntPtr]9, [IntPtr]0x000F0001) | Out-Null        # WM_KEYDOWN Tab
[Msg]::PostMessage($f, 0x0101, [IntPtr]9, [IntPtr]0xC00F0001) | Out-Null        # WM_KEYUP
Start-Sleep -Milliseconds 500
$f2 = Get-Field
if ($f2 -eq [IntPtr]::Zero) { 'no field after Tab'; exit 1 }
Send-Text $f2 $pass
Start-Sleep -Milliseconds 300
[Msg]::PostMessage($ok, 0x00F5, [IntPtr]::Zero, [IntPtr]::Zero) | Out-Null      # BM_CLICK
'login sent'
