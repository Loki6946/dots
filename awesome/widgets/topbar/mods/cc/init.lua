-- Minimal control center
-- ~~~~~~~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local rubato = require("modules.rubato")

awful.screen.connect_for_each_screen(function(s)
	-- Mainbox
	--~~~~~~~~~~~~~~~~~
	control_c = wibox({
		type = "dock",
		shape = helpers.rrect(beautiful.rounded + 5),
		screen = s,
		width = dpi(380),
		height = dpi(438),
		bg = beautiful.bg_color .. "BF",
		border_width = dpi(1),
		border_color = "#5A5A5E",
		margins = 10,
		ontop = true,
		visible = false,
	})
	--~~~~~~~~~~~~~~~

	-- widgets
	--~~~~~~~~
	local profile = require("widgets.topbar.mods.cc.profile")
	local sliders = require("widgets.topbar.mods.cc.sliders")
	local utils = require("widgets.topbar.mods.cc.utils")
	local song = require("widgets.topbar.mods.cc.music")

	-- animations
	--------------
	local slide_right = rubato.timed({
		pos = s.geometry.width, -- Ensure this starts at screen width
		rate = 60,
		duration = 0.28,
		intro = 0.12,
		easing = rubato.ease_in_out_cubic,
		subscribed = function(pos)
			control_c.x = s.geometry.x + pos
		end,
	})

	cc_toggle = function(screen)
		screen = screen or s
		control_c.y = screen.geometry.y + (dpi(33) + beautiful.useless_gap)

		if not control_c.visible then
			slide_right.target = s.geometry.width - (control_c.width + beautiful.useless_gap * 5)
			control_c.x = s.geometry.x + s.geometry.width -- Start from far right
			control_c.visible = true
		else
			if screen.index ~= screen_backup then
				return
			end

			slide_right.target = s.geometry.width
			gears
				.timer({
					single_shot = true,
					timeout = 0.41,
					callback = function()
						control_c.visible = false
					end,
				})
				:start()
		end

		screen_backup = screen.index
	end
	-- Eof toggler script
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	-- Initial setup
	control_c:setup({
		{
			{
				{
					profile,
					nil,
					{
						{
							utils,
							top = dpi(20),
							widget = wibox.container.margin,
						},
						layout = wibox.layout.fixed.vertical,
					},
					spacing = dpi(12),
					layout = wibox.layout.fixed.horizontal,
				},
				sliders,
				song,
				layout = wibox.layout.fixed.vertical,
				spacing = dpi(12),
			},
			widget = wibox.container.margin,
			margins = dpi(12),
		},
		layout = wibox.layout.fixed.vertical,
	})
end)
