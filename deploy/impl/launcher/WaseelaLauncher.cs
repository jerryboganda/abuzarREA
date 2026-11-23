using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;
using System.Threading;
using System.Windows.Forms;

namespace WaseelaLauncher
{
    internal static class Program
    {
        [DllImport("user32.dll")]
        private static extern bool SetForegroundWindow(IntPtr hWnd);

        [DllImport("user32.dll")]
        private static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

        [DllImport("user32.dll")]
        private static extern IntPtr GetForegroundWindow();

        [DllImport("user32.dll")]
        private static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);

        [DllImport("user32.dll")]
        private static extern bool AttachThreadInput(uint idAttach, uint idAttachTo, bool fAttach);

        [DllImport("user32.dll")]
        private static extern bool BringWindowToTop(IntPtr hWnd);

        [DllImport("user32.dll")]
        private static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter,
            int x, int y, int cx, int cy, uint flags);

        private static void ForceForeground(IntPtr hWnd)
        {
            if (hWnd == IntPtr.Zero) return;

            IntPtr foreground = GetForegroundWindow();
            uint foregroundPid;
            uint targetPid;
            uint foregroundThread = GetWindowThreadProcessId(foreground, out foregroundPid);
            uint targetThread = GetWindowThreadProcessId(hWnd, out targetPid);

            AttachThreadInput(targetThread, foregroundThread, true);
            ShowWindow(hWnd, 9); // SW_RESTORE
            SetWindowPos(hWnd, (IntPtr)(-1), 0, 0, 0, 0, 0x0003); // TOPMOST, NOSIZE|NOMOVE
            SetWindowPos(hWnd, (IntPtr)(-2), 0, 0, 0, 0, 0x0003); // NOTOPMOST
            BringWindowToTop(hWnd);
            SetForegroundWindow(hWnd);
            AttachThreadInput(targetThread, foregroundThread, false);
        }

        private static IntPtr FindAppWindow()
        {
            foreach (Process p in Process.GetProcessesByName("abuzar"))
            {
                if (p.MainWindowHandle != IntPtr.Zero)
                    return p.MainWindowHandle;
            }
            return IntPtr.Zero;
        }

        [STAThread]
        private static void Main()
        {
            string dir = AppDomain.CurrentDomain.BaseDirectory;
            string exe = Path.Combine(dir, "abuzar.exe");
            if (!File.Exists(exe))
            {
                MessageBox.Show("abuzar.exe was not found next to WaseelaLauncher.exe.",
                    "Waseela", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            // If Waseela is already running, bring it forward instead of starting a second copy.
            foreach (Process p in Process.GetProcessesByName("abuzar"))
            {
                if (p.MainWindowHandle != IntPtr.Zero)
                {
                    ShowWindow(p.MainWindowHandle, 9); // SW_RESTORE
                    SetForegroundWindow(p.MainWindowHandle);
                    return;
                }
            }

            using (var splash = new SplashForm(dir))
            {
                splash.Show();
                Application.DoEvents();

                Process app = Process.Start(new ProcessStartInfo(exe)
                {
                    WorkingDirectory = dir,
                    UseShellExecute = true
                });

                DateTime deadline = DateTime.UtcNow.AddSeconds(40);
                while (DateTime.UtcNow < deadline)
                {
                    Application.DoEvents();
                    Thread.Sleep(150);

                    if (app == null || app.HasExited)
                        break;

                    IntPtr appWindow = FindAppWindow();
                    if (appWindow != IntPtr.Zero)
                    {
                        // Bring the login window forward before removing the splash;
                        // otherwise focus returns to whatever was behind the splash.
                        ForceForeground(appWindow);
                        Thread.Sleep(600);
                        break;
                    }
                }

                splash.Close();

                // The splash was topmost; force the app's first window forward again
                // after it disappears so the user sees the login form, not the browser.
                Thread.Sleep(800);
                IntPtr finalWindow = FindAppWindow();
                if (finalWindow != IntPtr.Zero)
                {
                    ForceForeground(finalWindow);
                    Thread.Sleep(400);
                    ForceForeground(finalWindow);
                }
            }
        }
    }

    internal sealed class SplashForm : Form
    {
        public SplashForm(string dir)
        {
            FormBorderStyle = FormBorderStyle.None;
            StartPosition = FormStartPosition.CenterScreen;
            ClientSize = new Size(560, 300);
            BackColor = Color.FromArgb(12, 28, 48);
            TopMost = true;
            ShowInTaskbar = false;
            DoubleBuffered = true;

            string logo = Path.Combine(dir, "Logo1.bmp");
            if (!File.Exists(logo))
                logo = Path.Combine(dir, "Logo.bmp");

            if (File.Exists(logo))
            {
                using (var bmp = new Bitmap(logo))
                {
                    var pic = new PictureBox
                    {
                        Image = new Bitmap(bmp),
                        SizeMode = PictureBoxSizeMode.Zoom,
                        Bounds = new Rectangle(40, 26, 480, 172),
                        BackColor = Color.Transparent
                    };
                    Controls.Add(pic);
                }
            }

            var title = new Label
            {
                Text = "WASEELA",
                ForeColor = Color.White,
                Font = new Font("Segoe UI Semibold", 24f),
                TextAlign = ContentAlignment.MiddleCenter,
                Bounds = new Rectangle(0, 202, 560, 46)
            };

            var sub = new Label
            {
                Text = "Starting...",
                ForeColor = Color.FromArgb(160, 190, 220),
                Font = new Font("Segoe UI", 11f),
                TextAlign = ContentAlignment.MiddleCenter,
                Bounds = new Rectangle(0, 248, 560, 30)
            };

            Controls.Add(title);
            Controls.Add(sub);

            Paint += (s, e) =>
            {
                using (var pen = new Pen(Color.FromArgb(60, 110, 160), 2))
                    e.Graphics.DrawRectangle(pen, 0, 0, Width - 1, Height - 1);
            };
        }

        protected override bool ShowWithoutActivation
        {
            get { return true; }
        }

        protected override CreateParams CreateParams
        {
            get
            {
                CreateParams cp = base.CreateParams;
                cp.ExStyle |= 0x00000008; // WS_EX_TOPMOST
                return cp;
            }
        }
    }
}
