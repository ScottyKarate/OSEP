## Powershell search for Constrained Delegation property 'msDS-AllowedToDelegateTo'

Can filter out properties or leave it blank for all properties
$searcher.PropertiesToLoad.Add("name") | Out-Null
$searcher.PropertiesToLoad.Add("msDS-AllowedToDelegateTo") | Out-Null

``` powershell
$searcher = New-Object DirectoryServices.DirectorySearcher
$searcher.Filter = "(&(objectCategory=computer)(msDS-AllowedToDelegateTo=*))"

$results = $searcher.FindAll()

foreach ($result in $results) {
    $name = $result.Properties["name"]
    $delegation = $result.Properties["msds-allowedtodelegateto"]
    Write-Output "Computer: $name"
    foreach ($entry in $delegation) {
        Write-Output "  AllowedToDelegateTo: $entry"
    }
    Write-Output ""
}
```


## Powershell to query for unconstrained delegation 

objectCategory=user

```powershell
$searcher = New-Object DirectoryServices.DirectorySearcher
# 0x80000 = TRUSTED_FOR_DELEGATION flag in userAccountControl
$searcher.Filter = "(&(userAccountControl:1.2.840.113556.1.4.803:=524288)(objectCategory=computer))"
$searcher.PropertiesToLoad.Add("name") | Out-Null
$searcher.PropertiesToLoad.Add("userAccountControl") | Out-Null

$results = $searcher.FindAll()

foreach ($result in $results) {
    $name = $result.Properties["name"]
    $uac = $result.Properties["useraccountcontrol"]
    Write-Output "Computer: $name"
    Write-Output "  userAccountControl: $uac"
    Write-Output ""
}


## 
```
