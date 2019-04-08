
Func Supervision($parent, $worker)
	If $parent = "supervisor" Then
		$gui = GUICreate("Supervision", 321, 321)
		$button1 = GUICtrlCreateButton("Open Current (6 mo.) supervision form", 10, 10, 150, 150, 0x2000)
		$button2 = GUICtrlCreateButton("Archive current (6 mo.) supervision form", 161, 10, 150, 150, 0x2000)
		$button3 = GUICtrlCreateButton("New weekly supervision form", 10, 161, 150, 150, 0x2000)
		$button4 = GUICtrlCreateButton("Open supervision Archive for " & $worker, 161, 161, 150, 150, 0x2000)

		GUISetState(@SW_SHOW, $gui)

		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $GUI_EVENT_CLOSE
					GUIDelete()
					mainwindow()
				Case $button1
					ShellExecute($employeefolders & "\" & $worker & "\Supervision\in progress\Supplement Form A.pdf")
				Case $button2
					$name = InputBox("6-Month Archive", "Input the dates for the form following this pattern: ""MMM YY - MMM YY""")
					If $name = "" Then
						If @error = 1 Then
							guidelete($gui)
							Supervision($parent, $worker)
						EndIf
						MsgBox(0, "Error", "You must input a file name")
					Else
						$name = $name & ".pdf"
						FileMove($employeefolders & "\" & $worker & "\Supervision\in progress\Supplement Form A.pdf", $employeefolders & "\" & $worker & "\Supervision\Archive\Supplement Form A\" & $name, $FC_CREATEPATH)
						FileCopy($supervisionFormsPath & "\Supplement Form A.pdf", $employeefolders & "\" & $worker & "\Supervision\in progress\")
					EndIf
				Case $button3
					$year = StringTrimRight(_NowCalcDate(), 6)
					$month = StringTrimRight(_NowCalcDate(), 3)
					$month = StringTrimLeft($month, 5)
					$month = _DateToMonth($month)
					$day = StringTrimLeft(_NowCalcDate(), 8)
					$name = "Week of " & $day & " " & $month & ", " & $year & ".pdf"
					FileCopy($supervisionFormsPath & "\Supervision Packet A.pdf", $employeefolders & "\" & $worker & "\supervision\archive\Supervision Packet A\supervision packet a.pdf")
					FileMove($employeefolders & "\" & $worker & "\supervision\archive\Supervision Packet A\supervision Packet A.pdf", $employeefolders & "\" & $worker & "\supervision\archive\Supervision Packet A\" & $year & "\" & $month & "\" & $name, $FC_CREATEPATH)
					ShellExecute($employeefolders & "\" & $worker & "\supervision\archive\Supervision Packet A\" & $year & "\" & $month & "\" & $name)
				Case $button4
					GUIDelete()
					SupervisionArchive1($parent, $worker)
			EndSwitch
		WEnd

	Else
		MsgBox(0, "", "Something is going to happen")
		MsgBox(0, "", "Contact your administrator, you weren't supposed to find this")
		Exit
	EndIf
EndFunc   ;==>Supervision

Func SupervisionArchive1($parent, $worker)
	$gui = GUICreate("Supervision Archive", 321, 171)
	$button1 = GUICtrlCreateButton("Weekly Supervisions", 10, 10, 150, 150, 0x2000)
	$button2 = GUICtrlCreateButton("6-month supervisions", 161, 10, 150, 150, 0x2000)

	GUISetState(@SW_SHOW, $gui)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				Supervision($parent, $worker)
			Case $button1
				GUIDelete()
				SupervisionArchive3($parent, $worker, "Supervision Packet A")
			Case $button2
				GUIDelete()
				SupervisionArchive2($parent, $worker, "Supplement Form A")
		EndSwitch
	WEnd
EndFunc   ;==>SupervisionArchive1

Func SupervisionArchive2($parent, $worker, $type)
	$gui = GUICreate($type, 500, 500)
	$list = GUICtrlCreateListView($type, 10, 10, 450, 400)
	_GUICtrlListView_SetColumnWidth($list, 0, 440)
	$FileList = _FileListToArray($employeefolders & "\" & $worker & "\Supervision\Archive\" & $type, "*.pdf")
	If @error = 1 Then
		MsgBox(0, "Error", "Directory not found")
		mainwindow()
	EndIf
	If @error = 4 Then
		MsgBox(0, "Error", "No files of " & $type & " found for " & $worker)
		GUIDelete()
		mainwindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
	EndIf
	$button1 = GUICtrlCreateButton("Open", 405, 411, 45, 25)
	GUISetState(@SW_SHOW, $gui)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				Supervision($parent, $worker)
			Case $button1
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "ERROR", "You must to select a file")
				Else
					ShellExecute($employeefolders & "\" & $worker & "\Supervision\Archive\" & $type & "\" & $sItem)
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>SupervisionArchive2

Func SupervisionArchive3($parent, $worker, $type)
	$gui = GUICreate($type, 500, 500)
	$list = GUICtrlCreateListView($type, 10, 10, 450, 400)
	_GUICtrlListView_SetColumnWidth($list, 0, 440)
	$FileList = _FileListToArray($employeefolders & "\" & $worker & "\Supervision\Archive\" & $type)
	If @error = 1 Then
		MsgBox(0, "Error", "Directory not found")
		mainwindow()
	EndIf
	If @error = 4 Then
		MsgBox(0, "Error", "No files of " & $type & " found for " & $worker)
		GUIDelete()
		mainwindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
	EndIf
	$button1 = GUICtrlCreateButton("Open", 405, 411, 45, 25)
	GUISetState(@SW_SHOW, $gui)
	$path = $employeefolders & "\" & $worker & "\Supervision\Archive\" & $type

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				Supervision($parent, $worker)
			Case $button1
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "ERROR", "You must to select a file")
				Else
					$attributes = FileGetAttrib($path & "\" & $sItem)
					If $attributes = "D" Then
						$path = $path & "\" & $sItem
						_GUICtrlListView_DeleteAllItems($list)
						$FileList = _FileListToArray($path)
						If @error = 1 Then
							MsgBox(0, "Error", "Directory not found")
							mainwindow()
						EndIf
						If @error = 4 Then
							MsgBox(0, "Error", "No files of " & $type & " found for " & $worker)
							GUIDelete()
							mainwindow()
						Else
							For $INDEX = 1 To $FileList[0]
								GUICtrlCreateListViewItem($FileList[$INDEX], $list)
							Next
						EndIf
					Else
						ShellExecute($path & "\" & $sItem)
					EndIf
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>SupervisionArchive3

