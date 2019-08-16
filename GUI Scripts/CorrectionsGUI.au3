Func CorrectionGUI()
	Global $correctionsGUI = GUICreate("Needs Corrections", 340, 330)
	$list = GUICtrlCreateListView("File", 10, 10, 320, 280)
	_GUICtrlListView_SetColumnWidth($list, 0, 317)
	$rename = GUICtrlCreateButton("Change Name", 85, 291, 75, 25)
	$changeDate = GUICtrlCreateButton("Change Date", 10, 291, 75, 25)
	$correctionsopenbutton = GUICtrlCreateButton("Open", 285, 291, 45, 25)
	$tosupervisor = GUICtrlCreateButton("Queue to Supervisor", 160, 291, 125, 25)
	$FileList = _FileListToArray($correctionPath, "*.pdf", 1)
	If @error = 4 Then
		MsgBox(0, "Error", "No files found in Needs Correction Folder")
		MainWindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
			GUISetState(@SW_SHOW, $correctionsGUI)
		Next
		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $correctionsopenbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					ShellExecute($correctionPath & "\" & $sItem)
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
							FileMove($correctionPath & "\" & $sItem, $correctionPath & "\" & $filerename)
							_GUICtrlListView_DeleteAllItems($list)
							$FileList = _FileListToArray($correctionPath, "*.pdf", 1)
							If @error = 4 Then
								MsgBox(0, "Error", "No files found in Corrections")
								MainWindow()
							Else
								For $INDEX = 1 To $FileList[0]
									GUICtrlCreateListViewItem($FileList[$INDEX], $list)
								Next
							EndIf
							MsgBox(0, "Caution", "Please be more careful when creating forms.")
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
							FileMove($correctionPath & "\" & $sItem, $correctionPath & "\" & $filerename)
							_GUICtrlListView_DeleteAllItems($list)
							$FileList = _FileListToArray($correctionPath, "*.pdf", 1)
							If @error = 4 Then
								MsgBox(0, "Error", "No files found in Corrections")
								MainWindow()
							Else
								For $INDEX = 1 To $FileList[0]
									GUICtrlCreateListViewItem($FileList[$INDEX], $list)
								Next
							EndIf
							MsgBox(0, "Caution", "Please be more careful when creating forms.")
						EndIf
					EndIf
				Case $tosupervisor
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					$queueconfirm = MsgBox(4, "Confirm Queue", "Are you sure you want to queue " & $sItem & " to supervisor?")
					If $queueconfirm = 6 Then
						FileCopy($correctionPath & "\" & $sItem, $supervisorPath)
						FileDelete($correctionPath & "\" & $sItem)
						_GUICtrlListView_DeleteAllItems($list)
						$FileList = _FileListToArray($correctionPath, "*.pdf", 1)
						If @error = 4 Then
							MsgBox(0, "Error", "No files found in Needs Correction Folder")
							MainWindow()
						Else
							For $INDEX = 1 To $FileList[0]
								GUICtrlCreateListViewItem($FileList[$INDEX], $list)
							Next
						EndIf
					EndIf
				Case $GUI_EVENT_CLOSE
					GUIDelete($correctionsGUI)
					MainWindow()
			EndSwitch
		WEnd

	EndIf


EndFunc   ;==>CorrectionGUI

