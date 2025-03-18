-- Minimal control center
-- ~~~~~~~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")

awful.screen.connect_for_each_screen(function(s)
	-- Mainbox
	--~~~~~~~~~~~~~~~~~
	control_c = wibox({
		type = "menu",
		shape = function(cr, width, height)
			gears.shape.infobubble(cr, width, height, dpi(17), 8)
		end,
		screen = s,
		width = dpi(350),
		height = dpi(400),
		bg = beautiful.bg_color .. "D9",
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
	local sliders = require("widgets.topbar.mods.cc.sliders_2")
	local utils = require("widgets.topbar.mods.cc.utils")
	local song = require("widgets.topbar.mods.cc.music")

	cc_toggle = function(screen)
		screen = screen or s
		control_c.y = screen.geometry.y + (dpi(42))

		if not control_c.visible then
			control_c.x = s.geometry.width - (control_c.width + 24)
			control_c.visible = true
		else
			control_c.visible = false
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
				spacing = dpi(13),
			},
			widget = wibox.container.margin,
			margins = dpi(13),
		},
		layout = wibox.layout.fixed.vertical,
	})
end)
