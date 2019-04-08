Func ActivitiesGUI()
	Global $Activities = GUICreate("GRDHD HANDS Home Visitor", 440, 426)
	$activityList = GUICtrlCreateListView("Activities", 10, 50, 400, 300)
	_GUICtrlListView_SetColumnWidth($activityList, 0, 395)
	FileList($activityList, "", $activitiesPath, "*")
	$open = GUICtrlCreateButton("Open", 320, 351, 50, 25)
	GUISetState(@SW_SHOW, $Activities)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				mainwindow()
			Case $open
				$sItem = GUICtrlRead(GUICtrlRead($activityList))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You need to make a selection")
				Else
					$attributes = FileGetAttrib($activitiespath & "\" & $sItem)
					If $attributes = "D" Then
						GUIDelete()
						activityfolderGUI($sItem)
						Exit
					Else
						ShellExecute($activitiespath & "\" & $sItem)
					EndIf
				EndIf
		EndSwitch
	WEnd

EndFunc   ;==>ActivitiesGUI

Func ActivityFolderGUI($folder)
	Global $Activities2 = GUICreate("GRDHD HANDS Home Visitor", 440, 426)
	$activityList = GUICtrlCreateListView("Activities", 10, 50, 400, 300)
	_GUICtrlListView_SetColumnWidth($activityList, 0, 395)
	FileList($activityList, "", $activitiesPath & "\" & $folder, "*")
	$open = GUICtrlCreateButton("Open", 320, 351, 50, 25)
	GUISetState(@SW_SHOW, $Activities2)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				ActivitiesGUI()
				Case $open
				$sItem = GUICtrlRead(GUICtrlRead($activityList))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You need to make a selection")
				Else
					$attributes = FileGetAttrib($activitiespath & "\" & $folder & "\" & $sItem)
					If $attributes = "D" Then
						GUIDelete()
						activityfolderGUI2($activitiespath & "\" & $folder & "\" & $sItem)
						Exit
					Else
						ShellExecute($activitiespath & "\" & $folder & "\" & $sItem)
					EndIf
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>ActivityFolderGUI

Func ActivityFolderGUI2($folder)
	Global $Activities2 = GUICreate("GRDHD HANDS Home Visitor", 440, 426)
	$activityList = GUICtrlCreateListView("Activities", 10, 50, 400, 300)
	_GUICtrlListView_SetColumnWidth($activityList, 0, 395)
	FileList($activityList, "", $folder, "*")
	$open = GUICtrlCreateButton("Open", 320, 351, 50, 25)
	GUISetState(@SW_SHOW, $Activities2)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				ActivitiesGUI()
				Case $open
				$sItem = GUICtrlRead(GUICtrlRead($activityList))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You need to make a selection")
				Else
					$attributes = FileGetAttrib($folder & "\" & $sItem)
					If $attributes = "D" Then
						GUIDelete()
						activityfolderGUI2($folder & "\" & $sItem)
						Exit
					Else
						ShellExecute($folder & "\" & $sItem)
					EndIf
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>ActivityFolderGUI
