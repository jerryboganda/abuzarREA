param(
    [string]$Original = 'C:\Projects\Abuzar\deploy\parity\original-login.png',
    [string]$Rebuild  = 'C:\Projects\Abuzar\deploy\parity\rebuild-login.png',
    [int]$CropX = 227,
    [int]$CropY = 159,
    [int]$CropW = 346,
    [int]$CropH = 261,
    [string]$Diff     = 'C:\Projects\Abuzar\deploy\parity\login-diff.png',
    [string]$Side     = 'C:\Projects\Abuzar\deploy\parity\login-side-by-side.png'
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -ReferencedAssemblies 'System.Drawing' @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
public static class ImgTools2 {
  public static string Compare(string aPath, string bPath, int x, int y, int w, int h, string diffPath, string sidePath) {
    using (var a = new Bitmap(aPath))
    using (var b0 = new Bitmap(bPath))
    using (var orig = new Bitmap(w, h))
    using (var crop = new Bitmap(w, h)) {
      using (var g = Graphics.FromImage(orig)) {
        g.InterpolationMode = InterpolationMode.HighQualityBicubic;
        g.DrawImage(a, 0, 0, w, h);
      }
      using (var g = Graphics.FromImage(crop)) {
        g.DrawImage(b0, new Rectangle(0, 0, w, h), new Rectangle(x, y, w, h), GraphicsUnit.Pixel);
      }
      long sum = 0; long over = 0; long n = 0;
      using (var diff = new Bitmap(w, h))
      using (var side = new Bitmap(w * 2 + 12, h))
      using (var gs = Graphics.FromImage(side)) {
        gs.Clear(Color.FromArgb(40, 40, 40));
        gs.DrawImage(orig, 0, 0);
        gs.DrawImage(crop, w + 12, 0);
        for (int yy = 0; yy < h; yy++) {
          for (int xx = 0; xx < w; xx++) {
            Color ca = orig.GetPixel(xx, yy);
            Color cb = crop.GetPixel(xx, yy);
            int d = (Math.Abs(ca.R - cb.R) + Math.Abs(ca.G - cb.G) + Math.Abs(ca.B - cb.B)) / 3;
            sum += d; n++;
            if (d > 40) over++;
            diff.SetPixel(xx, yy, Color.FromArgb(255, Math.Min(255, d * 3), 0, 0));
          }
        }
        diff.Save(diffPath, ImageFormat.Png);
        side.Save(sidePath, ImageFormat.Png);
      }
      double mae = (double)sum / n;
      double pct = 100.0 * over / n;
      return string.Format("size={0}x{1} mae={2:F2}/255 pixels_over_40={3:F2}%", w, h, mae, pct);
    }
  }
}
"@
$result = [ImgTools2]::Compare($Original, $Rebuild, $CropX, $CropY, $CropW, $CropH, $Diff, $Side)
Write-Output $result
Write-Output "diff=$Diff"
Write-Output "side=$Side"
