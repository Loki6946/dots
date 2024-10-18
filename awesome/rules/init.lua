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
				"Google-chrome",
				"Code",
				"org.gnome.Nautilus",
				"obsidian",
			},
		},
		properties = { titlebars_enabled = false },
	})

	-- Music client
	ruled.client.append_rule({
		rule_any = { class = { "music" }, instance = { "music" } },
		properties = {
			floating = true,
			width = 900,
			height = 540,
			placement = helpers.centered_client_placement,
		},
	})
end)
