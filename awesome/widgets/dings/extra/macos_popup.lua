-- popup notif --
-- ~~~~~~~~~~~ --

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

-- widgets themselves
-- ~~~~~~~~~~~~~~~~~~

-- icon
local icon = wibox.widget({
	font = beautiful.icon_var .. "60",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

-- progress bar
local bar = wibox.widget({
	bar_color = beautiful.fg_color .. "33",
	handle_width = dpi(0),
	bar_active_color = beautiful.fg_color,
	bar_height = dpi(6),
	bar_width = dpi(7),
	value = 25,
	minimum = 0,
	maximum = 100,
	widget = wibox.widget.slider,
})

-- actual popup
local pop = wibox({
	type = "popup",
	screen = screen.primary,
	height = dpi(180),
	width = dpi(185),
	shape = helpers.rrect(beautiful.rounded),
	bg = beautiful.bg_3 .. "CC",
	border_width = dpi(1),
	border_color = beautiful.border_accent,
	halign = "center",
	valign = "center",
	ontop = true,
	visible = false,
})

-- placement
awful.placement.centered(pop, { margins = { top = dpi(200) } })

-- tuemout
local timeout = gears.timer({
	autostart = true,
	timeout = 2.4,
	single_shot = true,
	callback = function()
		pop.visible = false
	end,
})

local function toggle_pop()
	if pop.visible then
		timeout:again()
	else
		pop.visible = true
		timeout:start()
	end
end

pop:setup({
	{
		icon,
		margins = { top = dpi(40), right = dpi(8) },
		widget = wibox.container.margin,
	},
	{
		bar,
		margins = { botom = dpi(14), left = dpi(24), right = dpi(24) },
		layout = wibox.container.margin,
	},
	spacing = dpi(10),
	layout = wibox.layout.fixed.vertical,
})

-- update widgets accordingly
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~

-- volume
local first_V = true
awesome.connect_signal("signal::volume", function(value, muted)
	if first_V or control_c.visible then
		first_V = false
	else
		icon.markup = "<span foreground='" .. beautiful.fg_color .. "'></span>"
		bar.value = value

		if muted or value == 0 then
			bar.bar_active_color = beautiful.fg_color .. "99"
			icon.markup = "<span foreground='" .. beautiful.fg_color .. "99" .. "'></span>"
		else
			bar.bar_active_color = beautiful.fg_color
		end

		toggle_pop()
	end
end)

-- brightness
local first_B = true
awesome.connect_signal("signal::brightness", function(value)
	if first_B or control_c.visible then
		first_B = false
	else
		icon.markup = "<span foreground='" .. beautiful.fg_color .. "'></span>"
		bar.bar_active_color = beautiful.fg_color
		bar.value = value
		toggle_pop()
	end
end)
