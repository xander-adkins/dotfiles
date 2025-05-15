#!/usr/bin/osascript
tell app "Citrix Viewer" to activate
tell app "System Events" to repeat with c in the clipboard
	keystroke c
	delay 0.05
end
