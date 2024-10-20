-- Taglist widget
-- ~~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local rubato = require("modules.rubato")
local helpers = require("helpers")

-- default modkey
local modkey = "Mod4"

local get_taglist = function(s)
	-- Taglist buttons
	local taglist_buttons = gears.table.join(
		awful.button({}, 1, function(t)
			t:view_only()
		end),
		awful.button({ modkey }, 1, function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end),
		awful.button({}, 3, awful.tag.viewtoggle),
		awful.button({ modkey }, 3, function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end),
		awful.button({}, 4, function(t)
			awful.tag.viewnext(t.screen)
		end),
		awful.button({}, 5, function(t)
			awful.tag.viewprev(t.screen)
		end)
	)

	local the_taglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		style = { shape = gears.shape.circle },
		layout = { spacing = dpi(10), layout = wibox.layout.fixed.vertical },
		widget_template = {
			{
				{
					{
						id = "hover",
						widget = wibox.container.background,
						shape = gears.shape.rounded_bar,
						bg = beautiful.accent_3,
						opacity = 0,
					},
					{
						{
							id = "text_role",
							widget = wibox.widget.textbox,
							font = beautiful.font_var .. "10",
							align = "center",
							markup = "DD",
							valign = "center",
						},
						margins = dpi(8),
						widget = wibox.container.margin,
					},
					layout = wibox.layout.stack,
				},
				widget = wibox.container.background,
			},
			id = "background_role",
			bg = beautiful.accent,
			widget = wibox.container.background,

			create_callback = function(self, c3, _)
				local animation_button_opacity = rubato.timed({
					pos = 0,
					rate = 60,
					intro = 0.04,
					duration = 0.2,
					awestore_compat = true,
					subscribed = function(pos)
						helpers.gc(self, "hover").opacity = pos
					end,
				})

				helpers.gc(self, "hover"):connect_signal("mouse::enter", function()
					animation_button_opacity:set(0.4)
				end)

				helpers.gc(self, "hover"):connect_signal("mouse::leave", function()
					animation_button_opacity:set(0.0)
				end)

				-- add buttons and commands
				helpers.gc(self, "hover"):connect_signal("button::press", function()
					animation_button_opacity:set(1)
				end)

				helpers.gc(self, "hover"):connect_signal("button::release", function()
					animation_button_opacity:set(0.4)
				end)

				helpers.hover_cursor(helpers.gc(self, "hover"))

				if c3.selected then
					self:get_children_by_id("background_role")[1].bg = beautiful.accent
				elseif #c3:clients() == 0 then
					self:get_children_by_id("background_role")[1].bg = beautiful.fg_color .. "33"
				else
					self:get_children_by_id("background_role")[1].bg = beautiful.fg_color .. "99"
				end
			end,

			update_callback = function(self, c3, _)
				if c3.selected then
					self:get_children_by_id("background_role")[1].bg = beautiful.accent
				elseif #c3:clients() == 0 then
					self.bg = beautiful.fg_color .. "33"
					self:get_children_by_id("background_role")[1].bg = beautiful.fg_color .. "33"
				else
					self:get_children_by_id("background_role")[1].bg = beautiful.fg_color .. "99"
				end
			end,
		},

		buttons = taglist_buttons,
	})

	return the_taglist
end

return get_taglist
