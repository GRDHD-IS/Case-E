Func surveyGUI()
	Global $surveyGUI = GUICreate("Surveys", 300, 330)
	$list = GUICtrlCreateListView("Select a Location", 10, 10, 280, 280)
	_GUICtrlListView_SetColumnWidth($list, 0, 279)
	$surveyselectbutton = GUICtrlCreateButton("Select", 245, 291, 45, 25)
	$queue = GUICtrlCreateButton("Send to Supervisor", 109, 291, 135, 25)
	$FileList = _FileListToArray($correctionPath & "\surveys to sign", "*.pdf")
	If @error = 1 Then
		MsgBox(0, "Error", "File location not found, ensure you are connected to the GRDHD network.")
		MainWindow()
	EndIf
	If @error = 4 Then
		MsgBox(0, "Error", "No survey files found.")
		MainWindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $surveyGUI)
	EndIf
	While 1
		$cmsg = GUIGetMsg()
		Switch $cmsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				MainWindow()
			Case $queue
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You must make a selection")
				Else
					$queueconfirm = MsgBox(4, "Confirm Queue", "Are you sure you want to queue " & $sItem & " to supervisor?")
					If $queueconfirm = 6 Then
						FileMove($correctionPath & "\surveys to sign\" & $sItem, $supervisorPath)
						_GUICtrlListView_DeleteAllItems($list)
						$FileList = _FileListToArray($correctionPath & "\surveys to sign", "*.pdf")
						If @error = 4 Then
							MsgBox(0, "Error", "No files found in Work in Progress Folder")
							MainWindow()
						Else
							For $INDEX = 1 To $FileList[0]
								GUICtrlCreateListViewItem($FileList[$INDEX], $list)
							Next
						EndIf
					EndIf
				EndIf
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				MainWindow()
			Case $surveyselectbutton
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You must make a selection")
				Else
					ShellExecute($correctionPath & "\surveys to sign\" & $sItem)
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>surveyGUI

