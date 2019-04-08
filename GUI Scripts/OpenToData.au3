Func OpentoData($worker)
	Global $ToDataGUI = GUICreate("To Data", 500, 555)
	$list = GUICtrlCreateListView("Select a Note", 10, 10, 480, 480)
	_GUICtrlListView_SetColumnWidth($list, 0, 476)
	$openbutton = GUICtrlCreateButton("Open", 151, 491, 140, 25)
	$renameButton = GUICtrlCreateButton("Rename", 415, 491, 75, 25)
	$toSupervisorbutton = GUICtrlCreateButton("Send to Supervisor", 151, 517, 140, 25)
	$workersignature = GUICtrlCreateButton("Submit Survey to Worker for Signature", 292, 517, 198, 25)
	$OpenCaseloadButton = GUICtrlCreateButton("Caseload", 292, 491, 122, 25)
	$filetochartbutton = GUICtrlCreateButton("File to Chart", 10, 491, 139, 25)
	$tocorrectionsbutton = GUICtrlCreateButton("Send to Corrections", 10, 517, 139, 25)
	$FileList = _FileListToArray($employeefolders & "\" & $worker & "\to data entry", "*.pdf")
	If @error = 1 Then
		MsgBox(0, "Error", "You must select a worker from the list.")
		MainWindow()
	EndIf
	If @error = 4 Then
		MsgBox(0, "Error", "No files found in the ""To Data Entry"" directory for " & $worker)
		MainWindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $ToDataGUI)
		While 1
			$cmsg = GUIGetMsg()
			Switch $cmsg
				Case $renameButton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					If $sItem = "" Then
						MsgBox(0, "Error", "You must select a file.")
					Else

						$rename = InputBox("File Rename", "What is the new file name?" & @CRLF & "Please Follow the format:" & @CRLF & "MM-DD-YYYY Lastname, Firstname - Form")
						If $rename = "DELETE" Then
							FileDelete($employeefolders & "\" & $worker & "\to data entry\" & $sItem)
						ElseIf $rename = "" Then
							MsgBox(0, "Error", "You must provide input to change the file name")
						Else
							FileMove($employeefolders & "\" & $worker & "\to data entry\" & $sItem, $employeefolders & "\" & $worker & "\to data entry\" & $rename & ".pdf")
						EndIf
					EndIf
					GUIDelete()
					OpentoData($worker)
				Case $workersignature
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1)
					If $sItem = "" Then
						MsgBox(0, "Select a file", "You need to select a file")
					Else
						GUIDelete()
						DataSurveysignGUI($sItem, $worker)
					EndIf
				Case $openbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					If $sItem = "" Then
						MsgBox(0, "Error", "Please make a selection on the list")
					Else
						ShellExecute($employeefolders & "\" & $worker & "\to data entry\" & $sItem)
					EndIf
				Case $toSupervisorbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1)
					If $sItem = "" Then
						MsgBox(0, "Error", "Please make a selection on the list")
					Else
						FileMove($employeefolders & "\" & $worker & "\to data entry\" & $sItem, $employeefolders & "\" & $worker & "\to supervisor\")
						_GUICtrlListView_DeleteAllItems($list)
						$FileList = _FileListToArray($employeefolders & "\" & $worker & "\to data entry", "*.pdf")
						If @error = 4 Then
							GUIDelete()
							MainWindow()
						Else
							For $INDEX = 1 To $FileList[0]
								GUICtrlCreateListViewItem($FileList[$INDEX], $list)
							Next
						EndIf
					EndIf
				Case $filetochartbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1)
					If $sItem = "" Then
						MsgBox(0, "Error", "Please make a selection on the list")
					Else
						GUIDelete()
						ChartsFileGUI($sItem, $worker, "to data entry", "data")
					EndIf
				Case $GUI_EVENT_CLOSE
					GUIDelete($ToDataGUI)
					MainWindow()
				Case $OpenCaseloadButton
					GUIDelete()
					Caseloads("data", $worker)
				Case $tocorrectionsbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1)
					If $sItem = "" Then
						MsgBox(0, "Error", "Please make a selection on the list")
					Else
						FileMove($employeefolders & "\" & $worker & "\to data entry\" & $sItem, $employeefolders & "\" & $worker & "\needs correction\")
						GUIDelete()
						MainWindow()
					EndIf
			EndSwitch
		WEnd
	EndIf
EndFunc   ;==>OpentoData
