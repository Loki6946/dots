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
		layout = { layout = wibox.layout.fixed.horizontal },
		widget_template = {
			{
				{
					id = "hover",
					widget = wibox.container.background,
					shape = helpers.rrect(0),
					bg = beautiful.fg_color .. "66",
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
					left = dpi(13),
					right = dpi(13),
					widget = wibox.container.margin,
				},
				layout = wibox.layout.stack,
			},
			id = "background_role",
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

				self.update = function()
					if c3.selected then
						helpers.gc(self, "background_role").bg = beautiful.black .. "00"
						helpers.gc(self, "text_role").font = beautiful.font_var .. "Bold 10"
					elseif #c3:clients() == 0 then
						helpers.gc(self, "background_role").bg = beautiful.fg_color .. "33"
					else
						helpers.gc(self, "background_role").bg = beautiful.fg_color .. "99"
					end
				end

				self.update()
			end,

			update_callback = function(self)
				self.update()
			end,
		},

		buttons = taglist_buttons,
	})

	return the_taglist
end

return get_taglist
