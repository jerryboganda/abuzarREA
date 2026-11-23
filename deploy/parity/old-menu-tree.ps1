# Dump the original app's current Win32 menu tree (text, command ID, state).
# Read-only.
Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
public class MTree {
  [DllImport("user32.dll")] public static extern IntPtr GetMenu(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr GetSubMenu(IntPtr m, int i);
  [DllImport("user32.dll")] public static extern int GetMenuItemCount(IntPtr m);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetMenuString(IntPtr m, uint i, StringBuilder s, int n, uint f);
  [DllImport("user32.dll")] public static extern uint GetMenuItemID(IntPtr m, int i);
  [DllImport("user32.dll")] public static extern uint GetMenuState(IntPtr m, uint id, uint f);
}
"@
$p = Get-Process abuzar -ErrorAction Stop | Select-Object -First 1
$m = [MTree]::GetMenu($p.MainWindowHandle)
function Dump([IntPtr]$m, [int]$depth) {
  if ($m -eq [IntPtr]::Zero) { return }
  $c = [MTree]::GetMenuItemCount($m)
  for ($i = 0; $i -lt $c; $i++) {
    $sb = New-Object Text.StringBuilder 512
    [MTree]::GetMenuString($m, [uint32]$i, $sb, 512, 0x400) | Out-Null
    $id = [MTree]::GetMenuItemID($m, $i)
    $st = if ($id -ne 4294967295) { [MTree]::GetMenuState($m, $id, 0) } else { 0 }
    ('  ' * $depth) + $sb.ToString() + " [id=$id state=0x$('{0:X}' -f $st)]"
    $sub = [MTree]::GetSubMenu($m, $i)
    if ($sub -ne [IntPtr]::Zero) { Dump $sub ($depth + 1) }
  }
}
Dump $m 0
