-- tags  / layouts
-- ~~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local lmachi = require("modules.layout-machi")
local bling = require("modules.bling")
local beautiful = require("beautiful")

-- misc/vars
-- ~~~~~~~~~

-- bling layouts
local mstab = bling.layout.mstab
local equal = bling.layout.equalarea
local deck = bling.layout.deck

-- layout machi
lmachi.editor.nested_layouts = {
	["0"] = deck,
	["1"] = awful.layout.suit.spiral,
	["2"] = awful.layout.suit.fair,
	["3"] = awful.layout.suit.fair.horizontal,
}

-- names/numbers of layouts
local names = { "Terminal", "Develop", "Browser", "Media", "Other" }
local l = awful.layout.suit

-- Configurations
-- **************

-- default tags
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		l.floating,
		l.tile,
		lmachi.default_layout,
		equal,
		mstab,
		deck,
	})
end)

-- set tags
screen.connect_signal("request::desktop_decoration", function(s)
	screen[s].padding = { left = 0, right = 0, top = 0, bottom = 0 }
	awful.tag(names, s, awful.layout.layouts[1])
	s.calendar = require("widgets.menubar.mods.widget.fancy_calendar")(s)
end)

local tag = require("awful.widget.taglist")
local original_create = tag.taglist_label
tag.taglist_label = function(t, args)
	if t.selected then
		beautiful.taglist_font = beautiful.font_var .. "Semibold 10"
	else
		beautiful.taglist_font = beautiful.font_var .. "Medium 10"
	end
	local result = original_create(t, args)
	return result
end
