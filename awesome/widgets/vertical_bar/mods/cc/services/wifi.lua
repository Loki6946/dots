-- wifi button/widget
-- ~~~~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local rubato = require("modules.rubato")

-- misc/vars
-- ~~~~~~~~~

local service_icon = ""

-- widgets
-- ~~~~~~~

-- icon
local icon = wibox.widget({
	font = beautiful.icon_var .. "14",
	markup = helpers.colorize_text(service_icon, beautiful.fg_color),
	widget = wibox.widget.textbox,
	valign = "center",
	align = "center",
})

-- animation :love:
local circle_animate = wibox.widget({
	widget = wibox.container.background,
	shape = helpers.rrect(9999),
	bg = beautiful.accent,
})

-- mix those
local alright = wibox.widget({
	{
		circle_animate,
		{
			icon,
			margins = dpi(13),
			widget = wibox.container.margin,
		},
		layout = wibox.layout.stack,
	},
	widget = wibox.container.background,
	shape = helpers.rrect(9999),
	bg = beautiful.bg_3 .. "B3",
})

local animation_button_opacity = rubato.timed({
	pos = 0,
	rate = 60,
	intro = 0.08,
	duration = 0.3,
	awestore_compat = true,
	subscribed = function(pos)
		circle_animate.opacity = pos
	end,
})

local function update_everything(value)
	if value then
		icon.markup = helpers.colorize_text(service_icon, beautiful.bg_color)
		animation_button_opacity:set(1)
	else
		icon.markup = helpers.colorize_text(service_icon, beautiful.fg_color)
		animation_button_opacity:set(0)
	end
end

awesome.connect_signal("signal::wifi", function(value)
	if value then
		update_everything(true)

		alright:buttons(gears.table.join(awful.button({}, 1, function()
			awful.spawn("nmcli radio wifi off", false)
			update_everything(false)
		end)))
	else
		update_everything(false)
		alright:buttons(gears.table.join(awful.button({}, 1, function()
			awful.spawn("nmcli radio wifi on", false)
			update_everything(true)
		end)))
	end
end)

helpers.hover_cursor(alright)

return alright
