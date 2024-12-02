-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local button_creator = require("helpers.widget.create_button")
local wibox = require("wibox")

-- widgets
-- ~~~~~~~

-- progressbar
local brightness = wibox.widget({
	widget = wibox.widget.slider,
	maximum = 20,
	forced_width = dpi(260),
	shape = gears.shape.rounded_bar,
	bar_shape = gears.shape.rounded_bar,
	bar_color = beautiful.fg_2 .. "26",
	bar_margins = { bottom = dpi(7), top = dpi(7) },
	bar_active_color = beautiful.fg_color,
	handle_width = dpi(27),
	handle_shape = gears.shape.circle,
	handle_color = beautiful.fg_2,
	handle_border_width = 1,
	handle_border_color = beautiful.fg_color,
})

local brightness_bg = wibox.widget({
	nil,
	{
		{
			forced_width = dpi(270),
			bg = beautiful.fg_color .. "26",
			shape = gears.shape.rounded_bar,
			widget = wibox.container.background,
		},
		margins = dpi(19),
		widget = wibox.container.margin,
	},
	layout = wibox.layout.align.horizontal,
	expand = "none",
})

local brightness_icon = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color),
	font = beautiful.icon_var .. "17",
	align = "center",
	valign = "center",
})

local brightness_button = wibox.widget({
	button_creator(brightness_icon, beautiful.black .. "00", beautiful.black .. "00", dpi(6), nil, nil, dpi(4)),
	widget = wibox.container.background,
})

local brightness_text = awful.tooltip({
	objects = { brightness },
	align = "top",
	margins = dpi(6),
	gaps = { bottom = dpi(12) },
	shape = helpers.rrect(3),
})

local bright_init = wibox.widget({
	brightness_button,
	{
		{
			brightness,
			widget = wibox.container.margin,
		},
		layout = wibox.layout.stack,
	},
	layout = wibox.layout.fixed.horizontal,
	forced_height = dpi(42),
	spacing = dpi(17),
})

awful.spawn.easy_async_with_shell(
	"brightnessctl | grep -i  'current' | awk '{ print $4}' | tr -d \"(%)\"",
	function(stdout)
		local value = string.gsub(stdout, "^%s*(.-)%s*$", "%1")
		brightness.value = tonumber(value / 5)
		brightness_text.markup = helpers.colorize_text(value .. "%", beautiful.fg_color)
	end
)

brightness:connect_signal("property::value", function(_, new_value)
	brightness_text.markup = helpers.colorize_text((new_value * 5) .. "%", beautiful.fg_color)
	brightness.value = new_value
	awful.spawn("brightnessctl set " .. (new_value * 5) .. "%", false)
end)

-- volume
local volume = wibox.widget({
	widget = wibox.widget.slider,
	maximum = 20,
	forced_width = dpi(260),
	shape = gears.shape.rounded_bar,
	bar_shape = gears.shape.rounded_bar,
	bar_color = beautiful.fg_2 .. "26",
	bar_margins = { bottom = dpi(7), top = dpi(7) },
	bar_active_color = beautiful.fg_color,
	handle_width = dpi(27),
	handle_shape = gears.shape.circle,
	handle_color = beautiful.fg_2,
	handle_border_width = 1,
	handle_border_color = beautiful.fg_color,
})

-- local volume_bg = wibox.widget({
-- 	nil,
-- 	{
-- 		{
-- 			forced_width = dpi(270),
-- 			bg = beautiful.fg_color .. "26",
-- 			shape = gears.shape.rounded_bar,
-- 			widget = wibox.container.background,
-- 		},
-- 		margins = dpi(19),
-- 		widget = wibox.container.margin,
-- 	},
-- 	layout = wibox.layout.align.horizontal,
-- 	expand = "none",
-- })

local volume_icon = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color),
	font = beautiful.icon_var .. "17",
	align = "center",
	valign = "center",
})

local volume_button = wibox.widget({
	button_creator(volume_icon, beautiful.bg_2 .. "00", nil, dpi(6), nil, nil, dpi(4)),
	widget = wibox.container.background,
})

local volume_text = awful.tooltip({
	objects = { volume },
	align = "top",
	margins = dpi(6),
	gaps = { bottom = dpi(12) },
	shape = helpers.rrect(3),
})

local volume_init = wibox.widget({
	volume_button,
	{
		{
			volume,
			widget = wibox.container.margin,
		},
		layout = wibox.layout.stack,
	},
	layout = wibox.layout.fixed.horizontal,
	forced_height = dpi(42),
	spacing = dpi(17),
})

awful.spawn.easy_async_with_shell(
	"amixer -D pulse get Master | tail -n 1 | awk '{print $5}' | tr -d '[%]'",
	function(stdout)
		local value = string.gsub(stdout, "^%s*(.-)%s*$", "%1")
		volume.value = tonumber(value / 5)
		volume_text.markup = helpers.colorize_text(value .. "%", beautiful.fg_color)
	end
)

volume_button:buttons({
	gears.table.join(awful.button({}, 1, function()
		awful.spawn("amixer -D pulse set Master 1+ toggle", false)
	end)),
})

awesome.connect_signal("signal::volume", function(value, muted)
	if muted or value == 0 then
		volume.bar_active_color = beautiful.fg_3
		volume.handle_border_color = beautiful.fg_3
		volume_icon.markup = "<span foreground='" .. beautiful.fg_3 .. "'></span>"
	else
		volume.bar_active_color = beautiful.fg_color
		volume.handle_border_color = beautiful.fg_color
		volume_icon.markup = "<span foreground='" .. beautiful.fg_color .. "'></span>"
	end
end)

volume:connect_signal("property::value", function(_, new_value)
	volume_text.markup = helpers.colorize_text((new_value * 5) .. "%", beautiful.fg_color)
	volume.value = new_value
	awful.spawn("amixer -D pulse set Master " .. (new_value * 5) .. "%", false)
end)

return wibox.widget({
	{
		{
			{
				{
					markup = helpers.colorize_text("Display", beautiful.fg_color),
					font = beautiful.font_var .. "Medium 12",
					widget = wibox.widget.textbox,
				},
				bright_init,
				spacing = dpi(10),
				layout = wibox.layout.fixed.vertical,
			},
			margins = { top = dpi(12), bottom = dpi(12), left = dpi(18), right = dpi(12) },
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
		bg = beautiful.bg_2 .. "CC",
		border_width = dpi(1),
		border_color = beautiful.border_color .. "CC",
		shape = helpers.rrect(beautiful.rounded),
	},
	{
		{
			{
				{
					markup = helpers.colorize_text("Audio", beautiful.fg_color),
					font = beautiful.font_var .. "Medium 12",
					widget = wibox.widget.textbox,
				},
				volume_init,
				spacing = dpi(10),
				layout = wibox.layout.fixed.vertical,
			},
			margins = { top = dpi(12), bottom = dpi(12), left = dpi(18), right = dpi(12) },
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
		bg = beautiful.bg_2 .. "CC",
		border_width = dpi(1),
		border_color = beautiful.border_color .. "CC",
		shape = helpers.rrect(beautiful.rounded),
	},
	spacing = dpi(15),
	layout = wibox.layout.fixed.vertical,
})
