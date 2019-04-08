
Func goalGUI()
	$goals = GUICreate("Goals", 500, 700)
	$list = GUICtrlCreateListView("Current Goals", 10, 10, 480, 600)
	_GUICtrlListView_SetColumnWidth($list, 0, 476)
	$FileList = _FileListToArray($workPath & "\Goals in Progress", "*.pdf")
	If @error = 1 Then
		MsgBox(0, "Error", "You have no current goals, returning to Main Window.")
		mainwindow()
	EndIf
	If @error = 4 Then
		MsgBox(0, "Error", "You have no current goals, returning to Main Window.")
		GUIDelete()
		mainwindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
	EndIf
	$button1 = GUICtrlCreateButton("Open", 445, 611, 45, 25)
	$button2 = GUICtrlCreateButton("Complete Goal", 10, 611, 95, 25)
	GUISetState(@SW_SHOW, $goals)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				MainWindow()
			Case $button1
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You must select a goal")
				Else
					ShellExecute($workPath & "\Goals in Progress\" & $sItem)
				EndIf
			Case $button2
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You must select a goal")
				Else
					FileMove($workPath & "\Goals in Progress\" & $sItem, $supervisorPath & "\" & complete($sItem))
					_GUICtrlListView_DeleteAllItems($list)
					$FileList = _FileListToArray($workPath & "\Goals in Progress", "*.pdf")
					If @error = 1 Then
						MsgBox(0, "Error", "You have no current goals, returning to Main Window.")
						mainwindow()
					EndIf
					If @error = 4 Then
						MsgBox(0, "Error", "You have no current goals, returning to Main Window.")
						GUIDelete()
						mainwindow()
					Else
						For $INDEX = 1 To $FileList[0]
							GUICtrlCreateListViewItem($FileList[$INDEX], $list)
						Next
					EndIf
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>goalGUI

Func complete($string)

	$trim = StringInStr($string, "-", 0, 3)
	$trim = StringLen($string) - ($trim + 1)
	$astring = StringTrimRight($string, $trim)

	$bstring = StringRight($string, $trim)
	Return ($astring & "Completed " & $bstring)
EndFunc   ;==>complete


