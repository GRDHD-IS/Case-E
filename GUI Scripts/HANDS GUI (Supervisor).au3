#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=\\grdhd3\hands\HANDS Box\Version 1.1\hands-start-icon.ico
#AutoIt3Wrapper_Res_Description=GRDHD HANDS GUI for Supervisors
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

;Variables that declare paths
Global $server = "GRDHD3"
Global $employeefolders = "\\" & $server & "\HANDS\employee folders"
Global $chartsPath = "\\" & $server & "\HANDS\charts"
Global $labelsPath = "\\" & $server & "\hands\documents\labels"
Global $workPath = "\\" & $server & "\hands\employee folders\" & @UserName & "\Work in Progress"
Global $formspath = "\\" & $server & "\hands\documents\forms"
Global $supervisorpath = "\\" & $server & "\hands\supervisor"
Global $caseloadspath = "\\" & $server & "\hands\gui\caseload.xlsx"
Global $supervisionFormsPath = "\\" & $server & "\Hands\gui\supervision"

;Variable for caseload file type
Global $caseloadFileType = ".xlsx"

;Variables used as defaults for functions
Global $formLanguage = "English"

Global $Getdate_Dateentered

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
	$mainWindow = GUICreate("Case-E Supervisor Edition", 877, 753)
	$workerlist = GUICtrlCreateListView("Workers", 10, 50, 251, 600)
	_GUICtrlListView_SetColumnWidth($workerlist, 0, 247)
	FileList($workerlist, "to supervisor", $employeefolders, "*")
	$workerfolders = GUICtrlCreateListView("To Supervisor | Needs Correction | To Data | Work in Progress", 260, 50, 596, 600)
	_GUICtrlListView_SetColumnWidth($workerfolders, 0, 148)
	_GUICtrlListView_SetColumnWidth($workerfolders, 1, 148)
	_GUICtrlListView_SetColumnWidth($workerfolders, 2, 148)
	_GUICtrlListView_SetColumnWidth($workerfolders, 3, 148)
	FileList2($workerfolders, $employeefolders, "*")
	$toSupervisor = GUICtrlCreateButton("Open ""To Supervisor""", 10, 651, 140, 25)
	$needsCorrection = GUICtrlCreateButton("Open ""Needs Correction""", 151, 651, 140, 25)
	$completedVisits = GUICtrlCreateButton("Open ""Completed Visits""", 151, 676, 140, 25)
	$completedVisitsArchive = GUICtrlCreateButton("""Completed Visits Archive""", 151, 701, 140, 25)
	$openCharts = GUICtrlCreateButton("Open Charts", 576, 651, 140, 25)
	$openArchive = GUICtrlCreateButton("Open Archive", 717, 651, 140, 25)
	$openCaseload = GUICtrlCreateButton("Caseload", 10, 676, 140, 25)
	$openSupervision = GUICtrlCreateButton("Supervision", 292, 651, 140, 25)
	$opendata = GUICtrlCreateButton("Open ""To Data""", 10, 701, 140, 25)
	$NewUserButton = GUICtrlCreateButton("Create New User", 292, 701, 140, 25)
	$Refresh = GUICtrlCreateButton("Refresh", 781, 0, 75, 25)
	$import = GUICtrlCreateButton("Import", 435, 651, 140, 25)
	$supervisorfolder = GUICtrlCreateButton("Supervisor Folder", 292, 676, 140, 25)
	GUISetState(@SW_SHOW, $mainWindow)


	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Refresh
				GUIDelete()
				MainWindow()
			Case $toSupervisor
				$sItem = GUICtrlRead(GUICtrlRead($workerlist))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a worker", "You need to select a worker")
				Else
					GUIDelete()
					OpentoSupervisor($sItem)
				EndIf
			Case $needsCorrection
				$sItem = GUICtrlRead(GUICtrlRead($workerlist))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a worker", "You need to select a worker")
				Else
					GUIDelete()
					openNeedscorrection($sItem)
				EndIf
			Case $opendata
				$sItem = GUICtrlRead(GUICtrlRead($workerlist))
				$trim = StringInStr($sItem, "|")
				$sItem = StringTrimRight($sItem, StringLen($sItem) - $trim + 1)
				If $sItem = "" Then
					MsgBox(0, "Select a worker", "You need to select a worker")
				Else
					GUIDelete()
					OpentoData($sItem)
				EndIf
			Case $completedVisits
				$sItem = GUICtrlRead(GUICtrlRead($workerlist))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				GUIDelete()
				OpencompletedVisits($sItem)
			Case $completedVisitsArchive
				$sItem = GUICtrlRead(GUICtrlRead($workerlist))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				GUIDelete()
				OpencompletedVisitsArchive($sItem)
			Case $openCharts
				GUIDelete()
				ChartsGUI("supervisor")
			Case $openArchive
				ShellExecute("\\" & $server & "\HANDS\Archive")
			Case $openCaseload
				$sItem = GUICtrlRead(GUICtrlRead($workerlist))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a worker", "You need to select a worker")
				Else
					GUIDelete()
					Caseloads("supervisor", $sItem)
				EndIf
			Case $supervisorfolder
				ShellExecute($supervisorpath)
			Case $openSupervision
				$sItem = GUICtrlRead(GUICtrlRead($workerlist))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Select a worker", "You need to select a worker")
				Else
					GUIDelete()
					supervision("supervisor", $sItem)
				EndIf
			Case $NewUserButton
				ShellExecute('\\' & $server & "\hands\handsuserfolders.cmd")
			Case $import
				GUIDelete()
				Importgui("supervisor")
		EndSwitch
	WEnd

EndFunc   ;==>MainWindow

#include "FileList.au3"
#include "CompletedVisits.au3"
#include "OpenToSupervisor.au3"
#include "OpenNeedsCorrection.au3"
#include "NewSupervision.au3"
#include "Supervision.au3"
#include "PreviousSupervision.au3"
#include "ChartsGUI.au3"
#include "ChartFileGUI.au3"
#include "ChartsPageFind.au3"
#include "NewFamily.au3"
#include "SurveySignGUI.au3"
#include "OpenToData.au3"
#include "ImportGUI.au3"
#include "Caseload.au3"
