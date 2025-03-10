-- A dock for the Awesome Window Manager
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- source: https://github.com/saimoomedits/dotfiles

local dock = require(... .. ".dock_animated")
local icon_handler = require(... .. ".icon_handler")
local beautiful = require("beautiful")
local awful = require("awful")

-- usage:
-- {"command to launch", "icon name" }
-- you  can leave an empty array for no pinned apps
local pinned_defaults = {
	{ "xterm" },
	{ "firefox" },
}

-- dock properties
-- ~~~~~~~~~~~~~~~
local dock_size = beautiful.awesome_dock_size or 80
local offset = beautiful.awesome_dock_offset or beautiful.useless_gap or 0
local pinned_apps = beautiful.awesome_dock_pinned or pinned_defaults
local active_color = beautiful.awesome_dock_color_active or beautiful.fg_focus or "#ffffff"
local background_color = beautiful.awesome_dock_color_bg or beautiful.bg_normal or "#000000"
local border_color = beautiful.awesome_dock_color_border or "#3A3A3C"
local modules_spacing = beautiful.awesome_dock_spacing or 12
local icon_theme = beautiful.awesome_dock_icon

if beautiful.awesome_dock_disabled == true then
	return
else
	awful.screen.connect_for_each_screen(function(s)
		for s in screen do
			-- require("naughty").notify({title = tostring(s.index)})
			dock(
				s,
				pinned_apps,
				dock_size,
				offset,
				modules_spacing,
				active_color,
				background_color,
				border_color,
				icon_handler,
				icon_theme
			)
		end
	end)
end
