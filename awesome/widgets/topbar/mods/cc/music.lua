-- minimal music widget
-- ~~~~~~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local button_creator = require("helpers.widget.create_button")

-- widgets
-- ~~~~~~~

-- Song info
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- album art
local album_art = wibox.widget({
	widget = wibox.widget.imagebox,
	clip_shape = helpers.rrect(beautiful.rounded - 3),
	forced_height = dpi(75),
	forced_width = dpi(75),
	image = beautiful.album_art_fallback,
	border_color = beautiful.fg_color .. "33",
	border_width = dpi(1),
})

-- song artist
local song_artist = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("Unknown", beautiful.fg_color),
	font = beautiful.font_var .. "10",
	align = "left",
	valign = "center",
})

-- song name
local song_name = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("None", beautiful.fg_color),
	font = beautiful.font_var .. "Bold 11",
	align = "left",
	valign = "center",
})

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EOF Song info

-- buttons
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- toggle button
local toggle_button = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color),
	font = beautiful.icon_var .. "16",
	align = "right",
	valign = "center",
})

-- next button
local next_button = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color),
	font = beautiful.icon_var .. "14",
	align = "right",
	valign = "center",
})

-- prev button
local prev_button = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color),
	font = beautiful.icon_var .. "14",
	align = "right",
	valign = "center",
})

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EOF buttons

-- update widgets
-- ~~~~~~~~~~~~~~

local playerctl = require("modules.bling").signal.playerctl.lib()

local toggle_command = function()
	playerctl:play_pause()
end
local prev_command = function()
	playerctl:previous()
end
local next_command = function()
	playerctl:next()
end

toggle_button:buttons(gears.table.join(awful.button({}, 1, function()
	toggle_command()
end)))

next_button:buttons(gears.table.join(awful.button({}, 1, function()
	next_command()
end)))

prev_button:buttons(gears.table.join(awful.button({}, 1, function()
	prev_command()
end)))

playerctl:connect_signal("metadata", function(_, title, artist, album_path, __, ___, ____)
	if title == "" then
		title = "None"
	end
	if artist == "" then
		artist = "Unknown"
	end
	if album_path == "" then
		album_path = beautiful.album_art_fallback
	end

	album_art:set_image(gears.surface.load_uncached(album_path))
	song_name:set_markup_silently(helpers.colorize_text(title, beautiful.fg_color))
	song_artist:set_markup_silently(helpers.colorize_text("~" .. artist, beautiful.fg_color))
end)

playerctl:connect_signal("playback_status", function(_, playing, __)
	if playing then
		toggle_button.markup = helpers.colorize_text("", beautiful.fg_color)
	else
		toggle_button.markup = helpers.colorize_text("", beautiful.fg_color)
	end
end)

-- ~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~
return wibox.widget({
	{
		{
			album_art,
			{
				{
					nil,
					{
						{
							step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
							widget = wibox.container.scroll.horizontal,
							forced_width = dpi(150),
							speed = 30,
							song_name,
						},
						{
							step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
							widget = wibox.container.scroll.horizontal,
							forced_width = dpi(150),
							speed = 30,
							song_artist,
						},
						spacing = dpi(5),
						layout = wibox.layout.fixed.vertical,
					},
					layout = wibox.layout.align.vertical,
					expand = "none",
				},
				{
					{
						button_creator(prev_button, beautiful.black .. "00", nil, dpi(4), nil, nil, dpi(0)),
						button_creator(toggle_button, beautiful.black .. "00", nil, dpi(4), nil, nil, dpi(0)),
						button_creator(next_button, beautiful.black .. "00", nil, dpi(4), nil, nil, dpi(0)),
						layout = wibox.layout.fixed.horizontal,
						spacing = dpi(0),
					},
					margins = { top = dpi(23), bottom = dpi(23) },
					widget = wibox.container.margin,
				},
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(10),
			},
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
		},
		margins = dpi(12),
		widget = wibox.container.margin,
	},
	widget = wibox.container.background,
	bg = beautiful.bg_3,
	border_color = beautiful.fg_color .. "33",
	shape = helpers.rrect(beautiful.rounded),
})
-- ~~~~~~~~~~~~~~~~~~
