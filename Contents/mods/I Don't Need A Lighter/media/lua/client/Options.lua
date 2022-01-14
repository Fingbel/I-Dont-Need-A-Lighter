-- These are the default options.
local OPTIONS = {
  box1 = true,
  box2 = false,
}

-- Connecting the options to the menu, so user can change them.
if ModOptions and ModOptions.getInstance then
  ModOptions:getInstance(OPTIONS, "MyModID", "My Mod")
end

-- Check actual options at game loading.
Events.OnGameStart.Add(function()
  print("checkbox1 = ", OPTIONS.box1)
  print("checkbox2 = ", OPTIONS.box2)
end)