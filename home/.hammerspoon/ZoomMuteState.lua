print "Loaded ZoomMuteState.lua"

-- check zoom menus to see if muted
function updateZoomMuteState()
  local apps = hs.application.applicationsForBundleID("us.zoom.xos")

  for k, app in pairs(apps) do
    if app:findMenuItem({"Meeting", "Unmute Audio"}) then
      -- muted
      zoomMuteState:returnToMenuBar()
      zoomMuteState:setIcon("~/.hammerspoon/ZoomMuteState/muted.png", false)
      return
    elseif app:findMenuItem({"Meeting", "Mute Audio"}) then
      -- unmuted
      zoomMuteState:returnToMenuBar()
      zoomMuteState:setIcon("~/.hammerspoon/ZoomMuteState/unmuted.png", false)
      return
    end

    -- not in a meeting
    zoomMuteState:removeFromMenuBar()
  end
end

zoomMuteState = hs.menubar.new(false, "zoomMuteState")
zoomMuteChecker = hs.timer.doEvery(2, updateZoomMuteState)
