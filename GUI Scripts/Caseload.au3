Func Caseloads($parent, $worker)

	Global $caseloadgui = GUICreate("Caseload for " & $worker, 500, 200)
	$currentButton = GUICtrlCreateButton(" Open Current ", 50, 50, 75, 75, 0x2000)
	$archiveButton = GUICtrlCreateButton(" Open Archive ", 375, 50, 75, 75, 0x2000)
	If $parent = "supervisor" Then
		$sendToArchive = GUICtrlCreateButton("Send To Archive", 215, 50, 75, 75, 0x2000)
	EndIf
	If $parent = "worker" Then
		$sendToArchive = GUICtrlCreateButton("Staff Caseloads", 215, 50, 75, 75, 0x2000)
	EndIf
	GUISetState(@SW_SHOW)


	If $parent = "supervisor" Then
		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $GUI_EVENT_CLOSE
					GUIDelete()
					Mainwindow()
				Case $currentButton
					ShellExecute("\\grdhd3\hands\Caseloads\" & $worker & "\caseload" & $caseloadFileType)
				Case $archiveButton
					GUIDelete()
					CaseloadArchive($parent, $worker)
				Case $sendToArchive
					$sure = MsgBox(4, "", "Are you sure you want the send the current Caseload to archive?")
					If $sure = 6 Then
						GUIDelete()
						Date($parent, $worker)
					Else
					EndIf
			EndSwitch
		WEnd
	Else
		If $parent = "data" Then
			While 1
				$nMsg = GUIGetMsg()
				Switch $nMsg
					Case $GUI_EVENT_CLOSE
						GUIDelete()
						opentodata($worker)
					Case $currentButton
						ShellExecute("\\grdhd3\hands\caseloads\" & $worker & "\caseload" & $caseloadFileType)
					Case $archiveButton
						GUIDelete()


				EndSwitch
			WEnd
		Else
			If $parent = "datamain" Then
				While 1
					$nMsg = GUIGetMsg()
					Switch $nMsg
						Case $GUI_EVENT_CLOSE
							GUIDelete()
							mainwindow()
						Case $currentButton
							ShellExecute("\\grdhd3\hands\caseloads\" & $worker & "\caseload" & $caseloadFileType)
						Case $archiveButton
							GUIDelete()
							CaseloadArchive($parent, $worker)
					EndSwitch
				WEnd
			Else
				While 1
					$nMsg = GUIGetMsg()
					Switch $nMsg
						Case $GUI_EVENT_CLOSE
							GUIDelete()
							Mainwindow()
						Case $currentButton
							ShellExecute("\\grdhd3\hands\caseloads\" & @UserName & "\caseload" & $caseloadFileType)
						Case $sendToArchive
							$filecheck = FileExists("\\" & $server & "\hands")
							If $filecheck = 0 Then
								MsgBox(0, "GRDHD Network Connection Not Detected", "The GRDHD netowrk has not been detected, This option is only avaliable on the network.", 3)
							EndIf
							GUIDelete()
							StaffCaseloads($parent, @UserName)
						Case $archiveButton
							GUIDelete()
							CaseloadArchive($parent, @UserName)
					EndSwitch
				WEnd
			EndIf
		EndIf
	EndIf
EndFunc   ;==>Caseloads

Func CaseloadArchive($parent, $worker)
	$archivegui = GUICreate("Caseload Archive", 500, 500)
	$list = GUICtrlCreateListView("File", 25, 25, 450, 424)
	_GUICtrlListView_SetColumnWidth($list, 0, 420)
	filelist($list, "filler", "\\grdhd3\hands\caseloads\" & $worker & "\archive", Default)
	$openbutton = GUICtrlCreateButton("Open", 425, 450, 50, 25)
	;$backbutton = GUICtrlCreateButton("Back", 374, 450, 50, 25)
	GUISetState(@SW_SHOW)
	$path = ""

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				Caseloads($parent, $worker)
				;Case $backbutton
				;	If $path = "\\grdhd3\hands\employee folders\" & $worker & "\caseload" Then
				;		_GUICtrlListView_DeleteAllItems($list)
				;		filelist($list, "filler", $path, Default)
				;	Else
				;		$trim = StringInStr($path, "\", 0, -1)
				;		$trim = StringLen($path) - $trim
				;		$path = StringTrimRight($path, $trim + 1)
				;		_GUICtrlListView_DeleteAllItems($list)
				;		filelist($list, "filler", $path, Default)
				;	EndIf
			Case $openbutton
				$sItem = GUICtrlRead(GUICtrlRead($list))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You must make a selection")
				Else
					If $path = "" Then
						$path = "\\grdhd3\hands\caseloads\" & $worker & "\archive\" & $sItem
					Else
						$path = $path & "\" & $sItem
					EndIf
					$attributes = FileGetAttrib($path)
					If $attributes = "D" Then
						_GUICtrlListView_DeleteAllItems($list)
						filelist($list, "filler", $path, Default)
					Else
						ShellExecute($path)
					EndIf
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>CaseloadArchive

Func StaffCaseloads($parent, $worker)
	$staff = GUICreate("Staff", 300, 300)
	$select = GUICtrlCreateButton("Select", 226, 271, 45, 25)
	$staffList = GUICtrlCreateListView("Staff Member", 10, 10, 260, 260)
	FileList($staffList, "", "\\grdhd3\hands\caseloads", "*")
	_GUICtrlListView_SetColumnWidth($staffList, 0, 209)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $select
				$sItem = GUICtrlRead(GUICtrlRead($staffList))
				$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
				If $sItem = "" Then
					MsgBox(0, "Error", "You must make a selection")
				Else
					ShellExecute("\\" & $server & "\hands\caseloads\" & $sItem & "\caseload" & $caseloadFileType)
				EndIf
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				Caseloads($parent, $worker)
		EndSwitch
	WEnd
EndFunc   ;==>StaffCaseloads

Func Date($parent, $worker)
	Global $datewindow = GUICreate("Date", 300, 125)
	$monthpicker = GUICtrlCreateCombo("Month", 10, 10, 125, 25)
	$yearpicker = GUICtrlCreateCombo("Year", 136, 10, 75, 25)
	$selectButton = GUICtrlCreateButton("Select", 185, 61, 75, 25)
	GUISetState(@SW_SHOW)

	$monthlist = FileRead($formsPath & "\Months.txt")
	$monthlist = StringReplace($monthlist, @CRLF, "|")
	GUICtrlSetData($monthpicker, $monthlist, "")

	$yearlist = FileRead($formsPath & "\Years.txt")
	$yearlist = StringReplace($yearlist, @CRLF, "|")
	GUICtrlSetData($yearpicker, $yearlist, "")

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				Caseloads($parent, $worker)
			Case $selectButton
				$monthselected = GUICtrlRead($monthpicker)
				$yearselected = GUICtrlRead($yearpicker)
				FileCopy("\\grdhd3\hands\caseloads\" & $worker & "\caseload" & $caseloadfileType, "\\grdhd3\hands\caseloads\" & $worker & "\archive\" & $yearselected & "\caseload" & $caseloadFileType, $FC_CREATEPATH)
				FileMove("\\grdhd3\hands\caseloads\" & $worker & "\archive\" & $yearselected & "\caseload" & $caseloadfileType, "\\grdhd3\hands\caseloads\" & $worker & "\archive\" & $yearselected & "\" & $monthselected & $caseloadfiletype)
				GUIDelete($datewindow)
				Caseloads($parent, $worker)
		EndSwitch
	WEnd
EndFunc   ;==>Date







