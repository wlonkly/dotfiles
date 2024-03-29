print "Loaded ZoomMuteState.lua"

-- check zoom menus to see if muted
function updateZoomMuteState()
  for k, app in pairs(zoomApps()) do
    if app:findMenuItem({"Meeting", "Unmute audio"}) then
      -- muted
      zoomUpdateMenubar("~/.hammerspoon/ZoomMuteState/muted.png")
      return
    elseif app:findMenuItem({"Meeting", "Mute audio"}) then
      -- unmuted
      zoomUpdateMenubar("~/.hammerspoon/ZoomMuteState/unmuted.png")
      return
    end

    -- not in a meeting
    zoomMuteState:removeFromMenuBar()
  end
end

function zoomToggleMute()
  for k, app in pairs(zoomApps()) do
    hs.eventtap.keyStroke({}, "f6", 200000, app)
    updateZoomMuteState()
  end
end

function zoomUpdateMenubar(path)
  -- have to set callback every time because removeFromMenubar clears it
  zoomMuteState:returnToMenuBar():setClickCallback(zoomToggleMute):setIcon(path, false)
end

function zoomApps()
  return hs.application.applicationsForBundleID("us.zoom.xos")
end

zoomMuteState = hs.menubar.new(false, "zoomMuteState")

-- TODO: wrap this timer in an hs.application.watcher so it stops when Zoom is not running
zoomMuteChecker = hs.timer.doEvery(2, updateZoomMuteState)
