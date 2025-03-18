-- Requirements
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local button_creator = require("helpers.widget.create_button")
local wibox = require("wibox")

-- Function to create sliders
local function create_slider(icon, max_value, command, signal_name, type, button_command, button_hover)
	local slider = wibox.widget({
		widget = wibox.widget.slider,
		maximum = max_value,
		forced_width = dpi(250),
		shape = gears.shape.rounded_bar,
		bar_shape = gears.shape.rounded_bar,
		bar_color = beautiful.fg_2 .. "33",
		bar_margins = { bottom = dpi(4), top = dpi(4) },
		bar_active_color = beautiful.fg_color,
		handle_width = dpi(32),
		handle_shape = gears.shape.circle,
		handle_color = beautiful.fg_2,
		handle_border_width = 2,
		handle_border_color = beautiful.fg_color,
	})

	local icon_widget = wibox.widget({
		widget = wibox.widget.textbox,
		markup = helpers.colorize_text(icon, beautiful.fg_color),
		font = beautiful.icon_round .. "17",
		align = "center",
		valign = "center",
	})

	local button = wibox.widget({
		button_creator(
			icon_widget,
			beautiful.black .. "00",
			button_hover or beautiful.black .. "00",
			dpi(6),
			nil,
			nil,
			dpi(4)
		),
		widget = wibox.container.background,
	})

	button:buttons({
		gears.table.join(awful.button({}, 1, function()
			awful.spawn(button_command, false)
		end)),
	})

	local tooltip = awful.tooltip({
		objects = { slider },
		align = "top",
		margins = dpi(6),
		gaps = { bottom = dpi(12) },
		shape = helpers.rrect(3),
	})

	-- Initialize value
	awful.spawn.easy_async_with_shell(command, function(stdout)
		local value = tonumber(stdout:match("%d+")) or 0
		slider.value = value / 5
		tooltip.markup = helpers.colorize_text(value .. "%", beautiful.fg_color)
	end)

	-- Update on change
	slider:connect_signal("property::value", function(_, new_value)
		local percentage = new_value * 5
		tooltip.markup = helpers.colorize_text(percentage .. "%", beautiful.fg_color)
		awful.spawn(signal_name .. " " .. percentage .. "%", false)
	end)

	if type == "volume" then
		awesome.connect_signal("signal::volume", function(value, muted)
			if muted or value == 0 then
				slider.bar_active_color = beautiful.fg_2
				slider.handle_color = beautiful.fg_2
				slider.handle_border_color = beautiful.fg_2
				icon_widget.markup = "<span foreground='" .. beautiful.fg_2 .. "'></span>"
			else
				slider.bar_active_color = beautiful.fg_color
				slider.handle_color = beautiful.fg_2
				slider.handle_border_color = beautiful.fg_color
				icon_widget.markup = "<span foreground='" .. beautiful.fg_color .. "'></span>"
			end
		end)
	end

	return wibox.widget({
		button,
		{ slider, widget = wibox.container.margin },
		layout = wibox.layout.fixed.horizontal,
		forced_height = dpi(42),
		spacing = dpi(10),
	})
end

-- Brightness Control
local brightness_control = create_slider(
	"",
	20,
	"brightnessctl | grep -i 'current' | awk '{ print $4}' | tr -d \"(%)\"",
	"brightnessctl set"
)

-- Volume Control
local volume_control = create_slider(
	"",
	20,
	"amixer -D pulse get Master | tail -n 1 | awk '{print $5}' | tr -d '[%]'",
	"amixer -D pulse set Master",
	"volume",
	"amixer -D pulse set Master 1+ toggle",
	beautiful.fg_color .. "59"
)

-- Layout
return wibox.widget({
	{
		{
			{
				{
					markup = helpers.colorize_text("Display", beautiful.fg_color),
					font = beautiful.font_var .. "Bold 11",
					widget = wibox.widget.textbox,
				},
				brightness_control,
				spacing = dpi(8),
				layout = wibox.layout.fixed.vertical,
			},
			margins = { top = dpi(12), bottom = dpi(12), left = dpi(15), right = dpi(12) },
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
		bg = beautiful.bg_3 .. "D9",
		shape = helpers.rrect(beautiful.rounded),
	},
	{
		{
			{
				{
					markup = helpers.colorize_text("Sound", beautiful.fg_color),
					font = beautiful.font_var .. "Bold 11",
					widget = wibox.widget.textbox,
				},
				volume_control,
				spacing = dpi(8),
				layout = wibox.layout.fixed.vertical,
			},
			margins = { top = dpi(12), bottom = dpi(12), left = dpi(15), right = dpi(12) },
			widget = wibox.container.margin,
		},
		widget = wibox.container.background,
		bg = beautiful.bg_3 .. "D9",
		shape = helpers.rrect(beautiful.rounded),
	},
	spacing = dpi(13),
	layout = wibox.layout.fixed.vertical,
})
