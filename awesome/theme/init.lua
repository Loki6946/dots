-- requirements
-- ~~~~~~~~~~~~
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

-- misc/vars
-- ~~~~~~~~~
local assets = require("theme.assets")
local apps_icon_dir = home_var .. "/.config/awesome/theme/assets/apps/"
local apps = require("config.apps")
local colors = require("theme.colors.sequoia")

-- initial empty array
local theme = {}

-- foreground
-- ~~~~~~~~~~
theme.fg_color = colors.fg_color
theme.fg_2 = colors.fg_2
theme.fg_3 = colors.fg_3

-- backgrounds
-- ~~~~~~~~~~~
theme.bg_color = colors.bg_color
theme.bg_2 = colors.bg_2
theme.bg_3 = colors.bg_3

-- base green
-- ~~~~~~~~~~
theme.green = colors.green
theme.green_2 = colors.green_2
theme.green_3 = colors.green_3

-- base red
-- ~~~~~~~~
theme.red = colors.red
theme.red_2 = colors.red_2
theme.red_3 = colors.red_3

-- accents
-- ~~~~~~~
theme.accent = colors.accent
theme.accent_2 = colors.accent_2
theme.accent_3 = colors.accent_3

-- base
-- ~~~~~~~~~~
theme.black = colors.black
theme.white = colors.white

-- initial colors
-- ~~~~~~~~~~~~~~
theme.bg_normal = theme.bg_color
theme.bg_focus = theme.bg_2
theme.bg_urgent = theme.red_2
theme.bg_minimize = theme.bg_2
theme.bg_systray = theme.bg_c2

theme.fg_normal = theme.fg_color
theme.fg_focus = theme.fg_color
theme.fg_urgent = theme.bg_color
theme.fg_minimize = theme.bg_2

-- font vars
theme.font_var = "SF Pro Display "
theme.icon_var = "Material Icons "
theme.icon_round = "Material Icons Round "
theme.icon_sharp = "Material Icons Sharp "
theme.icon_outlined = "Material Icons Outlined "
theme.icon_tone = "Material Icons TwoTone "

-- images
-- ~~~~~~
theme.notification_icon = assets.notification_icon
theme.warning_icon = assets.warning_icon
theme.awm_icon = assets.awm_icon
theme.control_center_icon = assets.control_center_icon
theme.bolt_icon = assets.bolt_icon
theme.charge_icon = assets.charge_icon
theme.search_icon = assets.search_icon
theme.health_icon = assets.health_icon
theme.album_art_fallback = assets.album_art_fallback
theme.music_art_fallback = assets.music_art_fallback
theme.pp = assets.pp

-- wallpaper
-- ~~~~~~~~~
local wallpaper_directory = home_var .. "/.config/awesome/theme/assets/walls/"

