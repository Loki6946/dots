local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")

gears.timer({
	timeout = 1800,
	call_now = false,
	autostart = true,
	callback = function()
		naughty.notify({
			app_name = "Awesome",
			title = "Health",
			text = "Hey its time to drink",
			image = beautiful.health_icon,
		})
	end,
})

gears.timer({
	timeout = 300,
	call_now = false,
	autostart = true,
	callback = function()
		naughty.notify({
			app_name = "Awesome",
			title = "Health",
			text = "Hey correct your posture",
			image = beautiful.health_icon,
		})
	end,
})
