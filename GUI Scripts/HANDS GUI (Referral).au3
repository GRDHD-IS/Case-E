#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\HANDS Box\Version 1.1\hands-start-icon.ico
#AutoIt3Wrapper_Res_Description=GRDHD HANDS GUI for Referrals
#AutoIt3Wrapper_Res_Fileversion=3.3.0.0
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;******************************************************************************
;
;
;
; ORIGINAL CODE BY KYLE ROSS. Label and form functions developed by Daniel McFeeters.
;
;
; This program is free software; you can redistribute it and/or
; modify it under the terms of the GNU General Public License
; as published by the Free Software Foundation; either version 2
; of the License.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
;
; These license terms may also be modified by the LOCAL DISTRIBUTION EXCEPTION
; described in the accompanying LICENSE.txt file.
;
;******************************************************************************
#include <FileConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <WindowsConstants.au3>
#include <GUIListView.au3>
#include <Constants.au3>
#include <Date.au3>
#include <File.au3>
#include <Array.au3>
#include <Crypt.au3>
#include <String.au3>
#include <IE.au3>

Global $version = "3.3"

Global $server = "grdhd5"

Global $date = StringSplit(_NowCalcDate(), "/")

;networkcheck
$filecheck = FileExists("\\" & $server & "\hands")
If $filecheck = 1 Then
	Global $referralspath = "\\" & $server & "\hands\referrals\"
	$filecheck = FileExists("\\" & $server & "\hands\gui\readme - referral.txt")
	If $filecheck = 1 Then
		$LocalVersion = FileRead(@UserProfileDir & "\documents\hands\gui\README - referral.txt", 27)
		$ServerVersion = FileRead("\\" & $server & "\hands\gui\README - referral.txt", 27)
		If $LocalVersion = $ServerVersion Then
			MainWindow()
		Else
			MsgBox(0, "Update Required", "Please Wait while your HANDS GUI is updated", 5)
			OnAutoItExitRegister("Update")
			Exit (1)
		EndIf
	Else
		MainWindow()
	EndIf
Else
	Global $referralspath = @UserProfileDir & "\documents\hands\referrals\"
	$filecheck = FileExists("\\" & $server & "\hands\gui\readme - referral.txt")
	If $filecheck = 1 Then
		$LocalVersion = FileRead(@UserProfileDir & "\documents\hands\gui\README - referral.txt", 27)
		$ServerVersion = FileRead("\\" & $server & "\hands\gui\README - referral.txt", 27)
		If $LocalVersion = $ServerVersion Then
			MainWindow()
		Else
			MsgBox(0, "Update Required", "Please Wait while your HANDS GUI is updated", 5)
			OnAutoItExitRegister("Update")
			Exit (1)
		EndIf
	Else
		MainWindow()
	EndIf
EndIf

Func Update()
	FileDelete(@UserProfileDir & "\documents\hands\gui\README - referral.txt")
	FileCopy("\\" & $server & "\hands\gui\README - referral.txt", @UserProfileDir & "\documents\hands\gui\README - referral.txt", $FC_OVERWRITE + $FC_CREATEPATH)
	FileDelete(@TempDir & "\GUI UPDATE.cmd")
	Global $CMD_BATCH = ':loop' & _
			@CRLF & 'del "' & @ScriptFullPath & '"' & _
			@CRLF & 'if exist "' & @ScriptFullPath & '" goto loop' & _
			@CRLF & 'copy "\\' & $server & '\hands\gui\' & @OSArch & "\" & @ScriptName & '" "' & @ScriptFullPath & '"' & _
			@CRLF & 'f' & _
			@CRLF & '"' & @ScriptFullPath & '"'
	FileWrite(@TempDir & "\GUI UPDATE.cmd", $CMD_BATCH)
	Run(@TempDir & "\GUI UPDATE.cmd", @TempDir, @SW_HIDE)
EndFunc   ;==>Update

