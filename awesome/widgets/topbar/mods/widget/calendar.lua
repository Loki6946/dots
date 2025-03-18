local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")

local M = {}

local function datewidget(date, weekend, notIn)
	if notIn then
		return wibox.widget({})
	end

	return wibox.widget({
		markup = weekend and helpers.colorize_text(date, beautiful.fg_color) or date,
		align = "center",
		font = beautiful.font_var .. "Semibold 9",
		widget = wibox.widget.textbox,
	})
end

local function daywidget(day, weekend)
	return wibox.widget({
		markup = weekend and helpers.colorize_text(day, beautiful.fg_3) or day,
		align = "center",
		font = beautiful.font_var .. "Bold 10",
		widget = wibox.widget.textbox,
	})
end

local function currwidget(day)
	return wibox.widget({
		{
			{
				markup = helpers.colorize_text(day, beautiful.black),
				align = "center",
				font = beautiful.font_var .. "Semibold 9",
				widget = wibox.widget.textbox,
			},
			left = 3,
			right = 3,
			widget = wibox.container.margin,
		},
		shape = helpers.rrect(999),
		bg = beautiful.fg_color,
		widget = wibox.container.background,
	})
end

local theGrid = wibox.widget({
	forced_num_rows = 7,
	forced_num_cols = 7,
	vertical_spacing = 8,
	horizontal_spacing = 10,
	min_rows_size = 20,
	homogenous = true,
	layout = wibox.layout.grid,
})

local curr = os.date("*t")
local title_text = wibox.widget({
	font = beautiful.font_var .. "Bold 11",
	widget = wibox.widget.textbox,
	halign = "center",
})

local prev_button = wibox.widget({
	markup = helpers.colorize_text("", beautiful.fg_3),
	font = beautiful.icon_var .. "Bold 14",
	widget = wibox.widget.textbox,
	buttons = gears.table.join(awful.button({}, 1, function()
		curr = os.date("*t", os.time({ day = curr.day, month = curr.month - 1, year = curr.year }))
		M.updateCalendar(curr)
	end)),
})

local next_button = wibox.widget({
	markup = helpers.colorize_text("", beautiful.fg_3),
	font = beautiful.icon_var .. "Bold 14",
	widget = wibox.widget.textbox,
	buttons = gears.table.join(awful.button({}, 1, function()
		curr = os.date("*t", os.time({ day = curr.day, month = curr.month + 1, year = curr.year }))
		M.updateCalendar(curr)
	end)),
})

local title = wibox.widget({
	{
		prev_button,
		title_text,
		next_button,
		layout = wibox.layout.align.horizontal,
	},
	left = 15,
	right = 15,
	top = 5,
	widget = wibox.container.margin,
})

M.updateCalendar = function(date)
	title_text.markup = helpers.colorize_text(helpers.capitalize(os.date("%B %Y", os.time(date))), beautiful.fg_color)
	theGrid:reset()
	for _, w in ipairs({ "S", "M", "T", "W", "T", "F", "S" }) do
		theGrid:add(daywidget(w, w == "S"))
	end

	local firstDate = os.date("*t", os.time({ day = 1, month = date.month, year = date.year }))
	local lastDate = os.date("*t", os.time({ day = 0, month = date.month + 1, year = date.year }))
	local prevMonthLastDay = os.date("*t", os.time({ year = date.year, month = date.month, day = 0 })).day
	local offsetStart = firstDate.wday - 1
	local offsetEnd = 42 - lastDate.day - offsetStart

	local row, col = 2, firstDate.wday

	for day = prevMonthLastDay - offsetStart, prevMonthLastDay - 1 do
		theGrid:add(datewidget(day, false, true))
	end

	for day = 1, lastDate.day do
		local widget = day == date.day and currwidget(day) or datewidget(day, col == 1 or col == 7, false)
		theGrid:add_widget_at(widget, row, col)

		col = col == 7 and 1 or col + 1
		row = col == 1 and row + 1 or row
	end

	for day = 1, offsetEnd do
		theGrid:add(datewidget(day, false, true))
	end
end

M.updateCalendar(curr)

gears.timer({
	timeout = 86400,
	autostart = true,
	callback = function()
		curr = os.date("*t")
		M.updateCalendar(curr)
	end,
})

return function(s)
	local calendar = wibox({
		type = "menu",
		screen = s,
		width = 230,
		height = 243,
		bg = beautiful.bg_3 .. "D3",
		border_width = 1,
		border_color = beautiful.border_accent,
		shape = function(cr, width, height)
			gears.shape.infobubble(cr, width, height, 13, 8, 160)
		end,
		ontop = false,
		visible = false,
	})

	calendar:setup({
		{
			title,
			{ theGrid, widget = wibox.container.place, halign = "center" },
			spacing = 8,
			layout = wibox.layout.fixed.vertical,
		},
		widget = wibox.container.margin,
		margins = { top = 13, left = 5, bottom = 5, right = 5 },
	})

	helpers.place_widget(calendar, "top_right", 3, 0, 0, 5)
	helpers.popup_opacity(calendar, 0.3)

	awesome.connect_signal("widget::toggle", function()
		calendar.visible = not calendar.visible
	end)

	return calendar
end