local wallpapers = {
	{ name = "piazza-gae-aulenti", path = wallpaper_directory .. "piazza-gae-aulenti.jpg", color = "#070304" },
	{ name = "dreamscape", path = wallpaper_directory .. "dreamscape.jpg", color = theme.bg_color },
	{ name = "white-minimalist", path = wallpaper_directory .. "white-minimalist.jpg", color = "#F2F2F2" },
	{ name = "sun", path = wallpaper_directory .. "sun.jpg", color = "#F4F0E7" },
	{ name = "blue-sun", path = wallpaper_directory .. "blue-sun.png", color = "#31302C" },
	{ name = "moneterey", path = wallpaper_directory .. "moneterey-light-3.jpg", color = "#373737" },
	{ name = "ridge", path = wallpaper_directory .. "ridge.jpg", color = "#3739ae" },
	{ name = "black", path = wallpaper_directory .. "black.jpg", color = "#1E1E1E" },
	{ name = "grey", path = wallpaper_directory .. "grey.png", color = "#434343" },
	{ name = "mojave", path = wallpaper_directory .. "mojave.jpg", color = "#44388E" },
	{ name = "catalina", path = wallpaper_directory .. "catalina.jpg", color = "#293E6A" },
	{ name = "apple-black", path = wallpaper_directory .. "apple-black.png", color = "#000000" },
	{ name = "leaf", path = wallpaper_directory .. "leaf.jpg", color = "#000000" },
	{ name = "polygon", path = wallpaper_directory .. "polygon.jpg", color = "#000000" },
	{ name = "dark-grey", path = wallpaper_directory .. "dark-grey.jpg", color = "#363636" },
	{ name = "cube-mono", path = wallpaper_directory .. "cube-mono.jpg", color = "#0C0C0C" },
	{ name = "loupe-mono-dark", path = wallpaper_directory .. "loupe-mono-dark.jpg", color = "#131313" },
	{ name = "mono-dark-distortion-1", path = wallpaper_directory .. "mono-dark-distortion-1.jpg", color = "#0D0D0D" },
	{
		name = "mono-light-distortion-1",
		path = wallpaper_directory .. "mono-light-distortion-1.jpg",
		color = "#181818",
	},
	{ name = "sequoia-sunrise", path = wallpaper_directory .. "sequoia-sunrise.png", color = "#484F44" },
	{ name = "sonoma-horizon", path = wallpaper_directory .. "sonoma-horizon.png", color = "#E4E4DD" },
	{ name = "sonoma-clouds1", path = wallpaper_directory .. "sonoma-clouds1.png", color = "#E5DDBF" },
	{ name = "sonoma-clouds2", path = wallpaper_directory .. "sonoma-clouds2.png", color = "#DFDAC0" },
	{ name = "pro-black", path = wallpaper_directory .. "pro-black.png", color = "#000001" },
}

local function get_wallpaper(identifier)
	if type(identifier) == "number" then
		return wallpapers[identifier]
	elseif type(identifier) == "string" then
		for _, wallpaper in ipairs(wallpapers) do
			if wallpaper.name == identifier then
				return wallpaper
			end
		end
	end
	return nil
end

local function is_light_color(hex)
	local r, g, b = tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
	local brightness = (0.299 * r + 0.587 * g + 0.114 * b) / 255
	return brightness > 0.5
end

theme.selected_wallpaper = get_wallpaper("sonoma-horizon")
theme.wallpaper = theme.selected_wallpaper.path

-- menubar/taglist
-- ~~~~~~
theme.menubar_bg = theme.selected_wallpaper.color .. "CC"
if is_light_color(theme.selected_wallpaper.color) then
	theme.menubar_fg = theme.black
	theme.menubar_fg_2 = theme.bg_3
	theme.menubar_item_bg = theme.black .. "D9"
else
	theme.menubar_fg = theme.fg_color
	theme.menubar_fg_2 = theme.fg_2
	theme.menubar_item_bg = theme.fg_color
end

-- gaps/border thing
-- ~~~~~~~~~~~~~~~~~
theme.useless_gap = dpi(3)
theme.border_width = dpi(1)
theme.border_color = colors.border_color
theme.border_normal = colors.border_color
theme.border_focus = colors.border_color_active
theme.border_accent = colors.border_accent

-- tooltip
-- ~~~~~~~
theme.tooltip_border_width = dpi(1)
theme.tooltip_border_color = theme.border_accent
theme.tooltip_font = theme.font_var .. "10"
theme.tooltip_fg = theme.fg_color
theme.tooltip_bg = theme.bg_2 .. "F2"

-- rounded corner
-- ~~~~~~~~~~~~~~
theme.rounded = dpi(10)

-- notifs
-- ~~~~~~
theme.notification_font = theme.font_var .. "11"
theme.notification_spacing = dpi(theme.useless_gap * 2.2)
theme.notification_border_width = dpi(0)

