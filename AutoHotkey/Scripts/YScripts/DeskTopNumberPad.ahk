; On-Screen Keyboard (requires XP/2k/NT) -- by Jon
; http://www.autohotkey.com
; This script creates a mock keyboard at the bottom of your screen that shows
; the keys you are pressing in real time. I made it to help me to learn to
; touch-type (to get used to not looking at the keyboard).  The size of the
; on-screen keyboard can be customized at the top of the script. Also, you
; can double-click the tray icon to show or hide the keyboard.

;---- Configuration Section: Customize the size of the on-screen keyboard and
; other options here.

; Changing this font size will make the entire on-screen keyboard get
; larger or smaller:
k_FontSize = 14
k_FontName = Verdana  ; This can be blank to use the system's default font.
k_FontStyle =     ; Example of an alternative: Italic Underline
k_FontSize4Text = 9
; Names for the tray menu items:
k_MenuItemHide = Hide on-screen &keyboard
k_MenuItemShow = Show on-screen &keyboard

; To have the keyboard appear on a monitor other than the primary, specify
; a number such as 2 for the following variable.  Leave it blank to use
; the primary:
k_Monitor = 

;---- End of configuration section.  Don't change anything below this point
; unless you want to alter the basic nature of the script.


;---- Alter the tray icon menu:
Menu, Tray, Add, %k_MenuItemHide%, k_ShowHide
Menu, Tray, Add, &Exit, k_MenuExit
Menu, Tray, Default, %k_MenuItemHide%
Menu, Tray, NoStandard

;---- Calculate object dimensions based on chosen font size:
k_KeyWidth = %k_FontSize%
k_KeyWidth *= 3
k_KeyHeight = %k_FontSize%
k_KeyHeight *= 3
k_KeyMargin = %k_FontSize%
k_KeyMargin /= 6
k_SpacebarWidth = %k_FontSize%
k_SpacebarWidth *= 25
k_KeyWidthHalf = %k_KeyWidth%
k_KeyWidthHalf /= 2


k_KeySize = w%k_KeyWidth% h%k_KeyHeight%
k_Position = x+%k_KeyMargin% %k_KeySize%
k_YWinWidth := (k_KeyWidth * 4 + k_KeyMargin * 4)
k_YWinHeight := (k_KeyWidth * 5 + k_KeyMargin * 12)
;---- Create a GUI window for the on-screen keyboard:
Gui, Font, s%k_FontSize% %k_FontStyle%, %k_FontName%
Gui, +Resize +MaxSize%k_YWinWidth%x%k_YWinHeight% +MinSize%k_YWinWidth%x%k_YWinHeight% +ToolWindow +AlwaysOnTop
TransColor = F1ECED
Gui, Color, %TransColor%  ; This color will be made transparent later below.

;---- Add a button for each key. Position the first button with absolute
; coordinates so that all other buttons can be positioned relative to it:

Gui, Add, Button, section %k_KeySize% x-0 y-0, 7
Gui, Add, Button, %k_Position% y-0, 8
Gui, Add, Button, %k_Position% y-0, 9
Gui, Add, Button, %k_Position% y-0, /
Gui, Add, Button, %k_KeySize% xm y+%k_KeyMargin% x-0, 4
Gui, Add, Button, %k_Position%, 5
Gui, Add, Button, %k_Position%, 6
Gui, Add, Button, %k_Position%, *
Gui, Add, Button, %k_KeySize% xm y+%k_KeyMargin% x-0, 1
Gui, Add, Button, %k_Position%, 2
Gui, Add, Button, %k_Position%, 3
Gui, Add, Button, %k_Position%, -
Gui, Add, Button, %k_KeySize% xm y+%k_KeyMargin% x-0, .
Gui, Add, Button, %k_Position%, 0
Gui, Add, Button, %k_Position%, =
Gui, Add, Button, %k_Position%, +
Gui, Add, Button, %k_KeySize% xm y+%k_KeyMargin% x-0, (
Gui, Add, Button, %k_Position%, )
Gui, Add, Button, %k_Position%, BK
Gui, Add, Button, %k_Position%, EN
Gui, font,s%k_FontSize4Text%, %k_FontName%
Gui, Add, Text, w%k_YWinWidth% xm y+%k_KeyMargin% x-0 -Background,在窗口按Alt+K获取焦点
;---- Show the window:
Gui, Show, , NumPad
k_IsVisible = y

