Func openNeedscorrection($worker)
	Global $NeedsCorrectionGUI = GUICreate("Needs Correction", 300, 355)
	$list = GUICtrlCreateListView("Select a Note", 10, 10, 280, 280)
	_GUICtrlListView_SetColumnWidth($list, 0, 279)
	$openbutton = GUICtrlCreateButton("Open", 151, 291, 140, 25)
	;$filetochartbutton = GUICtrlCreateButton("File to Chart", 10, 291, 139, 25)
	$FileList = _FileListToArray($employeefolders & "\" & $worker & "\needs correction", "*.pdf")
	If @error = 1 Then
		MsgBox(0, "Error", "You must select a worker from the list.")
		MainWindow()
	EndIf
	If @error = 4 Then
		MsgBox(0, "Error", "No files found in the ""Needs Correction"" directory for " & $worker)
		MainWindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $NeedsCorrectionGUI)
		While 1
			$cmsg = GUIGetMsg()
			Switch $cmsg
				Case $openbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					ShellExecute($employeefolders & "\" & $worker & "\needs correction\" & $sItem)
				;Case $filetochartbutton
				;	$sItem = GUICtrlRead(GUICtrlRead($list))
				;	$sItem = StringTrimRight($sItem, 1)
				;	GUIDelete()
				;	ChartsFileGUI($sItem, $worker, "needs corrections", "supervisor")
				Case $GUI_EVENT_CLOSE
					GUIDelete()
					MainWindow()
			EndSwitch
		WEnd
	EndIf
EndFunc   ;==>openNeedscorrection