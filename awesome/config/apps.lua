local _M = {
	terminal = "alacritty",
	editor = "nvim",
	app_launcher = "rofi -show drun -theme ./.config/awesome/misc/rofi/rofi.rasi",
	music = "alacritty --class 'music' --config-file " .. home_var .. "/.config/alacritty/ncmpcpp.toml -e ncmpcpp ",
	file_manager = "thunar",
	web_browser = home_var .. "/.local/share/AppImage/ZenBrowser.AppImage",
}

_M.editor_cmd = _M.terminal .. " -e " .. _M.editor
_M.manual_cmd = _M.terminal .. " -e man awesome"

return _M
