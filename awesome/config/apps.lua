local _M = {
	terminal = "ghostty",
	editor = "nvim",
	app_launcher = "rofi -show drun -theme ./.config/awesome/misc/rofi/raycast.rasi",
	music = "alacritty --class 'local-music' --config-file "
		.. home_var
		.. "/.config/alacritty/ncmpcpp.toml -e ncmpcpp ",
	file_manager = "nautilus",
	web_browser = home_var .. "/.local/share/AppImage/ZenBrowser.AppImage",
	system_info = "about-this-mc run",
}

_M.editor_cmd = _M.terminal .. " -e " .. _M.editor
_M.manual_cmd = _M.terminal .. " -e man awesome"

return _M
