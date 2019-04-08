Func openSupervision($worker)
	Global $SupervisionGUI = GUICreate("Weekly Supervision", 300, 355)
	$list = GUICtrlCreateListView("Select a File", 10, 10, 280, 280)
	_GUICtrlListView_SetColumnWidth($list, 0, 279)
	$openbutton = GUICtrlCreateButton("Open", 151, 291, 140, 25)
	$filebutton = GUICtrlCreateButton("File", 10, 291, 139, 25)
	$FileList = _FileListToArray($employeefolders & "\" & $worker & "\weekly supervision", "*.pdf")
	If @error = 1 Then
		MsgBox(0, "Error", "You must select a worker from the list.")
		MainWindow()
	EndIf
	If @error = 4 Then
		$response = MsgBox(4, "Error", "No files found in the ""weekly supervision"" directory for " & $worker & @CRLF & @CRLF & "Open Previous Supervision Forms?")
		If $response = 6 Then
			previousSupervision($worker)
		Else
			MainWindow()
		EndIf
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
					ShellExecute($employeefolders & "\" & $worker & "\Weekly Supervision\" & $sItem)
				Case $filebutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1)
					FileMove($employeefolders & "\" & $worker & "\Weekly Supervision\" & $sItem, $employeefolders & "\" & $worker & "\Weekly Supervision\Previous Supervision Forms\", $FC_Createpath)
					GUIDelete()
					MainWindow()
				Case $GUI_EVENT_CLOSE
					GUIDelete()
					MainWindow()

			EndSwitch
		WEnd
	EndIf
EndFunc   ;==>openSupervision