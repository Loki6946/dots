local awful = require("awful")
local menu = require("modules.menu")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local apps = require("config.apps")
local focused = awful.screen.focused()

local function awesome_menu()
	return menu({
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "Show Help",
			on_press = function()
				hotkeys_popup.show_help(nil, awful.screen.focused())
				awesome.emit_signal("close::menu")
			end,
		}),
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "Docs",
			on_press = function()
				awful.spawn.with_shell(
					"firefox https://awesomewm.org/apidoc/documentation/07-my-first-awesome.md.html#"
				)
				awesome.emit_signal("close::menu")
			end,
		}),
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "Edit Config",
			on_press = function()
				awful.spawn.with_shell("cd ~/.config/awesome && alacritty -e nvim" .. " " .. awesome.conffile)
				awesome.emit_signal("close::menu")
			end,
		}),
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "Restart",
			on_press = function()
				awesome.emit_signal("close::menu")
				awesome.restart()
			end,
		}),
		menu.button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "Quit",
			on_press = function()
				awesome.emit_signal("close::menu")
				awesome.quit()
			end,
		}),
	})
end

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
		menu.separator(),
		menu.sub_menu_button({
			icon = { icon = "", font = beautiful.icon_var },
			text = "AwesomeWM",
			sub_menu = awesome_menu(),
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
