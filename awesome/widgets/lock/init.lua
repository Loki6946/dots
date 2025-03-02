local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local pam = require("liblua_pam")
local animation = require("modules.animation")
local helpers = require("helpers")

local os_getenv = os.getenv
local cache = {
	user = os_getenv("USER"),
	hostname = io.popen("uname -n"):read("*l"),
}

local auth = function(password)
	return pam.auth_current_user(password)
end

return function(s)
	local lock = wibox({
		screen = s,
		width = screen.primary.geometry.width,
		height = screen.primary.geometry.height,
		ontop = true,
		visible = false,
	})

	local profilepic = wibox.widget({
		{
			image = beautiful.pp,
			clip_shape = helpers.rrect(9999),
			halign = "center",
			forced_width = 70,
			forced_height = 70,
			widget = wibox.widget.imagebox,
		},
		{
			markup = cache.user .. "@" .. cache.hostname,
			font = beautiful.font_var .. "Bold 12",
			halign = "center",
			widget = wibox.widget.textbox,
		},
		spacing = 10,
		widget = wibox.layout.fixed.vertical,
	})

	local slide = animation:new({
		duration = 0.5,
		pos = -lock.height,
		easing = animation.easing.inOutExpo,
		update = function(_, poss)
			lock.y = poss
		end,
	})
	local slide_end = gears.timer({
		timeout = 1,
		single_shot = true,
		callback = function()
			lock.visible = false
		end,
	})

	local input = ""
	local star = ""
	local swiped = false
	local prompt = wibox.widget({
		{
			{
				id = "txt",
				markup = "Enter Password",
				font = beautiful.font_var .. "10",
				align = "center",
				halign = "center",
				widget = wibox.widget.textbox,
			},
			id = "bg",
			forced_width = 200,
			forced_height = 50,
			shape = helpers.rrect(50),
			widget = wibox.container.background,
			bg = beautiful.bg_color .. "88",
		},
		widget = wibox.container.place,
	})

	local bottom = wibox.widget({
		profilepic,
		spacing = 20,
		layout = wibox.layout.fixed.vertical,
	})

	local grabber = awful.keygrabber({
		auto_start = true,
		stop_event = "release",
		mask_event_callback = true,
		keypressed_callback = function(self, _, key, _)
			if key == "Escape" then
				if input == "" then
					self:stop()
					start_input:start()
					bottom:reset()
					bottom:add(profilepic)
					input = ""
					star = ""
				else
					input = ""
					star = ""
					helpers.gc(prompt, "txt"):set_markup("Enter Password")
					helpers.gc(prompt, "txt"):set_font(beautiful.font_var .. "12")
				end
			elseif #key == 1 then
				input = input .. key
				star = star .. "󰧞"
				helpers.gc(prompt, "bg"):set_bg(beautiful.bg_color .. "88")
				helpers.gc(prompt, "txt"):set_markup(star)
				helpers.gc(prompt, "txt"):set_font(beautiful.font_var .. "15")
			elseif key == "BackSpace" then
				if input == "" then
					self:stop()
					start_input:start()
					bottom:reset()
					bottom:add(profilepic)
					input = ""
					star = ""
				end
				input = input:sub(1, -2)
				star = star:sub(1, -5)
				if #input == 0 then
					input = ""
					star = ""
					helpers.gc(prompt, "txt"):set_markup("Enter Password")
					helpers.gc(prompt, "txt"):set_font(beautiful.font_var .. "12")
				else
					helpers.gc(prompt, "txt"):set_markup(star)
					helpers.gc(prompt, "txt"):set_font(beautiful.font_var .. "15")
				end
			elseif key == "Return" then
				if input ~= "" then
					if auth(input) then
						self:stop()
						slide_end:start()
						slide:set(-lock.height)
						start_input:stop()
						table.remove(bottom.children, 2)
						input = ""
						star = ""
						swiped = false
					else
						input = ""
						star = ""
						helpers
							.gc(prompt, "txt")
							:set_markup(helpers.colorize_text("Incorrect Password", beautiful.bg_color))
						helpers.gc(prompt, "txt"):set_font(beautiful.font_var .. "12")
						helpers.gc(prompt, "bg"):set_bg(beautiful.red)
						gears.timer.start_new(2, function()
							if input ~= "" then
								return false
							end
							helpers.gc(prompt, "txt"):set_markup("Enter Password")
							helpers.gc(prompt, "bg"):set_bg(beautiful.bg_color .. "88")
						end)
					end
				end
			end
		end,
	})

	start_input = awful.keygrabber({
		auto_start = true,
		stop_event = "release",
		keypressed_callback = function(self, _, key, _)
			if key == "Return" or key == " " then
				self:stop()
				bottom:add(prompt)
				grabber:start()
				input = ""
				star = ""
			elseif key == "XF86AudioRaiseVolume" then
				awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ +2%")
				volume_emit()
			elseif key == "XF86AudioLowerVolume" then
				awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ -2%")
				volume_emit()
			elseif key == "XF86AudioMute" then
				volume_toggle()
			end
		end,
	})

	local background = wibox.widget({
		image = beautiful.wallpaper,
		horizontal_fit_policy = "fit",
		vertical_fit_policy = "fit",
		widget = wibox.widget.imagebox,
		buttons = gears.table.join(
			awful.button({}, 4, function()
				if swiped then
					grabber:stop()
					start_input:start()
					bottom:reset()
					bottom:add(profilepic)
					input = ""
					star = ""
					swiped = false
				end
			end),
			awful.button({}, 5, function()
				if not swiped then
					start_input:stop()
					bottom:add(prompt)
					grabber:start()
					input = ""
					star = ""
					swiped = true
				end
			end)
		),
	})
	awesome.connect_signal("lock::change", function()
		background:set_image(beautiful.wallpaper)
	end)

	local time = wibox.widget({
		{
			font = beautiful.font_var .. "Medium 18",
			format = helpers.colorize_text("%A, %B %d", beautiful.white),
			halign = "center",
			widget = wibox.widget.textclock,
		},
		{
			font = beautiful.font_var .. "Medium 70",
			format = helpers.colorize_text("%H:%M", beautiful.white),
			halign = "center",
			widget = wibox.widget.textclock,
		},
		layout = wibox.layout.fixed.vertical,
	})

	lock:setup({
		background,
		{
			{
				time,
				nil,
				bottom,
				layout = wibox.layout.align.vertical,
			},
			top = 80,
			bottom = 80,
			widget = wibox.container.margin,
		},
		layout = wibox.layout.stack,
	})

	awesome.connect_signal("toggle::lock", function()
		if not lock.visible then
			lock.visible = true
			slide:set(0)
			start_input:start()
			helpers.gc(prompt, "txt"):set_markup("Enter Password")
			helpers.gc(prompt, "txt"):set_font(beautiful.font_var .. "12")
		end
	end)

	return lock
end
