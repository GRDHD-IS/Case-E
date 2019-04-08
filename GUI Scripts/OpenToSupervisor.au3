Func OpentoSupervisor($worker)
	Global $ToSupervisorGUI = GUICreate("To Supervisor", 500, 379)
	$list = GUICtrlCreateListView("Select a Note", 10, 10, 480, 280)
	_GUICtrlListView_SetColumnWidth($list, 0, 476)
	$openbutton = GUICtrlCreateButton("Open", 151, 291, 140, 25)
	$filetochartbutton = GUICtrlCreateButton("File to Chart", 10, 291, 139, 25)
	$tocorrectionsbutton = GUICtrlCreateButton("Send to Corrections", 10, 317, 139, 25)
	$toDatabutton = GUICtrlCreateButton("Send to Data Entry", 151, 317, 139, 25)
	$backtoworker = GUICtrlCreateButton("Submit Survey to Worker for Signature", 10, 343, 280, 25)
	$renamebutton = GUICtrlCreateButton("Rename File", 360, 343, 120, 25)
	$FileList = _FileListToArray($employeefolders & "\" & $worker & "\to supervisor", "*.pdf")
	If @error = 1 Then
		MsgBox(0, "Error", "You must select a worker from the list.")
		MainWindow()
	EndIf
	If @error = 4 Then
		MsgBox(0, "Error", "No files found in the ""To Supervisor"" directory for " & $worker)
		MainWindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $ToSupervisorGUI)
		While 1
			$cmsg = GUIGetMsg()
			Switch $cmsg
				Case $openbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					If $sItem = "" Then
						MsgBox(0, "Select a file", "You need to select a file")
					Else
						ShellExecute($employeefolders & "\" & $worker & "\to supervisor\" & $sItem)
					EndIf
				Case $filetochartbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1)
					If $sItem = "" Then
						MsgBox(0, "Select a file", "You need to select a file")
					Else
						GUIDelete()
						ChartsFileGUI($sItem, $worker, "to supervisor", "supervisor")
					EndIf
				Case $renamebutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					If $sItem = "" Then
						MsgBox(0, "Select a file", "You need to select a file")
					Else
						$rename = InputBox("File Rename", "What is the new file name?" & @CRLF & "Please Follow the format:" & @CRLF & "MM-DD-YYYY Lastname, Firstname - Form")
						If $rename = "" Then
							MsgBox(0, "Error", "You must input a file name")
						EndIf
						FileMove($employeefolders & "\" & $worker & "\to supervisor\" & $sItem, $employeefolders & "\" & $worker & "\to supervisor\" & $rename & ".pdf")
						GUIDelete()
						OpentoSupervisor($worker)
					EndIf
				Case $GUI_EVENT_CLOSE
					GUIDelete()
					MainWindow()
				Case $tocorrectionsbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1)
					If $sItem = "" Then
						MsgBox(0, "Select a file", "You need to select a file")
					Else
						FileMove($employeefolders & "\" & $worker & "\to supervisor\" & $sItem, $employeefolders & "\" & $worker & "\needs correction\")
						GUIDelete()
						OpentoSupervisor($worker)
					EndIf
				Case $toDatabutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1)
					If $sItem = "" Then
						MsgBox(0, "Select a file", "You need to select a file")
					Else
						FileMove($employeefolders & "\" & $worker & "\to supervisor\" & $sItem, $employeefolders & "\" & $worker & "\to data entry\")
						_GUICtrlListView_DeleteAllItems($list)
						$FileList = _FileListToArray($employeefolders & "\" & $worker & "\to supervisor", "*.pdf")
						If @error = 4 Then
							GUIDelete()
							MainWindow()
						Else
							For $INDEX = 1 To $FileList[0]
								GUICtrlCreateListViewItem($FileList[$INDEX], $list)
							Next
						EndIf
					EndIf
				Case $backtoworker
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1)
					If $sItem = "" Then
						MsgBox(0, "Select a file", "You need to select a file")
					Else
						GUIDelete()
						SurveysignGUI($sItem, $worker)
					EndIf
			EndSwitch
		WEnd
	EndIf
EndFunc   ;==>OpentoSupervisor
