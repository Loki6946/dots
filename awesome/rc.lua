-- awesome_mode: api-level=4:screen=on

-- load luarocks if installed
pcall(require, "luarocks.loader")

-- global variable
home_var = os.getenv("HOME")

-- autorun
require("misc")

-- lead theme
require("theme")

-- load key and mouse bindings
require("bindings")

-- load rules
require("rules")

-- load config
require("config.other")

-- load signals
require("signals")
