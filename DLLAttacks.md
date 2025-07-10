### DLL SIDELOADING  

By default, Windows searches for DLLs in this order:  

The directory from which the application was loaded  
The system directory (System32)  
The 16-bit system directory  
The Windows directory  
The current working directory  
The directories listed in the PATH environment variable  




### securing against DLL sideloading  

To mitigate DLL sideloading, developers should use secure API calls like LoadLibraryExA() with LOAD_LIBRARY_SEARCH_* flags and configure the DLL search path explicitly using SetDefaultDllDirectories() or AddDllDirectory().  
