;Alt + r
;在打开的资源管理器打开cmd窗口
#HotkeyInterval 200
!r::
	if(WinActExeNameContains("explorer.exe")){
		currentPath := FolderPath() ;替换掉'Address'或者'地址'
		Run, cmd /s /k pushd %currentPath% ;执行cmd, pushd是改变目录
	}else{
		Send, !r
	}
Return

;Alt + c
;拷贝当前目录或者当前选中的文件路径
!c::
	if(WinActExeNameContains("explorer.exe")){
		Clipboard := ""
		Send, ^c
		Sleep 50

		if(StrLen(Clipboard) = 0){
			Clipboard := FolderPath()
		}
		Clipboard = %Clipboard%
		Tooltip %Clipboard%
		Sleep 200
		Tooltip
	}else{
		Send, !c
	}
Return

FolderPath(){
		SetTitleMatchMode, 2 ;窗口标题的某个位置必须包含 WinTitle
		WinGetText, folderPath, A ;获取当前活动窗口的信息
		RegExMatch(folderPath, "m)(Address:.*|地址:.*)", folderPath) ;正则匹配出窗口信息的address地址
		folderPath := RegExReplace(folderPath, "m)(Address:|地址:)") ;替换掉'Address'或者'地址'
		Return folderPath
}
WinActExeName(){
	WinGet, winActExe, ProcessName, A
	Return %winActExe%
}

WinActExeNameContains(subStr){
	contains := WinActExeName()
	contains := InStr(contains, subStr)
	Return contains
}
