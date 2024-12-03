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
local apps = require("config.apps")
local colors = require("theme.colors.dark")

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
theme.icon_sharp = "Material Icons Sharp "
theme.icon_outlined = "Material Icons Outlined "
theme.icon_tone = "Material Icons TwoTone "

-- images
-- ~~~~~~
theme.notification_icon = assets.notification_icon
theme.awm_icon = assets.awm_icon
theme.control_center_icon = assets.control_center_icon
theme.health_icon = assets.health_icon
theme.album_art_fallback = assets.album_art_fallback
theme.music_art_fallback = assets.music_art_fallback
theme.pp = assets.pp

-- wallpaper
-- ~~~~~~~~~
theme.wallpaper = assets.wall

-- gaps/border thing
-- ~~~~~~~~~~~~~~~~~
theme.useless_gap = dpi(2)
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
theme.tooltip_bg = theme.bg_3

-- rounded corner
-- ~~~~~~~~~~~~~~
theme.rounded = dpi(12)

-- notifs
-- ~~~~~~
theme.notification_font = theme.font_var .. "11"
theme.notification_spacing = dpi(theme.useless_gap * 2.2)
theme.notification_border_width = dpi(0)

-- titlebar
-- ~~~~~~~~
theme.titlebar_bg_normal = theme.bg_2
theme.titlebar_bg_focus = theme.bg_3
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
theme.taglist_fg_focus = theme.fg_color
theme.taglist_fg_urgent = theme.accent
theme.taglist_fg_occupied = theme.fg_color
theme.taglist_fg_empty = theme.fg_color

-- drop down Menu
-- ~~~~~~~~~~~~~~
theme.menu_font = theme.font_var .. "9"
theme.menu_height = dpi(30)
theme.menu_border_radius = 200
theme.menu_width = dpi(200)

-- Layout icons
-- ~~~~~~~~~~~~
theme.layout_floating = gears.color.recolor_image(themes_path .. "default/layouts/floating.png", theme.fg_color)
theme.layout_tile = gears.color.recolor_image(assets.tile, theme.fg_color)
theme.layout_fairh = gears.color.recolor_image(assets.flair, theme.fg_color)
theme.layout_fairv = gears.color.recolor_image(assets.flair, theme.fg_color)
theme.layout_spiral = gears.color.recolor_image(themes_path .. "default/layouts/spiralw.png", theme.fg_color)
theme.layout_machi = gears.color.recolor_image(assets.machi, theme.fg_color)

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
theme.playerctl_ignore = { "firefox", "chromium", "brave" }
theme.playerctl_player = { "mpd", "%any" }
theme.playerctl_update_on_activity = true
theme.playerctl_position_update_interval = 1

-- topbar
-- ~~~~~~
theme.topbar_background = theme.bg_2 .. "99"

-- Awesome dock
-- ~~~~~~~~~~~~
theme.awesome_dock_size = 65
theme.awesome_dock_pinned = {
	{ "thunar" },
	{ "alacritty" },
	{ "galculator" },
	{ apps.web_browser, "zen_browser" },
	{ apps.music, "gnome-music" },
	{ "spotify", "spotify" },
	{ "code", "vscode" },
	{ apps.editor_cmd, "neovim" },
}
theme.awesome_dock_color_active = theme.fg_color .. "80"
theme.awesome_dock_color_bg = theme.bg_3 .. "99"
theme.awesome_dock_disabled = false
theme.awesome_dock_spacing = dpi(2)
theme.awesome_dock_offset = theme.useless_gap + 8
theme.awesome_dock_icon = "WhiteSur-dark"

-- init
-- ~~~~
require("beautiful").init(theme)
