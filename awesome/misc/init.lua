local awful = require("awful")

local function run_once(cmd)
	local findme = cmd
	local firstspace = cmd:find(" ")
	if firstspace then
		findme = cmd:sub(0, firstspace - 1)
	end
	awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd), false)
end

-- picom

run_once("picom --config $HOME/.config/awesome/misc/picom/panthom.conf &")

-- mpDris2

run_once("mpDris2")

-- fix mouse

run_once("xinput set-prop '14' 'libinput Accel Profile Enabled' 0 1 0")

-- wifi thing

run_once("nm-applet")

-- pulseaudio deamon

run_once("pulseaudio -D")

return autostart
