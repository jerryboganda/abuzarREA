# Read-only scan of the running original app for job-name strings.
$src = @"
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;

public class MemScan {
  [DllImport("kernel32.dll", SetLastError=true)] static extern IntPtr OpenProcess(uint access, bool inherit, int pid);
  [DllImport("kernel32.dll", SetLastError=true)] static extern bool CloseHandle(IntPtr h);
  [DllImport("kernel32.dll", SetLastError=true)] static extern bool ReadProcessMemory(IntPtr h, IntPtr addr, byte[] buf, IntPtr size, out IntPtr read);
  [DllImport("kernel32.dll", SetLastError=true)] static extern IntPtr VirtualQueryEx(IntPtr h, IntPtr addr, out MBI mbi, IntPtr len);

  [StructLayout(LayoutKind.Sequential)]
  public struct MBI {
    public IntPtr BaseAddress;
    public IntPtr AllocationBase;
    public uint AllocationProtect;
    public uint __a1;
    public UIntPtr RegionSize;
    public uint State;
    public uint Protect;
    public uint Type;
    public uint __a2;
  }

  static string Clean(string s) {
    var sb = new StringBuilder();
    foreach (var ch in s) {
      if (ch >= 32 && ch < 127) sb.Append(ch);
      else if (ch == '\t') sb.Append(' ');
    }
    return sb.ToString().Trim();
  }

  public static List<string> Scan(int pid) {
    var found = new List<string>();
    var seen = new HashSet<string>();
    IntPtr h = OpenProcess(0x0010 | 0x0400, false, pid);
    if (h == IntPtr.Zero) { found.Add("OPEN_FAILED " + Marshal.GetLastWin32Error()); return found; }
    try {
      IntPtr addr = IntPtr.Zero;
      long max = 0x7FFFFFFFFFFF;
      while ((long)addr < max) {
        MBI m;
        IntPtr q = VirtualQueryEx(h, addr, out m, (IntPtr)Marshal.SizeOf(typeof(MBI)));
        if (q == IntPtr.Zero) break;
        long baseAddr = (long)m.BaseAddress;
        long size = (long)m.RegionSize;
        addr = (IntPtr)(baseAddr + size);
        if (m.State != 0x1000 || size <= 0) continue;
        uint p = m.Protect;
        if ((p & 0x01) != 0 || (p & 0x100) != 0) continue; // noaccess / guard
        if (size > 64L * 1024 * 1024) continue;
        byte[] buf = new byte[size];
        IntPtr read;
        if (!ReadProcessMemory(h, m.BaseAddress, buf, (IntPtr)size, out read)) continue;
        int n = (int)read;
        // UTF-16LE
        for (int i = 0; i + 18 < n; i += 2) {
          if (buf[i] != 0x42 || buf[i+1] != 0x00) continue; // 'B'
          string s = Encoding.Unicode.GetString(buf, i, Math.Min(160, n - i));
          s = Clean(s);
          int cut = s.Length;
          for (int k = 0; k < s.Length; k++) { if (!(char.IsLetterOrDigit(s[k]) || s[k]==' ' || s[k]=='_' || s[k]=='-' || s[k]=='.' || s[k]=='(' || s[k]==')')) { cut = k; break; } }
          s = s.Substring(0, cut).Trim();
          if (s.Length >= 5 && s.Length <= 80 && s.IndexOf("BACKUP", StringComparison.OrdinalIgnoreCase) >= 0) {
            if (seen.Add("u:" + s)) found.Add("U " + s);
          }
        }
        // ASCII
        for (int i = 0; i + 9 < n; i++) {
          if (buf[i] != 0x42) continue; // 'B'
          string s = Encoding.ASCII.GetString(buf, i, Math.Min(120, n - i));
          s = Clean(s);
          int cut = s.Length;
          for (int k = 0; k < s.Length; k++) { if (!(char.IsLetterOrDigit(s[k]) || s[k]==' ' || s[k]=='_' || s[k]=='-' || s[k]=='.' || s[k]=='(' || s[k]==')')) { cut = k; break; } }
          s = s.Substring(0, cut).Trim();
          if (s.Length >= 5 && s.Length <= 80 && s.IndexOf("BACKUP", StringComparison.OrdinalIgnoreCase) >= 0) {
            if (seen.Add("a:" + s)) found.Add("A " + s);
          }
        }
      }
    } finally { CloseHandle(h); }
    return found;
  }
}
"@
Add-Type -TypeDefinition $src -Language CSharp
$p = Get-Process abuzar -ErrorAction Stop | Select-Object -First 1
"scanning pid=$($p.Id) - $($p.WorkingSet64) bytes working set"
$hits = [MemScan]::Scan($p.Id)
"hits=$($hits.Count)"
$hits | Sort-Object | Select-Object -First 200
