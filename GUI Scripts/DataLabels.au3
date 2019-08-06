Func DataLabels()
	$LabelGUI = GUICreate("Labels", 220, 400)
	$labelList = GUICtrlCreateListView("Label", 10, 50, 200, 300)
	_GUICtrlListView_SetColumnWidth($labelList, 0, 175)
	FileList($labelList, "", $labelsPath, "*.fdf")
	$createLabel = GUICtrlCreateButton("New", 10, 351, 66, 25)
	$deleteLabel = GUICtrlCreateButton("Delete", 144, 351, 66, 25)
	$searchLabels = GUICtrlCreateButton("Search", 150, 24, 60, 25)
	$editlabel = GUICtrlCreateButton("Edit", 76, 351, 66, 25)

	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				mainwindow()
			Case $searchLabels
				$response = InputBox("Label Search", "Search for:")
				_GUICtrlListView_DeleteAllItems($labelList)
				FileList($labelList, "", $labelsPath, "*" & $response & "*.fdf")
			Case $createLabel
				GUIDelete()
				newLabel()
			Case $editlabel
				$sItem = GUICtrlRead(GUICtrlRead($labelList))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You must select a label")
				Else
					ShellExecute($labelsPath & "\" & $sItem)
				EndIf
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
		EndSwitch
	WEnd

EndFunc   ;==>DataLabels
