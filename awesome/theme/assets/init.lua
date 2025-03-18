-- sussy images
-- ~~~~~~~~~~~~

-- misc/vars
-- ~~~~~~~~~
local directory = home_var .. "/.config/awesome/theme/assets/"

-- init
-- ~~~~
return {
	-- images
	notification_icon = directory .. "images/notif.png",
	warning_icon = directory .. "images/warning.png",
	health_icon = directory .. "images/heart.png",
	awm_icon = directory .. "images/awm.png",
	album_art_fallback = directory .. "images/album-art.png",
	music_art_fallback = directory .. "images/music.png",
	pp = directory .. "images/pp.jpeg",

	--icons
	control_center_icon = directory .. "icons/control-centre.svg",
	search_icon = directory .. "icons/search.svg",
	bolt_icon = directory .. "icons/bolt.svg",
	charge_icon = directory .. "icons/charge.svg",

	-- layouts
	floating = directory .. "layouts/floating.png",
	flair = directory .. "layouts/flair.png",
	tile = directory .. "layouts/tile.png",
	machi = directory .. "layouts/layout-machi.png",
}
