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

-- wifi button
local wifi = require("widgets.vertical_bar.mods.cc.services.wifi")

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
	nil,
	{
		{
			wifi,
			button_creator(
				power_button,
				beautiful.bg_3 .. "B3",
				beautiful.fg_color .. "33",
				dpi(13),
				dpi(13),
				nil,
				nil,
				0,
				beautiful.fg_color .. "33"
			),
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
		},
		layout = wibox.layout.fixed.vertical,
	},
	layout = wibox.layout.align.vertical,
	expand = "none",
})
