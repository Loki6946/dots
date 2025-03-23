-- helper function to create buttons
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- uses rubato for smoooth animations

-- requirements
-- ~~~~~~~~~~~~
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local rubato = require("modules.rubato")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

return function(
	widget,
	normal_bg,
	hover_color,
	inner_inline_margin,
	inner_block_margin,
	outer_inline_margin,
	outer_block_margin,
	border_width,
	border_color,
	shape_spe
)
	-- containers
	local circle_animate = wibox.widget({
		widget = wibox.container.background,
		shape = shape_spe or gears.shape.rounded_bar,
		bg = hover_color or beautiful.fg_color,
	})

	local mainbox = wibox.widget({
		{
			{
				circle_animate,
				{
					widget,
					top = inner_block_margin or 0,
					bottom = inner_block_margin or 0,
					left = inner_inline_margin or 0,
					right = inner_inline_margin or 0,
					widget = wibox.container.margin,
				},
				layout = wibox.layout.stack,
			},
			bg = normal_bg or beautiful.bg_3,
			shape = shape_spe or gears.shape.rounded_bar,
			border_width = border_width or dpi(0),
			border_color = border_color or hover_color or "#00000000",
			widget = wibox.container.background,
		},
		top = outer_block_margin or 0,
		bottom = outer_block_margin or 0,
		left = outer_inline_margin or 0,
		right = outer_inline_margin or 0,
		widget = wibox.container.margin,
	})

	local animation_button_opacity = rubato.timed({
		pos = 0,
		rate = 60,
		intro = 0.01,
		duration = 0.15,
		awestore_compat = true,
		easing = rubato.easing.inOutSine,
		subscribed = function(pos)
			circle_animate.opacity = pos
		end,
	})

	mainbox:connect_signal("mouse::enter", function()
		animation_button_opacity:set(0.0)
	end)

	mainbox:connect_signal("mouse::leave", function()
		animation_button_opacity:set(0.0)
	end)

	-- add buttons and commands
	mainbox:connect_signal("button::press", function(_, _, _, button)
		if button == 1 then
			animation_button_opacity:set(0.2)
		end
	end)

	mainbox:connect_signal("button::release", function()
		gears.timer.start_new(1, function()
			animation_button_opacity:set(0.0)
		end)
		-- animation_button_opacity:set(0.3)
	end)

	-- helpers.hover_cursor(mainbox)

	return mainbox
end
