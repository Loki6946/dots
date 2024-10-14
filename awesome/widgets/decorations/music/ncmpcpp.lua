local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local ruled = require("ruled")
local wibox = require("wibox")
local helpers = require("helpers")
local button_creator = require("helpers.widget.create_button")

--- Custom mouse friendly ncmpcpp UI with album art
--- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local function create_button(shape, color, command, c)
	-- the widget
	local w = wibox.widget({
		widget = wibox.container.background,
		bg = color or beautiful.accent,
		shape = shape or helpers.prrect(beautiful.rounded, true, true, false, true),
		forced_width = dpi(12),
		forced_height = dpi(12),
	})

	-- hover effect
	w:connect_signal("mouse::enter", function()
		w.bg = beautiful.accent
	end)

	w:connect_signal("mouse::leave", function()
		w.bg = beautiful.fg_color .. "4D"
	end)

	-- press effect
	w:connect_signal("button::press", function()
		w.bg = beautiful.fg_color .. "99"
	end)

	w:connect_signal("button::release", function()
		w.bg = beautiful.accent
	end)

	-- dynamic color
	local function dyna()
		if client.focus == c then
			w.bg = beautiful.fg_color .. "4D"
		else
			w.bg = beautiful.fg_color .. "1A"
		end
	end

	-- apply dynamic color
	c:connect_signal("focus", dyna)

	c:connect_signal("unfocus", dyna)

	-- button action
	w:buttons(gears.table.join(awful.button({}, 1, command)))

	return w
end

--- Music icon
local function music_icon()
	local big_music_icon = wibox.widget({
		align = "center",
		font = beautiful.icon_var .. "15",
		markup = helpers.colorize_text("", beautiful.accent),
		widget = wibox.widget.textbox(),
	})

	local small_music_icon = wibox.widget({
		align = "center",
		font = beautiful.icon_var .. "11",
		markup = helpers.colorize_text("", beautiful.fg_color),
		widget = wibox.widget.textbox(),
	})

	local container_music_icon = wibox.widget({
		big_music_icon,
		{
			small_music_icon,
			top = dpi(11),
			widget = wibox.container.margin,
		},
		spacing = dpi(-9),
		layout = wibox.layout.fixed.horizontal,
	})

	local music_icon = wibox.widget({
		nil,
		{
			container_music_icon,
			spacing = dpi(14),
			layout = wibox.layout.fixed.horizontal,
		},
		expand = "none",
		layout = wibox.layout.align.horizontal,
	})

	return music_icon
end

--- Music art cover
local music_art = wibox.widget({
	image = beautiful.album_art_fallback,
	resize = true,
	clip_shape = helpers.rrect(beautiful.rounded),
	widget = wibox.widget.imagebox,
})

--- Music title
local title_now = wibox.widget({
	font = beautiful.font_var .. "Bold 12",
	valign = "bottom",
	widget = wibox.widget.textbox,
})

--- Music artist
local artist_now = wibox.widget({
	font = beautiful.font_var .. "Medium 10",
	valign = "top",
	widget = wibox.widget.textbox,
})

local toggle_button = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.bg_color),
	font = beautiful.icon_var .. "18",
	align = "center",
	valign = "center",
})

-- next button
local next_button = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color .. "99"),
	font = beautiful.icon_var .. "16",
	align = "center",
	valign = "center",
})

-- prev button
local prev_button = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color .. "99"),
	font = beautiful.icon_var .. "16",
	align = "center",
	valign = "center",
})

local loop_button = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color .. "99"),
	font = beautiful.icon_var .. "12",
	align = "center",
	valign = "center",
})

local shuffle_button = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color .. "99"),
	font = beautiful.icon_var .. "12",
	align = "center",
	valign = "center",
})

--- Music position
local music_pos = wibox.widget({
	font = beautiful.font_var .. "Bold 10",
	valign = "center",
	widget = wibox.widget.textbox,
})

--- Music position bar
local music_bar = wibox.widget({
	max_value = 100,
	value = 0,
	background_color = beautiful.accent .. "44",
	color = beautiful.accent,
	forced_height = dpi(3),
	widget = wibox.widget.progressbar,
})

music_bar:connect_signal("button::press", function(_, lx, __, button, ___, w)
	if button == 1 then
		awful.spawn.with_shell("mpc seek " .. math.ceil(lx * 100 / w.width) .. "%")
	end
end)

