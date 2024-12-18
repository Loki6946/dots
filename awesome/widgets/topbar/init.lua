-- a minimal bar
-- ~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi
local create_button = require("helpers.widget.create_button")

-- misc/vars
-- ~~~~~~~~~
require("widgets.topbar.mods.cc")

awful.screen.connect_for_each_screen(function(s)
	local screen_width = s.geometry.width

	-- widgets
	-- ~~~~~~~
	s.calendar = require("widgets.topbar.mods.widget.calendar")(s)
	s.clock = require("widgets.topbar.mods.widget.clock")(s)

	local taglist = require("widgets.topbar.mods.taglist")(s)

	-- launcher {{
	local launcher_icon = wibox.widget({
		{
			widget = wibox.widget.imagebox,
			image = gears.color.recolor_image(beautiful.awm_icon, beautiful.fg_color),
			forced_height = 16,
			forced_width = 16,
			resize = true,
		},
		align = "center",
		widget = wibox.container.place,
	})

	local launcher = wibox.widget({
		create_button(
			launcher_icon,
			beautiful.black .. "00",
			beautiful.fg_color .. "80",
			dpi(10),
			nil,
			nil,
			nil,
			nil,
			nil,
			helpers.rrect(4),
			false
		),
		widget = wibox.container.background,
	})

	launcher:buttons(gears.table.join({
		awful.button({}, 1, function()
			awful.spawn.with_shell(require("config.apps").app_launcher, false)
		end),
	}))
	-- }}

	-- wifi
	local wifi = wibox.widget({
		{
			id = "wifi_icon",
			markup = helpers.colorize_text("", beautiful.fg_color),
			font = beautiful.icon_var .. "11",
			valign = "center",
			align = "center",
			widget = wibox.widget.textbox,
		},
		bottom = dpi(2),
		widget = wibox.container.margin,
	})

	-- cc
	local cc_ic_icon = wibox.widget({
		image = gears.color.recolor_image(beautiful.control_center_icon, beautiful.fg_color),
		resize = true,
		valign = "center",
		widget = wibox.widget.imagebox,
	})

	local cc_ic = wibox.widget({
		create_button(
			cc_ic_icon,
			beautiful.black .. "00",
			beautiful.fg_color .. "80",
			dpi(8),
			dpi(7),
			nil,
			nil,
			nil,
			nil,
			helpers.rrect(4)
		),
		widget = wibox.container.background,
	})

	-- layout
	local layout = awful.widget.layoutbox({
		buttons = {
			awful.button({
				modifiers = {},
				button = 1,
				on_press = function()
					awful.layout.inc(1)
				end,
			}),
			awful.button({
				modifiers = {},
				button = 3,
				on_press = function()
					awful.layout.inc(-1)
				end,
			}),
		},
	})

	--------------------
	-- battery widget
	local battery = wibox.widget({
		{
			{
				{
					max_value = 100,
					value = 69,
					id = "prog",
					forced_width = 18,
					paddings = 1,
					border_color = beautiful.fg_color .. "99",
					background_color = beautiful.bg_color .. "00",
					color = beautiful.fg_color,
					bar_shape = helpers.rrect(1),
					border_width = 1,
					shape = helpers.rrect(2),
					widget = wibox.widget.progressbar,
				},
				widget = wibox.container.margin,
				top = 0,
				bottom = 0,
			},
			{
				{
					bg = beautiful.fg_color .. "99",
					forced_height = 5,
					forced_width = 2,
					shape = helpers.rrect(beautiful.rounded),
					widget = wibox.container.background,
				},
				widget = wibox.container.place,
			},
			spacing = 2,
			layout = wibox.layout.fixed.horizontal,
		},
		{
			{
				id = "status",
				markup = helpers.colorize_text("", beautiful.black),
				font = beautiful.icon_var .. "8",
				valign = "center",
				align = "center",
				widget = wibox.widget.textbox,
			},
			widget = wibox.container.margin,
			top = 0,
			bottom = 0,
			right = 3,
		},
		layout = wibox.layout.stack,
	})

	local battery_t = awful.tooltip({
		objects = { battery },
		mode = "outside",
		align = "top",
		margins = dpi(6),
		shape = helpers.rrect(3),
	})
	-- Eo battery
	-----------------------------------------------------

	cc_ic:buttons({
		gears.table.join(awful.button({}, 1, function()
			cc_toggle(s)
		end)),
	})

	-- clock
	---------------------------
	local clock = wibox.widget({
		{
			{
				widget = wibox.widget.textclock,
				format = helpers.colorize_text("%a %b %d", beautiful.fg_color),
				font = beautiful.font_var .. "Medium 10",
				valign = "center",
				align = "center",
			},
			{
				widget = wibox.widget.textclock,
				format = helpers.colorize_text("%H : %M", beautiful.fg_color),
				font = beautiful.font_var .. "Medium 10",
				valign = "center",
				align = "center",
			},
			spacing = dpi(10),
			layout = wibox.layout.fixed.horizontal,
		},
		bottom = dpi(1),
		widget = wibox.container.margin,
	})
	-- Eo clock
	------------------------------------------

	-- update widgets accordingly
	-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
	awesome.connect_signal("signal::battery", function(value, state)
		helpers.gc(battery, "prog").value = value
		battery_t.markup = helpers.colorize_text(tostring(value) .. "%", beautiful.fg_color)

		if state == 1 then
			helpers.gc(battery, "status").visible = true
		else
			helpers.gc(battery, "status").visible = false
		end

		if value < 50 then
			helpers.gc(battery, "status").markup = helpers.colorize_text("", beautiful.fg_color)
		else
			helpers.gc(battery, "status").markup = helpers.colorize_text("", beautiful.black)
		end
	end)

	awesome.connect_signal("signal::wifi", function(value)
		if value then
			helpers.gc(wifi, "wifi_icon").markup = helpers.colorize_text("", beautiful.fg_color)
			wifi:buttons(gears.table.join(awful.button({}, 1, function()
				awful.spawn("nmcli radio wifi off", false)
			end)))
		else
			helpers.gc(wifi, "wifi_icon").markup = helpers.colorize_text("", beautiful.fg_color .. "99")
			wifi:buttons(gears.table.join(awful.button({}, 1, function()
				awful.spawn("nmcli radio wifi on", false)
			end)))
		end
	end)

	-- wibar
	s.wibar_wid = awful.wibar({
		screen = s,
		visible = true,
		ontop = false,
		type = "dock",
		width = screen_width,
		height = dpi(28),
		bg = beautiful.topbar_background,
	})

	-- wibar placement
	awful.placement.top(s.wibar_wid)

	-- bar setup
	s.wibar_wid:setup({
		{
			{
				launcher,
				taglist,
				spacing = dpi(3),
				layout = wibox.layout.fixed.horizontal,
			},
			left = 10,
			widget = wibox.container.margin,
		},
		nil,
		{
			{
				{
					battery,
					left = dpi(8),
					right = dpi(8),
					top = dpi(9),
					bottom = dpi(9),
					widget = wibox.container.margin,
				},
				create_button(
					wifi,
					beautiful.black .. "00",
					beautiful.fg_color .. "80",
					dpi(8),
					dpi(6),
					nil,
					nil,
					nil,
					nil,
					helpers.rrect(4),
					false
				),
				cc_ic,
				create_button(
					layout,
					beautiful.black .. "00",
					beautiful.fg_color .. "80",
					dpi(8),
					dpi(8),
					nil,
					nil,
					nil,
					nil,
					helpers.rrect(4),
					false
				),
				{
					clock,
					left = dpi(8),
					right = dpi(8),
					top = dpi(6),
					bottom = dpi(6),
					widget = wibox.container.margin,
				},
				spacing = dpi(2),
				layout = wibox.layout.fixed.horizontal,
			},
			right = 10,
			widget = wibox.container.margin,
		},
		layout = wibox.layout.align.horizontal,
	})
end)
