--
-- https://spinscale.de/posts/2023-02-01-using-hammerspoon-to-enable-lighting-for-meetings.html
--
-- This script toggles a switch on Hubitat whenever a webcam is in use.
-- Usually that's to turn lights on and off, but the lighting logic is 
-- in a Rule Machine app there, not here. 

print("Loaded CameraLights.lua")

hubitatLightDevice = '159'  -- zoom MEETING, not zoom LIGHT
hubitatHost = 'hubitat.local'

function switchLights(state)
  local url = string.format('http://%s/apps/api/71/devices/%s/%s?access_token=%s', hubitatHost, hubitatLightDevice, state, hubitatApiToken)
  hs.http.asyncGet(url, nil, function(status, body, headers)
    if status == 200 then
      print("Switched lights to " .. state)
    else
      print("Failed to switch lights to " .. state)
    end
  end)
end

function stopConfigureAndStartPropertyWatcher(camera)
  if camera:isPropertyWatcherRunning() then
    camera:stopPropertyWatcher()
  end

  camera:setPropertyWatcherCallback(function(camera, property, scope, element)
    print("camera watcher call back triggered for " .. camera:name())
    -- switching cameras will produce two events but we'll only respond
    -- to the first one, so give it a moment
    hs.timer.doAfter(1, checkLights)
  end)
  camera:startPropertyWatcher()
end

function atDesk()
  return hs.battery.powerSource() == "AC Power"
     and hs.wifi.currentNetwork() == "Suckerfish"
     and hs.screen.primaryScreen():name() ~= "Built-in Retina Display"
end

function checkLights()
  if not atDesk() then
    print("Not at desk, not checking lights")
    return
  end

  local anyCameraInUse = false
  for k, camera in pairs(hs.camera.allCameras()) do
    print(string.format('Checking camera %s, is in use: %s', camera:name(), camera:isInUse()))
    if camera:isInUse() then
      anyCameraInUse = true
    end
  end

  if (anyCameraInUse) then
    print("Camera in use")
    switchLights('on')
  else
    print("Camera not in use")
    switchLights('off')
  end
end

for k, camera in pairs(hs.camera.allCameras()) do
  stopConfigureAndStartPropertyWatcher(camera)
end

hs.camera.setWatcherCallback(function(camera, state)
  if state == 'Added' then
    print('Camera change callback triggered ' .. state)
    stopConfigureAndStartPropertyWatcher(camera)
  end
  checkLights()
end)
hs.camera.startWatcher()
