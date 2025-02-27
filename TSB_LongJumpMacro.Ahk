#SingleInstance, Force

SysGet, screenWidth, 78
SysGet, screenHeight, 79

tooltipX := screenWidth - 250
tooltipY := screenHeight - 50

ToolTip, Macro is working! Press 'Del' to close macro., %tooltipX%, %tooltipY%

SetTimer, CheckExitKey, 100

Loop {
    InputBox, key, Key Assignment, Which key do you want to use?, , 300, 150
    if (key = "") {
        MsgBox, No valid key entered! Exiting script.
        ExitApp
    }
    
    if (RegExMatch(key, "^[a-zA-Z0-9]$") || IsValidKey(key)) {
        break
    }
    
    MsgBox, Please enter **only one valid key**!
}

Hotkey, % "$*" key, ExecuteAction
return

ExecuteAction:
    SendEvent {Shift Up}
    Send, {d Down}
    Sleep, 7
    SendInput {q down}{Space down}
    Sleep, 10
    SendInput {q up}{Space up}
    Send, {d Up}
return

IsValidKey(key) {
    validKeys := "LButton,RButton,MButton,XButton1,XButton2,Tab,Enter,Escape,Backspace,Delete,Insert,"
               . "Home,End,PgUp,PgDn,Up,Down,Left,Right,CapsLock,ScrollLock,NumLock,"
               . "F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12"
    If key in %validKeys%
        return true
    return false
}

CheckExitKey:
    if GetKeyState("Delete", "P") {
        ToolTip  ; Remove tooltip
        ExitApp
    }
return
