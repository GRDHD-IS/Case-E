Func newSupervison($worker)
	Global $newSupervisonGUI = GUICreate("Supervison", 300, 355)
	$list = GUICtrlCreateListView("Select a Form", 10, 10, 280, 280)
	_GUICtrlListView_SetColumnWidth($list, 0, 279)
	$openbutton = GUICtrlCreateButton("Open", 151, 291, 140, 25)
	$FileList = _FileListToArray("\\" & $server & "\HANDS\GUI\Supervision", "*.pdf")
	If @error = 1 Then
		MsgBox(0, "Error", "You must select a worker from the list.")
		MainWindow()
	EndIf
	If @error = 4 Then
		MsgBox(0, "Error", "No files found in the ""Supervision"" directory")
		MainWindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $newSupervisonGUI)
		While 1
			$cmsg = GUIGetMsg()
			Switch $cmsg
				Case $openbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 5) ; Will remove the pipe "|" from the end of the string
					FileCopy("\\" & $server & "\HANDS\GUI\Supervision\" & $sItem & ".pdf", $employeefolders & "\" & $worker & "\weekly supervision\" & $sItem & " " & _NowDate() & ".pdf")
					$sItem = $sItem & " " & _NowDate() & ".pdf"
					ShellExecute($employeefolders & "\" & $worker & "\weekly supervision\" & $sItem)
					GUIDelete()
					MainWindow()
				Case $GUI_EVENT_CLOSE
					GUIDelete()
					MainWindow()
			EndSwitch
		WEnd
	EndIf
EndFunc   ;==>newSupervison