-- titlebar
-- ~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")
local gears = require("gears")

-- extra
-- ~~~~~
require("widgets.decorations.music.minimal")

-- function to create those buttons
local function create_title_button(c, color_focus, color_hover, color_unfocus, shp)
	local tb = wibox.widget({
		forced_width = dpi(20),
		forced_height = dpi(20),
		bg = color_focus .. 90,
		shape = shp,
		widget = wibox.container.background,
	})

	local function update()
		if client.focus == c then
			tb.bg = color_focus
		else
			tb.bg = color_unfocus
		end
	end
	update()

	c:connect_signal("focus", update)
	c:connect_signal("unfocus", update)

	tb:connect_signal("mouse::enter", function()
		tb.bg = color_hover
	end)
	tb:connect_signal("mouse::leave", function()
		tb.bg = color_focus
	end)

	tb.visible = true
	return tb
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

	-- Shapes

	local ci = function(width, height)
		return function(cr)
			gears.shape.circle(cr, width, height)
		end
	end

	-- Buttons

	local close = create_title_button(
		c,
		beautiful.titlebar_close,
		beautiful.titlebar_close_hover,
		beautiful.titlebar_unfocused,
		ci(dpi(12), dpi(12))
	)
	close:connect_signal("button::press", function()
		gears.timer.delayed_call(function()
			c:kill()
		end)
	end)

	local min = create_title_button(
		c,
		beautiful.titlebar_minimize,
		beautiful.titlebar_minimize_hover,
		beautiful.titlebar_unfocused,
		ci(dpi(12), dpi(12))
	)
	min:connect_signal("button::press", function()
		gears.timer.delayed_call(function()
			c.minimized = not c.minimized
		end)
	end)

	local max = create_title_button(
		c,
		beautiful.titlebar_maximize,
		beautiful.titlebar_maximize_hover,
		beautiful.titlebar_unfocused,
		ci(dpi(12), dpi(12))
	)
	max:connect_signal("button::press", function()
		gears.timer.delayed_call(function()
			c.maximized = not c.maximized
		end)
	end)

	local title = wibox.widget({
		markup = c.name,
		font = beautiful.font_var .. "11",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})
	c:connect_signal("property::name", function()
		title.markup = c.name
	end)

	--

	local wrap_widget = function(w)
		return {
			w,
			top = dpi(10),
			widget = wibox.container.margin,
		}
	end

	-- the titlebar
	awful
		.titlebar(c, {
			position = "top",
			size = dpi(36),
			bg = beautiful.bg_2,
		})
		:setup({
			{
				{
					nil,
					{
						wrap_widget(close),
						wrap_widget(min),
						wrap_widget(max),
						layout = wibox.layout.fixed.horizontal,
					},
					layout = wibox.layout.align.vertical,
					expand = "none",
				},
				margins = { left = dpi(16) },
				widget = wibox.container.margin,
			},
			{
				{
					nil,
					top = 5,
					bottom = 5,
					left = 0,
					right = 50,
					widget = wibox.container.margin,
				},
				align = "center",
				valign = "center",
				widget = wibox.container.place,
				buttons = buttons,
			},
			{
				nil,
				widget = wibox.container.margin,
				right = 20,
			},
			layout = wibox.layout.align.horizontal,
		})
end)
