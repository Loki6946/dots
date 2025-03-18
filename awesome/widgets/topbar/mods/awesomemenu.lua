local awful = require("awful")
local gears = require("gears")
local menu = require("modules.menu")
local apps = require("config.apps")
local hotkeys_popup = require("awful.hotkeys_popup")
local confirm_modal = require("helpers.widget.create_confirm_modal")

local function close_menu()
	gears.timer.start_new(0.1, function()
		awesome.emit_signal("close::awesomemenu")
	end)
end

local function awesome_menu()
	return menu({
		menu.button({
			text = "About This System",
			on_press = function()
				awful.spawn.with_shell(apps.system_info)
				close_menu()
			end,
		}),
		menu.separator(),
		menu.button({
			text = "Show Help",
			on_press = function()
				hotkeys_popup.show_help(nil, awful.screen.focused())
				close_menu()
			end,
		}),
		menu.button({
			text = "Docs",
			on_press = function()
				awful.spawn.with_shell("chrome https://awesomewm.org/apidoc/documentation/07-my-first-awesome.md.html#")
				close_menu()
			end,
		}),
		menu.button({
			text = "Edit Config",
			on_press = function()
				awful.spawn.with_shell("cd ~/.config/awesome && " .. apps.editor_cmd .. " ./theme/init.lua")
				close_menu()
			end,
		}),
		menu.separator(),
		menu.button({
			text = "Screen Scale 105%",
			on_press = function()
				confirm_modal.show(
					"Change Screen Scaling?",
					"This will change the screen scaling and restart awesomewm.",
					function()
						awful.spawn.with_shell("xrandr --output LVDS-1 --panning 1400x787 --scale 1.025x1.025")
						awesome.restart()
					end,
					function()
						print("Cancelled")
					end
				)
				close_menu()
			end,
		}),
		menu.button({
			text = "Screen Scale 100%",
			on_press = function()
				confirm_modal.show(
					"Change Screen Scaling?",
					"This will change the screen scaling and restart awesomewm.",
					function()
						awful.spawn.with_shell("xrandr --output LVDS-1 --panning 1366x768 --scale 1x1")
						awesome.restart()
					end,
					function()
						print("Cancelled")
					end
				)
				close_menu()
			end,
		}),
		menu.separator(),
		menu.button({
			text = "Restart AwesomeWM",
			on_press = function()
				confirm_modal.show("Restart AwesomeWM?", "This will restart awesomewm config.", function()
					awesome.restart()
				end, function()
					print("Cancelled")
				end)
				close_menu()
			end,
		}),
		menu.button({
			text = "Quit AwesomeWM",
			on_press = function()
				confirm_modal.show("Quit AwesomeWM?", "This will close all window and return to gdm.", function()
					awesome.quit()
				end, function()
					print("Cancelled")
				end)
				close_menu()
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
			x = 5,
			y = 34,
		},
	})
end)

return { desktop = awesomemenu }
