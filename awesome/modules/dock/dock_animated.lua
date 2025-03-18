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
	background_color,
	border_color,
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
				id = "app_icon_role",
				forced_height = dpi(size - 14),
				forced_width = dpi(size - 14),
				resize = true,
				widget = awful.widget.clienticon,
			},
			{
				{
					id = "circle_animate",
					widget = wibox.container.background,
					bg = active_color,
					shape = helpers.rrect(999),
					forced_width = dpi(5),
					forced_height = dpi(5),
				},
				halign = "center",
				widget = wibox.container.place,
			},
			spacing = dpi(1),
			layout = wibox.layout.fixed.vertical,
			create_callback = function(self, c, index, objects)
				local animation_circle_width = rubato.timed({
					pos = 0,
					rate = 60,
					intro = 0.1,
					duration = 0.20,
					awestore_compat = true,
					easing = rubato.easing.inOutCubic,
					subscribed = function(pos)
						helpers.gc(self, "circle_animate").forced_width = pos
					end,
				})

				self.update = function()
					collectgarbage("collect")

					helpers.gc(self, "app_icon_role").client = c

					self:connect_signal("mouse::enter", function()
						T_t.markup = helpers.capitalize(c.name)
					end)

					self:connect_signal("button::press", function(_, _, _, button)
						helpers.gc(self, "app_icon_role").opacity = 0.6
					end)
					self:connect_signal("button::release", function()
						helpers.gc(self, "app_icon_role").opacity = 1
					end)

					if c.active then
						self:get_children_by_id("app_icon_role")[1].opacity = 1
						animation_circle_width:set(10)
					elseif c.minimized then
						self:get_children_by_id("app_icon_role")[1].opacity = 1
						animation_circle_width:set(5)
					else
						self:get_children_by_id("app_icon_role")[1].opacity = 1
						animation_circle_width:set(5)
					end

					-- helpers.hover_cursor(self, "app_icon_role")
				end

				self.update()
			end,

			update_callback = function(self, c, _, __)
				self.update()
			end,
		},
	})

	T_t = awful.tooltip({
		objects = { screen.mytasklist },
		mode = "outside",
		align = "top",
		preferred_alignments = "middle",
		margins = { top = dpi(4), bottom = dpi(10), left = dpi(12), right = dpi(12) },
		gaps = { bottom = dpi(8) },
		shape = function(cr, width, height)
			gears
				.shape
				.transform(gears.shape.infobubble)
				:rotate_at(width / 2, height / 2, math.pi) -- Rotate 180° (π radians)
				(cr, width, height, dpi(3), dpi(6))
		end,
	})
	-- Eof taglist
	-------------------------------------------------------------------------------

	-- helper function to create an pinned app
	------------------------------------------
	local pin_app_creator = function(app_command, app_name)
		local app_icon = icon_handler(icon_theme, nil, app_name or string.lower(app_command))

		local w = wibox.widget({
			{
				widget = wibox.widget.imagebox,
				image = app_icon,
				forced_height = dpi(size - 15),
				forced_width = dpi(size - 15),
				resize = true,
			},
			{
				{
					id = "animate",
					widget = wibox.container.background,
					bg = active_color,
					shape = helpers.rrect(999),
					forced_width = dpi(5),
					forced_height = dpi(5),
				},
				halign = "center",
				layout = wibox.container.place,
			},
			spacing = dpi(1),
			layout = wibox.layout.fixed.vertical,
		})

		local formatted_name = app_name:gsub("[_-]", " ")
		local w_t = awful.tooltip({
			markup = helpers.capitalize(formatted_name),
			objects = { w },
			mode = "outside",
			align = "top",
			preferred_alignments = "middle",
			margins = { top = dpi(4), bottom = dpi(10), left = dpi(12), right = dpi(12) },
			gaps = { bottom = dpi(8) },
			shape = function(cr, width, height)
				gears
					.shape
					.transform(gears.shape.infobubble)
					:rotate_at(width / 2, height / 2, math.pi) -- Rotate 180° (π radians)
					(cr, width, height, dpi(3), dpi(6))
			end,
		})

		local animation_circle_opacity = rubato.timed({
			pos = 0,
			rate = 60,
			intro = 0.1,
			duration = 0.2,
			awestore_compat = true,
			easing = rubato.easing.inOutCubic,
			subscribed = function(pos)
				helpers.gc(w, "animate").opacity = pos
			end,
		})

		w:connect_signal("mouse::enter", function()
			animation_circle_opacity:set(1.0)
		end)

		w:connect_signal("mouse::leave", function()
			animation_circle_opacity:set(0)
		end)

		w:connect_signal("button::press", function(_, _, _, button)
			if button == 1 then
				awful.spawn.with_shell(app_command, false)
				animation_circle_opacity:set(0.8)
				w.opacity = 0.3
			end
		end)
		w:connect_signal("button::release", function()
			animation_circle_opacity:set(1.0)
			w.opacity = 1
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
		border_color = border_color,
		border_width = dpi(1),
		visible = true,
		maximum_width = dpi(1000),
		maximum_height = dpi(size),
		x = screen.geometry.x + screen.geometry.width / 2,
		y = awful.screen.focused().geometry.height,
		shape = helpers.rrect(20),
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
		height = dpi(2),
		type = "tooltip",
	})

	awful.placement.bottom(dock_helper)

	-- Eof fake dock
	---------------------------

	-- helper function for empty dock
	---------------------------------------

	local function when_no_apps_open(s)
		local content

		if #s.selected_tag:clients() < 1 then
			content = {
				{
					pinned_apps,
					align = "center",
					widget = wibox.container.place,
				},
				widget = wibox.container.margin,
			}
		else
			content = {
				{
					pinned_apps,
					screen.mytasklist,
					layout = wibox.layout.fixed.horizontal,
					spacing = dpi(20),
					spacing_widget = wibox.widget({
						{
							widget = wibox.widget.separator,
							orientation = "vertical",
							color = "#4A4A4E",
							thickness = 2,
						},
						widget = wibox.container.margin,
						margins = { top = dpi(5), bottom = dpi(10) },
					}),
				},
				widget = wibox.container.margin,
			}
		end

		dock:setup({
			content,
			margins = { top = dpi(5), left = dpi(5), right = dpi(5), bottom = dpi(1) },
			widget = wibox.container.margin,
		})
	end

	-------------------------------------------

	-- The dock visibility
	------------------------------------------------------------

	local hidden_y = awful.screen.focused().geometry.height
	local visible_y = awful.screen.focused().geometry.height - (dock.maximum_height + offset)

	-- animation when the dock is closed/opened
	local slide_animation = rubato.timed({
		duration = 0.35,
		pos = hidden_y,
		rate = 60,
		easing = rubato.easing.inOutSine,
		subscribed = function(pos)
			dock.y = pos
		end,
	})

	local function check_for_dock_hide()
		local clients = screen.selected_tag:clients()
		local should_hide = false

		for _, c in ipairs(clients) do
			if c.fullscreen or c.maximized then
				should_hide = true
				break
			end

			if not c.minimized then
				local y, h = c:geometry().y, c.height
				if (y + h) >= screen.geometry.height - 85 then
					should_hide = true
					break
				else
					should_hide = false
					break
				end
			end
		end

		if should_hide then
			slide_animation.target = hidden_y
			gears.timer.start_new(0.35, function()
				dock.visible = false
			end)
		else
			dock.visible = true
			slide_animation.target = visible_y
		end
	end

	-- a timer to check for dock hide
	local dockHide = gears.timer({
		timeout = 1,
		callback = function()
			slide_animation.target = visible_y
			when_no_apps_open(screen)
			check_for_dock_hide()
			dock:connect_signal("property::width", function()
				dock.x = screen.geometry.x + screen.geometry.width / 2 - dock.width / 2
			end)
		end,
	})
	dockHide:again()

	dock_helper:connect_signal("mouse::leave", function()
		dockHide:again()
	end)

	dock_helper:connect_signal("mouse::enter", function()
		dock:connect_signal("property::width", function()
			dock.x = screen.geometry.x + screen.geometry.width / 2 - dock.width / 2
		end)
		dock.visible = true
		slide_animation.target = visible_y
		dockHide:stop()
	end)

	dock:connect_signal("mouse::leave", function()
		dockHide:again()
	end)

	dock:connect_signal("mouse::enter", function()
		dockHide:stop()
	end)

	-- Eof dock visibility
	----------------------------------------------------------------------------
end