--- --- Playlist button
--- local playlist = function(c)
--- 	return widgets.button.text.normal({
--- 		normal_shape = gears.shape.rounded_rect,
--- 		font = beautiful.icon_font .. "Round ",
--- 		size = 14,
--- 		text_normal_bg = beautiful.white,
--- 		normal_bg = beautiful.music_bg_accent,
--- 		text = "",
--- 		on_release = function()
--- 			helpers.misc.send_key(c, "1")
--- 		end,
--- 	})
--- end
---
--- --- Visualizer button
--- local visualizer = function(c)
--- 	return widgets.button.text.normal({
--- 		normal_shape = gears.shape.rounded_rect,
--- 		font = "icomoon ",
--- 		size = 14,
--- 		text_normal_bg = beautiful.white,
--- 		normal_bg = beautiful.music_bg_accent,
--- 		text = "",
--- 		on_release = function()
--- 			helpers.misc.send_key(c, "8")
--- 		end,
--- 	})
--- end

--- Volume Control
local function volume_control()
	local volume_bar = wibox.widget({
		max_value = 100,
		value = 50,
		margins = {
			top = dpi(15),
			bottom = dpi(15),
			left = dpi(5),
			right = dpi(5),
		},
		forced_width = dpi(80),
		shape = gears.shape.rounded_bar,
		bar_shape = gears.shape.rounded_bar,
		color = beautiful.accent,
		background_color = beautiful.fg_color .. "11",
		border_width = 0,
		widget = wibox.widget.progressbar,
	})

	-- Update bar
	-- MPD Volume
	local function volume_info()
		awful.spawn.easy_async_with_shell(
			"mpc --port 6200 volume | awk '{print substr($2, 1, length($2)-1)}'",
			function(stdout)
				local volume = tonumber(stdout)
				volume_bar.value = volume and volume <= 100 and volume or 100
			end
		)
	end

	-- Run once to initialize widgets
	volume_info()

	-- Sleeps until mpd volume changes
	-- >> We use `sed '1~2d'` to remove every other line since the mixer event
	-- is printed twice for every volume update.
	-- >> The `-u` option forces sed to work in unbuffered mode in order to print
	-- without waiting for `mpc idleloop mixer` to finish
	local mpd_volume_script = [[
	  sh -c "
		mpc --port 6200 idleloop mixer | sed -u '1~2d'
	  "]]

	-- Kill old mpc idleloop mixer process
	awful.spawn.easy_async_with_shell(
		"ps x | grep \"mpc --port 6200 idleloop mixer\" | grep -v grep | awk '{print $1}' | xargs kill",
		function()
			-- Emit song info with each line printed
			awful.spawn.with_line_callback(mpd_volume_script, {
				stdout = function()
					volume_info()
				end,
			})
		end
	)

	-- Set up volume bar buttons
	volume_bar:connect_signal("button::press", function(_, lx, __, button)
		if button == 1 then
			awful.spawn.with_shell("mpc --port 6200 volume " .. tostring(math.ceil(lx * 100 / volume_bar.forced_width)))
		end
	end)

	local volume = wibox.widget({
		{
			align = "left",
			font = beautiful.icon_var .. "16",
			markup = helpers.colorize_text("", beautiful.accent),
			widget = wibox.widget.textbox(),
		},
		helpers.horizontal_pad(dpi(3)),
		volume_bar,
		helpers.horizontal_pad(dpi(2)),
		layout = wibox.layout.fixed.horizontal,
	})

	volume:buttons(gears.table.join(
		-- Scroll - Increase or decrease volume
		awful.button({}, 4, function()
			awful.spawn.with_shell("mpc --port 6200 volume +5")
		end),
		awful.button({}, 5, function()
			awful.spawn.with_shell("mpc --port 6200 volume -5")
		end)
	))

	return volume
end

--- PLayerctl
--- ~~~~~~~~~
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

loop_button:buttons(gears.table.join(awful.button({}, 1, function()
	loop_command()
end)))

shuffle_button:buttons(gears.table.join(awful.button({}, 1, function()
	shuffle_command()
end)))

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, ___, player_name)
	if player_name == "mpd" then
		if title == "" then
			title = "Nothing Playing"
		end
		if artist == "" then
			artist = "Nothing Playing"
		end
		if album_path == "" then
			album_path = beautiful.album_art_fallback
		end

		music_art:set_image(gears.surface.load_uncached(album_path))
		title_now:set_markup_silently(helpers.colorize_text(title, beautiful.fg_color))
		artist_now:set_markup_silently("~" .. artist)
	end
end)

