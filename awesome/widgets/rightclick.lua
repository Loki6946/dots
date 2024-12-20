local awful = require("awful")
local menu = require("modules.menu")
local beautiful = require("beautiful")
local apps = require("config.apps")

local function widget()
	return menu({
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "Terminal",
			on_press = function()
				awful.spawn.with_shell(apps.terminal, false)
				awesome.emit_signal("close::menu")
			end,
		}),
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "File Manager",
			on_press = function()
				awful.spawn.with_shell(apps.file_manager, false)
				awesome.emit_signal("close::menu")
			end,
		}),
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "Text Editor",
			on_press = function()
				awful.spawn.with_shell(apps.editor_cmd, false)
				awesome.emit_signal("close::menu")
			end,
		}),
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "Music Player",
			on_press = function()
				awful.spawn.with_shell(apps.music, false)
				awesome.emit_signal("close::menu")
			end,
		}),
	})
end

local themenu = widget()

awesome.connect_signal("close::menu", function()
	themenu:hide(true)
end)
awesome.connect_signal("toggle::menu", function()
	themenu:toggle()
end)

return { desktop = themenu }
