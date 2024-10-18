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

-- initial empty array
local theme = {}

-- foreground
-- ~~~~~~~~~~
theme.fg_color = "#ccd0d9"
theme.fg_2 = "#98a0b3"

-- backgrounds
-- ~~~~~~~~~~~
theme.bg_color = "#101012"
theme.bg_2 = "#161719"
theme.bg_3 = "#1e1e21"

-- base green
-- ~~~~~~~~~~
theme.green = "#6acc85"
theme.green_2 = theme.green .. "99"
theme.green_3 = "#1e2720"

-- base red
-- ~~~~~~~~
theme.red = "#F2B8B5"
theme.red_2 = "#F85E4D"
theme.red_3 = "#F9DEDC"

-- base black
-- ~~~~~~~~~~
theme.black = "#000000"

-- accents
-- ~~~~~~~
theme.accent = "#8ab4f8"
theme.accent_2 = theme.accent .. "66"
theme.accent_3 = "#4a5861"

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
theme.icon_alt_var = "Material Icons Outlined "

-- images
-- ~~~~~~
theme.notification_icon = assets.notification_icon
theme.awm_icon = assets.awm_icon
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

-- rounded corner
-- ~~~~~~~~~~~~~~
theme.rounded = dpi(12)

-- notifs
-- ~~~~~~
theme.notification_font = theme.font_var .. "12"
theme.notification_spacing = dpi(theme.useless_gap * 2.2)
theme.notification_border_width = dpi(0)

-- titlebar
-- ~~~~~~~~
theme.titlebar_bg_normal = theme.bg_color
theme.titlebar_bg_focus = theme.bg_color
theme.titlebar_unfocused = "#252628"
theme.titlebar_close = "#FF6057"
theme.titlebar_maximize = "#27C840"
theme.titlebar_minimize = "#FDBD2E"
theme.titlebars_enabled = true

-- taglist
-- ~~~~~~~
-- theme.taglist_bg = theme.bg_color
-- theme.taglist_bg_focus = theme.bg_3
-- theme.taglist_fg_focus = theme.accent
-- theme.taglist_bg_urgent = theme.red_color
-- theme.taglist_fg_urgent = theme.red_2
-- theme.taglist_bg_occupied = theme.bg_color
-- theme.taglist_fg_occupied = theme.fg_color
-- theme.taglist_bg_empty = theme.bg_color
-- theme.taglist_fg_empty = theme.fg_color .. "66"
-- theme.taglist_disable_icon = true

-- another taglist
-- ~~~~~~~
theme.taglist_bg_focus = theme.black .. "00"
theme.taglist_fg_focus = theme.fg_color
theme.taglist_fg_urgent = theme.red_2
theme.taglist_fg_occupied = theme.fg_color .. "E6"
theme.taglist_fg_empty = theme.fg_color .. "80"
theme.taglist_disable_icon = true

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

-- Awesome dock
-- ~~~~~~~~~~~~
theme.awesome_dock_size = 61
theme.awesome_dock_pinned = {
	{ "thunar" },
	{ "alacritty" },
	{ apps.web_browser, "zen_browser" },
	{ apps.music, "gnome-music" },
	{ apps.editor_cmd, "neovim" },
	{ "code", "vscode" },
}
theme.awesome_dock_color_active = theme.accent_3
theme.awesome_dock_color_inactive = theme.fg_color .. "66"
theme.awesome_dock_color_minimized = theme.accent .. "33"
theme.awesome_dock_color_hover = theme.fg_color .. "33"
theme.awesome_dock_color_bg = theme.bg_color .. "99"
theme.awesome_dock_disabled = false
theme.awesome_dock_spacing = dpi(2)
theme.awesome_dock_offset = theme.useless_gap * 3
theme.awesome_dock_timeout = 1.2

-- init
-- ~~~~
require("beautiful").init(theme)
