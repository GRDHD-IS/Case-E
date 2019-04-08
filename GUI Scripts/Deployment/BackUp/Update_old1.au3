




$LocalVersion = fileread(@UserProfileDir & "\desktop\README.txt")
$ServerVersion = fileread("\\grdhd3\hands\gui\README.txt")

MsgBox(0,"","Current Version: " & $LocalVersion & @CRLF & @CRLF & "Latest Version: " & $ServerVersion)

if $LocalVersion = $ServerVersion Then
	Msgbox(0,"","Your version is up to date")
	Else
	FileDelete(@UserProfileDir & "\desktop\README.txt")
	FileCopy("\\grdhd3\hands\gui\README.txt", @UserProfileDir & "\desktop\README.txt")
$LocalVersion = fileread(@UserProfileDir & "\desktop\README.txt")



MsgBox(0,"","Current Version: " & $LocalVersion & @CRLF & @CRLF & "Latest Version: " & $ServerVersion)
EndIf