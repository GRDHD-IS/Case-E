$User = "HANDS"
$perm = "F"


;filemove("c:\test\test.txt","c:\temp\test.txt")
filemove("c:\temp\test.txt","c:\test\test.txt")

;RunWait( 'iCACLS "' & "c:\temp\test.txt" & '" /grant HANDS:F','' , @SW_HIDE)
RunWait( 'iCACLS "' & "c:\test\test.txt" & '" /remove:g HANDS','' , @SW_HIDE)