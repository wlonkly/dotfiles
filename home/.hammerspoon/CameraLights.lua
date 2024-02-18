--
-- https://spinscale.de/posts/2023-02-01-using-hammerspoon-to-enable-lighting-for-meetings.html
--

print("Loaded CameraLights.lua")

hubitatLightDevice = '159'
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
    checkLights()
  end)
  camera:startPropertyWatcher()
end

function checkLights()
  local anyCameraInUse = false
  for k, camera in pairs(hs.camera.allCameras()) do
    print(string.format('Checking camera %s, is in use: %s', camera:name(), camera:isInUse()))
    if camera:isInUse() then
      anyCameraInUse = true
    end
  end

  -- TODO: check for connection to... something? monitor? wifi? to make sure i am at my desk!
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
