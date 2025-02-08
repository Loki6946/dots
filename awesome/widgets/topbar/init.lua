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
require("widgets.topbar.mods.awesomemenu")

awful.screen.connect_for_each_screen(function(s)
	local screen_width = s.geometry.width

	-- widgets
	-- ~~~~~~~
	s.lock = require("widgets.lock")(s)
	s.exit = require("widgets.exit")(s)
	local taglist = require("widgets.topbar.mods.taglist")(s)

	-- launcher {{
	local launcher_icon = wibox.widget({
		{
			widget = wibox.widget.imagebox,
			image = gears.color.recolor_image(beautiful.search_icon, beautiful.fg_color),
			forced_height = 14,
			forced_width = 14,
			valign = "center",
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
			dpi(4),
			nil,
			nil,
			helpers.rrect(4)
		),
		widget = wibox.container.background,
	})

	launcher:buttons(gears.table.join({
		awful.button({}, 1, function()
			awful.spawn.with_shell(require("config.apps").app_launcher, false)
		end),
	}))
	-- }}

	local awesomemenu_icon = wibox.widget({
		{
			widget = wibox.widget.imagebox,
			image = gears.color.recolor_image(beautiful.awm_icon, beautiful.fg_color),
			forced_height = 15,
			forced_width = 15,
			resize = true,
		},
		align = "center",
		widget = wibox.container.place,
	})

	local awesomemenu = wibox.widget({
		create_button(
			awesomemenu_icon,
			beautiful.black .. "00",
			beautiful.fg_color .. "80",
			dpi(10),
			nil,
			nil,
			dpi(4),
			nil,
			nil,
			helpers.rrect(4)
		),
		widget = wibox.container.background,
	})

	awesomemenu:buttons(gears.table.join({
		awful.button({}, 1, function()
			awesome.emit_signal("toggle::awesomemenu")
		end),
	}))

	-- wifi
	local wifi_icon = wibox.widget({
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

	local wifi = create_button(
		wifi_icon,
		beautiful.black .. "00",
		beautiful.fg_color .. "80",
		dpi(10),
		nil,
		nil,
		dpi(4),
		nil,
		nil,
		helpers.rrect(4)
	)

	-- cc
	local cc_ic_icon = wibox.widget({
		image = gears.color.recolor_image(beautiful.control_center_icon, beautiful.fg_color),
		forced_height = 13,
		forced_width = 13,
		resize = true,
		valign = "center",
		widget = wibox.widget.imagebox,
	})

	local cc_ic = wibox.widget({
		create_button(
			cc_ic_icon,
			beautiful.black .. "00",
			beautiful.fg_color .. "80",
			dpi(10),
			nil,
			nil,
			dpi(4),
			nil,
			nil,
			helpers.rrect(4)
		),
		widget = wibox.container.background,
	})

	-- layout
	local layout = create_button(
		awful.widget.layoutbox(),
		beautiful.black .. "00",
		beautiful.fg_color .. "80",
		dpi(10),
		dpi(7),
		nil,
		dpi(4),
		nil,
		nil,
		helpers.rrect(4)
	)

	layout:buttons(gears.table.join({
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
	}))

	--------------------
	-- battery widget
	local battery = wibox.widget({
		{
			{
				id = "status",
				markup = helpers.colorize_text("", beautiful.fg_color),
				font = beautiful.icon_outlined .. "10",
				valign = "center",
				align = "center",
				widget = wibox.widget.textbox,
			},
			widget = wibox.container.margin,
			top = 1,
			bottom = 0,
			right = 0,
		},
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
					shape = helpers.rrect(9999),
					widget = wibox.container.background,
				},
				widget = wibox.container.place,
			},
			spacing = 1,
			layout = wibox.layout.fixed.horizontal,
		},
		spacing = 1,
		layout = wibox.layout.fixed.horizontal,
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
				format = helpers.colorize_text("%a %d %b", beautiful.fg_color),
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
	end)

	awesome.connect_signal("signal::wifi", function(value)
		if value then
			helpers.gc(wifi_icon, "wifi_icon").markup = helpers.colorize_text("", beautiful.fg_color)
			wifi:buttons(gears.table.join(awful.button({}, 1, function()
				awful.spawn("nmcli radio wifi off", false)
			end)))
		else
			helpers.gc(wifi_icon, "wifi_icon").markup = helpers.colorize_text("", beautiful.fg_color .. "99")
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
		height = dpi(34),
		bg = beautiful.topbar_background,
	})

	-- wibar placement
	awful.placement.top(s.wibar_wid)

	-- bar setup
	s.wibar_wid:setup({
		{
			{
				awesomemenu,
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
					left = dpi(10),
					right = dpi(10),
					top = dpi(12),
					bottom = dpi(12),
					widget = wibox.container.margin,
				},
				wifi,
				launcher,
				cc_ic,
				layout,
				{
					clock,
					left = dpi(10),
					right = dpi(10),
					widget = wibox.container.margin,
				},
				spacing = dpi(0),
				layout = wibox.layout.fixed.horizontal,
			},
			right = 10,
			widget = wibox.container.margin,
		},
		layout = wibox.layout.align.horizontal,
	})
end)
