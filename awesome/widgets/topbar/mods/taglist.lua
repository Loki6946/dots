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
		layout = { spacing = dpi(2), layout = wibox.layout.fixed.horizontal },
		buttons = taglist_buttons,
		widget_template = {
			{
				{
					id = "hover",
					widget = wibox.container.background,
					shape = helpers.rrect(4),
					bg = beautiful.fg_color,
					opacity = 0.0,
				},
				{
					{
						id = "text_role",
						widget = wibox.widget.textbox,
						align = "center",
						markup = "DD",
						valign = "center",
					},
					left = dpi(10),
					right = dpi(10),
					widget = wibox.container.margin,
				},
				layout = wibox.layout.stack,
			},
			top = dpi(4),
			bottom = dpi(4),
			widget = wibox.container.margin,
			create_callback = function(self, c3, _)
				local animation_button_opacity = rubato.timed({
					pos = 0,
					rate = 60,
					intro = 0.01,
					duration = 0.15,
					awestore_compat = true,
					easing = rubato.easing.inOutSine,
					subscribed = function(pos)
						helpers.gc(self, "hover").opacity = pos
					end,
				})

				helpers.gc(self, "hover"):connect_signal("mouse::enter", function()
					animation_button_opacity:set(0.0)
				end)

				helpers.gc(self, "hover"):connect_signal("mouse::leave", function()
					animation_button_opacity:set(0.0)
				end)

				helpers.gc(self, "hover"):connect_signal("button::press", function(_, _, _, button)
					if button == 1 then
						animation_button_opacity:set(0.4)
					end
				end)

				helpers.gc(self, "hover"):connect_signal("button::release", function()
					gears.timer.start_new(1, function()
						animation_button_opacity:set(0.0)
					end)
					-- animation_button_opacity:set(0.4)
				end)

				-- helpers.hover_cursor(helpers.gc(self, "hover"))

				-- self.update = function()
				-- 	if c3.selected then
				-- 		helpers.gc(self, "bg_role").bg = beautiful.fg_2 .. "33"
				-- 	elseif #c3:clients() == 0 then
				-- 		helpers.gc(self, "bg_role").bg = beautiful.black .. "00"
				-- 	else
				-- 		helpers.gc(self, "bg_role").bg = beautiful.black .. "00"
				-- 	end
				-- end
				--
				-- self.update()
			end,

			update_callback = function(self)
				-- self.update()
			end,
		},
	})

	return the_taglist
end

return get_taglist