WinGet, k_ID, ID, A   ; Get its window ID.
WinGetPos,,, k_WindowWidth, k_WindowHeight, A

;---- Position the keyboard at the bottom of the screen (taking into account
; the position of the taskbar):
SysGet, k_WorkArea, MonitorWorkArea, %k_Monitor%

; Calculate window's X-position:
k_WindowX = %k_WorkAreaRight%
k_WindowX -= %k_WorkAreaLeft%  ; Now k_WindowX contains the width of this monitor.
k_WindowX -= %k_WindowWidth%
k_WindowX /= 2  ; Calculate position to center it horizontally.
; The following is done in case the window will be on a non-primary monitor
; or if the taskbar is anchored on the left side of the screen:
k_WindowX += %k_WorkAreaLeft%

; Calculate window's Y-position:
k_WindowY = %k_WorkAreaBottom%
k_WindowY -= %k_WindowHeight%

WinMove, A,, %k_WindowX%, %k_WindowY%
WinSet, AlwaysOnTop, On, ahk_id %k_ID%
WinSet, TransColor, %TransColor% 220, ahk_id %k_ID%


;---- Set all keys as hotkeys. See www.asciitable.com
k_n = 1
k_ASCII = 45

Loop
{
	Transform, k_char, Chr, %k_ASCII%
	StringUpper, k_char, k_char
	if k_char not in <,>,^,~,?`,
		Hotkey, ~*%k_char%, k_KeyPress
		; In the above, the asterisk prefix allows the key to be detected regardless
		; of whether the user is holding down modifier keys such as Control and Shift.
	if k_ASCII = 93
		break
	k_ASCII++
}

return ; End of auto-execute section.


;---- When a key is pressed by the user, click the corresponding button on-screen:

~*Backspace::
ControlClick, Bk, ahk_id %k_ID%, , LEFT, 1, D
KeyWait, Backspace
ControlClick, Bk, ahk_id %k_ID%, , LEFT, 1, U
return


; LShift and RShift are used rather than "Shift" because when used as a hotkey,
; "Shift" would default to firing upon release of the key (in older AHK versions):
~*LShift::
~*RShift::
~*LCtrl::  ; Must use Ctrl not Control to match button names.
~*RCtrl::
~*LAlt::
~*RAlt::
~*LWin::
~*RWin::
StringTrimLeft, k_ThisHotkey, A_ThisHotkey, 3
ControlClick, %k_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, D
KeyWait, %k_ThisHotkey%
ControlClick, %k_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, U
return


~*,::
~*'::
~*Space::
~*Enter::
~*Tab::
k_KeyPress:
StringReplace, k_ThisHotkey, A_ThisHotkey, ~
StringReplace, k_ThisHotkey, k_ThisHotkey, *
SetTitleMatchMode, 3  ; Prevents the T and B keys from being confused with Tab and Backspace.
ControlClick, %k_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, D
KeyWait, %k_ThisHotkey%
ControlClick, %k_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, U
Return


k_ShowHide:
if k_IsVisible = y
{
	Gui, Cancel
	Menu, Tray, Rename, %k_MenuItemHide%, %k_MenuItemShow%
	k_IsVisible = n
}
else
{
	Gui, Show
	Menu, Tray, Rename, %k_MenuItemShow%, %k_MenuItemHide%
	k_IsVisible = y
}
return


GuiClose:
k_MenuExit:
ExitApp
