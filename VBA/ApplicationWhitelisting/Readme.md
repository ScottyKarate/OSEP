## Applocker

Bypasses:
1) [Trusted Folders](#-Trusted-Folders)


#### Brief backbround 
<br><br>

<img width="843" height="715" alt="image" src="https://github.com/user-attachments/assets/2e218654-251b-40ac-8ec6-3b9401c5b371" />


<br><br>
## Basic Bypasses


#### Trusted Folders

**The default rules for AppLocker whitelist all executables and scripts located in C:\Program Files, C:\Program Files (x86), and C:\Windows. **

1) Use Accesschk from SysInternals to look for writable folders.  

AccessChk -w to locate writable directories, -u to suppress any errors and -s to recurse through all subdirectories  

Ex: accesschk.exe "student" C:\Windows -wus

2) Use icalcs.exe to see if you can execute on that folder.  

Ex: icacls.exe C:\Windows\Tasks


<img width="847" height="273" alt="image" src="https://github.com/user-attachments/assets/e55741da-1d8b-46c5-8815-11838c26c5d4" />
