
;----------------------------------------------------------------------------------------------------------------------------------------------------------

;------------------------------------------------------------------------------------------------------------------------------
Func newLabel()


	$labelWindow = GUICreate("Create HANDS Family Label", 340, 360)

	GUICtrlCreateLabel("Home Visitor: ", 10, 10)
	$labelFields[0] = GUICtrlCreateInput("", 135, 10, 200, 20)
	GUICtrlCreateLabel("Patient ID:", 10, 40)
	$labelFields[1] = GUICtrlCreateInput("", 135, 40, 200, 20)
	GUICtrlCreateLabel("Clinic ID: ", 10, 70)
	$labelFields[2] = GUICtrlCreateInput("", 135, 70, 200, 20)
	GUICtrlCreateLabel("DOB (MM/DD/YYYY): ", 10, 100)
	$labelFields[3] = GUICtrlCreateInput("", 135, 100, 200, 20)
	GUICtrlCreateLabel("Last Name: ", 10, 130)
	$labelFields[4] = GUICtrlCreateInput("", 135, 130, 200, 20)
	GUICtrlCreateLabel("First Name: ", 10, 160)
	$labelFields[5] = GUICtrlCreateInput("", 135, 160, 200, 20)
	GUICtrlCreateLabel("Middle Initial: ", 10, 190)
	$labelFields[6] = GUICtrlCreateInput("", 135, 190, 50, 20)
	GUICtrlSetOnEvent($labelFields[6], "CheckMILength")
	GUICtrlCreateLabel("Billing Code: ", 10, 220)
	$labelFields[7] = GUICtrlCreateCombo("", 138, 220, 200, 20)
	$labelFields[8] = GUICtrlCreateInput("", 220, 410, 20, 20) ; Hidden field for _GRDHD_NAME
	$labelFields[9] = GUICtrlCreateInput("@_GRDHD_FORMDATE", 220, 400, 20, 20) ; Hidden field for _GRDHD_FORMDATE
	$createLabel = GUICtrlCreateButton("Create Label", 1, 300, 338, 30)
	$cancelLabel = GUICtrlCreateButton("Cancel", 1, 330, 338, 30)

	$billingcodes = FileRead($formsPath & "\billingcodes.txt")
	$billingcodes = StringReplace($billingcodes, @CRLF, "|")

	GUICtrlSetData($labelFields[7], $billingcodes, "")


	GUISetState(@SW_SHOW, $labelWindow)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($labelWindow)
				MainWindow()
			Case $createLabel
				LabelCreate()
				GUIDelete($labelWindow)
				MainWindow()
			Case $cancelLabel
				GUIDelete($labelWindow)
				MainWindow()
		EndSwitch
	WEnd

EndFunc   ;==>newLabel

Func LabelCreate()
	; Create a label (FDF file) with information from the currently open Label form


	; GENERATE A NEW FDF FILE (LABEL) WITH DATA ENTERED ON NEW LABEL FORM
	Local $i = 0
	Local $aFields[0]
	Local $aValues[0]

	GUICtrlSetData($labelFields[8], GUICtrlRead($labelFields[4]) & ", " & GUICtrlRead($labelFields[5]) & " " & GUICtrlRead($labelFields[6]))
	While $i < UBound($labelFields)
		$v = GUICtrlRead($labelFields[$i])
		If Not $v = "" Then
			_ArrayAdd($aFields, $labelFieldsNames[$i])
			If StringInStr($v, "--") Then
				;ConsoleWriteError("Stripping Dashes: "& StringStripWS(StringMid($v,1,StringInStr($v,"--") - 2),$STR_STRIPTRAILING) & @CRLF);
				_ArrayAdd($aValues, StringStripWS(StringMid($v, 1, StringInStr($v, "--") - 2), $STR_STRIPTRAILING))
			Else
				_ArrayAdd($aValues, $v)
			EndIf
		EndIf
		$i += 1
	WEnd
	$fullFDF = CreateFDF("000 - Blank Label.pdf", $aFields, $aValues)

	$dstFile = $labelsSelectPath & "\" & GUICtrlRead($labelFields[4]) & ", " & GUICtrlRead($labelFields[5]) & " " & GUICtrlRead($labelFields[6]) & " " & GUICtrlRead($labelFields[7]) & ".fdf"
	$f = FileOpen($dstFile, $FO_BINARY + $FO_OVERWRITE)
	If @error > 0 Then
		MsgBox(0, "Error", "There was a problem creating the label.")
	EndIf
	FileWrite($f, $fullFDF)
	FileClose($f)
	FileInstall("000 - Blank Label.pdf", $labelsSelectPath & "\", $FC_OVERWRITE)
EndFunc   ;==>LabelCreate


Func CreateFDF($pdfFile, $aFields, $aValues)
	$innerFDF = $masterFDFTemplate[0] & $pdfFile & $masterFDFTemplate[1]
	$i = 0
	While $i < UBound($aFields)
		$innerFDF = $innerFDF & _
				'<</T (' & $aFields[$i] & ')' & @CRLF & _
				'/V (' & $aValues[$i] & ')' & @CRLF & _
				'>> '
		$i += 1
	WEnd
	$innerFDF = $innerFDF & $masterFDFTemplate[2]

	$fullFDF = $innerFDF & $masterFDFTemplate[3] & StringLen($innerFDF) & $masterFDFTemplate[4]
	Return $fullFDF
EndFunc   ;==>CreateFDF

Func CheckMILength()
	$mi = GUICtrlRead($labelFields[6])
	$mi = StringMid($mi, 1, 1)
	GUICtrlSetData($labelFields[6], $mi)
EndFunc   ;==>CheckMILength

Func ParseFDF($fdfdata, ByRef $aFields, ByRef $aValues)
	$rslt = StringRegExp($fdfdata, "(?Uis)<<(.*)>>", $STR_REGEXPARRAYGLOBALFULLMATCH, StringInStr($fdfdata, @CRLF & "/Fields"))
	If @error Then
		Return @error
	EndIf
	For $r In $rslt
		$field = StringRegExp($r[1], "\/([TV])\s\((.*)\)", $STR_REGEXPARRAYGLOBALFULLMATCH)
		If @error Or UBound($field) < 1 Then
			ContinueLoop
		EndIf
		$fname = ""
		$fvalue = ""
		For $element In $field
			If $element[1] = "T" Then
				$fname = $element[2]
			EndIf
			If $element[1] = "V" Then
				$fvalue = $element[2]
			EndIf
		Next
		If Not $fname = "" Then
			_ArrayAdd($aFields, $fname)
			_ArrayAdd($aValues, $fvalue)
		EndIf
	Next
	If UBound($aFields) > 0 Then
		Return 0
	Else
		Return -1
	EndIf
EndFunc   ;==>ParseFDF