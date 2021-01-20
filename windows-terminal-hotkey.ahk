#Include %A_ScriptDir%\Explorer.ahk
#SingleInstance, force
#NoTrayIcon
#NoEnv

PrefferredDir := "D:\dev" ; The default directory to open if the current expolorer path isn't valid.
UbuntuProfileName := "Ubuntu" ; The name of the alternate windows profile (Found in settings.json of windows terminal)

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DesktopPath := RegExReplace(A_Desktop, "\\", "\\\\" ) ; Sanitize the path to work with what we'll get from Explorer_GetPath

TerminalSig := "ahk_class CASCADIA_HOSTING_WINDOW_CLASS"

; Run Windows Terminal default profile at current path
^!w::
	DetectHiddenWindows, on
	If (WinExist(TerminalSig)) {
		WinRestore
		WinActivate
	}
	else 
	{
		path := Explorer_GetPath()
		path := RegExReplace(path, "\\", "\\\\")

		args := "-d "
		If (path != "ERROR" && path != DesktopPath) {
			args .= """" . path . """"
		}
		else {
			args .= PrefferredDir
		}

		Run wt.exe %args%
		WinSetTitle, PowerShell
	}
	
	keywait, t ; Wait for the key to be released before returning, otherwise multiple terminals can be spawned by one key press.
	return

; Run windows terminal with the ubuntu profile at current path
^!t::
	DetectHiddenWindows, on
	If (WinExist(TerminalSig)) {
		WinRestore
		WinActivate
	}
	else 
	{
		path := Explorer_GetPath()
		path := RegExReplace(path, "\\", "\\\\")

		args := "-d "
		If (path != "ERROR" && path != DesktopPath) {
			args .= """" . path . """"
		}
		else {
			args .= PrefferredDir
		}
		args .= " -p " . UbuntuProfileName ; -p arg requests wt to open with a specific profile.

		Run wt.exe %args%
	}
	keywait, u ; Wait for the key to be released before returning, otherwise multiple terminals can be spawned by one key press.
	return