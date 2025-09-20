# Active directory tooling 



### Normal windows net tools.... net user / net localgroup, etc



<br>

### Find primary Domain controller and distinguished name

<br>

``` powershell
$PDC = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().PdcRoleOwner.Name
$DN = ([adsi]'').distinguishedName 
$LDAP = "LDAP://$PDC/$DN"
$LDAP
```

<Br>

### Query AD with DirectoryEntry and DirectorySearcher

``` powershell
function LDAPSearch {
    param (
        [string]$LDAPQuery
    )

    $PDC = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().PdcRoleOwner.Name
    $DistinguishedName = ([adsi]'').distinguishedName

    $DirectoryEntry = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$PDC/$DistinguishedName")

    $DirectorySearcher = New-Object System.DirectoryServices.DirectorySearcher($DirectoryEntry, $LDAPQuery)

    return $DirectorySearcher.FindAll()

}
```

Examples:
- LDAPSearch -LDAPQuery "(samAccountType=805306368)" (find all)
- LDAPSearch -LDAPQuery "(objectclass=group)" (find all groups)




### AD enumeration with PowerView.ps1

**Find local admin access:**
- Find-LocalAdminAccess   

**Get users that are logged onto remote workstations:**
- Get-NetSession -ComputerName NAME

***check permissions from registry to see if we can access get-netsession***

``` powershell
Get-Acl -Path HKLM:SYSTEM\CurrentControlSet\Services\Lanma- nServer\DefaultSecurity\ | fl
```

Get users logged on with SysInternals Psloggedon.exe
- .\PsLoggedon.exe \\files04
<br><br>

### Enumeration via SPN's

***When applications like Exchange, MS SQL, or Internet Information Services (IIS) are integrated into AD, a unique service instance identifier known as Service Principal Name (SPN) associates a service to a specific service account in Active Directory.***

Windows tooling:
- setspn -L iis_service

Powerview.ps1
- Get-NetUser -SPN | select samaccountname,serviceprincipalname


### Enumerating Object Permissions


  

