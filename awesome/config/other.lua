local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")
local helpers = require("helpers")

require("config.tags")

-- wallpaper
-- ~~~~~~~~~
screen.connect_signal("request::wallpaper", function(s)
	awful.wallpaper({
		screen = s,
		widget = {
			image = beautiful.wallpaper,
			widget = wibox.widget.imagebox,
			upscale = true,
			downscale = true,
			horizontal_fit_policy = "fit",
			vertical_fit_policy = "fit",
		},
	})
end)

-- Error ding
-- ~~~~~~~~~~
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		app_name = "AwesomeWM",
		urgency = "critical",
		title = "bruh! an error has occured " .. (startup and " during startup" or "!"),
		message = message,
	})
end)

-- window stuff
-- ~~~~~~~~~~~~

-- autofucs on tag change
require("awful.autofocus")

-- remember floating window pos
require("modules.savefloats")

-- better resizing
require("modules.better-resize")

-- sloppy focus
client.connect_signal("mouse::enter", function(c)
	c:activate({ context = "mouse_enter", raise = false })
end)

-- Hide all windows when a splash is shown
awesome.connect_signal("widgets::splash::visibility", function(vis)
	local t = screen.primary.selected_tag
	if vis then
		for idx, c in ipairs(t:clients()) do
			c.hidden = true
		end
	else
		for idx, c in ipairs(t:clients()) do
			c.hidden = false
		end
	end
end)

-- round windows
-- ~~~~~~~~~~~~~
local function enable_rounding()
	if beautiful.rounded and beautiful.rounded > 0 then
		client.connect_signal("manage", function(c, startup)
			if not c.fullscreen and not c.maximized then
				c.shape = helpers.rrect(beautiful.rounded)
			end
		end)

		local function no_round_corners(c)
			if c.fullscreen then
				c.shape = nil
			elseif c.maximized then
				c.shape = helpers.prrect(false, false, false, false, beautiful.rounded)
			else
				c.shape = helpers.rrect(beautiful.rounded)
			end
		end

		client.connect_signal("property::fullscreen", no_round_corners)
		client.connect_signal("property::maximized", no_round_corners)

		beautiful.snap_shape = helpers.rrect(beautiful.rounded)
	else
		beautiful.snap_shape = gears.shape.rectangle
	end
end

enable_rounding()

-- Garbage Collection
-- ~~~~~~~~~~~~~~~~~~
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
