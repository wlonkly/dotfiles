print("Loaded CameraLights.lua")

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
    -- toggle lights here
    print("Camera in use")
  else
    print("Camera not in use")
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
