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
