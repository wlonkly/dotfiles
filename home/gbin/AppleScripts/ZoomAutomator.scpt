property liveTitle : "Mute audio"
property mutedTitle : "Unmute audio"

global virtualcam

on run
	tell application "AnyBar" to activate
	set virtualcam to "off"
end run

on idle
	tell application "System Events"
		if (get name of every application process) contains "zoom.us" then
			tell application "OBS" to activate
			tell application "System Events" to tell application process "zoom.us"
				if exists (menu bar item "Meeting" of menu bar 1) then
					# in a meeting
					my enableCam()

					if exists (menu item liveTitle of menu 1 of menu bar item "Meeting" of menu bar 1) then
						my setAnyBar("green")
					else if exists (menu item mutedTitle of menu 1 of menu bar item "Meeting" of menu bar 1) then
						my setAnyBar("red")
					end if
				else
					# no meeting
					my setAnyBar("filled")
					my disableCam()
				end if
			end tell
		else
			# zoom is not running
			my quitOBS()
			my setAnyBar("filled")
		end if
	end tell
	return 2
end idle


on enableCam()
	if virtualcam is equal to "off" then
		set virtualcam to "on"
		do shell script "$HOME/bin/obs-cli -p 4455 virtualcam start; true"
	end if
end enableCam

on disableCam()
	if virtualcam is equal to "on" then
		set virtualcam to "off"
		do shell script "$HOME/bin/obs-cli -p 4455 virtualcam stop; true"
	end if
end disableCam

on quitOBS()
	set virtualcam to "off"
	tell application "System Events"
		if (get name of every application process) contains "OBS" then
			do shell script "osascript -e 'tell application \"OBS\" to quit' >/dev/null 2>&1; true"
		end if
	end tell
end quitOBS

on setAnyBar(c)
	tell application "AnyBar" to set image name to c
end setAnyBar
