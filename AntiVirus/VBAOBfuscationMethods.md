# VBA methods in VBA for obfuscation of AV

<Br><br>


*** Method to sleep for 2 seconds to avoid AV ***

``` VBA

Private Declare PtrSafe Function Sleep Lib "KERNEL32" (ByVal mili As Long) As Long
...
Dim t1 As Date
Dim t2 As Date
Dim time As Long

t1 = Now()
Sleep (2000)
t2 = Now()
time = DateDiff("s", t1, t2)

If time < 2 Then
    Exit Function
End If
...

```

<br><br><br>

