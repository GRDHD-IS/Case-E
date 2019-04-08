#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=\\grdhd3\hands\HANDS Box\Version 1.1\hands-start-icon.ico
#AutoIt3Wrapper_Res_Description=GRDHD HANDS GUI for Data Entry
#AutoIt3Wrapper_Res_Fileversion=2.4.0.0
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
#include <WindowsConstants.au3>
#include <GUIListView.au3>
#include <Constants.au3>
#include <Date.au3>
#include <File.au3>
#include <Array.au3>
#include <Crypt.au3>
#include <String.au3>
#include <IE.au3>
#include <Timers.au3>

;Variables that declare paths
Global $server = "GRDHD3"
Global $employeefolders = "\\" & $server & "\HANDS\employee folders"
Global $chartsPath = "\\" & $server & "\HANDS\charts"
Global $supervisorpath = "\\" & $server & "\hands\supervisor"
;Global $variable = "\\" & $server & "\HANDS\employee folders"
Global $labelsPath = "\\" & $server & "\HANDS\Documents\Labels"
;Variables used as defaults for functions
Global $formLanguage = "English"
Global $formspath = "\\" & $server & "\HANDS\Documents\forms"
Global $caseloadspath = "\\" & $server & "\HANDS\GUI\caseload.xlsx"

;Variable for caseload file type
Global $caseloadFileType = ".xlsx"

;---------------------------------------------------------------------------------------------------------------------------------------------------------
Global $labelFields[10]
Global $labelFieldsNames[10] = ["_GRDHD_FSW", "_GRDHD_SSN", "_GRDHD_CLID", "_GRDHD_DOB", "_GRDHD_LNAME", "_GRDHD_FNAME", "_GRDHD_MI", "_GRDHD_BILLING", "_GRDHD_NAME", "_GRDHD_FORMDATE"]
Global $labelsSelectPath = "\\" & $server & "\HANDS\documents\labels"
Dim $masterFDFTemplate[5]

$masterFDFTemplate[0] = '%FDF-1.2' & Chr(13) & '%' & _
		Chr(226) & Chr(227) & Chr(207) & Chr(211) & @CRLF & _
		'1 0 obj' & @CRLF & _
		'<</Type /Catalog' & @CRLF & _
		'/FDF <</F ('

$masterFDFTemplate[1] = ')' & @CRLF & _
		'/Fields ['

$masterFDFTemplate[2] = _
		']' & @CRLF & _
		'>>' & @CRLF & _
		'>>' & @CRLF & _
		'endobj' & @CRLF

$masterFDFTemplate[3] = _
		'xref' & @CRLF & _
		'0 2' & @CRLF & _
		'0000000000 65535 f' & @CRLF & _
		'0000000016 00000 n' & @CRLF & _
		'trailer' & @CRLF & _
		'<</Root 1 0 R' & @CRLF & _
		'/Size 2' & @CRLF & _
		'>>' & @CRLF & _
		'startxref' & @CRLF

$masterFDFTemplate[4] = _
		@CRLF & _
		'%%EOF' & @CRLF
;------------------------------------------------------------------------------------------------------------------------------------------


$filecheck = FileExists("\\" & $server & "\hands\gui\readme.txt")
If $filecheck = 1 Then
	$LocalVersion = FileRead(@UserProfileDir & "\documents\hands\gui\README.txt", 27)
	$ServerVersion = FileRead("\\grdhd3\hands\gui\README.txt", 27)
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

Func Update()
	FileDelete(@UserProfileDir & "\documents\hands\gui\README.txt")
	FileCopy("\\" & $server & "\hands\gui\README.txt", @UserProfileDir & "\documents\hands\gui\README.txt", $FC_OVERWRITE + $FC_CREATEPATH)
	FileDelete(@TempDir & "\GUI UPDATE.cmd")
	Global $CMD_BATCH = ':loop' & _
			@CRLF & 'del "' & @ScriptFullPath & '"' & _
			@CRLF & 'if exist "' & @ScriptFullPath & '" goto loop' & _
			@CRLF & 'copy "\\grdhd3\hands\gui\' & @OSArch & "\" & @ScriptName & '" "' & @ScriptFullPath & '"' & _
			@CRLF & 'f' & _
			@CRLF & '"' & @ScriptFullPath & '"'
	FileWrite(@TempDir & "\GUI UPDATE.cmd", $CMD_BATCH)
	Run(@TempDir & "\GUI UPDATE.cmd", @TempDir, @SW_HIDE)
