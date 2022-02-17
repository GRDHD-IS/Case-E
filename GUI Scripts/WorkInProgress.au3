Func WorkingGUI()
	Global $workingGUI = GUICreate("Working",500, 430)
	$list = GUICtrlCreateListView("File", 10, 10, 480, 380)
	_GUICtrlListView_SetColumnWidth($list, 0, 478)
	Global $workingopenbutton = GUICtrlCreateButton("Open",445, 391, 45, 25)
	$delete = GUICtrlCreateButton("Delete", 10,391, 45, 25)
	$rename = GUICtrlCreateButton("Change Name", 244, 391, 75, 25)
	$changeDate = GUICtrlCreateButton("Change Date", 168, 391, 75, 25)
	$FileList = _FileListToArray($workPath, "*.pdf", 1)
	If @error = 4 Then
		MsgBox(0, "Error", "No files found in Work in Progress")
		MainWindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $workingGUI)
		While 1
			$wmsg = GUIGetMsg()
			Switch $wmsg
				Case $workingopenbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					If $sItem = "" Then
						MsgBox(0, "Error", "You must make a selection")
					Else
						ShellExecute($workPath & "\" & $sItem)
					EndIf
				Case $changeDate
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					If $sItem = "" Then
						MsgBox(0, "Error", "You must make a selection")
					Else
						$renameform = StringTrimLeft($sItem, 10)
						$input = InputBox("Change Date", "Input the date (mm-dd-yyyy)")
						$backcheck = StringInStr($input, '\')
						$forwardcheck = StringInStr($input, '/')
						If $input = "" Then
							MsgBox(0, "Error", "You must input a date in the format mm-dd-yyyy")
						ElseIf $backcheck <> 0 Or $forwardcheck <> 0 Then
							MsgBox(0, "Error", "The date cannot contain any slashes (\ or /)." & @CRLF & "Please try again")
						Else
							$filerename = $input & $renameform
							FileMove($workPath & "\" & $sItem, $workpath & "\" & $filerename)
							_GUICtrlListView_DeleteAllItems($list)
							$FileList = _FileListToArray($workPath, "*.pdf", 1)
							If @error = 4 Then
								MsgBox(0, "Error", "No files found in Work in Progress")
								MainWindow()
							Else
								For $INDEX = 1 To $FileList[0]
									GUICtrlCreateListViewItem($FileList[$INDEX], $list)
								Next
							EndIf
							MsgBox(0, "Caution", "Please be more careful when creating forms.")
						EndIf
					EndIf
				Case $delete
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					If $sItem = "" Then
						MsgBox(0, "Error", "You must make a selection")
					Else
						$response = MsgBox(4, "Confirm Deletion", "Are you sure you want to delete " & @CRLF & $sItem & "?")
						If $response = 6 Then
							$response2 = MsgBox(4, "Confirm Deletion", "Warning, deletion is premenant and irreversible." & @CRLF & "Are you sure you want to delete this file:" & @CRLF & $sItem & "?")
							If $response2 = 6 Then
								FileDelete($workPath & "\" & $sItem)
								_GUICtrlListView_DeleteAllItems($list)
								$FileList = _FileListToArray($workPath, "*.pdf", 1)
								If @error = 4 Then
									MsgBox(0, "Error", "No files found in Work in Progress")
									MainWindow()
								Else
									For $INDEX = 1 To $FileList[0]
										GUICtrlCreateListViewItem($FileList[$INDEX], $list)
									Next
								EndIf
								MsgBox(0, "Caution", "Please be more careful when creating forms.")
							EndIf
						EndIf
					EndIf
				Case $rename
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					If $sItem = "" Then
						MsgBox(0, "Error", "You must make a selection")
					Else
						$renamedate = StringLeft($sItem, 11)
						$renameform = StringInStr($sItem, "-", 0, 3)
						$renameform = StringLen($sItem) - ($renameform - 2)
						$renameform = StringRight($sItem, $renameform)
						$input = InputBox("Change Name", "Input the patient's name (Last, First MI)")
						If $input = "" Then
							MsgBox(0, "Error", "You must input a name in the format Last, First MI")
						Else
							$filerename = $renamedate & $input & $renameform
							FileMove($workPath & "\" & $sItem, $workpath & "\" & $filerename)
							_GUICtrlListView_DeleteAllItems($list)
							$FileList = _FileListToArray($workPath, "*.pdf", 1)
							If @error = 4 Then
								MsgBox(0, "Error", "No files found in Work in Progress")
								MainWindow()
							Else
								For $INDEX = 1 To $FileList[0]
									GUICtrlCreateListViewItem($FileList[$INDEX], $list)
								Next
							EndIf
							MsgBox(0, "Caution", "Please be more careful when creating forms.")
						EndIf
					EndIf
				Case $GUI_EVENT_CLOSE
					GUIDelete($workingGUI)
					MainWindow()
			EndSwitch
		WEnd
	EndIf
EndFunc   ;==>WorkingGUI




