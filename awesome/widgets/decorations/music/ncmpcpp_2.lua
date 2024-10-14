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

--- Music art cover
local music_art = wibox.widget({
	image = beautiful.album_art_fallback,
	resize = true,
	clip_shape = helpers.rrect(beautiful.rounded - 2),
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
	font = beautiful.font_var .. "10",
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
	markup = helpers.colorize_text("", beautiful.fg_color),
	font = beautiful.icon_var .. "16",
	align = "center",
	valign = "center",
})

-- prev button
local prev_button = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helpers.colorize_text("", beautiful.fg_color),
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

local playlist = function(c)
	return wibox.widget({
		{
			widget = wibox.widget.textbox,
			markup = helpers.colorize_text("", beautiful.fg_color),
			font = beautiful.icon_var .. "16",
			align = "start",
			valign = "center",
			buttons = (gears.table.join(awful.button({}, 1, function()
				helpers.send_key(c, "1")
			end))),
		},
		{
			widget = wibox.widget.textbox,
			markup = helpers.colorize_text("Home", beautiful.fg_color),
			font = beautiful.font_var .. "Medium 12",
			align = "start",
			valign = "center",
			buttons = (gears.table.join(awful.button({}, 1, function()
				helpers.send_key(c, "1")
			end))),
		},
		spacing = dpi(8),
		layout = wibox.layout.fixed.horizontal,
	})
end

local local_files = function(c)
	return wibox.widget({
		{
			widget = wibox.widget.textbox,
			markup = helpers.colorize_text("", beautiful.fg_color),
			font = beautiful.icon_var .. "16",
			align = "start",
			valign = "center",
			buttons = (gears.table.join(awful.button({}, 1, function()
				helpers.send_key(c, "2")
			end))),
		},
		{
			widget = wibox.widget.textbox,
			markup = helpers.colorize_text("Library", beautiful.fg_color),
			font = beautiful.font_var .. "Medium 12",
			align = "start",
			valign = "center",
			buttons = (gears.table.join(awful.button({}, 1, function()
				helpers.send_key(c, "2")
			end))),
		},
		spacing = dpi(8),
		layout = wibox.layout.fixed.horizontal,
	})
end

local search = function(c)
	return wibox.widget({
		{
			widget = wibox.widget.textbox,
			markup = helpers.colorize_text("", beautiful.fg_color),
			font = beautiful.icon_var .. "16",
			align = "start",
			valign = "center",
			buttons = (gears.table.join(awful.button({}, 1, function()
				helpers.send_key(c, "3")
			end))),
		},
		{
			widget = wibox.widget.textbox,
			markup = helpers.colorize_text("Search", beautiful.fg_color),
			font = beautiful.font_var .. "Medium 12",
			align = "start",
			valign = "center",
			buttons = (gears.table.join(awful.button({}, 1, function()
				helpers.send_key(c, "3")
			end))),
		},
		spacing = dpi(8),
		layout = wibox.layout.fixed.horizontal,
	})
end

local library = function(c)
	return wibox.widget({
		{
			widget = wibox.widget.textbox,
			markup = helpers.colorize_text("", beautiful.fg_color),
			font = beautiful.icon_var .. "16",
			align = "start",
			valign = "center",
			buttons = (gears.table.join(awful.button({}, 1, function()
				helpers.send_key(c, "4")
			end))),
		},
		{
			widget = wibox.widget.textbox,
			markup = helpers.colorize_text("Artist", beautiful.fg_color),
			font = beautiful.font_var .. "Medium 12",
			align = "start",
			valign = "center",
			buttons = (gears.table.join(awful.button({}, 1, function()
				helpers.send_key(c, "4")
			end))),
		},
		spacing = dpi(8),
		layout = wibox.layout.fixed.horizontal,
	})
end

local visualizer = function(c)
	return wibox.widget({
		{
			widget = wibox.widget.textbox,
			markup = helpers.colorize_text("", beautiful.fg_color),
			font = beautiful.icon_var .. "16",
			align = "start",
			valign = "center",
			buttons = (gears.table.join(awful.button({}, 1, function()
				helpers.send_key(c, "8")
			end))),
		},
		{
			widget = wibox.widget.textbox,
			markup = helpers.colorize_text("Visualizer", beautiful.fg_color),
			font = beautiful.font_var .. "Medium 12",
			align = "start",
			valign = "center",
			buttons = (gears.table.join(awful.button({}, 1, function()
				helpers.send_key(c, "8")
			end))),
		},
		spacing = dpi(8),
		layout = wibox.layout.fixed.horizontal,
	})
end

--- Music position
local music_now = wibox.widget({
	font = beautiful.font_var .. "9",
	valign = "center",
	widget = wibox.widget.textbox,
})

local music_length = wibox.widget({
	font = beautiful.font_var .. "9",
	valign = "center",
	widget = wibox.widget.textbox,
})

--- Music position bar
local pbar = wibox.widget({
	widget = wibox.widget.progressbar,
	forced_height = dpi(4),
	forced_width = dpi(380),
	color = beautiful.accent,
	background_color = beautiful.accent .. "4D",
	value = 50,
	max_value = 100,
	halign = "center",
	valign = "center",
})

