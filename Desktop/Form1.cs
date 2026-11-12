using app_csharp;
using Microsoft.VisualBasic; // Para InputBox
using Microsoft.Win32;
using NAudio.CoreAudioApi;
using Newtonsoft.Json; // Usando Newtonsoft.Json
using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AppCSharp
{
    public partial class Form1 : Form
    {
        private NotifyIcon trayIcon;
        private string codigo;
        private string caminhoCodigo;
        private Timer pollingTimer;

        public Form1()
        {
            InitializeComponent();

            caminhoCodigo = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "codigo.txt");
            VerificarCodigo();

            // Adiciona ao Startup
            AddToStartup();

            InicializarBandeja();

            // Form invisível
            this.WindowState = FormWindowState.Minimized;
            this.ShowInTaskbar = false;

            // Inicializa timer para polling a cada 5 segundos
            pollingTimer = new Timer();
            pollingTimer.Interval = 5000; // 5 segundos
            pollingTimer.Tick += async (s, e) =>
            {
                // Impede sobreposição de chamadas
                pollingTimer.Stop();
                try
                {
                    await PollServer();
                }
                finally
                {
                    pollingTimer.Start();
                }
            };
            pollingTimer.Start();
        }

        private void VerificarCodigo()
        {
            if (File.Exists(caminhoCodigo))
            {
                codigo = File.ReadAllText(caminhoCodigo);
            }
            else
            {
                codigo = Interaction.InputBox(
                    "Digite o código gerado no aplicativo Flutter:",
                    "Código do App",
                    ""
                );

                if (!string.IsNullOrEmpty(codigo))
                {
                    File.WriteAllText(caminhoCodigo, codigo);
                }
                else
                {
                    MessageBox.Show("Código obrigatório. O app será fechado.");
                    Application.Exit();
                }
            }
        }

        private void InicializarBandeja()
        {
            trayIcon = new NotifyIcon()
            {
                Icon = System.Drawing.SystemIcons.Application,
                Text = "App C# Tray",
                Visible = true
            };

            trayIcon.ContextMenuStrip = new ContextMenuStrip();
            trayIcon.ContextMenuStrip.Items.Add("Sair", null, (s, e) => Application.Exit());

            trayIcon.DoubleClick += (s, e) =>
            {
                MessageBox.Show($"Código do Flutter: {codigo}", "Info");
            };
        }

        private void AddToStartup()
        {
            try
            {
                string appName = "AppCSharp";
                string exePath = Application.ExecutablePath;

                RegistryKey rk = Registry.CurrentUser.OpenSubKey(
                    "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", true);
                rk.SetValue(appName, exePath);
                rk.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro ao adicionar ao Startup: " + ex.Message);
            }
        }

        // Polling do servidor a cada 10 segundos usando Newtonsoft.Json
        private async Task PollServer()
        {
            try
            {
                string url = $"URL?codigo={codigo}";
                 HttpClient client = new HttpClient();
                var response = await client.GetStringAsync(url);

                var comandos = JsonConvert.DeserializeObject<List<Comando>>(response);
                if (comandos != null)
                {
                    foreach (var cmd in comandos)
                    {
                        ProcessCommand(cmd.acao);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Erro no polling: " + ex.Message);
            }
        }

        private void ProcessCommand(string comando)
        {
            switch (comando)
            {
                case "desligar":
                    System.Diagnostics.Process.Start("shutdown", "/s /t 0");
                    break;
                case "reiniciar":
                    System.Diagnostics.Process.Start("shutdown", "/r /t 0");
                    break;
                case "menos_volume":
                    DiminuirVolume();
                    break;
                case "mais_volume":
                    AumentarVolume();
                    break;
                case "space":
                    KeyboardHelper.PressKey("Space");
                    break;
                default:
                    break;
            }
        }
        void AumentarVolume()
        {
            var deviceEnumerator = new MMDeviceEnumerator();
            var device = deviceEnumerator.GetDefaultAudioEndpoint(DataFlow.Render, Role.Multimedia);

            float volumeAtual = device.AudioEndpointVolume.MasterVolumeLevelScalar;
            float novoVolume = volumeAtual + 0.1f; // +10%
            if (novoVolume > 1.0f) novoVolume = 1.0f;

            device.AudioEndpointVolume.MasterVolumeLevelScalar = novoVolume;
            Console.WriteLine($"Volume aumentado para {(int)(novoVolume * 100)}%");
        }
        void DiminuirVolume()
        {
            var deviceEnumerator = new MMDeviceEnumerator();
            var device = deviceEnumerator.GetDefaultAudioEndpoint(DataFlow.Render, Role.Multimedia);

            float volumeAtual = device.AudioEndpointVolume.MasterVolumeLevelScalar;
            float novoVolume = volumeAtual - 0.1f; // -10%
            if (novoVolume < 0.0f) novoVolume = 0.0f;

            device.AudioEndpointVolume.MasterVolumeLevelScalar = novoVolume;
            Console.WriteLine($"Volume diminuído para {(int)(novoVolume * 100)}%");
        }
        private void Form1_Load(object sender, EventArgs e) { }

        // Classe para desserializar comandos JSON
        private class Comando
        {
            public int id { get; set; }
            public string codigo { get; set; }
            public string acao { get; set; }
            public int enviado { get; set; }
            public string timestamp { get; set; }
        }
    }
}