Func MainWindow()
	$mainWindow = GUICreate("Case-E Referral Edition v" & $version, 350, 575)
	$sync = GUICtrlCreateButton("Synchronize", 200, 25, 100, 25)
	$synclabel = GUICtrlCreateLabel("For RN/SWs only", 201, 51)
	$openlog = GUICtrlCreateButton("Current Log", 200, 75, 100, 25)
	$openloglabel = GUICtrlCreateLabel("Open the current year log", 201, 101)
	$openoldlog = GUICtrlCreateButton("Previous Log", 200, 125, 100, 25)
	$openoldloglabel = GUICtrlCreateLabel("Open the previous year log", 201, 151)
	$logarchive = GUICtrlCreateButton("Archive Log", 200, 175, 100, 25)
	$logarchivelabel = GUICtrlCreateLabel("Transfer logs to archive", 201, 201)
	$openarchive = GUICtrlCreateButton("Log Archive", 200, 225, 100, 25)
	$openarchivelabel = GUICtrlCreateLabel("Open log archive", 201, 251)
	$openpermanentarchive = GUICtrlCreateButton("Referral Archive", 200, 275, 100, 25)
	$openreferralarchivelabel = GUICtrlCreateLabel("Open referral achive", 201, 301)

	$button1 = GUICtrlCreateButton("Daviess Pending", 25, 25, 75, 50, $BS_MULTILINE)
	$button2 = GUICtrlCreateButton("Hancock Pending", 25, 100, 75, 50, $BS_MULTILINE)
	$button3 = GUICtrlCreateButton("Henderson Pending", 25, 175, 75, 50, $BS_MULTILINE)
	$button4 = GUICtrlCreateButton("McLean Pending", 25, 250, 75, 50, $BS_MULTILINE)
	$button5 = GUICtrlCreateButton("Ohio Pending", 25, 325, 75, 50, $BS_MULTILINE)
	$button6 = GUICtrlCreateButton("Union Pending", 25, 400, 75, 50, $BS_MULTILINE)
	$button7 = GUICtrlCreateButton("Webster Pending", 25, 475, 75, 50, $BS_MULTILINE)
	$daviessvariable = filelistcount($referralspath & "\daviess\")
	$label1 = GUICtrlCreateLabel("Pending: " & $daviessvariable, 26, 76)
	$hancockvariable = filelistcount($referralspath & "\hancock\")
	$label2 = GUICtrlCreateLabel("Pending: " & $hancockvariable, 26, 151)
	$hendersonvariable = filelistcount($referralspath & "\henderson\")
	$label3 = GUICtrlCreateLabel("Pending: " & $hendersonvariable, 26, 226)
	$mcleanvariable = filelistcount($referralspath & "\mclean\")
	$label4 = GUICtrlCreateLabel("Pending: " & $mcleanvariable, 26, 301)
	$ohiovariable = filelistcount($referralspath & "\ohio\")
	$label5 = GUICtrlCreateLabel("Pending: " & $ohiovariable, 26, 376)
	$unionvariable = filelistcount($referralspath & "\union\")
	$label6 = GUICtrlCreateLabel("Pending: " & $unionvariable, 26, 451)
	$webstervariable = filelistcount($referralspath & "\webster\")
	$label7 = GUICtrlCreateLabel("Pending: " & $webstervariable, 26, 526)
	$daviessvariable1 = filelistcount($referralspath & "\daviess\updates\")
	$label11 = GUICtrlCreateLabel("Updates: " & $daviessvariable1, 111, 35)
	$hancockvariable1 = filelistcount($referralspath & "\hancock\updates\")
	$label21 = GUICtrlCreateLabel("Updates: " & $hancockvariable1, 111, 110)
	$hendersonvariable1 = filelistcount($referralspath & "\henderson\updates\")
	$label31 = GUICtrlCreateLabel("Updates: " & $hendersonvariable1, 111, 185)
	$mcleanvariable1 = filelistcount($referralspath & "\mclean\updates\")
	$label41 = GUICtrlCreateLabel("Updates: " & $mcleanvariable1, 111, 260)
	$ohiovariable1 = filelistcount($referralspath & "\ohio\updates\")
	$label51 = GUICtrlCreateLabel("Updates: " & $ohiovariable1, 111, 335)
	$unionvariable1 = filelistcount($referralspath & "\union\updates\")
	$label61 = GUICtrlCreateLabel("Updates: " & $unionvariable1, 111, 410)
	$webstervariable1 = filelistcount($referralspath & "\webster\updates\")
	$label71 = GUICtrlCreateLabel("Updates: " & $webstervariable1, 111, 485)
	$button11 = GUICtrlCreateButton("Daviess Updates", 110, 50, 75, 50, $BS_MULTILINE)
	$button21 = GUICtrlCreateButton("Hancock Updates", 110, 125, 75, 50, $BS_MULTILINE)
	$button31 = GUICtrlCreateButton("Henderson Updates", 110, 200, 75, 50, $BS_MULTILINE)
	$button41 = GUICtrlCreateButton("McLean Updates", 110, 275, 75, 50, $BS_MULTILINE)
	$button51 = GUICtrlCreateButton("Ohio Updates", 110, 350, 75, 50, $BS_MULTILINE)
	$button61 = GUICtrlCreateButton("Union Updates", 110, 425, 75, 50, $BS_MULTILINE)
	$button71 = GUICtrlCreateButton("Webster Updates", 110, 500, 75, 50, $BS_MULTILINE)
	$import = GUICtrlCreateButton("Import", 250, 500, 75, 50)
	$importlabel = GUICtrlCreateLabel("Referrals must be .pdf" & @CRLF & "files for import to function.", 215, 465)
	GUISetState(@SW_SHOW, $mainWindow)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $sync
				GUIDelete()
				Sync()
				MainWindow()
			Case $openlog
				ShellExecute($referralspath & "\Referral Log.xlsx")
			Case $openoldlog
				ShellExecute($referralspath & "\Previous Referral Log.xlsx")
			Case $logarchive
				$confirm = MsgBox(4, "Confirm", "Are you sure you want to archive the Referral Logs?")
				If $confirm = 6 Then
					FileMove($referralspath & "\Previous Referral Log.xlsx", $referralspath & "\Log Archive\" & ($date[1] - 1) & ".xlsx")
					FileMove($referralspath & "\Referral Log.xlsx", $referralspath & "\Previous Referral Log.xlsx")
					FileCopy("\\" & $server & "\hands\gui\referral log.xlsx", $referralspath)
				Else
					GUIDelete()
					MainWindow()
				EndIf
			Case $openarchive
				GUIDelete()
				openlogarchive()
				;Case $openreferralarchive
				;	GUIDelete()
				;	ReferralArchiveLanding()
			Case $openpermanentarchive
				GUIDelete()
				PermanentArchiveLanding()
			Case $button1
				GUIDelete()
				pendingreferrals("Daviess")
			Case $button2
				GUIDelete()
				pendingreferrals("Hancock")
			Case $button3
				GUIDelete()
				pendingreferrals("Henderson")
			Case $button4
				GUIDelete()
				pendingreferrals("McLean")
			Case $button5
				GUIDelete()
				pendingreferrals("Ohio")
			Case $button6
				GUIDelete()
				pendingreferrals("Union")
			Case $button7
				GUIDelete()
				pendingreferrals("Webster")
			Case $button11
				GUIDelete()
				updatedreferrals("Daviess")
			Case $button21
				GUIDelete()
				updatedreferrals("Hancock")
			Case $button31
				GUIDelete()
				updatedreferrals("Henderson")
			Case $button41
				GUIDelete()
				updatedreferrals("McLean")
			Case $button51
				GUIDelete()
				updatedreferrals("Ohio")
			Case $button61
				GUIDelete()
				updatedreferrals("Union")
			Case $button71
				GUIDelete()
				updatedreferrals("Webster")
			Case $import
				GUIDelete()
				referralimport()
		EndSwitch
	WEnd
EndFunc   ;==>MainWindow

Func pendingreferrals($county)
	$pendingreferralgui = GUICreate("Pending Referrals", 500, 500)
	$list = GUICtrlCreateListView("Pending Referrals", 25, 25, 450, 400)
	_GUICtrlListView_SetColumnWidth($list, 0, 447)
	FileList($list, $county, $referralspath & "\" & $county, "*.pdf")
	$button1 = GUICtrlCreateButton("Open", 375, 426, 100, 25)
	$button2 = GUICtrlCreateButton("Move to Updates", 275, 426, 100, 25)
	$button3 = GUICtrlCreateButton("Enroll Patient", 175, 426, 100, 25)
	GUISetState(@SW_SHOW, $pendingreferralgui)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				MainWindow()
			Case $button1
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a referral", "You need to select a referral")
				Else
					ShellExecute($referralspath & "\" & $county & "\" & $sItem)
				EndIf
			Case $button2
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a referral", "You need to select a referral")
				Else
					FileMove($referralspath & "\" & $county & "\" & $sItem, $referralspath & "\" & $county & "\updates\" & $sItem, $FC_CREATEPATH)
					_GUICtrlListView_DeleteAllItems($list)
					FileList($list, $county, $referralspath & "\" & $county, "*.pdf")
				EndIf
			Case $button3
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a referral", "You need to select a referral")
				Else
					FileCopy($referralspath & "\" & $county & "\" & $sItem, $referralspath & "\" & $county & "\updates\" & $sItem, $FC_CREATEPATH)
					FileMove($referralspath & "\" & $county & "\" & $sItem, "\\" & $server & "\hands\employee folders\" & @UserName & "\work in progress\" & $sItem, $FC_CREATEPATH)
					_GUICtrlListView_DeleteAllItems($list)
					FileList($list, $county, $referralspath & "\" & $county, "*.pdf")
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>pendingreferrals

Func updatedreferrals($county)
	$updatedreferralgui = GUICreate("Updated Referrals", 500, 500)
	$list = GUICtrlCreateListView("Updated Referrals", 25, 25, 450, 400)
	_GUICtrlListView_SetColumnWidth($list, 0, 447)
	FileList($list, $county, $referralspath & "\" & $county & "\updates", "*.pdf")
	$button1 = GUICtrlCreateButton("Open", 375, 426, 100, 25)
	$button2 = GUICtrlCreateButton("Move to Pending", 275, 426, 100, 25)
	$button3 = GUICtrlCreateButton("File to Archive", 175, 426, 100, 25)
	GUISetState(@SW_SHOW, $updatedreferralgui)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				MainWindow()
			Case $button1
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a referral", "You need to select a referral")
				Else
					ShellExecute($referralspath & "\" & $county & "\updates\" & $sItem)
				EndIf
			Case $button2
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a referral", "You need to select a referral")
				Else
					FileMove($referralspath & "\" & $county & "\updates\" & $sItem, $referralspath & "\" & $county & "\" & $sItem, $FC_CREATEPATH)
					_GUICtrlListView_DeleteAllItems($list)
					FileList($list, $county, $referralspath & "\" & $county & "\updates", "*.pdf")
				EndIf
			Case $button3
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a referral", "You need to select a referral")
				Else
					GUIDelete()
					ArchiveTransmit($sItem, $county)
					;	FileMove($referralspath & "\" & $county & "\updates\" & $sItem, $referralspath & "\" & $county & "\Archive\" & $sItem, $FC_CREATEPATH)
					;	_GUICtrlListView_DeleteAllItems($list)
					;	FileList($list, $county, $referralspath & "\" & $county & "\updates", "*.pdf")
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>updatedreferrals

Func Sync()
	$filecheck = FileExists("\\" & $server & "\hands")
	If $filecheck = 0 Then
		MsgBox(0, "GRDHD Network Connection Not Detected", "The GRDHD netowrk has not been detected, synchronization cannot continue", 3)
	EndIf
	If $filecheck = 1 Then
		;$filecheck = FileExists($server & "\hands\gui\handssync.ffs_batch")
		;If $filecheck = 0 Then
		FileCopy("\\" & $server & "\hands\gui\referralSync.ffs_batch", @UserProfileDir & "\documents\hands", $FC_OVERWRITE)
		;EndIf
		If ProcessExists("NuancePDF.exe") Then
			MsgBox(0, "Error", "Sync cannot run while PDf files are open, please close all PDF files." & @CRLF & "Sync will begin once all PDF files are closed.")
			ProcessWaitClose("NuancePDF.exe")
		EndIf
		ShellExecute(@UserProfileDir & "\documents\hands\referralSync.ffs_batch")
		Sleep(1000)
		ProcessWaitClose("freefilesync.exe")
	EndIf
EndFunc   ;==>Sync

Func openlogarchive()
	$referralloggui = GUICreate("Archived Referral Logs", 500, 500)
	$list = GUICtrlCreateListView("Referral Logs", 25, 25, 450, 400)
	_GUICtrlListView_SetColumnWidth($list, 0, 447)
	FileList($list, "log archive", $referralspath & "\log archive", "*.xlsx")
	$button1 = GUICtrlCreateButton("Open", 375, 426, 100, 25)
	GUISetState(@SW_SHOW, $referralloggui)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				MainWindow()
			Case $button1
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a log", "You need to select a log")
				Else
					ShellExecute($referralspath & "\log archive\" & $sItem)
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>openlogarchive

Func referralimport()
	$importgui = GUICreate("Refferal Import", 500, 500)
	$list = GUICtrlCreateListView("Referrals to Import", 25, 25, 300, 400)
	_GUICtrlListView_SetColumnWidth($list, 0, 297)
	FileList($list, "log archive", @UserProfileDir & "\desktop\import", "*.pdf")
	$button1 = GUICtrlCreateButton("Daviess", 375, 25, 100, 25)
	$button2 = GUICtrlCreateButton("Hancock", 375, 90, 100, 25)
	$button3 = GUICtrlCreateButton("Henderson", 375, 155, 100, 25)
	$button4 = GUICtrlCreateButton("Mclean", 375, 220, 100, 25)
	$button5 = GUICtrlCreateButton("Ohio", 375, 285, 100, 25)
	$button6 = GUICtrlCreateButton("Union", 375, 350, 100, 25)
	$button7 = GUICtrlCreateButton("Webster", 375, 415, 100, 25)
	GUISetState(@SW_SHOW, $importgui)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				MainWindow()
			Case $button1
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a referral", "You need to select a referral")
				Else
					$lastname = InputBox("Last Name", " Input the patient's last name")
					If $lastname = "" Then
						MsgBox(0, "Error", "You must input a surname")
					Else
						$firstname = InputBox("First Name", "Input the patient's first name")
						If $firstname = "" Then
							MsgBox(0, "Error", "You must input a first name")
						Else
							FileMove(@UserProfileDir & "\desktop\import\" & $sItem, $referralspath & "\daviess\updates\" & $date[2] & "-" & $date[3] & "-" & $date[1] & " " & $lastname & ", " & $firstname & " - HANDS Referral.pdf", $FC_CREATEPATH)
							_GUICtrlListView_DeleteAllItems($list)
							FileList($list, "log archive", @UserProfileDir & "\desktop\import", "*.pdf")
						EndIf
					EndIf
				EndIf
			Case $button2
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a referral", "You need to select a referral")
				Else
					$lastname = InputBox("Last Name", " Input the patient's last name")
					If $lastname = "" Then
						MsgBox(0, "Error", "You must input a surname")
					Else
						$firstname = InputBox("First Name", "Input the patient's first name")
						If $firstname = "" Then
							MsgBox(0, "Error", "You must input a first name")
						Else
							FileMove(@UserProfileDir & "\desktop\import\" & $sItem, $referralspath & "\hancock\updates\" & $date[2] & "-" & $date[3] & "-" & $date[1] & " " & $lastname & ", " & $firstname & " - HANDS Referral.pdf", $FC_CREATEPATH)
							_GUICtrlListView_DeleteAllItems($list)
							FileList($list, "log archive", @UserProfileDir & "\desktop\import", "*.pdf")
						EndIf
					EndIf
				EndIf
			Case $button3
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a referral", "You need to select a referral")
				Else
					$lastname = InputBox("Last Name", " Input the patient's last name")
					If $lastname = "" Then
						MsgBox(0, "Error", "You must input a surname")
					Else
						$firstname = InputBox("First Name", "Input the patient's first name")
						If $firstname = "" Then
							MsgBox(0, "Error", "You must input a first name")
						Else
							FileMove(@UserProfileDir & "\desktop\import\" & $sItem, $referralspath & "\henderson\updates\" & $date[2] & "-" & $date[3] & "-" & $date[1] & " " & $lastname & ", " & $firstname & " - HANDS Referral.pdf", $FC_CREATEPATH)
							_GUICtrlListView_DeleteAllItems($list)
							FileList($list, "log archive", @UserProfileDir & "\desktop\import", "*.pdf")
						EndIf
					EndIf
				EndIf
			Case $button4
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a referral", "You need to select a referral")
				Else
					$lastname = InputBox("Last Name", " Input the patient's last name")
					If $lastname = "" Then
						MsgBox(0, "Error", "You must input a surname")
					Else
						$firstname = InputBox("First Name", "Input the patient's first name")
						If $firstname = "" Then
							MsgBox(0, "Error", "You must input a first name")
						Else
							FileMove(@UserProfileDir & "\desktop\import\" & $sItem, $referralspath & "\mclean\updates\" & $date[2] & "-" & $date[3] & "-" & $date[1] & " " & $lastname & ", " & $firstname & " - HANDS Referral.pdf", $FC_CREATEPATH)
							_GUICtrlListView_DeleteAllItems($list)
							FileList($list, "log archive", @UserProfileDir & "\desktop\import", "*.pdf")
						EndIf
					EndIf
				EndIf
			Case $button5
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a referral", "You need to select a referral")
				Else
					$lastname = InputBox("Last Name", " Input the patient's last name")
					If $lastname = "" Then
						MsgBox(0, "Error", "You must input a surname")
					Else
						$firstname = InputBox("First Name", "Input the patient's first name")
						If $firstname = "" Then
							MsgBox(0, "Error", "You must input a first name")
						Else
							FileMove(@UserProfileDir & "\desktop\import\" & $sItem, $referralspath & "\ohio\updates\" & $date[2] & "-" & $date[3] & "-" & $date[1] & " " & $lastname & ", " & $firstname & " - HANDS Referral.pdf", $FC_CREATEPATH)
							_GUICtrlListView_DeleteAllItems($list)
							FileList($list, "log archive", @UserProfileDir & "\desktop\import", "*.pdf")
						EndIf
					EndIf
				EndIf
			Case $button6
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a referral", "You need to select a referral")
				Else
					$lastname = InputBox("Last Name", " Input the patient's last name")
					If $lastname = "" Then
						MsgBox(0, "Error", "You must input a surname")
					Else
						$firstname = InputBox("First Name", "Input the patient's first name")
						If $firstname = "" Then
							MsgBox(0, "Error", "You must input a first name")
						Else
							FileMove(@UserProfileDir & "\desktop\import\" & $sItem, $referralspath & "\union\updates\" & $date[2] & "-" & $date[3] & "-" & $date[1] & " " & $lastname & ", " & $firstname & " - HANDS Referral.pdf", $FC_CREATEPATH)
							_GUICtrlListView_DeleteAllItems($list)
							FileList($list, "log archive", @UserProfileDir & "\desktop\import", "*.pdf")
						EndIf
					EndIf
				EndIf
			Case $button7
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a referral", "You need to select a referral")
				Else
					$lastname = InputBox("Last Name", " Input the patient's last name")
					If $lastname = "" Then
						MsgBox(0, "Error", "You must input a surname")
					Else
						$firstname = InputBox("First Name", "Input the patient's first name")
						If $firstname = "" Then
							MsgBox(0, "Error", "You must input a first name")
						Else
							FileMove(@UserProfileDir & "\desktop\import\" & $sItem, $referralspath & "\webster\updates\" & $date[2] & "-" & $date[3] & "-" & $date[1] & " " & $lastname & ", " & $firstname & " - HANDS Referral.pdf", $FC_CREATEPATH)
							_GUICtrlListView_DeleteAllItems($list)
							FileList($list, "log archive", @UserProfileDir & "\desktop\import", "*.pdf")
						EndIf
					EndIf
				EndIf
		EndSwitch
	WEnd

EndFunc   ;==>referralimport

Func ReferralArchiveLanding()
	$Archivegui = GUICreate("Archived Referrals", 300, 300)
	$button1 = GUICtrlCreateButton("Daviess", 25, 25, 100, 25)
	$button2 = GUICtrlCreateButton("Hancock", 25, 90, 100, 25)
	$button3 = GUICtrlCreateButton("Henderson", 25, 155, 100, 25)
	$button4 = GUICtrlCreateButton("Mclean", 25, 220, 100, 25)
	$button5 = GUICtrlCreateButton("Ohio", 150, 25, 100, 25)
	$button6 = GUICtrlCreateButton("Union", 150, 90, 100, 25)
	$button7 = GUICtrlCreateButton("Webster", 150, 155, 100, 25)
	GUISetState(@SW_SHOW, $Archivegui)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				MainWindow()
			Case $button1
				GUIDelete()
				ReferralArchive("Daviess")
			Case $button2
				GUIDelete()
				ReferralArchive("Hancock")
			Case $button3
				GUIDelete()
				ReferralArchive("Henderson")
			Case $button4
				GUIDelete()
				ReferralArchive("McLean")
			Case $button5
				GUIDelete()
				ReferralArchive("Ohio")
			Case $button6
				GUIDelete()
				ReferralArchive("Union")
			Case $button7
				GUIDelete()
				ReferralArchive("Webster")
		EndSwitch
	WEnd

EndFunc   ;==>ReferralArchiveLanding

Func ReferralArchive($county)
	$Archivegui = GUICreate("Archived Referrals", 450, 500)
	$list = GUICtrlCreateListView("Referrals", 25, 25, 400, 400)
	_GUICtrlListView_SetColumnWidth($list, 0, 397)
	FileList($list, "archive", $referralspath & "\" & $county & "\Archive", "*.pdf")
	GUISetState(@SW_SHOW, $Archivegui)
	$button1 = GUICtrlCreateButton("Open", 325, 426, 100, 25)
	$button2 = GUICtrlCreateButton("Archive Permanently", 220, 426, 105, 25)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				MainWindow()
			Case $button1
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a log", "You need to select a referral")
				Else
					ShellExecute($referralspath & "\" & $county & "\Archive\" & $sItem)
				EndIf
			Case $button2
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a log", "You need to select a referral")
				Else
					GUIDelete()
					ArchiveTransmit($sItem, $county)
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>ReferralArchive

Func ArchiveTransmit($file, $county)
	$transmitgui = GUICreate("Archive", 200, 100)
	$button1 = GUICtrlCreateButton("Previous Year", 0, 0, 100, 100, $BS_MULTILINE)
	$button2 = GUICtrlCreateButton("Current Year", 100, 0, 100, 100, $BS_MULTILINE)
	GUISetState(@SW_SHOW, $transmitgui)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				MainWindow()
			Case $button1
				FileMove($referralspath & "\" & $county & "\updates\" & $file, $referralspath & "\" & $county & "\Archive\" & $date[1] - 1 & "\" & $file, $FC_CREATEPATH)
				GUIDelete()
				updatedreferrals($county)
			Case $button2
				FileMove($referralspath & "\" & $county & "\updates\" & $file, $referralspath & "\" & $county & "\Archive\" & $date[1] & "\" & $file, $FC_CREATEPATH)
				GUIDelete()
				updatedreferrals($county)
		EndSwitch
	WEnd
EndFunc   ;==>ArchiveTransmit

Func PermanentArchiveLanding()
	$Archivegui = GUICreate("Archived Referrals", 300, 300)
	$button1 = GUICtrlCreateButton("Daviess", 25, 25, 100, 25)
	$button2 = GUICtrlCreateButton("Hancock", 25, 90, 100, 25)
	$button3 = GUICtrlCreateButton("Henderson", 25, 155, 100, 25)
	$button4 = GUICtrlCreateButton("Mclean", 25, 220, 100, 25)
	$button5 = GUICtrlCreateButton("Ohio", 150, 25, 100, 25)
	$button6 = GUICtrlCreateButton("Union", 150, 90, 100, 25)
	$button7 = GUICtrlCreateButton("Webster", 150, 155, 100, 25)
	GUISetState(@SW_SHOW, $Archivegui)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				MainWindow()
			Case $button1
				GUIDelete()
				permanentReferralArchive("Daviess")
			Case $button2
				GUIDelete()
				permanentReferralArchive("Hancock")
			Case $button3
				GUIDelete()
				permanentReferralArchive("Henderson")
			Case $button4
				GUIDelete()
				permanentReferralArchive("McLean")
			Case $button5
				GUIDelete()
				permanentReferralArchive("Ohio")
			Case $button6
				GUIDelete()
				permanentReferralArchive("Union")
			Case $button7
				GUIDelete()
				permanentReferralArchive("Webster")
		EndSwitch
	WEnd
EndFunc   ;==>PermanentArchiveLanding

Func permanentReferralArchive($county)
	$Archivegui = GUICreate("Archived Referrals", 450, 500)
	$list = GUICtrlCreateListView("Referrals", 25, 25, 400, 400)
	_GUICtrlListView_SetColumnWidth($list, 0, 397)
	$archivepath = $referralspath & "\" & $county & "\Archive"
	FileList($list, "archive", $archivepath, "????")
	GUISetState(@SW_SHOW, $Archivegui)
	$button1 = GUICtrlCreateButton("Open", 325, 426, 100, 25)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				MainWindow()
			Case $button1
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You must make a selection")
				Else
					$attributes = FileGetAttrib($archivepath & "\" & $sItem)
					If $attributes = "D" Then
						_GUICtrlListView_DeleteAllItems($list)
						$archivepath = $archivepath & "\" & $sItem
						FileList($list, "archive", $archivepath, "*.pdf")
					Else
						ShellExecute($archivepath & "\" & $sItem)
					EndIf
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>permanentReferralArchive

#include "filelist.au3"




