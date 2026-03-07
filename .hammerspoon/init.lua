local function app(name)
  return function()
    hs.application.launchOrFocus(name)
  end
end

hs.hotkey.bind({"cmd"}, "1", app("WezTerm"))
hs.hotkey.bind({"cmd"}, "2", app("iTerm"))
hs.hotkey.bind({"cmd"}, "3", app("Firefox"))
hs.hotkey.bind({"cmd"}, "4", app("Finder"))

hs.hotkey.bind({"ctrl", "cmd", "shift"}, "escape", function()
  hs.execute("pmset displaysleepnow")
end)

local powerChooser

local function powerChoices()
  return {
    {
      text = "Sleep",
      subText = "Put Mac to sleep",
      action = function()
        hs.caffeinate.systemSleep()
      end
    },
    {
      text = "Restart",
      subText = "Restart Mac",
      action = function()
        hs.execute([[osascript -e 'tell app "System Events" to restart']])
      end
    },
    {
      text = "Shutdown",
      subText = "Shutdown Mac",
      action = function()
        hs.execute([[osascript -e 'tell app "System Events" to shut down']])
      end
    },
    {
      text = "Cancel",
      subText = "Close this menu",
      action = function()
      end
    },
  }
end

powerChooser = hs.chooser.new(function(choice)
  if choice and choice.action then
    choice.action()
  end
end)

powerChooser:searchSubText(true)
powerChooser:rows(6)

hs.hotkey.bind({"cmd"}, "\\", function()
  powerChooser:choices(powerChoices())
  powerChooser:show()
end)


--local function app(name)
--  return function()
--    hs.application.launchOrFocus(name)
--  end
--end
----
---- cmd+3 → Firefox
--hs.hotkey.bind({"cmd"}, "1", app("WezTerm"))

---- cmd+3 → Firefox
--hs.hotkey.bind({"cmd"}, "3", app("Firefox"))

---- cmd+4 → Finder
--hs.hotkey.bind({"cmd"}, "4", app("Finder"))

---- ctrl+cmd+shift+esc → 화면 끄기 (Sleep Monitor)
--hs.hotkey.bind({"ctrl","cmd","shift"}, "escape", function()
--  hs.execute("pmset displaysleepnow")
--end)

---- cmd+\ → 전원 메뉴
--hs.hotkey.bind({"cmd"}, "\\", function()
--  local choices = {
--    { text = "Sleep", subText = "Put Mac to sleep", action = function()
--        hs.caffeinate.systemSleep()
--      end },
--    { text = "Restart", subText = "Restart Mac", action = function()
--        hs.execute("osascript -e 'tell app \"System Events\" to restart'")
--      end },
--    { text = "Shutdown", subText = "Shutdown Mac", action = function()
--        hs.execute("osascript -e 'tell app \"System Events\" to shut down'")
--      end },
--  }

--  hs.chooser.new(function(choice)
--    if choice then choice.action() end
--  end):choices(choices):show()
--end)


-- hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
--   print("key:", hs.keycodes.map[e:getKeyCode()], "flags:", hs.inspect(e:getFlags()))
--   return false
-- end):start()

-- hs.hotkey.bind({"cmd"}, "1", function()
--   hs.application.launchOrFocus("WezTerm")
-- end)

-- hs.hotkey.bind({"cmd"}, "3", function()
--   hs.application.launchOrFocus("Firefox")
-- end)

-- hs.hotkey.bind({"cmd"}, "4", function()
--   hs.application.launchOrFocus("Finder")
-- end)

-- hs.hotkey.bind({"ctrl","cmd","shift"}, "escape", function()
--   hs.execute("pmset displaysleepnow")
-- end)

-- -- hs.hotkey.bind({"ctrl", "cmd", "shift"}, "escape", function()
-- --   hs.application.launchOrFocus("Sleep Monitor")
-- -- end)
