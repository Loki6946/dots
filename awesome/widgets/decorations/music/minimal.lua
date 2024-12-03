-- titlebar decorations for ncmpcpp
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local helpers = require("helpers")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local ruled = require("ruled")
local dpi = beautiful.xresources.apply_dpi
local button_creator = require("helpers.widget.create_button")

-- widgets
-- ~~~~~~~

-- album art
local album_art = wibox.widget({
	widget = wibox.widget.imagebox,
	clip_shape = helpers.rrect(beautiful.rounded * 2),
	forced_height = dpi(240),
	forced_width = dpi(240),
	halign = "center",
	valign = "center",
	image = beautiful.album_art_fallback,
})

-- song artist
local song_artist = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("Unknown", beautiful.fg_color),
	font = beautiful.font_var .. "11",
	align = "center",
	valign = "center",
})

-- song name
local song_name = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("None", beautiful.fg_color),
	font = beautiful.font_var .. "Bold 13",
	align = "center",
	valign = "center",
})

-- buttons --

local toggle_button_icon = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.bg_color),
	font = beautiful.icon_var .. "18",
	align = "center",
	valign = "center",
})

local toggle_button = wibox.widget({
	button_creator(
		toggle_button_icon,
		beautiful.fg_color,
		beautiful.fg_3 .. "80",
		dpi(12),
		nil,
		nil,
		dpi(6),
		nil,
		nil,
		helpers.rrect(9999)
	),
	widget = wibox.container.background,
})

-- next button
local next_button_icon = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color),
	font = beautiful.icon_var .. "16",
	align = "center",
	valign = "center",
})

local next_button = wibox.widget({
	button_creator(
		next_button_icon,
		beautiful.black .. "00",
		nil,
		dpi(10),
		nil,
		nil,
		dpi(9),
		nil,
		nil,
		helpers.rrect(9999)
	),
	widget = wibox.container.background,
})

-- prev button
local prev_button_icon = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color),
	font = beautiful.icon_var .. "16",
	align = "center",
	valign = "center",
})

local prev_button = wibox.widget({
	button_creator(
		prev_button_icon,
		beautiful.black .. "00",
		nil,
		dpi(10),
		nil,
		nil,
		dpi(9),
		nil,
		nil,
		helpers.rrect(9999)
	),
	widget = wibox.container.background,
})

local loop_button_icon = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color .. "99"),
	font = beautiful.icon_var .. "12",
	align = "center",
	valign = "center",
})

local loop_button = wibox.widget({
	button_creator(
		loop_button_icon,
		beautiful.black .. "00",
		nil,
		dpi(12),
		nil,
		nil,
		dpi(9),
		nil,
		nil,
		helpers.rrect(9999)
	),
	widget = wibox.container.background,
})

local shuffle_button_icon = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color .. "99"),
	font = beautiful.icon_var .. "12",
	align = "center",
	valign = "center",
})

local shuffle_button = wibox.widget({
	button_creator(
		shuffle_button_icon,
		beautiful.black .. "00",
		nil,
		dpi(12),
		nil,
		nil,
		dpi(9),
		nil,
		nil,
		helpers.rrect(9999)
	),
	widget = wibox.container.background,
})

-- progressbar
local pbar = wibox.widget({
	widget = wibox.widget.slider,
	forced_height = dpi(10),
	shape = gears.shape.rounded_bar,
	bar_shape = gears.shape.rounded_bar,
	bar_color = beautiful.fg_color .. "11",
	bar_margins = { bottom = dpi(3), top = dpi(3) },
	bar_active_color = beautiful.fg_color,
	handle_width = dpi(12),
	handle_shape = gears.shape.circle,
	handle_color = beautiful.fg_2,
})

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
local loop_command = function()
	playerctl:cycle_loop_status()
end
local shuffle_command = function()
	playerctl:cycle_shuffle()
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

loop_button_icon:buttons(gears.table.join(awful.button({}, 1, function()
	loop_command()
end)))

shuffle_button:buttons(gears.table.join(awful.button({}, 1, function()
	shuffle_command()
end)))

playerctl:connect_signal("metadata", function(_, title, artist, album_path, _, __, ___)
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
	song_artist:set_markup_silently(helpers.colorize_text(artist, beautiful.fg_color))
end)

playerctl:connect_signal("playback_status", function(_, playing, _)
	if playing then
		toggle_button_icon.markup = helpers.colorize_text("", beautiful.bg_color)
	else
		toggle_button_icon.markup = helpers.colorize_text("", beautiful.bg_color)
	end
end)

playerctl:connect_signal("loop_status", function(self, loop_status, player)
	if loop_status == "none" then
		loop_button_icon.markup = helpers.colorize_text("", beautiful.fg_color .. "99")
	else
		loop_button_icon.markup = helpers.colorize_text("", beautiful.fg_color .. "99")
	end
end)

playerctl:connect_signal("shuffle", function(self, shuffle, player)
	if shuffle == true then
		shuffle_button_icon.markup = helpers.colorize_text("", beautiful.fg_color .. "99")
	else
		shuffle_button_icon.markup = helpers.colorize_text("", beautiful.fg_color .. "99")
	end
end)

playerctl:connect_signal("position", function(_, current_pos, total_pos, player_name)
	pbar.value = (current_pos / total_pos) * 100
end)

local music_init = function(c)
	-- bottom
	awful.titlebar(c, { position = "left", size = dpi(300), bg = beautiful.bg_color }):setup({
		{
			helpers.vertical_pad(dpi(20)),
			{
				album_art,
				{
					{
						{
							{
								{
									step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
									fps = 60,
									speed = 75,
									song_name,
									widget = wibox.container.scroll.horizontal,
								},
								{
									step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
									fps = 60,
									speed = 75,
									song_artist,
									widget = wibox.container.scroll.horizontal,
								},
								spacing = dpi(5),
								layout = wibox.layout.fixed.vertical,
							},
							left = dpi(18),
							right = dpi(18),
							widget = wibox.container.margin,
						},
						{
							pbar,
							margins = { left = dpi(18), right = dpi(21) },
							widget = wibox.container.margin,
						},
						spacing = dpi(20),
						layout = wibox.layout.fixed.vertical,
					},
					margins = { left = dpi(15), right = dpi(10) },
					widget = wibox.container.margin,
				},
				spacing = dpi(20),
				layout = wibox.layout.fixed.vertical,
			},
			layout = wibox.layout.fixed.vertical,
		},
		nil,
		{
			{
				{
					nil,
					{
						shuffle_button,
						prev_button,
						toggle_button,
						next_button,
						loop_button,
						layout = wibox.layout.fixed.horizontal,
						spacing = dpi(10),
					},
					layout = wibox.layout.align.horizontal,
					expand = "none",
				},
				bg = "alpha",
				widget = wibox.container.background,
				forced_width = dpi(300),
				forced_height = dpi(60),
			},
			helpers.vertical_pad(dpi(30)),
			layout = wibox.layout.fixed.vertical,
			spacing = dpi(0),
		},
		layout = wibox.layout.align.vertical,
		expand = "none",
	})

	c.custom_decoration = { top = true, left = true, bottom = true }
end

-- Add the titlebar whenever a new music client is spawned
ruled.client.connect_signal("request::rules", function()
	ruled.client.append_rule({
		id = "music",
		rule = { instance = "music" },
		callback = music_init,
	})
end)