local music_progress = wibox.widget({
	music_now,
	{
		pbar,
		top = dpi(8),
		bottom = dpi(8),
		left = dpi(10),
		right = dpi(10),
		widget = wibox.container.margin,
	},
	music_length,
	layout = wibox.layout.align.horizontal,
})

--- Volume Control
local function volume_control()
	local volume_bar = wibox.widget({
		max_value = 100,
		value = 50,
		margins = {
			top = dpi(47),
			bottom = dpi(47),
			left = dpi(5),
			right = dpi(5),
		},
		forced_width = dpi(80),
		shape = helpers.rrect(0),
		bar_shape = helpers.rrect(0),
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

pbar:connect_signal("button::press", function(_, value, __, button, ___, w)
	if button == 1 then
		playerctl:set_position(value)
	end
end)

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
		artist_now:set_markup_silently(helpers.colorize_text("~" .. artist, beautiful.fg_color .. "B3"))
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

		music_now:set_markup_silently(pos_now)
		music_length:set_markup_silently(pos_length)
		pbar.value = (interval_sec / length_sec) * 100
	end
end)

local music_create_decoration = function(c)
	--- Hide default titlebar
	-- awful.titlebar.hide(c)

	--- Sidebar
	awful.titlebar(c, { position = "left", size = dpi(200) }):setup({
		{
			{
				button_creator(
					playlist(c),
					beautiful.black .. "00",
					nil,
					dpi(12),
					dpi(12),
					dpi(8),
					nil,
					nil,
					nil,
					helpers.rrect(2)
				),
				button_creator(
					local_files(c),
					beautiful.black .. "00",
					nil,
					dpi(12),
					dpi(12),
					dpi(8),
					nil,
					nil,
					nil,
					helpers.rrect(2)
				),
				button_creator(
					search(c),
					beautiful.black .. "00",
					nil,
					dpi(12),
					dpi(12),
					dpi(8),
					nil,
					nil,
					nil,
					helpers.rrect(2)
				),
				button_creator(
					library(c),
					beautiful.black .. "00",
					nil,
					dpi(12),
					dpi(12),
					dpi(8),
					nil,
					nil,
					nil,
					helpers.rrect(2)
				),
				button_creator(
					visualizer(c),
					beautiful.black .. "00",
					nil,
					dpi(12),
					dpi(12),
					dpi(8),
					nil,
					nil,
					nil,
					helpers.rrect(2)
				),
				spacing = dpi(5),
				layout = wibox.layout.fixed.vertical,
			},
			widget = wibox.container.margin,
			top = dpi(15),
		},
		bg = beautiful.bg_color,
		widget = wibox.container.background,
	})

	--- Toolbar
	awful.titlebar(c, { position = "bottom", size = dpi(100), bg = beautiful.bg_2 }):setup({
		{
			{
				layout = wibox.layout.align.horizontal,
				expand = "none",
				{
					{
						music_art,
						bottom = dpi(20),
						top = dpi(20),
						widget = wibox.container.margin,
					},
					{
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
							spacing = dpi(4),
							layout = wibox.layout.flex.vertical,
						},
						top = dpi(15),
						bottom = dpi(15),
						widget = wibox.container.margin,
					},
					spacing = dpi(10),
					layout = wibox.layout.fixed.horizontal,
				},
				{
					{
						layout = wibox.layout.fixed.vertical,
						spacing = dpi(10),
						{
							{
								button_creator(
									shuffle_button,
									beautiful.black .. "00",
									nil,
									dpi(8),
									nil,
									nil,
									dpi(6),
									nil,
									nil,
									helpers.rrect(9999)
								),
								button_creator(
									prev_button,
									beautiful.black .. "00",
									nil,
									dpi(6),
									nil,
									nil,
									dpi(6),
									nil,
									nil,
									helpers.rrect(9999)
								),
								button_creator(
									toggle_button,
									beautiful.accent,
									nil,
									dpi(8),
									nil,
									nil,
									dpi(3),
									nil,
									nil,
									helpers.rrect(9999)
								),
								button_creator(
									next_button,
									beautiful.black .. "00",
									nil,
									dpi(6),
									nil,
									nil,
									dpi(6),
									nil,
									nil,
									helpers.rrect(9999)
								),
								button_creator(
									loop_button,
									beautiful.black .. "00",
									nil,
									dpi(8),
									nil,
									nil,
									dpi(6),
									nil,
									nil,
									helpers.rrect(9999)
								),
								spacing = dpi(15),
								forced_height = dpi(45),
								layout = wibox.layout.fixed.horizontal,
							},
							widget = wibox.container.place,
							halign = "center",
						},
						music_progress,
					},
					top = dpi(15),
					widget = wibox.container.margin,
				},
				{
					--- Music Position
					layout = wibox.layout.fixed.horizontal,
					volume_control(),
				},
			},
			left = dpi(12),
			right = dpi(12),
			widget = wibox.container.margin,
		},
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
