;Function to list files into their arrays, then create list view items in the list view controls, used only in main window
Func FileList($list, $directory, $path, $filter)
	If FileExists($path) Then
		$FileList = _FileListToArray($path, $filter)
		If @error = 4 Then
			Return 0
		EndIf
		If @error = 1 Then
			Return 0
		EndIf
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem($FileList[$INDEX], $list)
		Next
	EndIf

EndFunc   ;==>FileList

Func FileList2($list, $path, $filter)
	If FileExists($path) Then
		$FileList = _FileListToArray($path, $filter)
		If @error = 4 Then
			Return 0
		EndIf
		If @error = 1 Then
			Return 0
		EndIf
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem(FileListCount($path & "\" & $FileList[$INDEX] & "\To Supervisor") & "|" & FileListCount($path & "\" & $FileList[$INDEX] & "\Needs Correction") & "|" & FileListCount($path & "\" & $FileList[$INDEX] & "\To Data Entry") & "|" & FileListCount($path & "\" & $FileList[$INDEX] & "\Work In Progress"), $list)
		Next
	EndIf

EndFunc   ;==>FileList2

Func FileList3($list, $path, $filter)
	If FileExists($path) Then
		$FileList = _FileListToArray($path, $filter)
		If @error = 4 Then
			Return 0
		EndIf
		If @error = 1 Then
			Return 0
		EndIf
		For $INDEX = 1 To $FileList[0]
			GUICtrlCreateListViewItem(FileListCount($path & "\" & $FileList[$INDEX] & "\To Data Entry"), $list)
		Next
	EndIf


EndFunc   ;==>FileList3

;counts the number of files in a location
Func FileListCount($path)
	If FileExists($path) Then
		$FileListCount = _FileListToArray($path, "*.pdf")
		If @error = 1 Then
			MsgBox(0, "Error", "Directory not found")
		EndIf
		If @error = 4 Then
			Return 0
		EndIf
		Return $FileListCount[0]
	EndIf

EndFunc   ;==>FileListCount
