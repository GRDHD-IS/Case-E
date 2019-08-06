;function to create directories that will be used if the do not exist
Func setup()
	$filecheck = FileExists($handsPath)
	If @error = 0 Then
		DirCreate($handsPath)
	EndIf
	$filecheck = FileExists($activitiesPath)
	If @error = 0 Then
		DirCreate($activitiesPath)
	EndIf
	$filecheck = FileExists($formsPath)
	If @error = 0 Then
		DirCreate($formsPath)
	EndIf
	$filecheck = FileExists($labelsPath)
	If @error = 0 Then
		DirCreate($labelsPath)
	EndIf
	$filecheck = FileExists($correctionPath)
	If @error = 0 Then
		DirCreate($correctionPath)
	EndIf
	$filecheck = FileExists($dataPath)
	If @error = 0 Then
		DirCreate($dataPath)
	EndIf
	;$filecheck = FileExists($supervisorPath)
	;If @error = 0 Then
	;	DirCreate($supervisorPath)
	;EndIf
	;$filecheck = FileExists($supervisionPath)
	;If @error = 0 Then
	;	DirCreate($supervisionPath)
	;EndIf
	$filecheck = FileExists($workPath)
	If @error = 0 Then
		DirCreate($workPath)
	EndIf
EndFunc   ;==>setup