EndFunc   ;==>Update

Func MainWindow()
	Global $mainWindow = GUICreate("Case-E Data Entry Edition", 461, 673)
	Global $workerlist = GUICtrlCreateListView("Workers", 10, 50, 277, 520)
	_GUICtrlListView_SetColumnWidth($workerlist, 0, 250)
	FileList($workerlist, "\to data entry", $employeefolders, "*")
	Global $workerdatafolder = GUICtrlCreateListView("To Data Entry", 286, 50, 166, 520)
	_GUICtrlListView_SetColumnWidth($workerdatafolder, 0, 140)
	Filelist3($workerdatafolder, $employeefolders, "*")
	Global $openToDataButton = GUICtrlCreateButton("Open ' to Data'", 10, 571, 124, 25)
	Global $HealthNetButton = GUICtrlCreateButton("Open KY Health Net", 261, 571, 192, 25)
	Global $HANDS2Button = GUICtrlCreateButton("Open HANDS 2.0", 261, 597, 192, 25)
	Global $OpenCaseloadButton = GUICtrlCreateButton("Open Caseload", 135, 571, 125, 25)
	;Global $toSupervisor = GUICtrlCreateButton("Send to Supervisor", 10, 377, 125, 25)
	Global $chartButton = GUICtrlCreateButton("Charts", 135, 597, 124, 25)
	$DataLabels = GUICtrlCreateButton("Labels", 10, 623, 124, 25)
	$supervisorFolder = GUICtrlCreateButton("Supervisor Folder", 135, 623, 124, 25)
	Global $refreshButton = GUICtrlCreateButton("Refresh", 10, 597, 124, 25)
	GUISetState(@SW_SHOW, $mainWindow)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $supervisorFolder
				ShellExecute($supervisorpath)
			Case $HealthNetButton
				$oIE = _IECreate("https://sso.kymmis.com/adfs/ls/?wa=wsignin1.0&wtrealm=https%3a%2f%2fsso2.kymmis.com%2fadfs%2fls%2fid&wctx=0b0e5479-d63c-4273-8534-94396ecc6841&wct=2018-06-11T15%3a21%3a21Z&whr=https%3a%2f%2fsso.kymmis.com%2fadfs%2fls%2fid")
			Case $HANDS2Button
				$oIE = _IECreate("https://ssoexternal.chfs.ky.gov")
			Case $openToDataButton
				$sItem = GUICtrlRead(GUICtrlRead($workerlist))
				$trim = StringInStr($sItem, "|")
				$sItem = StringTrimRight($sItem, StringLen($sItem) - $trim + 1)
				If $sItem = "" Then
					MsgBox(0, "Select a worker", "You need to select a worker")
				Else
					GUIDelete()
					OpentoData($sItem)
				EndIf
			Case $chartButton
				GUIDelete()
				ChartsGUI("data")
			Case $refreshButton
				_GUICtrlListView_DeleteAllItems($workerlist)
				FileList($workerlist, "\to data entry", $employeefolders, "*")
				_GUICtrlListView_DeleteAllItems($workerdatafolder)
				Filelist3($workerdatafolder, $employeefolders, "*")
			Case $DataLabels
				GUIDelete()
				Datalabels()
			Case $OpenCaseloadButton
				$sItem = GUICtrlRead(GUICtrlRead($workerlist))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a worker", "You need to select a worker")
				Else
					GUIDelete()
					Caseloads("datamain", $sItem)
				EndIf
		EndSwitch
	WEnd

EndFunc   ;==>MainWindow


#include "FileList.au3"
#include "ChartsGUI.au3."
#include "OpenToData.au3"
#include "ChartFileGUI.au3"
#include "ChartsPageFind.au3"
#include "NewFamily.au3"
#include "Opentosupervisor.au3"
#include "SurveySignGUI.au3"
#include "DataLabels.au3"
#include "Labels.au3"
#include "caseload.au3"
