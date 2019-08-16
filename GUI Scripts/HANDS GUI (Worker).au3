#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\HANDS Box\Version 1.1\hands-start-icon.ico
#AutoIt3Wrapper_Res_Description=GRDHD HANDS GUI for Workers
#AutoIt3Wrapper_Res_Fileversion=3.4.0.0
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;******************************************************************************
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

;Versioning variable
$version = "3.4"

;Variables that declare paths
Global $server = "GRDHD5"
Global $handsPath = @UserProfileDir & "\documents\HANDS"
Global $workPath = $handsPath & "\Work in Progress"
;Global $supervisionPath = $handsPath & "\Supervision"
Global $supervisorPath = $handsPath & "\to Supervisor"
Global $dataPath = $handsPath & "\to Data Entry"
Global $correctionPath = $handsPath & "\Needs Correction"
Global $labelsPath = $handsPath & "\Labels"
Global $formsPath = $handsPath & "\Forms"
Global $activitiesPath = $handsPath & "\Activities"
Global $handoutspath = $handsPath & "\Handouts"
Global $chartsPath = "\\" & $server & "\HANDS\charts"
Global $completePath = $handsPath & "\Visits Completed"
Global $caseloadsPath = "\\" & $server & "\HANDS\caseloads\" & @UserName
Global $employeefolders = "\\" & $server & "\HANDS\employee folders\" & @UserName

;Variable for caseload file type
Global $caseloadFileType = ".xlsx"

;Variables used as defaults for functions
Global $formLanguage = "English"

;Variables used for date calculations
$sDate = _NowCalcDate()
$aDate = StringSplit($sDate, "/")
Global $sDate = _DateToMonth($aDate[2], 1) & "-" & $aDate[1]
Global $syear = $aDate[1]

;---------------------------------------------------------------------------------------------------------------------------------------------------------
Global $labelFields[10]
Global $labelFieldsNames[10] = ["_GRDHD_FSW", "_GRDHD_SSN", "_GRDHD_CLID", "_GRDHD_DOB", "_GRDHD_LNAME", "_GRDHD_FNAME", "_GRDHD_MI", "_GRDHD_BILLING", "_GRDHD_NAME", "_GRDHD_FORMDATE"]
Global $labelsSelectPath = @UserProfileDir & "\documents\hands\labels"
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
;Forms Variables
;----------------------------------------------------------------------------------------------------------------------------------------------------------
Global $formsCopied[0]
Global $formsCopiedHashes[0]
Global $checkPDFProcess = ["NitroPDF.exe", "Acrobat.exe", "Acrord32.exe", "Excel.exe", "FoxitReader.exe", "NuancePDF.exe"]
Global $blankLabelName = "000 - Blank Label.pdf"
If (@OSArch = "X32") Then
	Global $pdftk = EnvGet("programfiles") & '\PDFtk\bin\pdftk.exe'
Else
	Global $pdftk = EnvGet("programfiles(x86)") & '\PDFtk\bin\pdftk.exe'
