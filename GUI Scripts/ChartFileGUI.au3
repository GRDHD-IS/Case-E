Global $page = "Page 0"
Global $file2 = ""

;Functions used to file to charts
Func ChartsFileGUI($file, $worker, $folder, $parentgui)
	Global $ChartsFileGUI = GUICreate("Charts", 400, 630)
	$list = GUICtrlCreateListView("Select a Family", 10, 10, 380, 580)
	_GUICtrlListView_SetColumnWidth($list, 0, 375)
	$chartsselectbutton = GUICtrlCreateButton("Select", 345, 591, 45, 25)
	$chartsnewbutton = GUICtrlCreateButton("New", 10, 591, 45, 25)
	$search = GUICtrlCreateButton("Search", 299, 591, 45, 25)
	$FileList = _FileListToArray($chartsPath, Default, 2)
	If @error = 1 Then
		MsgBox(0, "Error", "File location not found, ensure you are connected to the GRDHD network")
	EndIf
	If @error = 4 Then
		MsgBox(0, "Error", "No files found in Charts")
		MainWindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $ChartsFileGUI)
		While 1
			$cmsg = GUIGetMsg()
			Switch $cmsg
				Case $chartsselectbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					If $sItem = "" Then
						MsgBox(0, "Error", "Please make a selection on the list")
					Else
						GUIDelete()
						patientSelectFileGUI($file, $worker, $sItem, $folder, $parentgui)
					EndIf
				Case $search
					$response = InputBox("Search", "Search for:")
					_GUICtrlListView_DeleteAllItems($list)
					FileList($list, "", $chartsPath, "*" & $response & "*")
				Case $chartsnewbutton
					newfamily($file, $worker, $folder)
					GUIDelete()
					ChartsFileGUI($file, $worker, $folder, $parentgui)
				Case $GUI_EVENT_CLOSE
					GUIDelete($ChartsFileGUI)
					MainWindow()
			EndSwitch
		WEnd
	EndIf
EndFunc   ;==>ChartsFileGUI


