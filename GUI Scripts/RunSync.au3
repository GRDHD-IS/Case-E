;function to use free file sync to sync with the server
Func runSync()
	$filecheck = FileExists("\\" & $server & "\hands")
	If $filecheck = 0 Then
		MsgBox(0, "GRDHD Network Connection Not Detected", "The GRDHD netowrk has not been detected, synchronization cannot continue", 3)
	EndIf
	If $filecheck = 1 Then
		;$filecheck = FileExists($server & "\hands\gui\handssync.ffs_batch")
		;If $filecheck = 0 Then
			FileCopy("\\" & $server & "\hands\gui\handsSync.ffs_batch", $handsPath,$FC_OVERWRITE)
		;EndIf
		ShellExecute($handsPath & "\handsSync.ffs_batch")
		sleep(1000)
		processwaitclose("freefilesync.exe")
	EndIf
EndFunc   ;==>runSync