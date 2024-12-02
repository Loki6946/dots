-- A dock with Awesomewm's taglist widget
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- source: https://github.com/saimoomedits/dotfiles
-- The dock has authide with animations and much more!
-- The animations require `rubato` module for awesomewm
-- clone it to your `mods` directory from here:
-- https://github.com/andOrnaldo/rubato

--[[ some things to clear out:

  * Why the extra `wibox` for opening the dock?
  : it causes screen tearing, lag and picom issues for me. so its better to use an
  invisible wibox instead of gliding the dock downwards

  * Why the icon handler?
  : its just useful

]]

-- Requirements
---------------
local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")
local helpers = require("helpers")
local rubato = require("modules.rubato")
------------------------------------------------------

return function(
	screen,
	pinned,
	size,
	offset,
	modules_spacing,
	active_color,
	inactive_color,
	minimized_color,
	background_color,
	hover_color,
	icon_handler,
	icon_theme
)
	-- buttons for the dock
	------------------------
	local tasklist_buttons = gears.table.join(
		awful.button({}, 1, function(c)
			if c == client.focus then
				c.minimized = true
			else
				c:emit_signal("request::activate", "tasklist", { raise = true })
			end
		end),
		awful.button({}, 3, function(c)
			c:kill()
		end),
		awful.button({}, 4, function()
			awful.client.focus.byidx(1)
		end),
		awful.button({}, 5, function()
			awful.client.focus.byidx(-1)
		end)
	)
	-- Eof tasklist buttons
	-----------------------------------------------------------------------

	-- main tasklist
	-------------------------------------------
	screen.mytasklist = awful.widget.tasklist({
		screen = screen,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		layout = {
			spacing = dpi(modules_spacing),
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					{
						id = "circle_animate",
						widget = wibox.container.background,
						shape = helpers.rrect(14),
						bg = active_color,
					},
					{
						awful.widget.clienticon,
						id = "app_icon_role",
						margins = 6,
						opacity = 1,
						widget = wibox.container.margin,
					},
					layout = wibox.layout.stack,
				},
				margins = dpi(0),
				widget = wibox.container.margin,
			},
			layout = wibox.layout.fixed.vertical,
			create_callback = function(self, c, index, objects)
				collectgarbage("collect")

				self:connect_signal("mouse::enter", function()
					T_t.markup = helpers.capitalize(c.name)
				end)

				if c.active then
					self:get_children_by_id("app_icon_role")[1].opacity = 1
					helpers.gc(self, "circle_animate").opacity = 0.5
				elseif c.minimized then
					self:get_children_by_id("app_icon_role")[1].opacity = 0.5
					helpers.gc(self, "circle_animate").opacity = 0
				else
					self:get_children_by_id("app_icon_role")[1].opacity = 1
					helpers.gc(self, "circle_animate").opacity = 0
				end

				-- helpers.hover_cursor(self, "app_icon_role")

				when_no_apps_open(screen)
			end,

			update_callback = function(self, c, _, __)
				collectgarbage("collect")

				local animation_button_opacity = rubato.timed({
					pos = 0,
					rate = 60,
					intro = 0.02,
					duration = 0.1,
					awestore_compat = true,
					subscribed = function(pos)
						helpers.gc(self, "circle_animate").opacity = pos
					end,
				})

				self:connect_signal("mouse::enter", function()
					T_t.markup = helpers.capitalize(c.name)
				end)

				if c.active then
					self:get_children_by_id("app_icon_role")[1].opacity = 1
					animation_button_opacity:set(0.5)
				elseif c.minimized then
					self:get_children_by_id("app_icon_role")[1].opacity = 0.5
					animation_button_opacity:set(0)
				else
					self:get_children_by_id("app_icon_role")[1].opacity = 1
					animation_button_opacity:set(0)
				end

				-- helpers.hover_cursor(self, "app_icon_role")

				when_no_apps_open(screen)
			end,
		},
	})

	T_t = awful.tooltip({
		objects = { screen.mytasklist },
		mode = "outside",
		align = "top",
		margins = { top = dpi(5), bottom = dpi(5), left = dpi(12), right = dpi(12) },
		gaps = { bottom = dpi(8) },
		shape = helpers.rrect(3),
	})
	-- Eof taglist
	-------------------------------------------------------------------------------

	-- helper function to create an pinned app
	------------------------------------------
	local pin_app_creator = function(app_command, app_name)
		local app_icon = icon_handler(icon_theme, nil, app_name or string.lower(app_command))

		local w = wibox.widget({
			{
				id = "animate",
				widget = wibox.container.background,
				shape = helpers.rrect(14),
				bg = active_color,
			},
			{
				{
					{
						widget = wibox.widget.imagebox,
						image = app_icon,
						valign = "center",
						halign = "center",
					},
					layout = wibox.container.place,
				},
				widget = wibox.container.margin,
				margins = dpi(3),
			},
			layout = wibox.layout.stack,
		})

		local w_t = awful.tooltip({
			markup = helpers.capitalize(app_name),
			objects = { w },
			mode = "outside",
			align = "top",
			margins = { top = dpi(5), bottom = dpi(5), left = dpi(12), right = dpi(12) },
			gaps = { bottom = dpi(8) },
			shape = helpers.rrect(3),
		})

		local animation_button_opacity = rubato.timed({
			pos = 0,
			rate = 60,
			intro = 0.02,
			duration = 0.1,
			awestore_compat = true,
			subscribed = function(pos)
				helpers.gc(w, "animate").opacity = pos
			end,
		})

		w:connect_signal("mouse::enter", function()
			animation_button_opacity:set(0.5)
		end)

		w:connect_signal("mouse::leave", function()
			animation_button_opacity:set(0)
		end)

		w:connect_signal("button::press", function()
			awful.spawn.with_shell(app_command, false)
			animation_button_opacity:set(0.2)
		end)
		w:connect_signal("button::release", function()
			animation_button_opacity:set(0.5)
		end)

		-- helpers.hover_cursor(w)

		return w
	end
	-- Eof pinned-helper
	----------------------------------------------------

	-- few pinned apps
	---------------------------------
	local predefine_pinned_apps = { layout = wibox.layout.fixed.horizontal, spacing = dpi(modules_spacing) }

	for i in ipairs(pinned) do
		table.insert(predefine_pinned_apps, pin_app_creator(pinned[i][1], pinned[i][2] or pinned[i][1]))
	end

	local pinned_apps = wibox.widget(predefine_pinned_apps)

	-- Eof pinned apps
	--------------------

	-- main dock wibox
	--------------------------
	local dock = awful.popup({
		screen = screen,
		widget = wibox.container.background,
		ontop = true,
		bg = background_color,
		border_color = "#3A3A3C",
		border_width = dpi(1),
		visible = true,
		maximum_width = dpi(1000),
		maximum_height = dpi(size),
		x = screen.geometry.x + screen.geometry.width / 2,
		y = awful.screen.focused().geometry.height,
		shape = helpers.rrect(17),
	})

	dock:setup({
		screen.mytasklist,
		widget = wibox.container.margin,
		margins = dpi(10),
	})

	-- Eof main dock
	--------------------------------------------------------------------------

	-- fake dock
	---------------------------
	local dock_helper = wibox({
		screen = screen,
		widget = wibox.container.background,
		ontop = false,
		opacity = 0,
		visible = true,
		width = dpi(800),
		height = dpi(1),
		type = "tooltip",
	})

	awful.placement.bottom(dock_helper)

	-- Eof fake dock
	---------------------------

	-- helper function for empty dock
	---------------------------------------
	function when_no_apps_open(s)
		if #s.selected_tag:clients() < 1 then
			dock:setup({
				pinned_apps,
				widget = wibox.container.margin,
				margins = dpi(3),
			})
		else
			dock:setup({
				{
					pinned_apps,
					screen.mytasklist,
					layout = wibox.layout.fixed.horizontal,
					spacing = dpi(20),
					spacing_widget = wibox.widget({
						{
							widget = wibox.widget.separator,
							orientation = "vertical",
							color = "#4A4A4EB0",
							thickness = 2,
						},
						widget = wibox.container.margin,
						margins = { top = dpi(8), bottom = dpi(8) },
					}),
				},
				widget = wibox.container.margin,
				margins = dpi(3),
			})
		end
	end

	-------------------------------------------

	-- The dock visibility
	------------------------------------------------------------

	-- hidden y
	local hidden_y = awful.screen.focused().geometry.height

	--visible y
	local visible_y = awful.screen.focused().geometry.height - (dock.maximum_height + offset)

	-- animation when the dock is closed/opened
	local animation = rubato.timed({
		intro = 0.05,
		outro = 0.05,
		duration = 0.1,
		pos = hidden_y,
		rate = 60,
		easing = rubato.linear,
		subscribed = function(pos)
			dock.y = pos
		end,
	})

	local function check_for_dock_hide()
		for _, client in ipairs(screen.selected_tag:clients()) do
			if client.fullscreen then
				animation.target = hidden_y
				gears.timer({
					timeout = 1,
					single_shot = true,
					callback = function()
						dock.visible = false
					end,
				})
			end
		end
		-- make dock visible if nothing is open
		if #screen.selected_tag:clients() < 1 then
			animation.target = visible_y
			dock.visible = true
			return
		end
		if screen == mouse.screen then
			local minimized
			for _, c in ipairs(screen.selected_tag:clients()) do
				if c.minimized then
					minimized = true
				end
				if c.maximized or c.fullscreen then
					animation.target = hidden_y
					return
				end
				if not c.minimized then
					-- if client enters dock area then hide it
					local y = c:geometry().y
					local h = c.height
					if (y + h) >= screen.geometry.height - 85 then
						animation.target = hidden_y
						gears.timer({
							timeout = 1,
							single_shot = true,
							callback = function()
								dock.visible = false
							end,
						})
						return
					else
						animation.target = visible_y
						dock.visible = true
					end
				end
			end
			if minimized then
				animation.target = visible_y
				dock.visible = true
			end
		else
			animation.target = hidden_y
			gears.timer({
				timeout = 1,
				single_shot = true,
				callback = function()
					dock.visible = false
				end,
			})
		end
	end

	-- a timer to check for dock hide
	local dockHide = gears.timer({
		timeout = 1,
		autostart = true,
		callback = function()
			animation.target = visible_y
			when_no_apps_open(screen)
			check_for_dock_hide()
			dock:connect_signal("property::width", function()
				dock.x = screen.geometry.x + screen.geometry.width / 2 - dock.width / 2
			end)
		end,
	})
	dockHide:again()

	dock_helper:connect_signal("mouse::leave", function()
		when_no_apps_open(screen)
		dockHide:again()
	end)

	dock_helper:connect_signal("mouse::enter", function()
		dock:connect_signal("property::width", function()
			dock.x = screen.geometry.x + screen.geometry.width / 2 - dock.width / 2
		end)
		when_no_apps_open(screen)
		dock.visible = true
		animation.target = visible_y
		dockHide:stop()
	end)

	dock:connect_signal("mouse::leave", function()
		dockHide:again()
	end)

	dock:connect_signal("mouse::enter", function()
		dock:connect_signal("property::width", function()
			dock.x = screen.geometry.x + screen.geometry.width / 2 - dock.width / 2
		end)
		dockHide:stop()
	end)

	-- Eof dock visibility
	----------------------------------------------------------------------------
end
