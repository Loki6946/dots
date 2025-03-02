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
		shape = helpers.rrect(beautiful.rounded),
		screen = s,
		width = dpi(380),
		height = dpi(438),
		bg = beautiful.bg_2 .. "D9",
		border_width = dpi(1),
		border_color = beautiful.border_focus,
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
		pos = s.geometry.width,
		rate = 60,
		duration = 0.3,
		intro = 0.10,
		easing = rubato.ease_out_cubic,
		subscribed = function(pos)
			control_c.x = s.geometry.x + pos
		end,
	})

	cc_toggle = function(screen)
		screen = screen or s
		control_c.y = screen.geometry.y + (dpi(35) + beautiful.useless_gap)

		if not control_c.visible then
			control_c.x = s.geometry.width -- Start off-screen
			control_c.visible = true
			slide_right.target = s.geometry.width - (control_c.width + beautiful.useless_gap * 3)
		else
			slide_right.target = s.geometry.width
			if slide_right.ended then
				slide_right.ended:subscribe(function()
					control_c.visible = false
				end)
			else
				gears.timer.start_new(0.3, function()
					control_c.visible = false
				end)
			end
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
