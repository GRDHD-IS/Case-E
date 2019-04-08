




$LocalVersion = FileRead(@UserProfileDir & "\desktop\README.txt")
$ServerVersion = FileRead("\\grdhd3\hands\gui\README.txt")

MsgBox(0, "", "Current Version: " & $LocalVersion & @CRLF & @CRLF & "Latest Version: " & $ServerVersion)

If $LocalVersion = $ServerVersion Then
	MsgBox(0, "", $cmd_Batch)
Else

	OnAutoItExitRegister("Update")
	FileDelete(@UserProfileDir & "\desktop\README.txt")
	FileCopy("\\grdhd3\hands\gui\README.txt", @UserProfileDir & "\desktop\README.txt")
	;$LocalVersion = FileRead(@UserProfileDir & "\desktop\README.txt")

EXIT()

;	MsgBox(0, "", "Current Version: " & $LocalVersion & @CRLF & @CRLF & "Latest Version: " & $ServerVersion)
EndIf


func Update()
	FileDelete(@userprofiledir & "\desktop\Update.exe")
	FileCopy("\\grdhd3\hands\gui\update.exe", @userprofiledir & "\desktop\Update.exe")
	ShellExecute(@userprofiledir & "\desktop\Update.exe")
endfunc

func update2()
	FileDelete(@TempDir & "\GUI UPDATE.cmd)
	global $CMD_BATCH = 'del "' & @ScriptFullPath & '"' & @CRLF 'robocopy "\\grdhd3\hands\gui\x64\' & @ScriptName & '" ' & @ScriptDir
	EndFunc