Func OpencompletedVisits($worker)
	Global $completedVisitsGUI = GUICreate("Completed Visits", 300, 379)
	$list = GUICtrlCreateListView("Select a file", 10, 10, 280, 280)
	_GUICtrlListView_SetColumnWidth($list, 0, 279)
	$openbutton = GUICtrlCreateButton("Open", 151, 291, 140, 25)

	$FileList = _FileListToArray($employeefolders & "\" & $worker & "\visits completed", "*.pdf")
	If @error = 1 Then
		MsgBox(0, "Error", "You must select a worker from the list.")
		MainWindow()
	EndIf
	If @error = 4 Then
		MsgBox(0, "Error", "No files found in the ""Visits Completed"" directory for " & $worker)
		MainWindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $completedVisitsGUI)
		While 1
			$cmsg = GUIGetMsg()
			Switch $cmsg
				Case $openbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					ShellExecute($employeefolders & "\" & $worker & "\visits completed" & $sItem)
				Case $GUI_EVENT_CLOSE
					GUIDelete()
					MainWindow()
			EndSwitch
		WEnd
	EndIf
EndFunc   ;==>OpencompletedVisits

Func OpencompletedVisitsArchive($worker)
	Global $completedVisitsGUI = GUICreate("Completed Visits", 300, 379)
	$list = GUICtrlCreateListView("Select a file", 10, 10, 280, 280)
	_GUICtrlListView_SetColumnWidth($list, 0, 279)
	$openbutton = GUICtrlCreateButton("Open", 151, 291, 140, 25)
	$FileList = _FileListToArray($employeefolders & "\" & $worker & "\completed visit archive", "*")
	If @error = 1 Then
		MsgBox(0, "Error", "You must select a worker from the list.")
		MainWindow()
	EndIf
	If @error = 4 Then
		MsgBox(0, "Error", "No files found in the ""Visits Completed Archive"" directory for " & $worker)
		MainWindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $completedVisitsGUI)
		$path = $employeefolders & "\" & $worker & "\completed visit archive"
		While 1
			$cmsg = GUIGetMsg()
			Switch $cmsg
				Case $openbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					If $sItem = '' Then
						MsgBox(0, 'Error', 'You must make a selection')
					Else
						$attributes = FileGetAttrib($path & "\" & $sItem)
						If $attributes = "D" Then
							$path = $path & "\" & $sItem
							_GUICtrlListView_DeleteAllItems($list)
							$FileList = _FileListToArray($path, "*")
							For $INDEX = 1 To $FileList[0]
								GUICtrlCreateListViewItem($FileList[$INDEX], $list)
							Next
						Else
							ShellExecute($path & "\" & $sItem)
						EndIf
					EndIf
				Case $GUI_EVENT_CLOSE
					GUIDelete()
					MainWindow()
			EndSwitch
		WEnd
	EndIf
EndFunc   ;==>OpencompletedVisitsArchive