EndIf
;date variables
Global $GetDate_DateEntered = -1
Global $GetDate_Window
Global $GetDate_Callback
Global $GetDate_Today
Global $GetDate_Yesterday
Global $GetDate_OtherDateCtrl
Global $GetDate_ParentWin
Global $packets = getPDFList($formsPath & "\" & $formLanguage, "*.pdf")
Global $templates = $packets

;-----------------------------------------------------------------------------------------------
$processcheck = WinExists("Case-E Worker Edition v" & $version)
If $processcheck = 1 Then
	WinActivate("Case-E Worker Edition v" & $version)
	Exit
EndIf
$filecheck = FileExists("\\" & $server & "\hands\gui\readme - worker.txt")
If FileExists("c:\program files\freefilesync\freefilesync.exe") Then
	If $filecheck = 1 Then
		$LocalVersion = FileRead(@UserProfileDir & "\documents\hands\gui\README - worker.txt", 27)
		$ServerVersion = FileRead("\\" & $server & "\hands\gui\README - worker.txt", 27)
		If $LocalVersion = $ServerVersion Then
			setup()
			runsync()
			MainWindow()
		Else
			MsgBox(0, "Update Required", "Please Wait while your HANDS GUI is updated", 5)
			OnAutoItExitRegister("Update")
			Exit (1)
		EndIf
	Else
		runsync()
		MainWindow()
	EndIf
Else
	MsgBox(0, "File Missing", "You must install ""Free File Sync"" from the prerequisites folder before running the HANDS GUI")
EndIf

Func Update()
	FileDelete(@UserProfileDir & "\documents\hands\gui\README - worker.txt")
	FileCopy("\\" & $server & "\hands\gui\README - worker.txt", @UserProfileDir & "\documents\hands\gui\README - worker.txt", $FC_OVERWRITE + $FC_CREATEPATH)
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

;---------------------------------------------------------------------------------------------------------------------------------------------------------
;Main Window
Func MainWindow()
	Global $mainWindow = GUICreate("Case-E Worker Edition v" & $version, 635, 504)
	Global $labelList = GUICtrlCreateListView("Labels", 10, 50, 200, 300)
	_GUICtrlListView_SetColumnWidth($labelList, 0, 175)
	FileList($labelList, "", $labelsPath, "*.fdf")
	Global $formList = GUICtrlCreateListView("Forms", 225, 50, 400, 300)
	_GUICtrlListView_SetColumnWidth($formList, 0, 379)
	FileList($formList, "", $formsPath & "\" & $formLanguage, "*.*")
	$searchLabels = GUICtrlCreateButton("Search", 150, 24, 60, 25)
	$searchFroms = GUICtrlCreateButton("Search", 225, 24, 60, 25)
	$englishButton = GUICtrlCreateButton("English", 570, 25, 55, 25)
	$spanishButton = GUICtrlCreateButton("Spanish", 514, 25, 55, 25)
	$refreshButton = GUICtrlCreateButton("Refresh", 459, 25, 55, 25)
	$asqbutton = GUICtrlCreateButton("ASQ3/SE", 399, 25, 60, 25)
	$createLabel = GUICtrlCreateButton("New", 10, 351, 99, 25)
	;$editLabel = GUICtrlCreateButton("Edit", 77, 351, 66, 25)
	$deleteLabel = GUICtrlCreateButton("Delete", 110, 351, 100, 25)
	$createForm = GUICtrlCreateButton("Create Form", 225, 351, 132, 25)
	$viewForm = GUICtrlCreateButton("Forms in Progress", 358, 351, 133, 25)
	$Transmitbutton = GUICtrlCreateButton("Send to Supervisor", 492, 351, 132, 25)
	$chartButton = GUICtrlCreateButton("Charts", 225, 377, 132, 25)
	$surveyButton = GUICtrlCreateButton("Surveys to Sign", 225, 402, 200, 25)
	$visitsignatureButton = GUICtrlCreateButton("Visit Completed Signature Form", 425, 402, 200, 25)
	$correctionButton = GUICtrlCreateButton("Needs Corrections", 358, 377, 133, 25)
	$supervisionButton = GUICtrlCreateButton("Supervision", 492, 377, 132, 25)
	$Sync = GUICtrlCreateButton("Synchronize with Server", 10, 377, 200, 50)
	$import = GUICtrlCreateButton("Import", 359, 428, 132, 25)
	$activities = GUICtrlCreateButton("Activitites", 492, 428, 132, 25)
	$handouts = GUICtrlCreateButton("Handouts", 492, 454, 132, 25)
	$openCaseload = GUICtrlCreateButton("Caseload", 225, 428, 132, 25)
	$opengoals = GUICtrlCreateButton("Goals", 359, 454, 132, 25)
	$workingcount = GUICtrlCreateLabel("Files in progress: " & FileListCount($workPath), 64, 429)
	$correctioncount = GUICtrlCreateLabel("Files needing correction: " & FileListCount($correctionPath), 28, 450)
	$surveycount = GUICtrlCreateLabel("Surveys needing signatures: " & FileListCount($correctionPath & "\Surveys to sign\"), 10, 471)

	GUISetState(@SW_SHOW, $mainWindow)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $searchLabels
				$response = InputBox("Label Search", "Search for:")
				_GUICtrlListView_DeleteAllItems($labelList)
				FileList($labelList, "", $labelsPath, "*" & $response & "*.fdf")
			Case $searchFroms
				$response = InputBox("Label Search", "Search for:")
				_GUICtrlListView_DeleteAllItems($formList)
				FileList($formList, "", $formsPath & "\" & $formLanguage, "*" & $response & "*.*")
			Case $chartButton
				GUIDelete($mainWindow)
				ChartsGUI("worker")
			Case $viewForm
				GUIDelete($mainWindow)
				WorkingGUI()
			Case $supervisionButton
				ShellExecute("\\" & $server & "\hands\employee folders\" & @UserName & "\supervision\in progress\Supplement Form A.pdf")
			Case $correctionButton
				GUIDelete($mainWindow)
				CorrectionGUI()
			Case $Transmitbutton
				GUIDelete($mainWindow)
				tosupervisorGUI()
			Case $spanishButton
				$formLanguage = "Spanish"
				_GUICtrlListView_DeleteAllItems($formList)
				FileList($formList, "", $formsPath & "\" & $formLanguage, "*.*")
			Case $englishButton
				$formLanguage = "English"
				_GUICtrlListView_DeleteAllItems($formList)
				FileList($formList, "", $formsPath & "\" & $formLanguage, "*.*")
			Case $refreshButton
				Global $formsPath = $handsPath & "\Forms"
				GUIDelete($mainWindow)
				MainWindow()
			Case $asqbutton
				Global $formsPath = $handsPath & "\Forms\ASQ"
				_GUICtrlListView_DeleteAllItems($formList)
				FileList($formList, "", $formsPath & "\" & $formLanguage, "*.*")
			Case $Sync
				runSync()
				GUIDelete()
				MainWindow()
			Case $createLabel
				GUIDelete()
				newLabel()
			Case $visitsignatureButton
				GUIDelete()
				visitcomplete()
			Case $surveyButton
				GUIDelete()
				surveyGUI()
				;Case $editLabel
				;	$sItem = GUICtrlRead(GUICtrlRead($labelList))
				;	$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				;	If $sItem = "" Then
				;		MsgBox(0, "Error", "You must select a label")
				;	Else
				;		FileDelete($labelsPath & "\" & $sItem)
				;		GUIDelete()
				;		newlabel()
				;	EndIf
			Case $opengoals
				GUIDelete()
				GoalGUI()
			Case $deleteLabel
				$sItem = GUICtrlRead(GUICtrlRead($labelList))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You must select a label")
				Else
					$confirm = MsgBox(4, "Delete Label", "Are you sure you want to delete the lable " & $sItem & "?")
					If $confirm = 6 Then
						FileDelete($labelsPath & "\" & $sItem)
						_GUICtrlListView_DeleteAllItems($labelList)
						FileList($labelList, "", $labelsPath, "*.fdf")
						;Else
						;	GUIDelete($mainWindow)
						;	MainWindow()
					EndIf
				EndIf
			Case $import
				GUIDelete()
				Importgui("worker")
			Case $openCaseload
				GUIDelete()
				Caseloads("worker", @UserName)
			Case $activities
				GUIDelete()
				ActivitiesGUI()
			Case $handouts
				GUIDelete()
				HandoutsGUI()
			Case $createForm
				CreateFormPacket()
		EndSwitch
	WEnd
EndFunc   ;==>MainWindow


;custom includes
#include "VisitComplete.au3"
#include "SurveyGUI.au3"
#include "ChartsGUI.au3"
#include "FileList.au3"
#include "WorkInProgress.au3"
#include "CorrectionsGUI.au3"
#include "QueueToSupervisor.au3"
#include "WorkerSetup.au3"
#include "NewFamily.au3"
#include "RunSync.au3"
#include "Labels.au3"
#include "Forms.au3"
#include "FormDate.au3"
#include "ActivitiesGUI.au3"
#include "HandoutsGUI.au3"
#include "ImportGUI.au3"
#include "Caseload.au3"
#include "GoalGUI.au3"
#include "opentodata.au3"
#include "surveysigngui.au3"
#include "chartfilegui.au3"
#include "opentosupervisor.au3"
#include "chartspagefind.au3"

