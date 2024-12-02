-- session buttons
-- ~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local button_creator = require("helpers.widget.create_button")

-- widgets
-- ~~~~~~~

local widget_button = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color),
	font = beautiful.icon_outlined .. "14",
	align = "center",
	valign = "center",
})

-- exitscreen button
local power_button = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color),
	font = beautiful.icon_var .. "14",
	align = "center",
	valign = "center",
})

-- add function to power_button
-- ~~~~~~~~~~~~~~~~~~~~
widget_button:buttons(gears.table.join(awful.button({}, 1, function()
	awesome.emit_signal("widget::hide")
end)))

power_button:buttons(gears.table.join(awful.button({}, 1, function()
	if control_c.visible then
		cc_toggle()
	end
	require("modules.exit-screen")
	awesome.emit_signal("module::exit_screen:show")
end)))

--~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~
return wibox.widget({
	{
		{
			button_creator(
				widget_button,
				beautiful.black .. "00",
				nil,
				dpi(7),
				dpi(8),
				nil,
				nil,
				0,
				beautiful.fg_color .. "33"
			),
			spacing_widget = wibox.widget({
				{
					widget = wibox.widget.separator,
					orientation = "vertical",
					color = beautiful.border_accent,
					thickness = 2,
				},
				widget = wibox.container.margin,
				margins = { top = dpi(5), bottom = dpi(5) },
			}),
			button_creator(
				power_button,
				beautiful.black .. "00",
				nil,
				dpi(7),
				dpi(8),
				nil,
				nil,
				0,
				beautiful.fg_color .. "33"
			),
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(18),
		},
		top = dpi(4),
		bottom = dpi(4),
		left = dpi(8),
		right = dpi(6),
		widget = wibox.container.margin,
	},
	bg = beautiful.bg_2 .. "CC",
	border_width = dpi(1),
	border_color = beautiful.border_color .. "CC",
	forced_height = dpi(40),
	forced_width = dpi(100),
	shape = helpers.rrect(beautiful.rounded),
	widget = wibox.container.background,
})
