## Locate all versions of .net installed via powershell

```powershell
Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
    Get-ItemProperty -Name Version -ErrorAction SilentlyContinue |
    Where-Object { $_.Version -match '^\d' } |
    Select-Object PSChildName, Version
```


X0r encode Powershell payloads

```powershell

function Encode-Buffer {
    param (
        [byte[]]$Buffer,
        [byte]$Key = 0x5F
    )

    $Encoded = @()
    foreach ($b in $Buffer) {
        $Encoded += ($b -bxor $Key)
    }

    $hex = ($Encoded | ForEach-Object { "0x{0:x2}" -f $_ }) -join ","
    Write-Host ("Encoded: [Byte[]] `$buf = {0}" -f $hex) -NoNewline

    return ,$Encoded  # return as byte array

}

```


## Enable RDP

``` powershell

Function Enable-RemoteDesktop ([switch]$EnableNetworkLevelAuth) {

    Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0

    if ($EnableNetworkLevelAuth) { $nlaValue = 1 } else { $nlaValue = 0 }

    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value $nlaValue

}

```
