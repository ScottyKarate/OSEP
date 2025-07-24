## Need GetModuleHandle and GetProcAddress  


To perform a dynamic lookup of function addresses, the operating system provides two special Win32 APIs: GetModuleHandle and GetProcAddress.  

GetModuleHandle obtains a handle to the specified DLL in the form of the DLL's memory address. To find the address of a specific function, we'll pass the DLL handle and the function name to GetProcAddress, which will return the function address. We can use these functions to locate any API.  

