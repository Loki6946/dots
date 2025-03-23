-- Requirements
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local button_creator = require("helpers.widget.create_button")

-- Song Info Widgets
local album_art = wibox.widget({
	widget = wibox.widget.imagebox,
	clip_shape = helpers.rrect(beautiful.rounded - 3),
	forced_height = dpi(60),
	forced_width = dpi(60),
	image = beautiful.album_art_fallback,
})

local song_artist = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("Unknown", beautiful.fg_color),
	font = beautiful.font_var .. "10",
	align = "left",
	valign = "center",
})

local song_name = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("None", beautiful.fg_color),
	font = beautiful.font_var .. "Bold 11",
	align = "left",
	valign = "center",
})

-- Control Buttons
local function create_button(icon, size)
	return wibox.widget({
		widget = wibox.widget.textbox,
		markup = helpers.colorize_text(icon, beautiful.fg_color .. "D9"),
		font = beautiful.icon_round .. size,
		align = "right",
		valign = "center",
	})
end

local toggle_button = create_button("", "25")
local next_button = create_button("", "25")
local prev_button = create_button("", "14")

-- Playerctl Integration
local playerctl = require("modules.bling").signal.playerctl.lib()

toggle_button:buttons(gears.table.join(awful.button({}, 1, function()
	playerctl:play_pause()
end)))

next_button:buttons(gears.table.join(awful.button({}, 1, function()
	playerctl:next()
end)))

prev_button:buttons(gears.table.join(awful.button({}, 1, function()
	playerctl:previous()
end)))

playerctl:connect_signal("metadata", function(_, title, artist, album_path, ...)
	song_name:set_markup_silently(helpers.colorize_text(title ~= "" and title or "None", beautiful.fg_color))
	song_artist:set_markup_silently(
		helpers.colorize_text("~" .. (artist ~= "" and artist or "Unknown"), beautiful.fg_color)
	)
	album_art:set_image(gears.surface.load_uncached(album_path ~= "" and album_path or beautiful.album_art_fallback))
end)

playerctl:connect_signal("playback_status", function(_, playing, ...)
	toggle_button.markup = helpers.colorize_text(playing and "" or "", beautiful.fg_color)
end)

-- Layout
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
						button_creator(
							toggle_button,
							beautiful.black .. "00",
							beautiful.fg_color,
							dpi(4),
							nil,
							nil,
							dpi(0)
						),
						button_creator(
							next_button,
							beautiful.black .. "00",
							beautiful.fg_color,
							dpi(4),
							nil,
							nil,
							dpi(0)
						),
						layout = wibox.layout.fixed.horizontal,
						spacing = dpi(0),
					},
					margins = { top = dpi(5), bottom = dpi(5) },
					widget = wibox.container.margin,
				},
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(10),
			},
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(0),
		},
		margins = dpi(10),
		widget = wibox.container.margin,
	},
	forced_height = dpi(70),
	bg = beautiful.bg_3 .. "D9",
	shape = helpers.rrect(beautiful.rounded),
	widget = wibox.container.background,
})
