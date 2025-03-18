local awful = require("awful")
local ruled = require("ruled")
local helpers = require("helpers")

ruled.client.connect_signal("request::rules", function()
	-- All clients will match this rule.
	ruled.client.append_rule({
		id = "global",
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			screen = awful.screen.preferred,
			placement = awful.placement.centered + awful.placement.no_offscreen,
		},
	})

	-- Floating clients.
	ruled.client.append_rule({
		id = "floating",
		rule_any = {
			instance = { "copyq", "pinentry" },
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"Sxiv",
				"Tor Browser",
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true, placement = helpers.centered_client_placement },
	})

	--- Centered
	ruled.client.append_rule({
		id = "centered",
		rule_any = {
			type = {
				"dialog",
			},
			class = {},
			role = {
				"GtkFileChooserDialog",
				"conversation",
			},
		},
		properties = { placement = helpers.centered_client_placement },
	})

	-- Add titlebars to normal clients and dialogs
	ruled.client.append_rule({
		id = "titlebars",
		rule_any = { type = { "normal", "dialog" } },
		properties = { titlebars_enabled = true },
	})

	ruled.client.append_rule({
		rule_any = {
			class = {
				"zen-alpha",
				"zen-beta",
				"zen-twilight",
				"zen",
				"Google-chrome",
				-- "Code",
				"org.gnome.Nautilus",
				"obsidian",
				"Eog",
				"bottles",
				"Lutris",
				"Totem",
				"About-this-mc",
				"python3",
				"Dconf-editor",
				"gnome-calculator",
				"file-roller",
				"ghostty",
				"gnome-system-monitor",
				"Gnome-screenshot",
				"org.gnome.clocks",
				"Spotube",
				"Chromium-browser",
				"errands",
				-- "com.github.th_ch.youtube_music",
			},
		},
		properties = { titlebars_enabled = false },
	})

	ruled.client.append_rule({
		rule_any = {
			class = {
				-- "zen-alpha",
				-- "zen-beta",
				-- "zen-twilight",
				-- "zen",
				"About-this-mc",
				"Chromium-browser",
			},
		},
		properties = { border_width = 0 },
	})

	-- Music client
	ruled.client.append_rule({
		rule_any = { class = { "local-music" }, instance = { "local-music" } },
		properties = {
			floating = true,
			-- width = 900,
			-- height = 540,
			width = 510,
			height = 520,
			placement = helpers.centered_client_placement,
		},
	})

	-- calculator
	ruled.client.append_rule({
		rule_any = { class = { "Galculator" } },
		properties = {
			floating = true,
			width = 150,
			height = 480,
			placement = helpers.centered_client_placement,
		},
	})

	-- neovim
	ruled.client.append_rule({
		rule_any = { class = { "neovim" } },
		properties = {
			floating = true,
			height = 650,
			width = 1100,
			placement = helpers.centered_client_placement,
		},
	})

	-- Youtube music
	-- ruled.client.append_rule({
	-- 	rule_any = { class = { "com.github.th_ch.youtube_music" } },
	-- 	properties = {
	-- 		floating = true,
	-- 		width = 330,
	-- 		height = 590,
	-- 		placement = helpers.centered_client_placement,
	-- 	},
	-- })
end)
