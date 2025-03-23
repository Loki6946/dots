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
local apps = require("config.apps")

-- widgets
-- ~~~~~~~

local setting = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color),
	font = beautiful.icon_outlined .. "14",
	align = "center",
	valign = "center",
})

local setting_button = button_creator(setting, beautiful.black .. "00", beautiful.fg_color, dpi(7), dpi(8), nil, nil)

-- exitscreen button
local power = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color),
	font = beautiful.icon_round .. "14",
	align = "center",
	valign = "center",
})

local power_button = button_creator(power, beautiful.black .. "00", beautiful.fg_color, dpi(7), dpi(8), nil, nil)

-- add function to power_button
-- ~~~~~~~~~~~~~~~~~~~~
setting_button:buttons(gears.table.join(awful.button({}, 1, function()
	gears.timer.start_new(0.15, function()
		awful.spawn.with_shell("cd ~/.config/awesome && " .. apps.editor_cmd .. " ./theme/init.lua")
		if control_c.visible then
			cc_toggle()
		end
	end)
end)))

power_button:buttons(gears.table.join(awful.button({}, 1, function()
	gears.timer.start_new(0.15, function()
		awesome.emit_signal("toggle::exit")
		if control_c.visible then
			cc_toggle()
		end
	end)
end)))

--~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~
return wibox.widget({
	{
		{
			setting_button,
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
			power_button,
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(18),
		},
		top = dpi(4),
		bottom = dpi(4),
		left = dpi(8),
		right = dpi(6),
		widget = wibox.container.margin,
	},
	bg = beautiful.bg_3 .. "D9",
	forced_height = dpi(40),
	forced_width = dpi(100),
	shape = helpers.rrect(beautiful.rounded),
	widget = wibox.container.background,
})
