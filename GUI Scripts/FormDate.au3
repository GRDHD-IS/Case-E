

Func GetDate($title, $prompt, $callback, $parent)
	$GetDate_ParentWin = $parent
	GUISetState(@SW_LOCK, $parent)
	$GetDate_Window = GUICreate($title, 250, 250, -1, -1, $WS_POPUP + $WS_CAPTION + $WS_SYSMENU, $WS_EX_TOPMOST)
	$GetDate_Callback = $callback
	GUICtrlCreateLabel($prompt, 30, 10)
	$today = "Today: " & _DateTimeFormat(_NowCalcDate(), 1)
	$GetDate_Today = _NowCalcDate()
	$todaybutton = GUICtrlCreateButton($today, 5, 50, 240, 30)

	; Yesterday button will become Friday, not Sunday, if today is Monday.
	If StringInStr($today, "Monday") Then
		$yesterday = _DateTimeFormat(_DateAdd("d", -3, _NowCalcDate()), 1)
		$GetDate_Yesterday = _DateAdd("d", -3, _NowCalcDate())
		$otherdate = _DateAdd("d", -4, _NowCalcDate())
	Else
		$yesterday = "Yesterday: " & _DateTimeFormat(_DateAdd("d", -1, _NowCalcDate()), 1)
		$GetDate_Yesterday = _DateAdd("d", -1, _NowCalcDate())
		$otherdate = _DateAdd("d", -2, _NowCalcDate())
	EndIf
	$yesterdaybutton = GUICtrlCreateButton($yesterday, 5, 100, 240, 30)


	GUICtrlCreateLabel("Or, choose a different date:", 30, 155)

	$GetDate_OtherDateCtrl = GUICtrlCreateDate($otherdate, 10, 175, 230, 30, $DTS_LONGDATEFORMAT)

	$selecteddatebutton = GUICtrlCreateButton("Use Selected Date", 5, 215, 240, 30)

	GUISetState(@SW_SHOW, $GetDate_Window)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GetDateClose()
			Case $todaybutton
				GetDateReturnToday()
			Case $yesterdaybutton
				GetDateReturnYesterday()
			Case $selecteddatebutton
				GetDateOK()
		EndSwitch
	WEnd

EndFunc   ;==>GetDate

Func GetDateClose()
	GUIDelete($GetDate_Window)
	GUISetState(@SW_UNLOCK, $GetDate_ParentWin)
	GUIDelete(MainWindow)
	MainWindow()
EndFunc   ;==>GetDateClose

Func GetDateFinish()
	GUIDelete($GetDate_Window)
	GUISetState(@SW_UNLOCK, $GetDate_ParentWin)
	If Not $GetDate_DateEntered == -1 And Not StringRegExp($GetDate_DateEntered, "^\d\d\d\d\-\d\d\-\d\d$") Then
		MsgBox(0, "Error", "Please enter the date as YYYY-MM-DD")
		Return 1
	EndIf
	Call($GetDate_Callback, $GetDate_DateEntered)
	GUIDelete(mainwindow)
	MainWindow()
EndFunc   ;==>GetDateFinish

Func GetDateReturnToday()
	$aDate = StringSplit($GetDate_today, "/")
	$GetDate_DateEntered = $aDate[2] & "-" & $adate[3] & "-" & $aDate[1]
	GetDateFinish()
EndFunc   ;==>GetDateReturnToday

Func GetDateReturnYesterday()
	$aDate = StringSplit($GetDate_yesterday, "/")
	$GetDate_DateEntered = $aDate[2] & "-" & $adate[3] & "-" & $aDate[1]
	GetDateFinish()
EndFunc   ;==>GetDateReturnYesterday

Func GetDateOK()
	GUICtrlSendMsg($GetDate_OtherDateCtrl, $DTM_SETFORMAT, 0, "y")
	$year = GUICtrlRead($GetDate_OtherDateCtrl)
	GUICtrlSendMsg($GetDate_OtherDateCtrl, $DTM_SETFORMAT, 0, "M")
	$month = GUICtrlRead($GetDate_OtherDateCtrl)
	GUICtrlSendMsg($GetDate_OtherDateCtrl, $DTM_SETFORMAT, 0, "d")
	$day = GUICtrlRead($GetDate_OtherDateCtrl)
	$GetDate_DateEntered = StringFormat("%02s-%02s-20%02s", $month, $day, $year)
	GetDateFinish()
EndFunc   ;==>GetDateOK