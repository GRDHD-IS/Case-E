Func newfamily($family, $worker, $folder)
	$newfamilycode = InputBox("New Family Billing code", "Input the Billing code of the new family:")
	If @error = 1 Then
		GUIDelete()
		MainWindow()
	Else
		$babyname = InputBox("New Family", "Input the name of the new family's baby")
		If $babyname = "" Then
			MsgBox(0, "Error", "You must input a patient name.")
		Else
			$mothername = InputBox("New Family", "Input the name of the new family's Mom")
			If $mothername = "" Then
				MsgBox(0, "Error", "You must input a caregiver name.")
			Else
				$newfamily = $mothername & ' - ' & $babyname & ' ' & $newfamilycode
				DirCreate($chartsPath & "\" & $newfamily & "\Mom - " & $mothername & "\Page 1")
				DirCreate($chartsPath & "\" & $newfamily & "\Mom - " & $mothername & "\Page 2")
				DirCreate($chartsPath & "\" & $newfamily & "\Mom - " & $mothername & "\Page 3")
				DirCreate($chartsPath & "\" & $newfamily & "\Mom - " & $mothername & "\Page 4")
				DirCreate($chartsPath & "\" & $newfamily & "\Mom - " & $mothername & "\Page 5")
				;
				DirCreate($chartsPath & "\" & $newfamily & "\baby - " & $babyname & "\Page 1")
				DirCreate($chartsPath & "\" & $newfamily & "\baby - " & $babyname & "\Page 2")
				DirCreate($chartsPath & "\" & $newfamily & "\baby - " & $babyname & "\Page 3")
				DirCreate($chartsPath & "\" & $newfamily & "\baby - " & $babyname & "\Page 4")
				DirCreate($chartsPath & "\" & $newfamily & "\baby - " & $babyname & "\Page 5")
			EndIf
		EndIf
	EndIf
EndFunc   ;==>newfamily

