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


