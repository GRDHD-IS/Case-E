Func visitcomplete()
	Global $visitcompletegui = GUICreate("Visit Completed", 300, 330)
	$list = GUICtrlCreateListView("Select a patient/family", 10, 10, 280, 280)
	_GUICtrlListView_SetColumnWidth($list, 0, 279)
	$Newbutton = GUICtrlCreateButton("New", 10, 291, 45, 25)
	$Transmitbutton = GUICtrlCreateButton("Transmit", 122, 291, 45, 25)
	$openButton = GUICtrlCreateButton("Open", 245, 291, 45, 25)
	$FileList = _FileListToArray($completePath, "*.pdf")
	If @error = 1 Then
		MsgBox(0, "Error", "File location not found, ensure you are connected to the GRDHD network.")
		MainWindow()
	EndIf
	If @error = 4 Then
		$response = MsgBox(4, "Error", "No survey files found. Would you like to begin a new Visit Completed Signatures Form?")
		If $response = 7 Then
			MainWindow()
		Else
			$name = InputBox("Patient Name", "Input patient / family name")
			FileCopy($formsPath & "\completed signatures\Signature form for visits completed.pdf", $completePath & "\" & $name & " - " & $sDate & ".pdf")
			GUIDelete()
			visitcomplete()
		EndIf
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $visitcompletegui)
	EndIf
	While 1
		$cmsg = GUIGetMsg()
		Switch $cmsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				MainWindow()
			Case $openButton
				$sItem = GUICtrlRead(GUICtrlRead($List))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				if $sItem = "" Then
					msgbox(0,"Error", "You must make a selection")
					Else
				ShellExecute($completePath & "\" & $sItem)
				EndIf
			Case $Transmitbutton
				$response = MsgBox(4, "Transmit", "Are you sure you want to transmit all Completed Visit Signature Forms to supervisor?")
				If $response = 7 Then
					GUIDelete()
					visitcomplete()
				Else
					$check = FileMove($completePath & "\*.pdf", $handsPath & "\completed visit archive\" & $sYear & "\",$FC_CREATEPATH + $FC_OVERWRITE)
					GUIDelete()
					MainWindow()
				EndIf
			Case $Newbutton
				$name = InputBox("Patient Name", "Input patient / family name")
				FileCopy($formsPath & "\completed signatures\Signature form for visits completed.pdf", $completePath & "\" & $name & " - " & $sDate & ".pdf")
				GUIDelete()
				visitcomplete()
		EndSwitch
	WEnd


	$input1 = InputBox("Patient Name", "Input patient / family name")

EndFunc   ;==>visitcomplete