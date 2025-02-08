local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

require("widgets.decorations.music.minimal")

local predefined_colors = {
	["Thunar"] = "#373737",
	["Nemo"] = "#373737",
	["neovim"] = "#161616",
	["Galculator"] = "#333333",
	["Gpick"] = "#373737",
	["Spotify"] = "#000000",
	["Alacritty"] = "#1C1C1EFC",
	["qBittorrent"] = "#EFEFEF",
	["Nm-applet"] = "#333333",
	["Lxappearance"] = "#333333",
	["music"] = beautiful.bg_color,
	["default"] = beautiful.titlebar_bg_normal,
}

local function create_button(icon, action)
	return wibox.widget({
		{
			id = "iconbot",
			markup = helpers.colorize_text("", beautiful.fg_color),
			font = beautiful.icon_var .. "13",
			widget = wibox.widget.textbox,
		},
		{
			id = "icon",
			markup = helpers.colorize_text(icon, beautiful.fg_color),
			font = beautiful.icon_var .. "13",
			widget = wibox.widget.textbox,
		},
		layout = wibox.layout.stack,
		buttons = { awful.button({}, 1, action) },
	})
end

client.connect_signal("request::titlebars", function(c)
	local color = predefined_colors[c.class] or predefined_colors["default"]

	local buttons = {
		close = create_button("", function()
			c:kill()
		end),
		minimize = create_button("", function()
			gears.timer.delayed_call(function()
				c.minimized = not c.minimized
			end)
		end),
		maximize = create_button("", function()
			c.maximized = not c.maximized
		end),
	}

	local function update_button_colors(focused)
		local icon_color = focused
				and {
					close = beautiful.titlebar_close,
					minimize = beautiful.titlebar_minimize,
					maximize = beautiful.titlebar_maximize,
				}
			or {
				close = beautiful.titlebar_unfocused,
				minimize = beautiful.titlebar_unfocused,
				maximize = beautiful.titlebar_unfocused,
			}

		for name, btn in pairs(buttons) do
			helpers.gc(btn, "icon"):set_markup(
				helpers.colorize_text(
					name == "close" and "" or name == "minimize" and "" or "",
					icon_color[name]
				)
			)
			helpers.gc(btn, "iconbot"):set_markup(helpers.colorize_text("", icon_color[name]))
		end
	end

	for _, btn in pairs(buttons) do
		btn:connect_signal("mouse::enter", function()
			helpers.gc(btn, "iconbot"):set_markup(helpers.colorize_text("", beautiful.bg_2))
		end)
		btn:connect_signal("mouse::leave", function()
			update_button_colors(client.focus == c)
		end)
	end

	c:connect_signal("focus", function()
		update_button_colors(true)
	end)
	c:connect_signal("unfocus", function()
		update_button_colors(false)
	end)

	local click_timer
	local function handle_click()
		if click_timer then
			click_timer:stop()
			click_timer = nil
			c.maximized = true
			c:raise()
		else
			client.focus = c
			c:raise()
			if c.maximized then
				c.maximized = false
			end
			awful.mouse.client.move(c)
			click_timer = gears.timer.start_new(0.3, function()
				click_timer = nil
				return false
			end)
		end
	end

	awful.titlebar(c, { size = 36, bg = color }):setup({
		{
			widget = wibox.container.margin,
			left = 12,
			{
				buttons.close,
				buttons.minimize,
				buttons.maximize,
				spacing = 6,
				layout = wibox.layout.fixed.horizontal,
			},
		},
		{
			{
				nil,
				top = 5,
				bottom = 5,
				left = 200,
				right = 200,
				widget = wibox.container.margin,
			},
			align = "center",
			valign = "center",
			widget = wibox.container.place,
			buttons = gears.table.join(
				awful.button({}, 1, handle_click),
				awful.button({}, 3, function()
					client.focus = c
					c:raise()
					awful.mouse.client.resize(c)
				end)
			),
		},
		{
			nil,
			widget = wibox.container.margin,
			right = 20,
		},
		layout = wibox.layout.align.horizontal,
	})
end)