Func patientSelectFileGUI($file, $worker, $family, $folder, $parentgui)
	Global $patientSelectFileGUI = GUICreate("Charts", 300, 530)
	$list = GUICtrlCreateListView("Select a Patient", 10, 10, 280, 480)
	_GUICtrlListView_SetColumnWidth($list, 0, 279)
	$chartsselectbutton = GUICtrlCreateButton("Select", 245, 491, 45, 25)
	$newBaby = GUICtrlCreateButton("New Chart", 10, 491, 75, 25)
	$FileList = _FileListToArray($chartsPath & "\" & $family, Default)
	If @error = 4 Then
		MsgBox(0, "Error", "No files found for " & $family)
		MainWindow()
	EndIf
	If @error = 1 Then
		MsgBox(0, "Error", "You do not have any charts in " & $family)
		GUIDelete($patientSelectFileGUI)
		MainWindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $patientSelectFileGUI)
	EndIf
	While 1
		$scmsg = GUIGetMsg()
		Switch ($scmsg)
			Case $GUI_EVENT_CLOSE
				GUIDelete($patientSelectFileGUI)
				MainWindow()
			Case $newBaby
				$response = MsgBox(4, "New Chart", "Is this chart for a baby?")
				If $response = 6 Then
					$babyname = InputBox("New Family", "Input the name of the new baby")
					If $babyname = "" Then
						MsgBox(0, "Error", "You must input a patient name.")
					Else
						DirCreate($chartsPath & "\" & $family & "\baby - " & $babyname)
						DirCreate($chartsPath & "\" & $family & "\baby - " & $babyname & "\Page 1")
						DirCreate($chartsPath & "\" & $family & "\baby - " & $babyname & "\Page 2")
						DirCreate($chartsPath & "\" & $family & "\baby - " & $babyname & "\Page 3")
						DirCreate($chartsPath & "\" & $family & "\baby - " & $babyname & "\Page 4")
						DirCreate($chartsPath & "\" & $family & "\baby - " & $babyname & "\Page 5")
					EndIf
				Else
					$mothername = InputBox("New Family", "Input the name of the new caregiver")
					If $mothername = "" Then
						MsgBox(0, "Error", "You must input a caregiver name.")
					Else
						DirCreate($chartsPath & "\" & $family & "\Caregiver - " & $mothername)
						DirCreate($chartsPath & "\" & $family & "\Caregiver - " & $mothername & "\Page 1")
						DirCreate($chartsPath & "\" & $family & "\Caregiver - " & $mothername & "\Page 2")
						DirCreate($chartsPath & "\" & $family & "\Caregiver - " & $mothername & "\Page 3")
						DirCreate($chartsPath & "\" & $family & "\Caregiver - " & $mothername & "\Page 4")
						DirCreate($chartsPath & "\" & $family & "\Caregiver - " & $mothername & "\Page 5")
					EndIf
				EndIf
				GUIDelete()
				patientSelectFileGUI($file, $worker, $family, $folder, $parentgui)
			Case $chartsselectbutton
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "Please make a selection on the list")
				Else
					ChartsPageFind($file)
					If $page = "Page 0" Then
						GUIDelete()
						pageSelectFileGui($file, $worker, $family, $sItem, $folder, $parentgui)
					Else
						$checkcomplete = StringInStr($file, "completed")
						$checkgoal = StringInStr($file, "goal")
						If $checkcomplete <> 0 Then
							FileMove($employeefolders & "\" & $worker & "\" & $folder & "\" & $file, $chartsPath & "\" & $family & "\" & $sItem & "\" & $page & "\" & $file, $FC_CREATEPATH)
							GUIDelete()
							If $parentgui = "data" Then
								opentodata($worker)
							ElseIf $parentgui = "supervisor" Then
								opentosupervisor($worker)
							EndIf
						ElseIf $checkgoal <> 0 Then
							FileCopy($employeefolders & "\" & $worker & "\" & $folder & "\" & $file, $employeefolders & "\" & $worker & "\work in progress\Goals in Progress\" & $file, $FC_CREATEPATH)
							FileMove($employeefolders & "\" & $worker & "\" & $folder & "\" & $file, $chartsPath & "\" & $family & "\" & $sItem & "\" & $page & "\" & $file, $FC_CREATEPATH)
							GUIDelete()
							If $parentgui = "data" Then
								opentodata($worker)
							ElseIf $parentgui = "supervisor" Then
								opentosupervisor($worker)
							EndIf
						Else
							chartcheck($family, $sItem, $page, $file, "")
							FileMove($employeefolders & "\" & $worker & "\" & $folder & "\" & $file, $chartsPath & "\" & $family & "\" & $sItem & "\" & $page & "\" & $file2, $FC_CREATEPATH)
							GUIDelete()
							If $parentgui = "data" Then
								opentodata($worker)
							ElseIf $parentgui = "supervisor" Then
								opentosupervisor($worker)
							EndIf
						EndIf
					EndIf
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>patientSelectFileGUI

Func pageSelectFileGui($file, $worker, $family, $patient, $folder, $parentgui)
	Global $pageSelectFileGUI = GUICreate("Charts", 300, 530)
	$list = GUICtrlCreateListView("Select a Page", 10, 10, 280, 480)
	_GUICtrlListView_SetColumnWidth($list, 0, 279)
	$chartsselectbutton = GUICtrlCreateButton("File", 245, 491, 45, 25)
	$FileList = _FileListToArray($chartsPath & "\" & $family & "\" & $patient, Default)
	If @error = 4 Then
		MsgBox(0, "Error", "No files found in " & $patient)
		MainWindow()
	EndIf
	If @error = 1 Then
		MsgBox(0, "Error", "You do not have any charts in " & $patient)
		GUIDelete($pageSelectFileGUI)
		MainWindow()
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $pageSelectFileGUI)
	EndIf
	While 1
		$scmsg = GUIGetMsg()
		Switch ($scmsg)
			Case $GUI_EVENT_CLOSE
				GUIDelete($pageSelectFileGUI)
				MainWindow()
			Case $chartsselectbutton
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "Please make a selection on the list")
				Else
					FileMove($employeefolders & "\" & $worker & "\" & $folder & "\" & $file, $chartsPath & "\" & $family & "\" & $patient & "\" & $sItem & "\" & $file, $FC_CREATEPATH)
					GUIDelete()
					If $parentgui = "data" Then
						opentodata($worker)
					ElseIf $parentgui = "supervisor" Then
						opentosupervisor($worker)
					EndIf
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>pageSelectFileGui

Func chartcheck($family, $patient, $page, $file, $suffix)
	$check = FileExists($chartsPath & "\" & $family & "\" & $patient & "\" & $page & "\" & $file)
	If $check = 1 Then
		$suffix = $suffix + 1
		$oldfile = $file
		If $suffix = 1 Then
			$newfile = StringReplace($file, ".pdf", $suffix & ".pdf")
		ElseIf $suffix <= 9 Then
			$newfile = StringTrimRight($file, "5")
			$newfile = $newfile & $suffix & ".pdf"
		ElseIf $suffix > 9 Then
			$newfile = StringTrimRight($file, "6")
			$newfile = $newfile & $suffix & ".pdf"
		EndIf
		$rename = MsgBox(4, "Form Name Conflict", "Error: " & $oldfile & " already exists in this chart." & @CRLF & @CRLF & "Would you like to rename this form to " & $newfile & "?")
		If $rename = 6 Then
			chartcheck($family, $patient, $page, $newfile, $suffix)
		EndIf
	Else
		Global $file2 = $file
	EndIf
EndFunc   ;==>chartcheck


