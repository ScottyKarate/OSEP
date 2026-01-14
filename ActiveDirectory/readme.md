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

<br><br>
### Enumerating Object Permissions

##### ACE/ACL background: 

an object in AD may have a set of permissions applied to it with multiple Access Control Entries (ACE). These ACEs make up the Access Control List (ACL). Each ACE defines whether access to the specific object is allowed or denied.

As a very basic example, let's say a domain user attempts to access a domain share (which is also an object). The targeted object, in this case the share, will then go through a validation check based on the ACL to determine if the user has permissions to the share. This ACL validation involves two main steps. To access the share, the user will send an access token, which consists of the user identity and permissions. The target object will then validate the token against the list of permissions (the ACL). If the ACL allows the user to access the share, access is granted. Otherwise, the request is denied.

<br>

<img width="843" height="220" alt="image" src="https://github.com/user-attachments/assets/15aced5d-f8b8-435a-b8be-9a1c70cb8fb7" />
<br><br>

Powerview:  
Get object ACL:
- Get-ObjectAcl -Identity stephanie

<img width="843" height="557" alt="image" src="https://github.com/user-attachments/assets/69c8677a-6ed4-4fad-a4f0-ccfe77011da0" />

<br><br>
Convert sids to names:
- Convert-SidToName S-1-5-21-1987370270-658905905-1781884369-1104

<br><br>

**GenericAll leads to an attack path:**  

1)
Enumerate ACLs for a user
```powershell
Get-DomainUser | Get-ObjectAcl -ResolveGUIDs | Foreach-Object {$_ | Add-Member -NotePropertyName Identity -NotePropertyValue (ConvertFrom-SID $_.SecurityIdentifier.value) -Force; $_} | Foreach-Object {if ($_.Identity -eq $("$env:UserDomain\$env:Username")) {$_}}
```

Enumerate ACLS for a group using powerview.ps1
   ```powershell
   Get-ObjectAcl -Identity "Management Department" | ? {$_.ActiveDirectoryRights -eq "GenericAll"} | select SecurityIdentifier,ActiveDirectoryRights
   ```
   <img width="856" height="332" alt="image" src="https://github.com/user-attachments/assets/da22295e-0ad0-4596-a7e7-49efc77543b1" />

6) Convert sids to names:
   
   <img width="852" height="377" alt="image" src="https://github.com/user-attachments/assets/17e6cc5a-a298-4b94-ac74-ad9463f6eb30" />


7) Because we have access as stephanie, who has genericall access to "management department" we jjust add ourselves to that group
   <img width="886" height="477" alt="image" src="https://github.com/user-attachments/assets/e49424fd-3a19-4cae-837a-2fe89866a27f" />

#### OPSEC:  Delete yourself from the group when done

4) net group "Management Department" stephanie /del /domain
<br><br>

### Enumerating Domain Shares
<br>

Powerview:
<br>
- Find-DomainShare (-CheckShareAccess flag to display shares only available to us.)

<br>
Check SYSVOL for Cpassword or any other files of interest

- ls \\dc1.corp.com\sysvol\corp.com
<br>
##### If Cpassword found, decrypt it in kali with gpp-decrypt

- gpp-decrypt "+bsY0V3d4/KgX3VJdO/vyepPfAN1zMFTiQDApgR92JE"
<br><br>


## AD Enumeration - Automated with Bloodhound/SharpHound
<br>

[Latest SharpHound](https://github.com/BloodHoundAD/SharpHound/releases)

<br>

1) import sharphound - Import-Module .\Sharphound.ps1
2) Invoke-BloodHound -CollectionMethod All -OutputDirectory C:\Users\stephanie\Desktop\ -OutputPrefix "corp audit"
***With SharpHound imported, we can now start collecting domain data. However, to run SharpHound, we must first run Invoke-BloodHound. This is not intuitive since we're only running SharpHound at this stage. Let's invoke Get-Help to learn more about this command.***

3) Read data.  To use BloodHound, we need to start the Neo4j service, which is installed by default. Note that when Bloodhound is installed with APT, the Neo4j service is automatically installed as well.
<img width="851" height="1037" alt="image" src="https://github.com/user-attachments/assets/ab6ebe8a-a5c6-4514-8e84-b186ea99b5f0" />

4) start bloodhound from terminal and import data caputred in step 2
<br><br>


##Pen-300 queries?

<br><br><br>
### Powershell search for Constrained Delegation property 'msDS-AllowedToDelegateTo'

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


### Powershell to query for unconstrained delegation 

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

```


  

