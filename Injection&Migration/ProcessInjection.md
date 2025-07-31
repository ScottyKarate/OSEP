<img width="1303" height="692" alt="image" src="https://github.com/user-attachments/assets/8c9b2509-cacf-419b-8ca8-d195c7e68c4b" />



##### we can initiate Windows-based process injection by opening a channel from one process to another. Process must be running at same integrity level or lower.    

1. Use Win32 OpenProcess API to open a channel. 
2. We'll then modify its memory space through the VirtualAllocEx and WriteProcessMemory APIs  
3. create a new execution thread inside the remote process with CreateRemoteThread.  

[OpenProcess API](http://pinvoke.net/default.aspx/kernel32/OpenProcess.html) has three arguments. Desired access listed on pinvoke webpage  
1. dwDesiredAccess, establishes the access rights we require on that process.  
2. bInheritHandle, determines if the returned handle may be inherited by a child process   
3. dwProcessId, specifies the process identifier of the target process. 

[VirtualAllocEx API](http://pinvoke.net/default.aspx/kernel32/VirtualAllocEx.html)

[VirtualAllocEx MS page with function prototype](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualallocex) 


The first argument (hProcess) is the process handle to explorer.exe that we just obtained from OpenProcess and the second, lpAddress, is the desired address of the allocation in the remote process. If the API succeeds, our new buffer will be allocated with a starting address as supplied in lpAddress.

If the address given with lpAddress is already allocated and in use, the call will fail. It is better to pass a null value and let the API select an unused address.

The last three arguments (dwSize, flAllocationType, and flProtect) mirror the VirtualAlloc API parameters and specify the size of the desired allocation, the allocation type, and the memory protections. We'll set these to 0x1000, 0x3000 (MEM_COMMIT and MEM_RESERVE) and 0x40 (PAGE_EXECUTE_READWRITE), respectively. The VirtualAllocEx invocation is shown below.


Explorer.exe was pid 4804  


```Csharp

IntPtr hProcess = OpenProcess(0x001F0FFF, false, 4804);

IntPtr addr = VirtualAllocEx(hProcess, IntPtr.Zero, 0x1000, 0x3000, 0x40);

```
