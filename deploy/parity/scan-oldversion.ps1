# Read-only scan of the running original app for the DBMS version string that
# sqlca.dbms_version() returns (the 2012-vs-modern DataWindow switch depends on it).
$src = @"
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
public class VerScan {
  [DllImport("kernel32.dll", SetLastError=true)] static extern IntPtr OpenProcess(uint access, bool inherit, int pid);
  [DllImport("kernel32.dll", SetLastError=true)] static extern bool CloseHandle(IntPtr h);
  [DllImport("kernel32.dll", SetLastError=true)] static extern bool ReadProcessMemory(IntPtr h, IntPtr addr, byte[] buf, IntPtr size, out IntPtr read);
  [DllImport("kernel32.dll", SetLastError=true)] static extern IntPtr VirtualQueryEx(IntPtr h, IntPtr addr, out MBI mbi, IntPtr len);
  [StructLayout(LayoutKind.Sequential)] public struct MBI {
    public IntPtr BaseAddress; public IntPtr AllocationBase; public uint AllocationProtect; public uint __a1;
    public UIntPtr RegionSize; public uint State; public uint Protect; public uint Type; public uint __a2;
  }
  static string Clean(string s) {
    var sb = new StringBuilder();
    foreach (var ch in s) { if (ch >= 32 && ch < 127) sb.Append(ch); else if (ch == '\t') sb.Append(' '); }
    return sb.ToString().Trim();
  }
  public static List<string> Scan(int pid) {
    var found = new List<string>(); var seen = new HashSet<string>();
    IntPtr h = OpenProcess(0x0010 | 0x0400, false, pid);
    if (h == IntPtr.Zero) { found.Add("OPEN_FAILED " + Marshal.GetLastWin32Error()); return found; }
    try {
      IntPtr addr = IntPtr.Zero; long max = 0x7FFFFFFFFFFF;
      while ((long)addr < max) {
        MBI m; IntPtr q = VirtualQueryEx(h, addr, out m, (IntPtr)Marshal.SizeOf(typeof(MBI)));
        if (q == IntPtr.Zero) break;
        long baseAddr = (long)m.BaseAddress; long size = (long)m.RegionSize;
        addr = (IntPtr)(baseAddr + size);
        if (m.State != 0x1000 || size <= 0 || size > 64L*1024*1024) continue;
        uint p = m.Protect; if ((p & 0x01) != 0 || (p & 0x100) != 0) continue;
        byte[] buf = new byte[size]; IntPtr read;
        if (!ReadProcessMemory(h, m.BaseAddress, buf, (IntPtr)size, out read)) continue;
        int n = (int)read;
        for (int wide = 0; wide < 2; wide++) {
          for (int i = 0; i + 12 < n; i += (wide == 1 ? 1 : 2)) {
            bool hit;
            if (wide == 0) hit = buf[i]==0x53 && buf[i+1]==0 && buf[i+2]==0x51 && buf[i+3]==0 && buf[i+4]==0x4c && buf[i+5]==0;
            else hit = buf[i]==0x53 && buf[i+1]==0x51 && buf[i+2]==0x4c;
            if (!hit) continue;
            string s = wide == 0 ? Encoding.Unicode.GetString(buf, i, Math.Min(240, n-i)) : Encoding.ASCII.GetString(buf, i, Math.Min(160, n-i));
            s = Clean(s);
            int cut = s.Length;
            for (int k = 0; k < s.Length; k++) { if (!(char.IsLetterOrDigit(s[k]) || s[k]==' ' || s[k]=='(' || s[k]==')' || s[k]=='.' || s[k]=='-' || s[k]=='/' || s[k]==':' )) { cut = k; break; } }
            s = s.Substring(0, cut).Trim();
            if (s.Length >= 10 && s.Length <= 120 && s.IndexOf("SQL Server", StringComparison.OrdinalIgnoreCase) >= 0) {
              if (seen.Add((wide==0?"u:":"a:")+s)) found.Add((wide==0?"U ":"A ")+s);
            }
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
$hits = [VerScan]::Scan($p.Id)
"hits=$($hits.Count)"
$hits | Sort-Object -Unique | Select-Object -First 200
