# Dismiss the original app's modal message boxes by clicking their OK buttons.
# Prints every dialog text it sees. Read-only apart from dismissing the boxes.
param([int]$Max = 40)
Add-Type @"
using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public class DlgDismiss {
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr p, EnumProc cb, IntPtr l);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr SendMessage(IntPtr h, uint msg, IntPtr w, IntPtr l);
  public static string Text(IntPtr h) { var s = new StringBuilder(2048); GetWindowText(h, s, s.Capacity); return s.ToString(); }
  public static string Class(IntPtr h) { var s = new StringBuilder(256); GetClassName(h, s, s.Capacity); return s.ToString(); }
  public static List<IntPtr> Tops(uint pid) { var r = new List<IntPtr>(); EnumWindows((h,l)=>{uint p;GetWindowThreadProcessId(h,out p); if(p==pid) r.Add(h); return true;}, IntPtr.Zero); return r; }
  public static List<IntPtr> Kids(IntPtr p) { var r = new List<IntPtr>(); EnumChildWindows(p,(h,l)=>{r.Add(h);return true;},IntPtr.Zero); return r; }
  public static void Click(IntPtr h) { SendMessage(h, 0x00F5, IntPtr.Zero, IntPtr.Zero); }
}
"@
$p = Get-Process abuzar -ErrorAction Stop | Select-Object -First 1
for ($n = 0; $n -lt $Max; $n++) {
  $clicked = $false
  foreach ($t in [DlgDismiss]::Tops([uint32]$p.Id)) {
    if (-not [DlgDismiss]::IsWindowVisible($t)) { continue }
    if ([DlgDismiss]::Class($t) -ne '#32770') { continue }
    $kids = [DlgDismiss]::Kids($t)
    $texts = @()
    $ok = $null
    foreach ($k in $kids) {
      $kt = [DlgDismiss]::Text($k)
      $kc = [DlgDismiss]::Class($k)
      if ($kt) { $texts += $kt }
      if ($kc -match 'Button' -and $kt -eq 'OK') { $ok = $k }
    }
    "DIALOG '$([DlgDismiss]::Text($t))': $($texts -join ' | ')"
    if ($ok) {
      [DlgDismiss]::Click($ok)
      $clicked = $true
      Start-Sleep -Milliseconds 350
      break
    }
  }
  if (-not $clicked) { "done after $n dialogs"; return }
}
"stopped after $Max dialogs"
