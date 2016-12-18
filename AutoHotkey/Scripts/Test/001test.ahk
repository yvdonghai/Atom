~LCtrl::
	KeyWait, LCtrl
	If (A_TimeSinceThisHotkey > 500)
		Send, {LWin}
	Else
    Send, {LCtrl}
Return
