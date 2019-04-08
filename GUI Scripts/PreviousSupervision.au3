Func previousSupervision($worker)
	Global $SupervisionGUI = GUICreate("Weekly Supervision", 300, 355)
	$list = GUICtrlCreateListView("Select a File", 10, 10, 280, 280)
	_GUICtrlListView_SetColumnWidth($list, 0, 279)
	$openbutton = GUICtrlCreateButton("Open", 151, 291, 140, 25)
	$FileList = _FileListToArray($employeefolders & "\" & $worker & "\weekly supervision\previous supervision forms", "*.pdf")
	If @error = 1 Then
		MsgBox(0, "Error", "You must select a worker from the list.")
		MainWindow()
	EndIf
	If @error = 4 Then
		MsgBox(0, "Error", "No files found in the "" previous weekly supervision"" directory for " & $worker)
		MainWindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $SupervisionGUI)
		While 1
			$cmsg = GUIGetMsg()
			Switch $cmsg
				Case $openbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					ShellExecute($employeefolders & "\" & $worker & "\Weekly Supervision\previous supervision forms\" & $sItem)
				Case $GUI_EVENT_CLOSE
					GUIDelete()
					MainWindow()
			EndSwitch
		WEnd
	EndIf
EndFunc   ;==>previousSupervision