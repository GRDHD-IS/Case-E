#include <FileConstants.au3>
#include <MsgBoxConstants.au3>


Global $Arch = @OSArch
If FileExists(@DesktopDir & "\HANDS GUI (Worker).lnk") Then
	FileDelete(@DesktopDir & "\HANDS GUI (Worker).lnk")
EndIf
If $Arch = "x86" Then
	FileCopy("\\grdhd3\hands\gui\x86\HANDS GUI (Worker).exe", @UserProfileDir & "\documents\hands\GUI\HANDS GUI (Worker).exe", $FC_OVERWRITE + $FC_CREATEPATH)
	FileCopy("\\grdhd3\hands\gui\Readme.txt", @UserProfileDir & "\documents\hands\GUI\Readme.txt", $FC_OVERWRITE + $FC_CREATEPATH)
	If Not FileExists("C:\users\" & @UserName & "\documents\hands\GUI\HANDS.jpg") Then
		FileCopy("\\grdhd3\hands\gui\HANDS.jpg", "C:\users\" & @UserName & "\documents\hands\GUI\HANDS.jpg", $FC_OVERWRITE + $FC_CREATEPATH)
	EndIf
	If Not FileExists(@DesktopDir & "\Case-E Worker Edition.lnk") Then
		FileCreateShortcut("C:\users\" & @UserName & "\documents\hands\GUI\HANDS GUI (Worker).exe", @DesktopDir & "\Case-E Worker Edition.lnk")
	EndIf
ElseIf $Arch = "x64" Then
	FileCopy("\\grdhd3\hands\GUI\x64\HANDS GUI (Worker).exe", @UserProfileDir & "\documents\hands\GUI\HANDS GUI (Worker).exe", $FC_OVERWRITE + $FC_CREATEPATH)
	FileCopy("\\grdhd3\hands\gui\Readme.txt", @UserProfileDir & "\documents\hands\GUI\Readme.txt", $FC_OVERWRITE + $FC_CREATEPATH)
	If Not FileExists("C:\users\" & @UserName & "\documents\hands\GUI\HANDS.jpg") Then
		FileCopy("\\grdhd3\hands\gui\HANDS.jpg", "C:\users\" & @UserName & "\documents\hands\GUI\HANDS.jpg", $FC_OVERWRITE + $FC_CREATEPATH)
	EndIf
	If Not FileExists(@DesktopDir & "\Case-E Worker Edition.lnk") Then
		FileCreateShortcut("C:\users\" & @UserName & "\documents\hands\GUI\HANDS GUI (Worker).exe", @DesktopDir & "\Case-E Worker Edition.lnk")
	EndIf
Else
	MsgBox(0, "Error", "Unrecognized Operating System Archetecture, contact your administrator")
EndIf


