local awful = require("awful")
local gtable = require("gears.table")
local gtimer = require("gears.timer")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi
local setmetatable = setmetatable
local ipairs = ipairs
local capi = { awesome = awesome, mouse = mouse, tag = tag }

local menu = { mt = {} }

function menu:set_pos(args)
	args = args or {}

	local coords = args.coords
	local wibox = args.wibox
	local widget = args.widget
	local offset = args.offset or { x = 0, y = 0 }

	if offset.x == nil then
		offset.x = 0
	end
	if offset.y == nil then
		offset.y = 0
	end

	local screen_workarea = awful.screen.focused().workarea
	local screen_w = screen_workarea.x + screen_workarea.width
	local screen_h = screen_workarea.y + screen_workarea.height

	if not coords and wibox and widget then
		coords = helpers.get_widget_geometry(wibox, widget)
	else
		coords = args.coords or capi.mouse.coords()
	end

	if coords.x + self.width > screen_w then
		if self.parent_menu ~= nil then
			self.x = coords.x - (self.width * 2) - offset.x
		else
			self.x = coords.x - self.width + offset.x
		end
	else
		self.x = coords.x + offset.x
	end

	if coords.y + self.height > screen_h then
		self.y = screen_h - self.height + offset.y
	else
		self.y = coords.y + offset.y
	end
end

function menu:hide_parents_menus()
	if self.parent_menu ~= nil then
		self.parent_menu:hide(true)
	end
end

function menu:hide_children_menus()
	if self.widget then
		for _, button in ipairs(self.widget.children) do
			if button.sub_menu ~= nil then
				button.sub_menu:hide()
			end
		end
	end
end

function menu:hide(hide_parents)
	if self.visible == false then
		return
	end

	-- Hide self
	self.visible = false

	-- Hides all child menus
	self:hide_children_menus()

	if hide_parents == true then
		self:hide_parents_menus()
	end
end

function menu:show(args)
	if self.visible == true then
		return
	end

	self.can_hide = false

	gtimer({
		timeout = 0.1,
		autostart = true,
		call_now = false,
		single_shot = true,
		callback = function()
			self.can_hide = true
		end,
	})

	-- Hide sub menus belonging to the menu of self
	if self.parent_menu ~= nil then
		for _, button in ipairs(self.parent_menu.widget.children) do
			if button.sub_menu ~= nil and button.sub_menu ~= self then
				button.sub_menu:hide()
			end
		end
	end

	self:set_pos(args)
	self.visible = true

	capi.awesome.emit_signal("menu::toggled_on", self)
end

function menu:toggle(args)
	if self.visible == true then
		self:hide()
	else
		self:show(args)
	end
end

function menu:add(widget)
	if widget.sub_menu then
		widget.sub_menu.parent_menu = self
	end
	widget.menu = self
	self.widget:add(widget)
end

function menu:remove(widget)
	self.widget:remove(widget)
end

function menu:reset()
	self.widget:reset()
end

function menu.menu(widgets, width)
	local widget = awful.popup({
		x = 32500,
		type = "menu",
		visible = false,
		ontop = true,
		minimum_width = width or dpi(160),
		maximum_width = width or dpi(180),
		shape = helpers.rrect(beautiful.rounded - 4),
		bg = beautiful.bg_2 .. "CC",
		border_width = dpi(1),
		border_color = beautiful.border_accent,
		widget = wibox.layout.fixed.vertical,
	})
	gtable.crush(widget, menu, true)

	awful.mouse.append_client_mousebinding(awful.button({ "Any" }, 1, function(c)
		if widget.can_hide == true then
			widget:hide(true)
		end
	end))

	awful.mouse.append_client_mousebinding(awful.button({ "Any" }, 3, function(c)
		if widget.can_hide == true then
			widget:hide(true)
		end
	end))

	awful.mouse.append_global_mousebinding(awful.button({ "Any" }, 1, function(c)
		if widget.can_hide == true then
			widget:hide(true)
		end
	end))

	awful.mouse.append_global_mousebinding(awful.button({ "Any" }, 3, function(c)
		if widget.can_hide == true then
			widget:hide(true)
		end
	end))

	capi.tag.connect_signal("property::selected", function(t)
		widget:hide(true)
	end)

	capi.awesome.connect_signal("menu::toggled_on", function(menu)
		if menu ~= widget and menu.parent_menu == nil then
			widget:hide(true)
		end
	end)

	for _, menu_widget in ipairs(widgets) do
		widget:add(menu_widget)
	end

	return widget
end

