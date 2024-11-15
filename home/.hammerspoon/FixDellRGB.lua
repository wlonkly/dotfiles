
print("Loaded FixDellRGB.lua")

fixRGB = function()
  print("Screens changed, checking for Dell monitor")
  dell = hs.screen.find("Dell")
  if dell ~= nil then
    print("Fixing RGB state for " .. dell:name())
    hs.execute("~/.hammerspoon/fix-dell-rgb.sh")
  end
end

w = hs.screen.watcher.new(fixRGB):start()

