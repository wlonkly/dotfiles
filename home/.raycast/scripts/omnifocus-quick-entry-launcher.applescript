#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Omnifocus Quick Entry Launcher
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ??

# Documentation:
# @raycast.description If Omnifocus is not running, captures the Quick Entry hotkey and launches Omnifocus
# @raycast.author Rich Lafferty
# @raycast.authorURL https://github.com/wlonkly/

-- (*
-- OopsieFocus

-- A script to launch OmniFocus and activate the Quick Entry Panel

-- By Shawn Blanc (http://shawnblanc.net)
-- May 20, 2011

-- With code used from the Toggle Twitter script by Red Sweater Software:
--   http://www.red-sweater.com/blog/1646/toggle-twitter

-- Works great with FastScripts or Keyboard Maestro:
--   http://www.red-sweater.com/fastscripts/
--   http://www.keyboardmaestro.com/main/

-- How it works:
--   Set this script to run using the same keyboard shortut that you use to launch the Quick
--   Entry Panel in OmniFocus. If you ever try to activate the Quick Entry Panel but
--   OmniFocus happens to not be running, then this script will launch OmniFocus and bring
--   up the Quick Entry Panel for you.
--

set GTDAppName to "OmniFocus"
global GTDAppName
MaybeOpenQuickEntry()

-- Is OmniFocus running?
on AppIsRunning(GTDAppName)
	tell application "System Events"
		return (count of (application processes whose name is GTDAppName)) is not 0
	end tell
end AppIsRunning

-- If OmniFocus is running, do nothing.
-- If OmniFocus is not running, launch it and bring up the Quick Entry Panel.
on MaybeOpenQuickEntry()
	if AppIsRunning(GTDAppName) then
		return ""
	else
		tell application "OmniFocus"
			activate
			tell quick entry
				open
				make new inbox task
				tell application "System Events" to keystroke tab
			end tell
		end tell
	end if
return "Raycast launched OmniFocus"
end MaybeOpenQuickEntry
