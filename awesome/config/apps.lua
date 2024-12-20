local _M = {
	terminal = "alacritty",
	editor = "nvim",
	app_launcher = "rofi -show drun -theme ./.config/awesome/misc/rofi/spotlight-dark.rasi",
	music = "alacritty --class 'music' --config-file " .. home_var .. "/.config/alacritty/ncmpcpp.toml -e ncmpcpp ",
	file_manager = "thunar",
	web_browser = home_var .. "/.local/share/AppImage/ZenBrowser.AppImage",
	system_info = "about-this-mc run",
}

_M.editor_cmd = _M.terminal .. " --class 'neovim' " .. " -e " .. _M.editor
_M.manual_cmd = _M.terminal .. " -e man awesome"

return _M
