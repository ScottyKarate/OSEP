## Need GetModuleHandle and GetProcAddress  


To perform a dynamic lookup of function addresses, the operating system provides two special Win32 APIs: GetModuleHandle and GetProcAddress.  

GetModuleHandle obtains a handle to the specified DLL in the form of the DLL's memory address. To find the address of a specific function, we'll pass the DLL handle and the function name to GetProcAddress, which will return the function address. We can use these functions to locate any API.  


## get all assemblies and their locations

```powershell

$Assemblies = [AppDomain]::CurrentDomain.GetAssemblies()

$Assemblies |
  ForEach-Object {
    $_.Location
    $_.GetTypes()|
      ForEach-Object {
          $_ | Get-Member -Static| Where-Object {
            $_.TypeName.Equals('Microsoft.Win32.UnsafeNativeMethods')
          }
      } 2> $null
    }


```

## Script to find the procaddress and modulehandle to dll  

#### Usage:  $MessageBoxA = LookupFunc user32.dll MessageBoxA  

```powershell

function LookupFunc {

	Param ($moduleName, $functionName)

	$assem = ([AppDomain]::CurrentDomain.GetAssemblies() | 
    Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].
      Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
    $tmp=@()
    $assem.GetMethods() | ForEach-Object {If($_.Name -eq "GetProcAddress") {$tmp+=$_}}
	return $tmp[0].Invoke($null, @(($assem.GetMethod('GetModuleHandle')).Invoke($null, @($moduleName)), $functionName))
}

```