-- titlebar
-- ~~~~~~~~
theme.titlebar_bg_normal = theme.bg_2
theme.titlebar_unfocused = colors.inactive_button
theme.titlebar_close = colors.close_button
theme.titlebar_close_hover = colors.close_button_hover
theme.titlebar_minimize = colors.minimize_button
theme.titlebar_minimize_hover = colors.minimize_button_hover
theme.titlebar_maximize = colors.maximize_button
theme.titlebar_maximize_hover = colors.maximize_button_hover
theme.titlebars_enabled = true

-- taglist
-- ~~~~~~~
theme.taglist_fg_focus = theme.menubar_fg
theme.taglist_fg_urgent = theme.red
theme.taglist_fg_occupied = theme.menubar_fg
theme.taglist_fg_empty = theme.menubar_fg

-- drop down Menu
-- ~~~~~~~~~~~~~~
theme.menu_font = theme.font_var .. "9"
theme.menu_height = dpi(30)
theme.menu_border_radius = 200
theme.menu_width = dpi(200)

-- Layout icons
-- ~~~~~~~~~~~~
theme.layout_floating = gears.color.recolor_image(themes_path .. "default/layouts/floating.png", theme.menubar_fg)
theme.layout_tile = gears.color.recolor_image(assets.tile, theme.menubar_fg)
theme.layout_fairh = gears.color.recolor_image(assets.flair, theme.menubar_fg)
theme.layout_fairv = gears.color.recolor_image(assets.flair, theme.menubar_fg)
theme.layout_spiral = gears.color.recolor_image(themes_path .. "default/layouts/spiralw.png", theme.menubar_fg)
theme.layout_machi = gears.color.recolor_image(assets.machi, theme.menubar_fg)

-- not in use layout
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"

-- Bling playerctl
-- ~~~~~~~~~~~~~~~
theme.playerctl_ignore = { "firefox", "brave" }
theme.playerctl_player = { "mpd", "chromium", "chromium.instance", "%any" }
theme.playerctl_update_on_activity = true
theme.playerctl_position_update_interval = 1

-- custom icons
-- ~~~~~~~~~~~~
theme.ic_icons = {
	["zen"] = apps_icon_dir .. "zen-browser.svg",
	["Alacritty"] = apps_icon_dir .. "alacritty.svg",
	["local-music"] = apps_icon_dir .. "music.svg",
	["Google-chrome"] = apps_icon_dir .. "chrome.svg",
	["neovim"] = apps_icon_dir .. "neovim.svg",
	["About-this-mc"] = apps_icon_dir .. "about-this-mc.svg",
	["com.mitchellh.ghostty"] = apps_icon_dir .. "ghostty.svg",
	["com.github.th_ch.youtube_music"] = apps_icon_dir .. "youtube-music.svg",
	["cursor"] = apps_icon_dir .. "cursor.svg",
	["Code"] = apps_icon_dir .. "vscode.svg",
	["Ld-linux-x86-64.so.2"] = apps_icon_dir .. "org.inkscape.Inkscape.svg",
	["org.gnome.Nautilus"] = apps_icon_dir .. "folder.svg",
	["gnome-calculator"] = apps_icon_dir .. "calculator.svg",
}

-- Awesome dock
-- ~~~~~~~~~~~~
theme.awesome_dock_size = 70
theme.awesome_dock_pinned = {
	{ apps.file_manager },
	{ "ghostty" },
	{ apps.web_browser, "zen-browser" },
	{ "youtube-music" },
	{ "code", "vscode" },
}
theme.awesome_dock_color_active = theme.fg_color
theme.awesome_dock_color_bg = theme.bg_2 .. "66"
theme.awesome_dock_color_border = theme.border_focus
theme.awesome_dock_disabled = false
theme.awesome_dock_spacing = dpi(5)
theme.awesome_dock_offset = dpi(10)
theme.awesome_dock_icon = "WhiteSur"

-- init
-- ~~~~
require("beautiful").init(theme)