playerctl:connect_signal("playback_status", function(_, playing, _)
	if playing then
		toggle_button.markup = helpers.colorize_text("", beautiful.bg_color)
	else
		toggle_button.markup = helpers.colorize_text("", beautiful.bg_color)
	end
end)

playerctl:connect_signal("loop_status", function(self, loop_status, player)
	if loop_status == "none" then
		loop_button.markup = helpers.colorize_text("", beautiful.fg_color .. "99")
	else
		loop_button.markup = helpers.colorize_text("", beautiful.fg_color .. "99")
	end
end)

playerctl:connect_signal("shuffle", function(self, shuffle, player)
	if shuffle == true then
		shuffle_button.markup = helpers.colorize_text("", beautiful.fg_color .. "99")
	else
		shuffle_button.markup = helpers.colorize_text("", beautiful.fg_color .. "99")
	end
end)

playerctl:connect_signal("position", function(_, interval_sec, length_sec, player_name)
	if player_name == "mpd" then
		local pos_now = tostring(os.date("!%M:%S", math.floor(interval_sec)))
		local pos_length = tostring(os.date("!%M:%S", math.floor(length_sec)))
		local pos_markup = pos_now .. helpers.colorize_text(" / " .. pos_length, beautiful.fg_color)

		music_pos:set_markup_silently(pos_markup)
		music_bar.value = (interval_sec / length_sec) * 100
		music_length = length_sec
	end
end)

local music_create_decoration = function(c)
	--- Hide default titlebar
	awful.titlebar.hide(c)

	local buttons = gears.table.join(awful.button({}, 1, function()
		awful.mouse.client.move(c)
	end))

	--- Decoration Init
	awful.titlebar(c, { position = "top", size = dpi(45), bg = beautiful.bg_color }):setup({
		{
			{
				{
					volume_control(),
					forced_width = dpi(200),
					widget = wibox.container.constraint,
				},
				music_icon(),
				create_button(gears.shape.circle, beautiful.fg_color, function()
					c:kill()
				end, c),
				layout = wibox.layout.align.horizontal,
			},
			left = dpi(20),
			right = dpi(20),
			widget = wibox.container.margin,
		},
		bg = beautiful.bg_color,
		shape = helpers.prrect(true, true, false, false, beautiful.rounded),
		widget = wibox.container.background,
		buttons = buttons,
	})

	--- Toolbar
	awful.titlebar(c, { position = "bottom", size = dpi(90), bg = beautiful.bg_2 }):setup({
		{
			layout = wibox.layout.align.vertical,
			music_bar,
			{
				{
					layout = wibox.layout.align.horizontal,
					expand = "none",
					{
						music_art,
						{
							{
								step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
								fps = 60,
								speed = 75,
								title_now,
								forced_width = dpi(170),
								widget = wibox.container.scroll.horizontal,
							},
							{
								step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
								fps = 60,
								speed = 75,
								artist_now,
								forced_width = dpi(170),
								widget = wibox.container.scroll.horizontal,
							},
							spacing = dpi(2),
							layout = wibox.layout.flex.vertical,
						},
						spacing = dpi(10),
						layout = wibox.layout.fixed.horizontal,
					},
					{
						button_creator(
							shuffle_button,
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
						button_creator(
							prev_button,
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
						button_creator(
							toggle_button,
							beautiful.accent,
							nil,
							dpi(12),
							nil,
							nil,
							dpi(5),
							nil,
							nil,
							helpers.rrect(9999)
						),
						button_creator(
							next_button,
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
						button_creator(
							loop_button,
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
						spacing = dpi(5),
						layout = wibox.layout.fixed.horizontal,
					},
					{
						--- Music Position
						music_pos,
						spacing = dpi(5),
						layout = wibox.layout.fixed.horizontal,
					},
				},
				top = dpi(15),
				bottom = dpi(15),
				left = dpi(12),
				right = dpi(12),
				widget = wibox.container.margin,
			},
		},
		bg = beautiful.bg_2,
		shape = helpers.prrect(false, false, true, true, beautiful.rounded),
		widget = wibox.container.background,
	})

	--- Set custom decoration flags
	c.custom_decoration = { top = true, left = true, bottom = true }
end

--- Add the titlebar whenever a new music client is spawned
ruled.client.connect_signal("request::rules", function()
	ruled.client.append_rule({
		id = "music",
		rule = { instance = "music" },
		callback = music_create_decoration,
	})
end)
