-- titlebar
-- ~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local helpers = require("helpers")
local gears = require("gears")

-- function to create those buttons
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

-- init
-- ~~~~

-- connect to titlebar signal
client.connect_signal("request::titlebars", function(c)
	-- buttons for the actual titlebar

	local buttons = gears.table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			if c.maximized == true then
				c.maximized = false
			end
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	-- the titlebar
	awful
		.titlebar(c, {
			position = "top",
			size = dpi(46),
			font = beautiful.font_var .. "12",
			fg = beautiful.fg_color .. "99",
			bg = beautiful.bg_2,
		})
		:setup({

			layout = wibox.layout.align.horizontal,
			{
				{
					{
						nil,
						{

							create_button(gears.shape.circle, beautiful.fg_color, function()
								c:kill()
							end, c),

							create_button(gears.shape.circle, beautiful.fg_color, function()
								gears.timer.delayed_call(function()
									c.minimized = not c.minimized
								end)
							end, c),

							create_button(gears.shape.circle, beautiful.fg_color, function()
								c.maximized = not c.maximized
								c:raise()
							end, c),

							layout = wibox.layout.fixed.horizontal,
							spacing = dpi(10),
						},
						layout = wibox.layout.align.vertical,
						expand = "none",
					},
					margins = { left = dpi(24) },
					widget = wibox.container.margin,
				},
				widget = wibox.container.background,
				buttons = nil,
			},
			{
				wibox.widget.textbox,
				layout = wibox.layout.flex.horizontal,
				buttons = buttons,
			},
		})
end)

require("widgets.decorations.music.ncmpcpp_2")
