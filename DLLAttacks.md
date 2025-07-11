### DLL SIDELOADING  

By default, Windows searches for DLLs in this order:  

The directory from which the application was loaded  
The system directory (System32)  
The 16-bit system directory  
The Windows directory  
The current working directory  
The directories listed in the PATH environment variable  

### Check zone of the file to see if its got Mark Of The Web (Security prompt)

Get-Content -Path .\putty.exe -Stream Zone.Identifier  

### Query DLL file for its exported functions so you can copy them
From VS Code Developer Command promt  

dumpbin /exports file.dll  


### securing against DLL sideloading  

To mitigate DLL sideloading, developers should use secure API calls like LoadLibraryExA() with LOAD_LIBRARY_SEARCH_* flags and configure the DLL search path explicitly using SetDefaultDllDirectories() or AddDllDirectory().  
