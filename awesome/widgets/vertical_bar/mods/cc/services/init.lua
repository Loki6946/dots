-- services buttons
-- ~~~~~~~~~~~~~~~~
-- each button has a fade animation when activated

-- requirements
-- ~~~~~~~~~~~~
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local wibox = require("wibox")

-- widgets
-- ~~~~~~~
local wifi = require("widgets.vertical_bar.mods.cc.services.wifi")

-- return
-- ~~~~~~
local returner = wibox.widget({
	{
		wifi,
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(22),
	},
	spacing = dpi(0),
	layout = wibox.layout.fixed.vertical,
})

return returner

