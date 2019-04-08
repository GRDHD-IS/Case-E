




$LocalVersion = FileRead(@UserProfileDir & "\documents\hands\gui\README.txt",27)
$ServerVersion = FileRead("\\grdhd3\hands\gui\README.txt",27)

If $LocalVersion = $ServerVersion Then
;insert script here

Else
	msgbox(0,"Update Required", "Please Wait while your HANDS GUI is updated", 5)
	OnAutoItExitRegister("Update")
	Exit (1)
EndIf

Func Update()
	FileDelete(@UserProfileDir & "\documents\hands\gui\README.txt")
	FileCopy("\\grdhd3\hands\gui\README.txt", @UserProfileDir & "\documents\hands\gui\README.txt")
	FileDelete(@TempDir & "\GUI UPDATE.cmd")
	Global $CMD_BATCH = ':loop' & _
			@CRLF & 'del "' & @ScriptFullPath & '"' & _
			@CRLF & 'if exist "' & @ScriptFullPath & '" goto loop' & _
			@CRLF & 'robocopy \\grdhd3\hands\gui\' & ' ' & @ScriptDir  & ' ' & @ScriptName & _
			@CRLF & '"' & @ScriptFullPath & '"'
	FileWrite(@TempDir & "\GUI UPDATE.cmd", $CMD_BATCH)
	Run(@TempDir & "\GUI UPDATE.cmd", @TempDir, @SW_HIDE)
EndFunc   ;==>update2
