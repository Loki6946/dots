local M = {}

-- Reusable Confirmation Modal
function M.show(message_header, message, on_confirm, on_cancel)
	local awful = require("awful")
	local wibox = require("wibox")
	local beautiful = require("beautiful")
	local rubato = require("modules.rubato")
	local dpi = beautiful.xresources.apply_dpi
	local helpers = require("helpers")

	-- Modal Container
	local modal = wibox({
		width = dpi(280),
		height = dpi(250),
		ontop = true,
		visible = false,
		type = "dialog",
		bg = beautiful.bg_3 .. "D9",
		border_width = dpi(1),
		border_color = beautiful.border_focus,
		shape = helpers.rrect(10),
	})

	-- Message Icon
	local icon_widget = wibox.widget({
		image = beautiful.warning_icon,
		resize = true,
		forced_height = dpi(64),
		forced_width = dpi(64),
		halign = "center",
		valign = "center",
		widget = wibox.widget.imagebox,
	})

	-- Message Title
	local message_title = wibox.widget({
		text = message_header or "Are you sure?",
		font = beautiful.font_var .. "Bold 11",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	-- Message Text
	local message_text = wibox.widget({
		text = message or "You cannot undo this action.",
		font = beautiful.font_var .. "10",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	-- Button Factory
	local function create_button(label, color, callback)
		local btn = wibox.widget({
			{
				{
					text = label,
					font = beautiful.font_var .. "11",
					align = "center",
					valign = "center",
					widget = wibox.widget.textbox,
				},
				margins = dpi(7),
				widget = wibox.container.margin,
			},
			bg = color,
			shape = helpers.rrect(6),
			widget = wibox.container.background,
		})

		-- Button Animation
		local anim = rubato.timed({
			pos = 0,
			rate = 60,
			intro = 0.1,
			duration = 0.2,
			easing = rubato.easing.inOutQuad,
			subscribed = function(pos)
				btn.opacity = 1 - pos * 0.3
			end,
		})

		btn:connect_signal("mouse::enter", function()
			anim.target = 1
		end)

		btn:connect_signal("mouse::leave", function()
			anim.target = 0
		end)

		btn:connect_signal("button::press", function()
			if callback then
				callback()
			end
			modal.visible = false
		end)

		helpers.hover_cursor(btn)

		return btn
	end

	-- Create Buttons
	local confirm_btn = create_button("Yes", beautiful.accent, on_confirm)
	local cancel_btn = create_button("No", beautiful.bg_2, on_cancel)

	modal:setup({
		{
			{
				{
					icon_widget,
					{
						message_title,
						message_text,
						spacing = dpi(10),
						layout = wibox.layout.fixed.vertical,
					},
					spacing = dpi(25),
					layout = wibox.layout.fixed.vertical,
				},
				top = dpi(10),
				widget = wibox.container.margin,
			},
			nil,
			{
				cancel_btn,
				confirm_btn,
				spacing = dpi(8),
				layout = wibox.layout.flex.horizontal,
			},
			layout = wibox.layout.align.vertical,
		},
		margins = dpi(18),
		widget = wibox.container.margin,
	})

	-- Center Modal
	awful.placement.centered(modal)

	-- Show Modal
	modal.visible = true

	return modal
end

return M
