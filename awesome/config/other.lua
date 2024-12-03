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
---@diagnostic disable: param-type-mismatch
collectgarbage("setpause", 150)
collectgarbage("setstepmul", 500)

local memory_last_check_count = collectgarbage("count")
local memory_last_run_time = os.time()
local memory_growth_factor = 1.1
local memory_long_collection_time = 600

require("gears.timer").start_new(15, function()
	local cur_memory = collectgarbage("count")
	local elapsed = os.time() - memory_last_run_time
	local waited_long = elapsed >= memory_long_collection_time
	local grew_enough = cur_memory > memory_last_check_count * memory_growth_factor
	if grew_enough or waited_long then
		collectgarbage("collect")
		collectgarbage("collect")
		memory_last_run_time = os.time()
	end
	memory_last_check_count = math.max(memory_last_check_count, collectgarbage("count"))
	return true
end)
