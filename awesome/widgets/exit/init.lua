local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("helpers")

local exit, prompt_grabber

local function createButton(icon, cmd)
	local button = wibox.widget({
		{
			{
				image = gears.color.recolor_image(
					home_var .. "/.config/awesome/theme/assets/icons/" .. icon,
					beautiful.fg_color
				),
				forced_height = 30,
				forced_width = 30,
				resize = true,
				widget = wibox.widget.imagebox,
			},
			margins = 15,
			widget = wibox.container.margin,
		},
		id = "bg",
		bg = beautiful.bg_2,
		shape_border_width = beautiful.border_width,
		shape_border_color = beautiful.border_accent,
		shape = helpers.rrect(15),
		widget = wibox.container.background,
		buttons = {
			awful.button({}, 1, function()
				prompt_grabber:stop()
				exit.visible = false
				awful.spawn.with_shell(cmd)
			end),
		},
	})
	button.cmd = cmd

	button:connect_signal("mouse::enter", function()
		helpers.gc(button, "bg").bg = beautiful.bg_3
	end)

	button:connect_signal("mouse::leave", function()
		helpers.gc(button, "bg").bg = beautiful.bg_2
	end)

	helpers.hover_cursor(button)
	return button
end

local entries_container = wibox.widget({
	spacing = 15,
	layout = wibox.layout.fixed.horizontal,
})

local buttons = {
	createButton("poweroff.svg", "systemctl poweroff"),
	createButton("restart.svg", "systemctl reboot"),
	createButton("lock.svg", "awesome-client \"awesome.emit_signal('toggle::lock')\""),
	createButton("suspend.svg", "systemctl suspend"),
	createButton("logout.svg", "loginctl kill-user $USER"),
}

local index_entry = 1
local function filter_entries()
	entries_container:reset()
	for i, button in ipairs(buttons) do
		if i == index_entry then
			helpers.gc(button, "bg").bg = beautiful.bg_3
		else
			helpers.gc(button, "bg").bg = beautiful.bg_2
		end
		entries_container:add(button)
	end
end

local function next()
	if index_entry < #buttons then
		index_entry = index_entry + 1
	else
		index_entry = 1
	end
	filter_entries()
end
local function prev()
	if index_entry > 1 then
		index_entry = index_entry - 1
	else
		index_entry = #buttons
	end
	filter_entries()
end

return function(s)
	exit = wibox({
		screen = s,
		type = "splash",
		height = s.geometry.height,
		width = s.geometry.width,
		x = s.geometry.x,
		y = s.geometry.y,
		ontop = true,
		bg = beautiful.black .. "33",
		visible = false,
	})

	exit:setup({
		nil,
		{
			{
				{
					{
						id = "uptime",
						align = "center",
						font = beautiful.font_var .. "Medium 12",
						widget = wibox.widget.textbox,
					},
					entries_container,
					layout = wibox.layout.fixed.vertical,
				},
				widget = wibox.container.margin,
				margins = 15,
			},
			widget = wibox.container.background,
			forced_width = 390,
			forced_height = 130,
			shape = helpers.rrect(13),
			bg = beautiful.bg_color,
			border_width = beautiful.border_width,
			border_color = beautiful.border_accent,
		},
		layout = wibox.container.place,
		halign = "center",
		valign = "center",
	})

	exit:buttons(gears.table.join(
		awful.button({}, 2, function()
			awesome.emit_signal("close::exit")
		end),

		awful.button({}, 3, function()
			awesome.emit_signal("close::exit")
		end),

		awful.button({}, 1, function()
			awesome.emit_signal("close::exit")
		end)
	))

	awesome.connect_signal("signal::uptime", function(v)
		helpers.gc(exit, "uptime").markup = helpers.colorize_text("Up: " .. v, beautiful.fg_color)
	end)

	prompt_grabber = awful.keygrabber({
		auto_start = true,
		stop_event = "release",
		keypressed_callback = function(self, _, key, _)
			if key == "Left" then
				prev()
			elseif key == "Right" or key == "Tab" then
				next()
			elseif key == "Return" then
				self:stop()
				exit.visible = false
				gears.timer.start_new(0.2, function()
					awful.spawn.with_shell(buttons[index_entry].cmd)
				end)
			elseif key == "Escape" then
				exit.visible = false
				self:stop()
			end
		end,
	})

	awesome.connect_signal("toggle::exit", function()
		if exit.visible then
			exit.visible = false
			prompt_grabber:stop()
		else
			index_entry = 0
			filter_entries()
			prompt_grabber:start()
			exit.visible = true
		end
	end)

	awesome.connect_signal("close::exit", function()
		if exit.visible then
			exit.visible = false
			prompt_grabber:stop()
		end
	end)

	helpers.place_widget(exit, "center")

	return exit
end