function menu.sub_menu_button(args)
	args = args or {}

	args.icon = args.icon or nil
	args.icon_size = args.icon_size or 12
	args.text = args.text or ""
	args.text_size = args.text_size or 10
	args.sub_menu = args.sub_menu or nil

	local icon = args.icon ~= nil
			and wibox.widget({
				font = args.icon.font .. " " .. args.icon_size,
				markup = helpers.colorize_text(args.icon.icon, beautiful.fg_color),
				widget = wibox.widget.textbox,
				halign = "start",
				forced_width = 40,
			})
		or nil

	local widget = wibox.widget({
		{
			{
				{
					id = "animate",
					widget = wibox.container.background,
					shape = helpers.rrect(5),
					bg = beautiful.accent,
					opacity = 0.0,
				},
				{
					{
						layout = wibox.layout.align.horizontal,
						spacing = dpi(0),
						-- icon,
						nil,
						{
							id = "text",
							font = beautiful.font_var .. args.text_size,
							markup = helpers.colorize_text(args.text, beautiful.fg_color),
							widget = wibox.widget.textbox,
							halign = "start",
						},
						{
							id = "icon",
							font = beautiful.icon_var .. "10",
							markup = helpers.colorize_text("", beautiful.fg_color),
							widget = wibox.widget.textbox,
							halign = "start",
						},
					},
					widget = wibox.container.margin,
					top = 5,
					right = 10,
					bottom = 5,
					left = 10,
				},
				layout = wibox.layout.stack,
			},
			widget = wibox.container.margin,
			margins = dpi(6),
		},
		widget = wibox.container.background,
	})

	widget:connect_signal("mouse::enter", function(self)
		local coords = helpers.get_widget_geometry(self.menu, self)
		coords.x = coords.x + self.menu.x + self.menu.width
		coords.y = coords.y + self.menu.y
		args.sub_menu:show({ coords = coords, offset = { x = -5 } })
		helpers.gc(widget, "animate").opacity = 1
		helpers.gc(widget, "text").font = beautiful.font_var .. "Semibold " .. args.text_size
	end)

	widget:connect_signal("mouse::leave", function()
		helpers.gc(widget, "animate").opacity = 0.0
		helpers.gc(widget, "text").font = beautiful.font_var .. args.text_size
	end)

	-- add buttons and commands
	widget:connect_signal("button::press", function()
		helpers.gc(widget, "animate").opacity = 1
	end)

	widget:connect_signal("button::release", function()
		helpers.gc(widget, "animate").opacity = 1
	end)

	helpers.hover_cursor(widget)

	widget.sub_menu = args.sub_menu

	return widget
end

function menu.button(args)
	args = args or {}

	args.icon = args.icon or nil
	args.icon_size = args.icon_size or 12
	args.image = args.image
	args.text = args.text or ""
	args.text_size = args.text_size or 10
	args.on_press = args.on_press or nil

	local icon = nil

	if args.icon ~= nil then
		icon = wibox.widget({
			font = args.icon.font .. " " .. args.icon_size,
			markup = helpers.colorize_text(args.icon.icon, beautiful.fg_color),
			widget = wibox.widget.textbox,
			halign = "start",
		})
	elseif args.image ~= nil then
		icon = wibox.widget({
			widget = wibox.widget.imagebox,
			image = args.image,
		})
	end

	local text_widget = wibox.widget({
		font = beautiful.font_var .. args.text_size,
		markup = helpers.colorize_text(args.text, beautiful.fg_color),
		widget = wibox.widget.textbox,
		halign = "start",
	})

	local widget = wibox.widget({
		{
			{
				{
					id = "animate",
					widget = wibox.container.background,
					shape = helpers.rrect(5),
					bg = beautiful.accent,
					opacity = 0.0,
				},
				{
					{
						layout = wibox.layout.fixed.horizontal,
						-- spacing = dpi(15),
						-- icon,
						text_widget,
					},
					widget = wibox.container.margin,
					top = 5,
					right = 10,
					bottom = 5,
					left = 10,
				},
				layout = wibox.layout.stack,
			},
			widget = wibox.container.margin,
			margins = dpi(5),
		},
		buttons = {
			awful.button({}, 1, function()
				args.on_press(menu, text_widget)
				menu:hide(true)
			end),
		},
		widget = wibox.container.background,
	})

	widget:connect_signal("mouse::enter", function(self)
		if self.menu.widget then
			self.menu:hide_children_menus()
		end
		helpers.gc(widget, "animate").opacity = 1
		text_widget.font = beautiful.font_var .. "Semibold " .. args.text_size
	end)

	widget:connect_signal("mouse::leave", function()
		helpers.gc(widget, "animate").opacity = 0.0
		text_widget.font = beautiful.font_var .. args.text_size
	end)

	-- add buttons and commands
	widget:connect_signal("button::press", function()
		helpers.gc(widget, "animate").opacity = 1
	end)

	widget:connect_signal("button::release", function()
		helpers.gc(widget, "animate").opacity = 1
	end)

	helpers.hover_cursor(widget)
	return widget
end

function menu.separator()
	return wibox.widget({
		widget = wibox.container.margin,
		top = 3,
		bottom = 3,
		left = 15,
		right = 15,
		{
			widget = wibox.widget.separator,
			forced_height = dpi(2),
			orientation = "horizontal",
			thickness = dpi(2),
			color = "#4A4A4E",
		},
	})
end

function menu.mt:__call(...)
	return menu.menu(...)
end

return setmetatable(menu, menu.mt)
