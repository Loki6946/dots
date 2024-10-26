-- profile widget
-- ~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

-- widgets
-- ~~~~~~~

-- image
local profile_image = wibox.widget({
	{
		image = beautiful.pp,
		clip_shape = gears.shape.circle,
		widget = wibox.widget.imagebox,
	},
	widget = wibox.container.background,
	shape = gears.shape.circle,
	border_color = beautiful.fg_color,
})

-- username
local username = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("Loki", beautiful.fg_color),
	font = beautiful.font_var .. "Medium 12",
	align = "left",
	valign = "center",
})

-- description/host
local desc = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("@Awesome", beautiful.fg_color .. "99"),
	font = beautiful.font_var .. "11",
	align = "left",
	valign = "center",
})

-- return
return wibox.widget({
	{
		{
			profile_image,
			{
				nil,
				username,
				layout = wibox.layout.align.vertical,
				expand = "none",
			},
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
		},
		margins = dpi(6),
		widget = wibox.container.margin,
	},
	forced_height = dpi(40),
	forced_width = dpi(250),
	shape = helpers.rrect(beautiful.rounded),
	bg = beautiful.bg_3,
	widget = wibox.container.background,
})
