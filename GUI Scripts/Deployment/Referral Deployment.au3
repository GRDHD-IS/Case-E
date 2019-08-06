#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\HANDS Box\Version 1.1\hands-start-icon.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>


Global $Arch = @OSArch
If FileExists(@DesktopDir & "\HANDS GUI (Referral).lnk") Then
	FileDelete(@DesktopDir & "\HANDS GUI (Referral).lnk")
EndIf
If $Arch = "x86" Then
	FileCopy("\\grdhd5\hands\gui\x86\HANDS GUI (Referral).exe", @UserProfileDir & "\documents\hands\GUI\HANDS GUI (Referral).exe", $FC_OVERWRITE + $FC_CREATEPATH)
	FileCopy("\\grdhd5\hands\gui\Readme.txt", @UserProfileDir & "\documents\hands\GUI\Readme - referral.txt", $FC_OVERWRITE + $FC_CREATEPATH)
	If Not FileExists("C:\users\" & @UserName & "\documents\hands\GUI\HANDS.jpg") Then
		FileCopy("\\grdhd5\hands\gui\HANDS.jpg", "C:\users\" & @UserName & "\documents\hands\GUI\HANDS.jpg", $FC_OVERWRITE + $FC_CREATEPATH)
	EndIf
	If Not FileExists(@DesktopDir & "\Case-E Referral Edition.lnk") Then
		FileCreateShortcut("C:\users\" & @UserName & "\documents\hands\GUI\HANDS GUI (referral).exe", @DesktopDir & "\Case-E Referral Edition.lnk")
	EndIf
ElseIf $Arch = "x64" Then
	FileCopy("\\grdhd5\hands\GUI\X64\HANDS GUI (Referral).exe", @UserProfileDir & "\documents\hands\GUI\HANDS GUI (referral).exe", $FC_OVERWRITE + $FC_CREATEPATH)
	FileCopy("\\grdhd5\hands\gui\Readme.txt", @UserProfileDir & "\documents\hands\GUI\Readme - referral.txt", $FC_OVERWRITE + $FC_CREATEPATH)
	If Not FileExists("C:\users\" & @UserName & "\documents\hands\GUI\HANDS.jpg") Then
		FileCopy("\\grdhd5\hands\gui\HANDS.jpg", "C:\users\" & @UserName & "\documents\hands\GUI\HANDS.jpg", $FC_OVERWRITE + $FC_CREATEPATH)
	EndIf
	If Not FileExists(@DesktopDir & "\Case-E Referral Edition.lnk") Then
		FileCreateShortcut("C:\users\" & @UserName & "\documents\hands\GUI\HANDS GUI (referral).exe", @DesktopDir & "\Case-E Referral Edition.lnk")
	EndIf
Else
	MsgBox(0, "Error", "Unrecognized Operating System Archetecture, contact your administrator")
EndIf
