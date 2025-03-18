-- ding - notification
-- ~~~~~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local naughty = require("naughty")
local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local ruled = require("ruled")
local menubar = require("menubar")
local gears = require("gears")

-- extra
require("widgets.dings.extra.music")
require("widgets.dings.extra.macos_popup")

-- configuration
-- ~~~~~~~~~~~~~
--
-- icon
naughty.connect_signal("request::icon", function(n, context, hints)
	if context ~= "app_icon" then
		return
	end

	local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())

	if path then
		n.icon = path
	end
end)

-- naughty config
naughty.config.defaults.ontop = true
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.title = "Ding!"
naughty.config.defaults.position = "top_right"

-- naughty normal preset
naughty.config.presets.normal = {
	font = beautiful.font,
	fg = beautiful.fg_color,
	bg = beautiful.bg_color,
	timeout = 12,
}

-- naughty low preset
naughty.config.presets.low = {
	font = beautiful.font_var .. "10",
	fg = beautiful.fg_color,
	bg = beautiful.bg_color,
	timeout = 12,
}

-- naughty critical preset
naughty.config.presets.critical = {
	font = beautiful.font_var .. "12",
	fg = beautiful.red_color,
	bg = beautiful.red_color,
	timeout = 0,
}

-- apply preset
naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical

-- ruled notification
ruled.notification.connect_signal("request::rules", function()
	ruled.notification.append_rule({
		rule = {},
		properties = { screen = awful.screen.preferred, implicit_timeout = 12 },
	})
end)

-- connect to each display
-- ~~~~~~~~~~~~~~~~~~~~~~~
naughty.connect_signal("request::display", function(n)
	-- action widget
	local action_widget = {
		{
			{
				id = "text_role",
				align = "center",
				valign = "center",
				font = beautiful.font_var .. "10",
				widget = wibox.widget.textbox,
			},
			margins = dpi(5),
			widget = wibox.container.margin,
		},
		bg = beautiful.bg_2,
		shape = helpers.rrect(dpi(8)),
		widget = wibox.container.background,
	}

	-- actions
	local actions = wibox.widget({
		notification = n,
		base_layout = wibox.widget({
			spacing = dpi(15),
			layout = wibox.layout.flex.horizontal,
		}),
		widget_template = action_widget,
		style = { underline_normal = false, underline_selected = true },
		widget = naughty.list.actions,
	})

	helpers.hover_cursor(actions)

	-- image
	local image_n = wibox.widget({
		{
			image = n.icon or beautiful.notification_icon,
			clip_shape = helpers.rrect(4),
			resize = true,
			halign = "center",
			valign = "center",
			widget = wibox.widget.imagebox,
		},
		strategy = "exact",
		height = dpi(20),
		width = dpi(20),
		widget = wibox.container.constraint,
	})

	-- title
	local title_n = wibox.widget({
		markup = n.title,
		font = beautiful.font_var .. "Semibold 11",
		align = "left",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local message_n = wibox.widget({
		markup = helpers.colorize_text("<span weight='normal'>" .. n.message .. "</span>", beautiful.fg_color .. "BF"),
		font = beautiful.font_var .. " 11",
		align = "left",
		valign = "center",
		wrap = "word",
		widget = wibox.widget.textbox,
	})

	-- app name
	local app_name_n = wibox.widget({
		markup = helpers.colorize_text(n.app_name, beautiful.fg_color .. "BF"),
		font = beautiful.font_var .. " 10",
		align = "left",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local time_n = wibox.widget({
		markup = helpers.colorize_text("now", beautiful.fg_color .. "BF"),
		font = beautiful.font_var .. " 10",
		align = "right",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	-- extra info
	local notif_info = wibox.widget({
		{
			image_n,
			app_name_n,
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(5),
		},
		time_n,
		layout = wibox.layout.align.horizontal,
	})

	-- init
	naughty.layout.box({
		notification = n,
		type = "notification",
		bg = beautiful.bg_3 .. "CC",
		shape = helpers.rrect(10),
		minimum_width = dpi(330),
		maximum_width = dpi(330),
		border_width = dpi(1),
		border_color = beautiful.border_accent,
		widget_template = {
			{
				{
					{
						notif_info,
						{
							{
								title_n,
								message_n,
								layout = wibox.layout.fixed.vertical,
								spacing = dpi(3),
							},
							margins = { left = dpi(0) },
							widget = wibox.container.margin,
						},
						layout = wibox.layout.fixed.vertical,
						spacing = dpi(12),
					},
					{
						{ actions, layout = wibox.layout.fixed.vertical },
						margins = { top = dpi(20) },
						visible = n.actions and #n.actions > 0,
						widget = wibox.container.margin,
					},
					layout = wibox.layout.fixed.vertical,
				},
				margins = dpi(13),
				widget = wibox.container.margin,
			},
			widget = wibox.container.background,
			shape = helpers.rrect(beautiful.rounded),
			bg = beautiful.bg_color .. "99",
		},
	})
end)
