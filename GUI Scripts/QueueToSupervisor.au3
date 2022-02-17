Func tosupervisorGUI()
	Global $tosupervisorGUI = GUICreate("Select a File to Queue to Supervisor", 500, 330)
	$list = GUICtrlCreateListView("File", 10, 10, 480, 280)
	_GUICtrlListView_SetColumnWidth($list, 0, 479)
	Global $tosupervisorqueueButton = GUICtrlCreateButton("Queue", 445, 291, 45, 25)
	$FileList = _FileListToArray($workPath, "*.pdf", 1)
	If @error = 4 Then
		MsgBox(0, "Error", "No files found in Work in Progress Folder")
		MainWindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $tosupervisorGUI)
		While 1
			$tmsg = GUIGetMsg()
			Switch $tmsg
				Case $tosupervisorqueueButton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					If $sItem = "" Then
						MsgBox(0, "Error", "You must select an item.")
					Else
						$queueconfirm = MsgBox(4, "Confirm Queue", "Are you sure you want to queue " & $sItem & " to supervisor?")
						If $queueconfirm = 6 Then
							FileCopy($workPath & "\" & $sItem, $supervisorPath)
							FileDelete($workPath & "\" & $sItem)
							_GUICtrlListView_DeleteAllItems($list)
							$FileList = _FileListToArray($workPath, "*.pdf", 1)
							If @error = 4 Then
								MsgBox(0, "Error", "No files found in Work in Progress Folder")
								guidelete()
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
			EndSwitch
		WEnd
	EndIf
EndFunc   ;==>tosupervisorGUI

