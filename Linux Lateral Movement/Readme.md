# Linux lateral movement - Pen-300

SSH KEYS: The public key is stored in the ~/.ssh/authorized_keys file of the server the user is connecting to. The private key is typically stored in the ~/.ssh/ directory on the system the user is connecting from.


**SEARCH FOR PRIVATE KEYS**

```bash
find /home/ -name "id_rsa"
```

**Search for recently connected to machines**
This may fail if "hash known hosts" is enabled. 
<br>
```bash
cat known_hosts
```

**Check bash history**
```bash
tail .bash_history
```
<br>

<br>
If you find a private key it may be password protected.  Heres how to unpassword it.

1) cat XYZ.key file to see if it contains encyrption type and algorithm.  If it does, its passwrd protected

2) Prepare the key file with John The Ripper, ssh2john.py

```bash
python /usr/share/john/ssh2john.py svuser.key > svuser.hash
```

3) Crack the key with JTR
```bash
sudo john --wordlist=/usr/share/wordlists/rockyou.txt ./svuser.hash
```
