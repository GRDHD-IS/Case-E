




$LocalVersion = FileRead(@UserProfileDir & "\desktop\README.txt")
$ServerVersion = FileRead("\\grdhd3\hands\gui\README.txt")

MsgBox(0, "", "Current Version: " & $LocalVersion & @CRLF & @CRLF & "Latest Version: " & $ServerVersion)

If $LocalVersion = $ServerVersion Then
	MsgBox(0, "", "Your HANDS GUI is up to date" & @CRLF & @CRLF & $LocalVersion)
Else

	OnAutoItExitRegister("Update")
	FileDelete(@UserProfileDir & "\desktop\README.txt")
	FileCopy("\\grdhd3\hands\gui\README.txt", @UserProfileDir & "\desktop\README.txt")
	;$LocalVersion = FileRead(@UserProfileDir & "\desktop\README.txt")

	Exit()

	;	MsgBox(0, "", "Current Version: " & $LocalVersion & @CRLF & @CRLF & "Latest Version: " & $ServerVersion)
EndIf


Func Update()
	FileDelete(@UserProfileDir & "\desktop\Update.exe")
	FileCopy("\\grdhd3\hands\gui\update.exe", @UserProfileDir & "\desktop\Update.exe")
	ShellExecute(@UserProfileDir & "\desktop\Update.exe")
EndFunc   ;==>Update

Func update2()
	FileDelete(@TempDir & "\GUI UPDATE.cmd")
	Global $CMD_BATCH = 'del "' & @ScriptFullPath & '"' & @CRLF 'robocopy "\\grdhd3\hands\gui\x64\' & @ScriptName & '" ' & @ScriptDir
EndFunc   ;==>update2
