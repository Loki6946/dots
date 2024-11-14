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

--[[ few stuffs to note

-- sidebar height (extras disabled)
-- height = dpi(580),

-- sidebar new height (extras enabled)
-- height = dpi(715),

]]

awful.screen.connect_for_each_screen(function(s)
	-- Mainbox
	--~~~~~~~~~~~~~~~~~
	control_c = wibox({
		type = "dock",
		shape = helpers.rrect(beautiful.rounded + 5),
		screen = s,
		width = dpi(390),
		height = dpi(408),
		bg = beautiful.bg_color,
		border_width = dpi(1),
		border_color = beautiful.border_color,
		margins = 15,
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
		intro = 0.14,
		duration = 0.33,
		subscribed = function(pos)
			control_c.x = s.geometry.x + pos
		end,
	})

	local slide_end = gears.timer({
		single_shot = true,
		timeout = 0.33 + 0.08,
		callback = function()
			control_c.visible = false
		end,
	})

	-- toggler script
	--~~~~~~~~~~~~~~~
	local screen_backup = 1

	cc_toggle = function(screen)
		-- set screen to default, if none were found
		if not screen then
			screen = s
		end

		-- control center x position
		control_c.y = screen.geometry.y + (dpi(33) + beautiful.useless_gap)

		-- toggle visibility
		if control_c.visible then
			-- check if screen is different or the same
			if screen_backup ~= screen.index then
				control_c.visible = true
			else
				slide_end:again()
				slide_right.target = s.geometry.width
			end
		elseif not control_c.visible then
			slide_right.target = s.geometry.width - (control_c.width + beautiful.useless_gap * 2)
			control_c.visible = true
		end

		-- set screen_backup to new screen
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
					utils,
					spacing = dpi(10),
					layout = wibox.layout.fixed.horizontal,
				},
				sliders,
				song,
				layout = wibox.layout.fixed.vertical,
				spacing = dpi(15),
			},
			widget = wibox.container.margin,
			margins = dpi(15),
		},
		layout = wibox.layout.fixed.vertical,
	})
end)
