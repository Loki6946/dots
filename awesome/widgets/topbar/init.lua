-- A minimal macOS-inspired topbar for AwesomeWM
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Requirements
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local create_button = require("helpers.widget.create_button")

-- Load additional modules
require("widgets.topbar.mods.cc")
require("widgets.topbar.mods.awesomemenu")

awful.screen.connect_for_each_screen(function(s)
	local screen_width = s.geometry.width

	-- Widgets
	s.lock = require("widgets.lock")(s)
	s.exit = require("widgets.exit")(s)
	local taglist = require("widgets.topbar.mods.taglist")(s)

	-- Helper function for creating icons
	local function create_icon(image, size)
		return wibox.widget({
			{
				widget = wibox.widget.imagebox,
				image = gears.color.recolor_image(image, beautiful.fg_color),
				forced_height = size,
				forced_width = size,
				resize = true,
			},
			align = "center",
			widget = wibox.container.place,
		})
	end

	-- Launcher Button
	local launcher = create_button(
		create_icon(beautiful.search_icon, 14),
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
	launcher:buttons(gears.table.join(awful.button({}, 1, function()
		awful.spawn.with_shell(require("config.apps").app_launcher, false)
	end)))

	-- Awesome Menu Button
	local awesomemenu = create_button(
		create_icon(beautiful.awm_icon, 15),
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
	awesomemenu:buttons(gears.table.join(awful.button({}, 1, function()
		awesome.emit_signal("toggle::awesomemenu")
	end)))

	-- WiFi Indicator
	local wifi_icon = wibox.widget({
		id = "wifi_icon",
		markup = helpers.colorize_text("", beautiful.fg_color),
		font = beautiful.icon_var .. "11",
		align = "center",
		widget = wibox.widget.textbox,
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

	-- Function to toggle WiFi
	local function toggle_wifi()
		awful.spawn.easy_async_with_shell("nmcli radio wifi", function(stdout)
			local status = stdout:gsub("%s+", "") -- Remove spaces/newlines
			if status == "enabled" then
				awful.spawn("nmcli radio wifi off", false)
				naughty.notify({
					app_name = "Nmcli",
					title = "WiFi Disabled",
					text = "Wireless connectivity has been turned off.",
					icon = beautiful.warning_icon,
					timeout = 3,
				})
			else
				awful.spawn("nmcli radio wifi on", false)
				naughty.notify({
					app_name = "Nmcli",
					title = "WiFi Enabled",
					text = "Wireless connectivity is now active.",
					icon = beautiful.warning_icon,
					timeout = 3,
				})
			end
		end)
	end

	-- Add click event to WiFi widget
	wifi:buttons(gears.table.join(awful.button({}, 1, function()
		toggle_wifi()
	end)))

	-- Control Center Button
	local cc_ic = create_button(
		create_icon(beautiful.control_center_icon, 13),
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
	cc_ic:buttons(gears.table.join(awful.button({}, 1, function()
		cc_toggle(s)
	end)))

	-- Layout Box
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
	layout:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end)
	))

	-- Battery Widget
	local battery = wibox.widget({
		{
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
					top = dpi(12),
					bottom = dpi(12),
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
		},
		widget = wibox.container.margin,
		left = dpi(10),
		right = dpi(10),
	})
	local battery_t = awful.tooltip({
		objects = { battery },
		mode = "outside",
		align = "top",
		preferred_alignments = "middle",
		margins = { top = dpi(4), bottom = dpi(4), left = dpi(12), right = dpi(12) },
		gaps = { bottom = dpi(8) },
		shape = helpers.rrect(3),
		bg = beautiful.bg_color .. "99",
	})

	-- Clock Widget
	local clock = wibox.widget({
		{
			{
				widget = wibox.widget.textclock,
				format = helpers.colorize_text("%a %d %b", beautiful.fg_color),
				font = beautiful.font_var .. "Medium 10",
			},
			{
				widget = wibox.widget.textclock,
				format = helpers.colorize_text("%H:%M", beautiful.fg_color),
				font = beautiful.font_var .. "Medium 10",
			},
			spacing = dpi(10),
			layout = wibox.layout.fixed.horizontal,
		},
		bottom = dpi(1),
		widget = wibox.container.margin,
	})

	local clock_widget = create_button(
		clock,
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

	clock_widget:buttons(gears.table.join(awful.button({}, 1, function()
		awesome.emit_signal("widget::toggle")
	end)))

	-- Update Widgets on Signals
	awesome.connect_signal("signal::battery", function(value, state)
		helpers.gc(battery, "prog").value = value
		battery_t.markup = tostring(value) .. "%"
		helpers.gc(battery, "status").visible = state == 1
	end)

	awesome.connect_signal("signal::wifi", function(value)
		wifi_icon.markup =
			helpers.colorize_text(value and "" or "", value and beautiful.fg_color or beautiful.fg_color .. "99")
	end)

	-- Wibar (Top Bar)
	s.wibar_wid = awful.wibar({
		screen = s,
		visible = true,
		ontop = false,
		type = "dock",
		width = screen_width,
		height = dpi(34),
		bg = beautiful.topbar_background,
	})

	-- Wibar Placement
	awful.placement.top(s.wibar_wid)

	-- Wibar Layout
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
				battery,
				wifi,
				launcher,
				cc_ic,
				layout,
				clock_widget,
				spacing = dpi(0),
				layout = wibox.layout.fixed.horizontal,
			},
			right = 10,
			widget = wibox.container.margin,
		},
		layout = wibox.layout.align.horizontal,
	})
end)
