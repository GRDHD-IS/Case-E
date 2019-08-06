;function to use free file sync to sync with the server
Func runSync()
	$filecheck = FileExists("\\" & $server & "\hands")
	If $filecheck = 0 Then
		MsgBox(0, "GRDHD Network Connection Not Detected", "The GRDHD netowrk has not been detected, synchronization cannot continue", 3)
	EndIf
	If $filecheck = 1 Then
		;$filecheck = FileExists($server & "\hands\gui\handssync.ffs_batch")
		;If $filecheck = 0 Then
		FileCopy("\\" & $server & "\hands\gui\handsSync.ffs_batch", $handsPath, $FC_OVERWRITE)
		FileCopy("\\" & $server & "\hands\gui\handsSync2.ffs_batch", $handsPath, $FC_OVERWRITE)
		;EndIf
		If ProcessExists("NuancePDF.exe") Then
			MsgBox(0, "Error", "Sync cannot run while PDf files are open, please close all PDF files." & @CRLF & "Sync will begin once all PDF files are closed.")
			ProcessWaitClose("NuancePDF.exe")
		EndIf
		ShellExecute($handsPath & "\handsSync.ffs_batch")
		Sleep(1000)
		ProcessWaitClose("freefilesync.exe")
		ShellExecute($handsPath & "\handsSync2.ffs_batch")
		Sleep(1000)
		ProcessWaitClose("freefilesync.exe")
	EndIf
EndFunc   ;==>runSync
