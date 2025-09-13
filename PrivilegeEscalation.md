# Windows Services

#### enumerate services running  

Get-CimInstance -ClassName win32_service| select Name, State, PathName | Where-Object { $_.State -like 'running'} | Out-String -Width 4000  
#### get permissions for services   
 
icacls.exe "C:\Program Files\WSL\wslservice.exe"



# Powershell History

Get-Content (Get-PSReadlineOption).HistorySavePath


