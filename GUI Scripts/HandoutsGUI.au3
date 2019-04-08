Func HandoutsGUI()
	Global $Handouts = GUICreate("GRDHD HANDS Home Visitor", 440, 426)
	$handoutList = GUICtrlCreateListView("Handouts", 10, 50, 400, 300)
	_GUICtrlListView_SetColumnWidth($handoutList, 0, 395)
	FileList($handoutList, "", $HandoutsPath, "*")
	$open = GUICtrlCreateButton("Open", 360, 351, 50, 25)
	GUISetState(@SW_SHOW, $Handouts)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				mainwindow()
			Case $open
				$sItem = GUICtrlRead(GUICtrlRead($handoutList))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You need to make a selection")
				Else
					$attributes = FileGetAttrib($handoutspath & "\" & $sItem)
					If $attributes = "D" Then
						GUIDelete()
						HandoutsFolderGUI($sItem)
						Exit
					Else
						ShellExecute($handoutspath & "\" & $sItem)
					EndIf
				EndIf
		EndSwitch
	WEnd

EndFunc   ;==>HandoutsGUI

Func HandoutsFolderGUI($folder)
	Global $Handouts2 = GUICreate("GRDHD HANDS Home Visitor", 440, 426)
	$handoutList = GUICtrlCreateListView("Handouts", 10, 50, 400, 300)
	_GUICtrlListView_SetColumnWidth($handoutList, 0, 395)
	FileList($handoutList, "", $HandoutsPath & "\" & $folder, "*")
	$open = GUICtrlCreateButton("Open", 360, 351, 50, 25)
	GUISetState(@SW_SHOW, $Handouts2)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				HandoutsGUI()
			Case $open
				$sItem = GUICtrlRead(GUICtrlRead($handoutList))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You need to make a selection")
				Else
					$attributes = FileGetAttrib($handoutspath & "\" & $folder & "\" & $sItem)
					If $attributes = "D" Then
						GUIDelete()
						HandoutsfolderGUI2($handoutspath & "\" & $folder & "\" & $sItem)
						Exit
					Else
						ShellExecute($handoutspath & "\" & $folder & "\" & $sItem)
					EndIf
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>HandoutsFolderGUI

Func HandoutsFolderGUI2($folder)
	Global $Handouts2 = GUICreate("GRDHD HANDS Home Visitor", 440, 426)
	$handoutList = GUICtrlCreateListView("Handouts", 10, 50, 400, 300)
	_GUICtrlListView_SetColumnWidth($handoutList, 0, 395)
	FileList($handoutList, "", $folder, "*")
	$open = GUICtrlCreateButton("Open", 360, 351, 50, 25)
	GUISetState(@SW_SHOW, $Handouts2)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				HandoutsGUI()
			Case $open
				$sItem = GUICtrlRead(GUICtrlRead($handoutList))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You need to make a selection")
				Else
					$attributes = FileGetAttrib($folder & "\" & $sItem)
					If $attributes = "D" Then
						GUIDelete()
						HandoutsfolderGUI2($folder & "\" & $sItem)
						Exit
					Else
						ShellExecute($folder & "\" & $sItem)
					EndIf
				EndIf
		EndSwitch
	WEnd
EndFunc
