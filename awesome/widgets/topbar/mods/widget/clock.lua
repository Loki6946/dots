local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

return function(s)
	local clock = wibox({
		screen = s,
		width = 290,
		height = 140,
		bg = beautiful.bg_color .. "CC",
		border_width = 1,
		border_color = beautiful.border_accent,
		shape = helpers.rrect(beautiful.rounded + 5),
		ontop = false,
		visible = false,
	})

	clock:setup({
		widget = wibox.widget.textclock,
		format = "%H:%M",
		font = beautiful.font_var .. "Heavy 60",
		valign = "center",
		align = "center",
	})
	helpers.place_widget(clock, "top_left", 175, 0, beautiful.useless_gap * 2, 0)
	helpers.popup_opacity(clock, 0.3)

	awesome.connect_signal("widget::hide", function()
		clock.visible = not clock.visible
	end)

	return clock
end
