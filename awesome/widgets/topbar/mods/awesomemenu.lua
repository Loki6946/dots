local awful = require("awful")
local menu = require("modules.menu")
local beautiful = require("beautiful")
local apps = require("config.apps")
local hotkeys_popup = require("awful.hotkeys_popup")

local function awesome_menu()
	return menu({
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "About This System",
			on_press = function()
				awesome.emit_signal("close::awesomemenu")
				awful.spawn.with_shell(apps.system_info)
			end,
		}),
		menu.separator(),
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "Show Help",
			on_press = function()
				awesome.emit_signal("close::awesomemenu")
				hotkeys_popup.show_help(nil, awful.screen.focused())
			end,
		}),
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "Docs",
			on_press = function()
				awesome.emit_signal("close::awesomemenu")
				awful.spawn.with_shell("chrome https://awesomewm.org/apidoc/documentation/07-my-first-awesome.md.html#")
			end,
		}),
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "Edit Config",
			on_press = function()
				awesome.emit_signal("close::awesomemenu")
				awful.spawn.with_shell("cd ~/.config/awesome && " .. apps.editor_cmd .. " ./theme/init.lua")
			end,
		}),
		menu.separator(),
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "Restart AwesomeWM",
			on_press = function()
				awesome.emit_signal("close::awesomemenu")
				awesome.restart()
			end,
		}),
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "Quit AwesomeWM",
			on_press = function()
				awesome.emit_signal("close::awesomemenu")
				awesome.quit()
			end,
		}),
	})
end

local awesomemenu = awesome_menu()

awesome.connect_signal("close::awesomemenu", function()
	awesomemenu:hide(true)
end)
awesome.connect_signal("toggle::awesomemenu", function()
	awesomemenu:toggle({
		coords = {
			x = 10,
			y = 30,
		},
	})
end)

return { desktop = awesomemenu }