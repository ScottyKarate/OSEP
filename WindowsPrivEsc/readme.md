# From pen-200 course.  





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

  
