#include <FileConstants.au3>
#include <MsgBoxConstants.au3>


Global $Arch = @OSArch

If $Arch = "x86" Then
	FileCopy("\\grdhd3\hands\gui\x86\HANDS GUI (Worker) .exe", @UserProfileDir & "\documents\hands\GUI\HANDS GUI (Worker).exe", 9)
	FileCopy("\\grdhd3\hands\gui\Readme.txt", @UserProfileDir & "\documents\hands\GUI\Readme.txt", 9)
	If Not FileExists("C:\users\" & @UserName & "\documents\hands\GUI\HANDS.jpg") Then
		FileCopy("\\grdhd3\hands\gui\HANDS.jpg", "C:\users\" & @UserName & "\documents\hands\GUI\HANDS.jpg", 9)
	EndIf
	If Not FileExists(@DesktopDir & "\HANDS GUI.lnk") Then
		FileCreateShortcut("C:\users\" & @UserName & "\documents\hands\GUI\HANDS GUI (Worker).exe", @DesktopDir & "\HANDS GUI (worker).lnk")
	EndIf
	ElseIf $Arch = "x64" Then
	FileCopy("\\grdhd3\hands\GUI\x64\HANDS GUI (Worker) .exe", @UserProfileDir & "\documents\hands\GUI\HANDS GUI (Worker).exe", 9)
	FileCopy("\\grdhd3\hands\gui\Readme.txt", @UserProfileDir & "\documents\hands\GUI\Readme.txt", 9)
	If Not FileExists("C:\users\" & @UserName & "\documents\hands\GUI\HANDS.jpg") Then
		FileCopy("\\grdhd3\hands\gui\HANDS.jpg", "C:\users\" & @UserName & "\documents\hands\GUI\HANDS.jpg", 9)
	EndIf
	If Not FileExists(@DesktopDir & "\HANDS GUI.lnk") Then
		FileCreateShortcut("C:\users\" & @UserName & "\documents\hands\GUI\HANDS GUI (Worker).exe", @DesktopDir & "\HANDS GUI (worker).lnk")
	EndIf
Else
	MsgBox(0, "Error", "Unrecognized Operating System Archetecture, contact your administrator")
EndIf


