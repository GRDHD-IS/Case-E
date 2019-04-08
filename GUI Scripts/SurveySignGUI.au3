Func SurveySignGUI($file, $worker)
	$surveySignGUI = GUICreate("GRDHD HANDS Supervisor", 277, 593)
	$workerlist = GUICtrlCreateListView("Workers", 10, 50, 251, 440)
	_GUICtrlListView_SetColumnWidth($workerlist, 0, 247)
	FileList($workerlist, "to supervisor", $employeefolders, "*")
	$select = GUICtrlCreateButton("Select", 186, 492, 75, 25)
	GUISetState(@SW_SHOW, $surveySignGUI)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				guidelete()
				mainwindow()
			Case $select
				$sItem = GUICtrlRead(GUICtrlRead($workerlist))
				$sItem = StringTrimRight($sItem, 1)
				If $sItem = "" Then
					MsgBox(0, "Select a worker", "You need to select a worker")
					Else
				FileMove($employeefolders & "\" & $worker & "\to supervisor\" & $file, $employeefolders & "\" & $sitem & "\needs correction\surveys to sign\" & $file)
				RunWait( 'iCACLS "' & $employeefolders & "\" & $sitem & "\needs correction\surveys to sign\" & $file & '" /grant ' & $sItem & ':F','' , @SW_HIDE)
				GUIDelete()
				OpenToSupervisor($worker)
				EndIf
		EndSwitch
	WEnd

EndFunc   ;==>SurveySignGUI


Func DataSurveySignGUI($file, $worker)
	$surveySignGUI = GUICreate("GRDHD HANDS Supervisor", 277, 593)
	$workerlist = GUICtrlCreateListView("Workers", 10, 50, 251, 440)
	_GUICtrlListView_SetColumnWidth($workerlist, 0, 247)
	FileList($workerlist, "to data", $employeefolders, "*")
	$select = GUICtrlCreateButton("Select", 186, 492, 75, 25)
	GUISetState(@SW_SHOW, $surveySignGUI)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $select
				$sItem = GUICtrlRead(GUICtrlRead($workerlist))
				$sItem = StringTrimRight($sItem, 1)
				If $sItem = "" Then
					MsgBox(0, "Select a worker", "You need to select a worker")
					Else
				FileMove($employeefolders & "\" & $worker & "\to data entry\" & $file, $employeefolders & "\" & $sitem & "\needs correction\surveys to sign\" & $file)
				RunWait( 'iCACLS "' & $employeefolders & "\" & $sitem & "\needs correction\surveys to sign\" & $file & '" /grant ' & $sItem & ':F','' , @SW_HIDE)
				GUIDelete()
				OpenToData($worker)
				EndIf
		EndSwitch
	WEnd

EndFunc   ;==>SurveySignGUI