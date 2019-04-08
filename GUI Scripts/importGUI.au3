Func ImportGUI($parent)

	Global $ImportGUI = GUICreate("GRDHD HANDS Home Visitor", 500, 350)
	GUICtrlCreateLabel("Select a file to import, a label to apply, and the type of form. Finally, select a date then click ""Import""", 10, 10)

	;---------------------------------------------------------------------------------------------------
	GUICtrlCreateLabel("Select the date the file was recieved:", 250, 265)
	Global $GetDate_OtherDateCtrl = GUICtrlCreateDate("", 250, 285, 230, 30, $DTS_LONGDATEFORMAT)
	$importbutton = GUICtrlCreateButton("Import", 10, 285, 230, 30)
	;-----------------------------------------------------------------------------------------------

	;-----------------------------------------------------------------------------------------------
	$labelList = GUICtrlCreateListView("Select a Label to apply to this form", 235, 50, 220, 200)
	_GUICtrlListView_SetColumnWidth($labelList, 0, 197)
	FileList($labelList, "", $labelsPath, "*.fdf")
	$searchLabels = GUICtrlCreateButton("Search", 390, 24, 60, 25)
	;-----------------------------------------------------------------------------------------------
	;$image1 = GUICtrlCreatePic("HANDS.jpg", 250, 320, 230, 105)
	;-----------------------------------------------------------------------------------------------
	$importList = GUICtrlCreateCombo("What type of form is being imported?:", 10, 260, 220, 200)
	_GUICtrlListView_SetColumnWidth($importList, 0, 215)
	$importforms = FileRead($formsPath & "\ImportForms.txt")
	$importforms = StringReplace($importforms, @CRLF, "|")

	GUICtrlSetData($importList, $importforms, "")
	;-----------------------------------------------------------------------------------------------
	$importfolderList = GUICtrlCreateListView("Select File to Import", 10, 50, 220, 200)
	_GUICtrlListView_SetColumnWidth($importfolderList, 0, 215)
	FileList($importfolderList, "", @UserProfileDir & "\desktop\Import", "*")
	;-----------------------------------------------------------------------------------------------
	GUISetState(@SW_SHOW, $ImportGUI)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				MainWindow()
			Case $searchLabels
				$response = InputBox("Label Search", "Search for:")
				_GUICtrlListView_DeleteAllItems($labelList)
				FileList($labelList, "", $labelsPath, $response & "*.fdf")
			Case $importbutton
				$sItem = GUICtrlRead(GUICtrlRead($importfolderList))
				$sItem = StringTrimRight($sItem, 1)
				$sItem2 = GUICtrlRead(GUICtrlRead($labelList))
				$sItem2 = StringTrimRight($sItem2, 5)
				$sItem3 = GUICtrlRead($importList)
				importgetdate()
				If $sItem = "" Then
					MsgBox(0, "Error", "You must select a file to import")
				Else
					If $sItem2 = "" Then
						MsgBox(0, "Error", "You must select a label for the file")
					Else
						If $sItem3 = "" Then
							MsgBox(0, "Error", "You must select a form type for this file")
						Else
							FileMove(@UserProfileDir & "\desktop\Import\" & $sItem, $workpath & "\" & $GetDate_DateEntered & " " & $sItem2 & " - " & $sItem3 & ".pdf") ;MM-DD-YYYY Last, First - Form
							_GUICtrlListView_DeleteAllItems($importfolderList)
							$importFileList = _FileListToArray(@UserProfileDir & "\desktop\Import")
							If @error = 4 Then
								GUIDelete()
								ImportGUI($parent)
							Else
								For $INDEX = 1 To $importFileList[0]
									GUICtrlCreateListViewItem($importFileList[$INDEX], $importfolderList)
								Next
							EndIf
						EndIf
					EndIf
				EndIf

		EndSwitch
	WEnd

EndFunc   ;==>ImportGUI

Func importgetdate()
	GUICtrlSendMsg($GetDate_OtherDateCtrl, $DTM_SETFORMAT, 0, "y")
	$year = GUICtrlRead($GetDate_OtherDateCtrl)
	GUICtrlSendMsg($GetDate_OtherDateCtrl, $DTM_SETFORMAT, 0, "M")
	$month = GUICtrlRead($GetDate_OtherDateCtrl)
	GUICtrlSendMsg($GetDate_OtherDateCtrl, $DTM_SETFORMAT, 0, "d")
	$day = GUICtrlRead($GetDate_OtherDateCtrl)
	Global $GetDate_DateEntered = StringFormat("%02s-%02s-20%02s", $month, $day, $year)
	;guictrlsendmsg($GetDate_OtherDateCtrl, $DTS_LONGDATEFORMAT, 0, "DD , MMMM dd , yyyy")
	GUICtrlDelete($GetDate_OtherDateCtrl)
	$GetDate_OtherDateCtrl = GUICtrlCreateDate("", 250, 285, 230, 30, $DTS_LONGDATEFORMAT)

EndFunc   ;==>importgetdate
