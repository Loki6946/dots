local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local bling = require("modules.bling")
local helpers = require("helpers")

client.connect_signal("request::titlebars", function(c)
	awful
		.titlebar(c, {
			position = "bottom",
			size = dpi(2),
			bg = "#00000000",
		})
		:setup({
			bg = beautiful.bg_color,
			shape = helpers.prrect(false, false, true, true, beautiful.border_radius),
			widget = wibox.container.background,
		})
end)
