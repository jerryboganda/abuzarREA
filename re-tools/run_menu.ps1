# Menu of the rebuilt application's main window (the abuzar.exe running from -Folder, never the vendor's copy).
#   -List                      prints every menu item as  Top/Sub/Item  [id] (grayed items are marked)
#   -Invoke "Sales/Cash Sale"  chooses that item by posting its command to the window (no keyboard, no focus change)
param(
  [string]$Folder = 'C:\Projects\Abuzar\pbrun',
  [switch]$List,
  [string]$Invoke = ''
)
Add-Type @"
using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public class Menu {
  [DllImport("user32.dll")] public static extern IntPtr GetMenu(IntPtr hWnd);
  [DllImport("user32.dll")] public static extern IntPtr GetSubMenu(IntPtr hMenu, int pos);
  [DllImport("user32.dll")] public static extern int GetMenuItemCount(IntPtr hMenu);
  [DllImport("user32.dll")] public static extern uint GetMenuItemID(IntPtr hMenu, int pos);
  [DllImport("user32.dll")] public static extern uint GetMenuState(IntPtr hMenu, uint id, uint flags);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetMenuString(IntPtr hMenu, uint id, StringBuilder s, int n, uint flags);
  [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr hWnd, uint msg, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern IntPtr SendMessage(IntPtr hWnd, uint msg, IntPtr w, IntPtr l);
  public static void Walk(IntPtr m, string path, List<string[]> res) {
    int n = GetMenuItemCount(m);
    for (int i = 0; i < n; i++) {
      var s = new StringBuilder(200); GetMenuString(m, (uint)i, s, 200, 0x400);
      string t = s.ToString().Replace("&", ""); int tab = t.IndexOf('\t'); if (tab >= 0) t = t.Substring(0, tab);
      if (t.Length == 0) continue;
      uint st = GetMenuState(m, (uint)i, 0x400);
      IntPtr sub = GetSubMenu(m, i);
      string p = path.Length > 0 ? path + "/" + t : t;
      if (sub != IntPtr.Zero) { SendMessage(IntPtr.Zero, 0, IntPtr.Zero, IntPtr.Zero); Walk(sub, p, res); }
      else res.Add(new string[] { p, GetMenuItemID(m, i).ToString(), ((st & 3) != 0) ? "grayed" : "" });
    }
  }
}
"@
$full = (Resolve-Path $Folder).Path.TrimEnd('\')
$p = Get-Process abuzar -ErrorAction SilentlyContinue | Where-Object { $_.Path -and $_.Path.StartsWith($full, [StringComparison]::OrdinalIgnoreCase) } | Select-Object -First 1
if (-not $p) { 'not running'; exit 1 }
$h = $p.MainWindowHandle
$m = [Menu]::GetMenu($h)
if ($m -eq [IntPtr]::Zero) { 'the main window has no menu'; exit 1 }
$items = New-Object 'System.Collections.Generic.List[string[]]'
[Menu]::Walk($m, '', $items)
if ($List) { "menu items: $($items.Count)"; $items | ForEach-Object { "$($_[0])  [$($_[1])] $($_[2])" } }
if ($Invoke) {
  $hit = $items | Where-Object { $_[0] -eq $Invoke } | Select-Object -First 1
  if (-not $hit) { "no menu item '$Invoke'"; exit 1 }
  if ($hit[2]) { "menu item '$Invoke' is grayed"; exit 1 }
  [Menu]::PostMessage($h, 0x0111, [IntPtr][int]$hit[1], [IntPtr]::Zero) | Out-Null
  "chosen: $Invoke [$($hit[1])]"
}
