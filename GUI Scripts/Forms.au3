

;----------------------------------------------------------------------------------------------------------------------------------------------------------


Func CreateForm($labelSelected, $templateSelected, $date) ; CREATE FORM FROM SELECTED TEMPLATE
	; GENERATE A TEMPORARY FDF FILE FROM SELECTED LABEL,
	; WITH @_GRDHD_FORMDATE FILLED IN WITH CURRENT DATE,
	; AND TARGET PDF FILE SET TO THE SELECTED PDF TEMPLATE.
	; THEN SHELL EXEC THE TEMPORARY FDF FILE TO OPEN WITH SYSTEM VIEWER



	$formateddate = StringReplace(StringMid($date, 6), "-", "/") & "/" & StringLeft($date, 4)
	$parsedName = ParseFormName($templateSelected)
	$workingFilename = $parsedName[3] & $date & " " & StringStripWS(StringReplace($labelSelected, ".fdf", ""), 7) & " - " & StringStripWS($parsedName[1], 7) & ".pdf"
	$suffix = ""
	While CheckFormName(StringReplace($workingFilename, ".pdf", $suffix & ".pdf"))
		$suffix = $suffix + 1
	WEnd
	$oldWorkingFilename = $workingFilename
	$workingFilename = StringReplace($workingFilename, ".pdf", $suffix & ".pdf")
	If Not $suffix = "" Then
		If MsgBox($MB_YESNO, "Form Already Exists", "A file named: " & @CRLF & @CRLF & $oldWorkingFilename & @CRLF & @CRLF & " already exists. Would you like to create a new form named: " & @CRLF & @CRLF & $workingFilename) = $IDNO Then
			Return 1
		EndIf
	EndIf

	$templateFile = $formsPath & "\" & $formLanguage & "\" & $templateSelected
	$finalPDF = $workPath & "\" & $workingFilename

	; Create an FDF file with the information

	$f = FileOpen($labelsSelectPath & "\" & $labelSelected, $FO_READ)
	$FDFTemplate = FileRead($f)
	FileClose($f)

	; Replace bogus date placeholder (@_LCDHD_FORMDATE) in template with today's date
	$FDFTemplate = FDFSearchReplace($FDFTemplate, "V", "@_GRDHD_FORMDATE", $formateddate)

	; Replace bogus date placeholder (@_LCDHD_DATE) in template with today's date
	$FDFTemplate = FDFSearchReplace($FDFTemplate, "V", "@_GRDHD_DATE", $formateddate)

	; Replace filename reference in label template with the new file we just created
	$FDFTemplate = FDFSearchReplace($FDFTemplate, "F", $blankLabelName, StringReplace($workPath & "\" & $workingFilename, "\", "/"))

	; Write out the FDF template file to a temporary file
	$TempFDFName = _TempFile(@TempDir, "HANDS_FDF_", ".fdf")
	$f = FileOpen($TempFDFName, $FO_BINARY + $FO_OVERWRITE)
	FileWrite($f, $FDFTemplate)
	FileClose($f)
	;OpenFDF($TempFDFName,$rootPath & $workBase & $workingPath & "\" & $workingFilename)

	; Create the new PDF file using the FDF file info
	RunWait('"' & $pdftk & '" "' & $templateFile & '" fill_form "' & $TempFDFName & '" output "' & $finalPDF & '"', "", @SW_HIDE)
	FileDelete($TempFDFName)

	; Open the PDF file using the default application

	ShellExecute($finalPDF, "", $workPath)

EndFunc   ;==>CreateForm

Func CreateFormPacket()
	; Initiate form creation, by opening the date selection window. Calls CreateFormPacketFinish after date is selected.
	If GetListFirstItemSelected($labelList) = -1 Then
		MsgBox(0, "Error", "Please select a name for the label")
		Return 1
	EndIf
	If GetListFirstItemSelected($formList) = -1 Then
		MsgBox(0, "Error", "Please select a form template")
		Return 1
	EndIf
	$date = GetDate("Service Date", "Please select the date the" & @CRLF & "service was performed:", "CreateFormPacketFinish", $mainWindow)
EndFunc   ;==>CreateFormPacket

Func CreateFormPacketFinish($date) ; Creates a form or form packet for the selected date. Called after date selection form.
	;
		Local $aFormList
	;	Local $i
	;	If $date = Null Then
	;		Return 1
	;	EndIf
	$sItem = GUICtrlRead(GUICtrlRead($labelList))
	$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
	$labelSelected = $sItem
	$sItem = GUICtrlRead(GUICtrlRead($formList))
	$sItem = StringTrimRight($sItem, 1) ; Will remove the pipe "|" from the end of the string
	$templateSelected = $sItem


	;	; Check if this is a form "packet" listing
		If StringRight($templateSelected, 4) = ".txt" Then
			_FileReadToArray($formsPath & "\" & $formLanguage & "\" & $templateSelected, $aFormList)
			$i = 1
			; Check to be sure all forms exist
			While $i < UBound($aFormList)
				If Not FileExists($formsPath & "\" & $formLanguage & "\" & $aFormList[$i]) Then
					MsgBox(0, "HANDS Box: Problem", "There is a problem with this form packet." & @CRLF & "The packet requires '" & $aFormList[$i] & "', but I can't find this file." & @CRLF & "Please contact the forms management staff to correct this problem.")
					Return 1
				EndIf
			$i += 1
			WEnd
		While $i > 1
				$i -= 1
				CreateForm($labelSelected, $aFormList[$i], $date)
				Sleep(2000)
			WEnd
		Else
	; This is just a single PDF form, proceed to create it
	CreateForm($labelSelected, $templateSelected, $date)
		EndIf


EndFunc   ;==>CreateFormPacketFinish

Func ProcessCheck() ; Check if any processes are running that could interfere with sync
	For $pname In $checkPDFProcess
		If ProcessExists($pname) Then
			MsgBox(0, "Please Close Open Forms", "It appears that forms may still be open in process " & $pname & ". Please save your work and close all other windows and try again")
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>ProcessCheck

Func CheckFormName($checkname) ; Search for a form name in the normal places. Used to prevent duplicate form names.
	If FileExists($workPath & "\" & $checkname) Then
		Return True
	EndIf
	If FileExists($supervisorPath & "\" & $checkname) Then
		Return True
	EndIf
	If FileExists($dataPath & "\" & $checkname) Then
		Return True
	EndIf
	Return False
EndFunc   ;==>CheckFormName

Func FDFSearchReplace($fdfdata, $type, $search, $replace)
	$fdfdata = StringReplace($fdfdata, "/" & $type & " (" & $search & ")", "/" & $type & " (" & $replace & ")")

	; At the bottom part of the FDF file, we expect there to be a line starting with "xref". We cut the file off here,
	; and replace it with our built-in template, calculating the length of the top portion so the FDF file is valid

	$fdfdata = StringMid($fdfdata, 1, StringInStr($fdfdata, @CRLF & "xref") + 1)
	$fdfdata = $fdfdata & $masterFDFTemplate[3] & StringLen($fdfdata) & $masterFDFTemplate[4]
	Return $fdfdata
EndFunc   ;==>FDFSearchReplace

Func ParseFormName($t) ; Parse the filename of a form template into an array containing multiple fields
	Local $parsedName[4]

	$parsedName[0] = StringStripWS(StringLeft($t, StringInStr($t, "-") - 1), $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)
	$titleStart = StringInStr($t, "-") + 1
	$dateStart = StringInStr($t, "(")
	$sectionStart = StringInStr($t, "[")
	$titleEnd = StringLen($t) - 3
	If $dateStart > 0 Or $sectionStart > 0 Then
		If $dateStart > 0 Then
			$titleEnd = $dateStart
		ElseIf $sectionStart > 0 Then
			$titleEnd = $sectionStart
		EndIf
	EndIf
	$parsedName[1] = StringStripWS(StringMid($t, $titleStart, $titleEnd - $titleStart), $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)
	$parsedName[2] = ""
	If $dateStart > 0 Then
		$dateEnd = StringInStr($t, ")")
		If $dateEnd > 0 Then
			$parsedName[2] = StringStripWS(StringMid($t, $dateStart + 1, $dateEnd - $dateStart - 1), $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)
		EndIf
	EndIf
	$parsedName[3] = ""
	If $sectionStart > 0 Then
		$parsedName[3] = StringStripWS(StringMid($t, $sectionStart + 1, 1), $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)
	EndIf
	Return $parsedName
EndFunc   ;==>ParseFormName

Func NormalizeName($name) ; NORMALIZE A PERSON'S NAME, AND STRIP WHITE SPACE
	$normalizedName = StringReplace($name, ",", ", ")
	$normalizedName = StringUpper(StringStripWS($normalizedName, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES))
	$normalizedName = StringReplace($normalizedName, " ,", ",")
	Return $normalizedName
EndFunc   ;==>NormalizeName

Func GetListFirstItemSelected($control) ; RETURN INDEX OF FIRST SELECTED ITEM IN _GUICtrlListView
	$count = _GUICtrlListView_GetItemCount($control)
	$i = 0
	While $i < $count
		If _GUICtrlListView_GetItemSelected($control, $i) Then
			Return $i
		EndIf
		$i += 1
	WEnd
	Return -1
EndFunc   ;==>GetListFirstItemSelected

Func getPDFList($path, $filter) ; LIST FILES IN $path (WITH SUPPLIED FILTER) AND RETURN IN AN ARRAY
	Local $blankArray[1]
	$blankArray[0] = "None"
	$fullpath = $path
	$fArr = _FileListToArray($fullpath, $filter)
	If @error = 1 Then
		ConsoleWrite("Path was invalid: " & $fullpath)
		Return $blankArray
	EndIf
	If @error = 4 Then
		ConsoleWrite("No File Found: " & $fullpath & @CRLF)
		Return $blankArray
	EndIf
	If @error > 0 Then
		ConsoleWrite("Other Error Listing File in: " & $fullpath)
		Return $blankArray
	EndIf
	Return $fArr
EndFunc   ;==>getPDFList