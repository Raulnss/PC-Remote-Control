using System;
using System.Windows.Forms;

namespace AppCSharp
{
    static class Program
    {
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            // Inicializa Form1 invisível
            Form1 app = new Form1();
            Application.Run();
        }
    }
}