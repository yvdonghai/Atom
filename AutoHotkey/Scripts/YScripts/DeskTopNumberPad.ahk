;根据jon的屏幕键盘改写
;地址:https://ahkcn.github.io/docs/scripts/KeyboardOnScreen.htm
#SingleInstance force
; larger or smaller:
k_FontSize = 14
k_FontName = Verdana  ; This can be blank to use the system's default font.
k_FontStyle =     ; Example of an alternative: Italic Underline
k_FontSize4Text = 9
; Names for the tray menu items:
k_MenuItemHide = Hide NumPad
k_MenuItemShow = Show NumPad

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
Gui, -MinimizeBox -MaximizeBox +Owner +AlwaysOnTop
TransColor = F1ECED
;Gui, Color, %TransColor%  ; This color will be made transparent later below.

;---- Add a button for each key. Position the first button with absolute
; coordinates so that all other buttons can be positioned relative to it:

Gui, Add, Button, section %k_KeySize%, 7
Gui, Add, Button, %k_Position%, 8
Gui, Add, Button, %k_Position%, 9
Gui, Add, Button, %k_Position%, /
Gui, Add, Button, %k_KeySize% xm y+%k_KeyMargin%, 4
Gui, Add, Button, %k_Position%, 5
Gui, Add, Button, %k_Position%, 6
Gui, Add, Button, %k_Position%, *
Gui, Add, Button, %k_KeySize% xm y+%k_KeyMargin%, 1
Gui, Add, Button, %k_Position%, 2
Gui, Add, Button, %k_Position%, 3
Gui, Add, Button, %k_Position%, -
Gui, Add, Button, %k_KeySize% xm y+%k_KeyMargin%, .
Gui, Add, Button, %k_Position%, 0
Gui, Add, Button, %k_Position%, =
Gui, Add, Button, %k_Position%, +
Gui, Add, Button, %k_KeySize% xm y+%k_KeyMargin% , (
Gui, Add, Button, %k_Position%, )
Gui, Add, Button, %k_Position%, BK
Gui, Add, Button, %k_Position%, EN
Gui, font,s%k_FontSize4Text%, %k_FontName%
Gui, Add, Text, w%k_YWinWidth% xm y+%k_KeyMargin%,在窗口按Win+K获取焦点
;---- Show the window:
Gui, Show, , NumPad
k_IsVisible = y
MouseControlHwnd = ;鼠标所在的输入位置的唯一标识
Button0:
	ControlSend , , 0, ahk_id %MouseControlHwnd%, , ,
Return
Button1:
	ControlSend , , 1, ahk_id %MouseControlHwnd%, , ,
Return
Button2:
	ControlSend , , 2, ahk_id %MouseControlHwnd%, , ,
Return
Button3:
	ControlSend , , 3, ahk_id %MouseControlHwnd%, , ,
Return
Button4:
	ControlSend , , 4, ahk_id %MouseControlHwnd%, , ,
Return
Button5:
	ControlSend , , 5, ahk_id %MouseControlHwnd%, , ,
Return
Button6:
	ControlSend , , 6, ahk_id %MouseControlHwnd%, , ,
Return
Button7:
	ControlSend , , 7, ahk_id %MouseControlHwnd%, , ,
Return
Button8:
	ControlSend , , 8, ahk_id %MouseControlHwnd%, , ,
Return
Button9:
	ControlSend , , 9, ahk_id %MouseControlHwnd%, , ,
Return
ButtonEN:
	ControlSend , , {Enter}, ahk_id %MouseControlHwnd%, , ,
Return
ButtonBK:
	ControlSend , , {Backspace}, ahk_id %MouseControlHwnd%, , ,
Return
Button(:
	ControlSend , , (, ahk_id %MouseControlHwnd%, , ,
Return
Button):
	ControlSend , , ), ahk_id %MouseControlHwnd%, , ,
Return
Button/:
	ControlSend , , /, ahk_id %MouseControlHwnd%, , ,
Return
Button*:
	ControlSend , , *, ahk_id %MouseControlHwnd%, , ,
Return
Button-:
	ControlSend , , -, ahk_id %MouseControlHwnd%, , ,
Return
Button+:
	ControlSend , , {+}, ahk_id %MouseControlHwnd%, , ,
Return
Button=:
	ControlSend , , {=}, ahk_id %MouseControlHwnd%, , ,
Return
Button.:
	ControlSend , , ., ahk_id %MouseControlHwnd%, , ,
Return
WinGet, k_ID, ID, A   ; Get its window ID.
WinGetPos, k_WindowX, k_WindowY, k_WindowWidth, k_WindowHeight, A

MouseGetPos, k_MouseX, k_MouseY, , , 1
; Calculate window's X-position:
k_WindowX = %k_WindowX%
k_WindowX += %k_MouseX%  ; Now k_WindowX contains the width of this monitor.
; Calculate window's Y-position:
k_WindowY = %k_WindowY%
k_WindowY += %k_MouseY%

WinMove, A,, %k_WindowX%, %k_WindowY%
WinSet, AlwaysOnTop, On, ahk_id %k_ID%
WinSet, TransColor, %TransColor% 220, ahk_id %k_ID%

;---- When a key is pressed by the user, click the corresponding button on-screen:
!k::
; 此脚本获取活动窗口焦点控件的 ahk_id（HWND）。
	MouseGetPos, , , MouseControlHwnd, , 1
	Gui, Show
	TrayTip , , 获取焦点%MouseControlHwnd%, 1, 1
Return

k_ShowHide:
if k_IsVisible = y
{
	Gui, Cancel
	Menu, Tray, Rename, %k_MenuItemHide%, %k_MenuItemShow%
	TrayTip , , 按Win+k显示Numpad, 1, 1
	k_IsVisible = n
}
else
{
	Gui, Show
	Menu, Tray, Rename, %k_MenuItemShow%, %k_MenuItemHide%
	TrayTip , , 按Win+k获取焦点, 1, 1
	k_IsVisible = y
}
return


GuiClose:
	Gui, Cancel
	try{
		Menu, Tray, Rename, %k_MenuItemHide%, %k_MenuItemShow%
	}catch {}
	TrayTip , , 按Win+k显示Numpad, 1, 1
	k_IsVisible = n
Return
k_MenuExit:
	ExitApp
