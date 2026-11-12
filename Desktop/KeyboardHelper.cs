using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;

namespace app_csharp
{
    public static class KeyboardHelper
    {
        [DllImport("user32.dll")]
        private static extern uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

        private const int INPUT_KEYBOARD = 1;
        private const uint KEYEVENTF_KEYUP = 0x0002;

        [StructLayout(LayoutKind.Sequential)]
        private struct INPUT
        {
            public uint type;
            public InputUnion U;
        }

        [StructLayout(LayoutKind.Explicit)]
        private struct InputUnion
        {
            [FieldOffset(0)]
            public KEYBDINPUT ki;
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct KEYBDINPUT
        {
            public ushort wVk;
            public ushort wScan;
            public uint dwFlags;
            public uint time;
            public IntPtr dwExtraInfo;
        }

        private static INPUT KeyDown(ushort key) => new INPUT
        {
            type = INPUT_KEYBOARD,
            U = new InputUnion
            {
                ki = new KEYBDINPUT
                {
                    wVk = key,
                    wScan = 0,
                    dwFlags = 0, // Key down
                    time = 0,
                    dwExtraInfo = IntPtr.Zero
                }
            }
        };

        private static INPUT KeyUp(ushort key) => new INPUT
        {
            type = INPUT_KEYBOARD,
            U = new InputUnion
            {
                ki = new KEYBDINPUT
                {
                    wVk = key,
                    wScan = 0,
                    dwFlags = KEYEVENTF_KEYUP, // Key up
                    time = 0,
                    dwExtraInfo = IntPtr.Zero
                }
            }
        };

        // Mapeamento de teclas
        private static readonly Dictionary<string, ushort> KeyMap = new Dictionary<string, ushort>(StringComparer.OrdinalIgnoreCase)
        {
            {"Alt", 0x12}, {"Ctrl", 0x11}, {"Shift", 0x10},
            {"Tab", 0x09}, {"Enter", 0x0D}, {"Esc", 0x1B},
            {"Space", 0x20}, {"Left", 0x25}, {"Up", 0x26}, {"Right", 0x27}, {"Down", 0x28},
            {"A", 0x41}, {"B",0x42}, {"C",0x43}, {"D",0x44}, {"E",0x45}, {"F",0x46}, {"G",0x47}, {"H",0x48},
            {"I",0x49}, {"J",0x4A}, {"K",0x4B}, {"L",0x4C}, {"M",0x4D}, {"N",0x4E}, {"O",0x4F}, {"P",0x50},
            {"Q",0x51}, {"R",0x52}, {"S",0x53}, {"T",0x54}, {"U",0x55}, {"V",0x56}, {"W",0x57}, {"X",0x58},
            {"Y",0x59}, {"Z",0x5A},
            {"F1",0x70}, {"F2",0x71}, {"F3",0x72}, {"F4",0x73}, {"F5",0x74}, {"F6",0x75},
            {"F7",0x76}, {"F8",0x77}, {"F9",0x78}, {"F10",0x79}, {"F11",0x7A}, {"F12",0x7B}
        };

        /// <summary>
        /// Pressiona uma tecla ou combinação de teclas globalmente (funciona mesmo com o app minimizado)
        /// Exemplos: "A", "Enter", "Ctrl+S", "Alt+Tab"
        /// </summary>
        public static void PressKeys(string keys)
        {
            var parts = keys.Split('+');
            List<INPUT> inputs = new List<INPUT>();

            // Pressiona todas as teclas
            foreach (var part in parts)
            {
                if (KeyMap.TryGetValue(part.Trim(), out ushort vk))
                {
                    inputs.Add(KeyDown(vk));
                }
                else
                {
                    throw new ArgumentException("Tecla não mapeada: " + part);
                }
            }

            // Solta todas as teclas na ordem inversa
            for (int i = parts.Length - 1; i >= 0; i--)
            {
                if (KeyMap.TryGetValue(parts[i].Trim(), out ushort vk))
                {
                    inputs.Add(KeyUp(vk));
                }
            }

            // Envia o input globalmente
            SendInput((uint)inputs.Count, inputs.ToArray(), Marshal.SizeOf(typeof(INPUT)));
        }

        /// <summary>
        /// Atalho para pressionar uma única tecla
        /// </summary>
        public static void PressKey(string keyName)
        {
            PressKeys(keyName);
        }
    }
}