;ChartsGUI
Func ChartsGUI($parent)
	Global $ChartsGUI = GUICreate("Charts", 450, 630)
	$list = GUICtrlCreateListView("Select a Family", 10, 10, 420, 580)
	_GUICtrlListView_SetColumnWidth($list, 0, 400)
	$chartsselectbutton = GUICtrlCreateButton("Select", 366, 591, 45, 25)
	$search = GUICtrlCreateButton("Search", 320, 591, 45, 25)
	$renameButton = GUICtrlCreateButton("Rename", 10, 591, 45, 25)
	If Not $parent = "worker" Then
		$FileToArchive = GUICtrlCreateButton("Archive Chart", 84, 591, 75, 25)
	Else
		$FileToArchive = GUICtrlCreateButton("Archive Chart", 5000, 5000, 5, 5)
	EndIf
	$FileList = _FileListToArray($chartsPath, Default, 2)
	If @error = 1 Then
		MsgBox(0, "Error", "File location not found, ensure you are connected to the GRDHD network")
	EndIf
	If @error = 4 Then
		MsgBox(0, "Error", "No files found in Charts")
		ChartsGUI($parent)
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $ChartsGUI)
		While 1
			$cmsg = GUIGetMsg()
			Switch $cmsg
				Case $renameButton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					If $sItem = "" Then
						MsgBox(0, "Error", "You must select a file.")
					Else
						$rename = InputBox("File Rename", "What is the new Family Name?" & @CRLF & "Please Follow the format:" & @CRLF & "Lastname, Firstname - Code")
						If $rename = "DELETE" Then
							DirRemove($chartsPath & "\" & $sItem, 1)
						Else
							DirMove($chartsPath & "\" & $sItem, $chartsPath & "\" & $rename)
						EndIf
					EndIf
					GUIDelete()
					ChartsGUI($parent)
				Case $search
					$response = InputBox("Search", "Search for:")
					_GUICtrlListView_DeleteAllItems($list)
					FileList($list, "", $chartsPath, "*" & $response & "*")
				Case $FileToArchive
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1)
					If $sItem = "" Then
						MsgBox(0, "Error", "You must select a file.")
					Else
						$archive = MsgBox(4, "Archive file?", "Are you sure you want to Archive " & $sItem & "?")
						If $archive = 6 Then
							DirMove($chartsPath & "\" & $sItem, "\\grdhd3\HANDS\Archive\HANDS Closed Charts\" & $sItem)
						Else
							GUIDelete()
							ChartsGUI($parent)
						EndIf
					EndIf
				Case $chartsselectbutton
					$sItem = GUICtrlRead(GUICtrlRead($list))
					$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
					GUIDelete()
					patientSelectGUI($sItem, $parent)
				Case $GUI_EVENT_CLOSE
					GUIDelete($ChartsGUI)
					MainWindow()
			EndSwitch
		WEnd
	EndIf
EndFunc   ;==>ChartsGUI


;patientSelectGUI
Func patientSelectGUI($family, $parent)
	Global $patientSelectGUI = GUICreate("Charts", 450, 630)
	$list = GUICtrlCreateListView("Select a Patient", 10, 10, 420, 580)
	$renameButton = GUICtrlCreateButton("Rename", 10, 591, 45, 25)
	_GUICtrlListView_SetColumnWidth($list, 0, 400)
	$chartsselectbutton = GUICtrlCreateButton("Select", 366, 591, 45, 25)
	$FileList = _FileListToArray($chartsPath & "\" & $family, Default)
	If @error = 4 Then
		MsgBox(0, "Error", "No files found for " & $family)
		ChartsGUI($parent)
	EndIf
	If @error = 1 Then
		MsgBox(0, "Error", "You do not have any charts in " & $family)
		GUIDelete()
		ChartsGUI($parent)
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $patientSelectGUI)
	EndIf
	While 1
		$scmsg = GUIGetMsg()
		Switch ($scmsg)
			Case $renameButton
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You must select a file.")
				Else

					$rename = InputBox("File Rename", "What is the new Family Name?" & @CRLF & "Please Follow the format:" & @CRLF & "Role - Lastname, Firstname")
					If $rename = "DELETE" Then
						DirRemove($chartsPath & "\" & $sItem, 1)
					Else
						DirMove($chartsPath & "\" & $family & "\" & $sItem, $chartsPath & "\" & $family & "\" & $rename)
					EndIf
				EndIf
				GUIDelete()
				patientSelectGUI($family, $parent)
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				ChartsGUI($parent)
			Case $chartsselectbutton
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				GUIDelete()
				pageSelectGui($family, $sItem, $parent)
		EndSwitch
	WEnd
EndFunc   ;==>patientSelectGUI

;pageSelectGui
Func pageSelectGui($family, $patient, $parent)
	Global $pageSelectGUI = GUICreate("Charts", 300, 330)
	$list = GUICtrlCreateListView("Select a Page", 10, 10, 280, 280)
	_GUICtrlListView_SetColumnWidth($list, 0, 279)
	$chartsselectbutton = GUICtrlCreateButton("Select", 245, 291, 45, 25)
	$FileList = _FileListToArray($chartsPath & "\" & $family & "\" & $patient, Default)
	If @error = 4 Then
		MsgBox(0, "Error", "No files found in " & $patient)
		ChartsGUI($parent)
	EndIf
	If @error = 1 Then
		MsgBox(0, "Error", "You do not have any charts in " & $patient)
		GUIDelete()
		ChartsGUI($parent)
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $pageSelectGUI)
	EndIf
	While 1
		$scmsg = GUIGetMsg()
		Switch ($scmsg)
			Case $GUI_EVENT_CLOSE
				GUIDelete($pageSelectGUI)
				ChartsGUI($parent)
			Case $chartsselectbutton
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				GUIDelete()
				chartfileselectGUI($family, $patient, $sItem, $parent)
		EndSwitch
	WEnd
EndFunc   ;==>pageSelectGui

chartfileselectGUI
Func chartfileselectGUI($family, $patient, $page, $parent)
	Global $chartfileSelectGUI = GUICreate("Charts", 450, 330)
	$list = GUICtrlCreateListView("Select a File", 10, 10, 420, 280)
	_GUICtrlListView_SetColumnWidth($list, 0, 400)
	$pageselectbutton = GUICtrlCreateButton("Select Page", 10, 291, 125, 25)
	$chartsselectbutton = GUICtrlCreateButton("Select", 366, 291, 45, 25)
	$FileList = _FileListToArray($chartsPath & "\" & $family & "\" & $patient & "\" & $page, Default)
	If @error = 4 Then
		MsgBox(0, "Error", "No files found")
		ChartsGUI($parent)
	EndIf
	If @error = 1 Then
		MsgBox(0, "Error", "You do not have any charts in " & $patient)
		GUIDelete()
		ChartsGUI($parent)
	Else
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
		GUISetState(@SW_SHOW, $chartfileSelectGUI)
	EndIf
	While 1
		$scmsg = GUIGetMsg()
		Switch ($scmsg)
			Case $GUI_EVENT_CLOSE
				GUIDelete($chartfileSelectGUI)
				ChartsGUI($parent)
			Case $pageselectbutton
				GUIDelete()
				repageselectgui($family, $patient, $parent)
			Case $chartsselectbutton
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				ShellExecute($chartsPath & "\" & $family & "\" & $patient & "\" & $page & "\" & $sItem)
		EndSwitch
	WEnd
EndFunc   ;==>chartfileselectGUI

Func repageselectgui($family, $patient, $parent)
	Global $repageselectgui = GUICreate("Page Selection", 480, 200)
	$page1Button = GUICtrlCreateButton("Page 1", 50, 50, 75, 75, 0x2000)
	$page2Button = GUICtrlCreateButton("Page 2", 126, 50, 75, 75, 0x2000)
	$page3Button = GUICtrlCreateButton("Page 3", 202, 50, 75, 75, 0x2000)
	$page4Button = GUICtrlCreateButton("Page 4", 278, 50, 75, 75, 0x2000)
	$page5Button = GUICtrlCreateButton("Page 5", 353, 50, 75, 75, 0x2000)
	GUISetState(@SW_SHOW)

	While 1
		$scmsg = GUIGetMsg()
		Switch ($scmsg)
			Case $page1Button
				GUIDelete()
				chartfileselectGUI($family, $patient, "page 1", $parent)
			Case $page2Button
				GUIDelete()
				chartfileselectGUI($family, $patient, "page 2", $parent)
			Case $page3Button
				GUIDelete()
				chartfileselectGUI($family, $patient, "page 3", $parent)
			Case $page4Button
				GUIDelete()
				chartfileselectGUI($family, $patient, "page 4", $parent)
			Case $page5Button
				GUIDelete()
				chartfileselectGUI($family, $patient, "page 5", $parent)
		EndSwitch
	WEnd

EndFunc   ;==>repageselectgui
