-----------------------------------------------------
-- Helper to get icons from a program/program name --
-----------------------------------------------------
-- created by Crylia
-- modified by saimoomedits

local icon_cache = {}

local function Get_icon(theme, client, program_string, class_string, is_steam)
	if not theme or not (client or program_string or class_string) then
		return home_var .. "/.icons/" .. theme .. "/apps/scalable/default-application.svg"
	end

	local clientName
	if is_steam then
		clientName = "steam_icon_" .. tostring(client) .. ".svg"
	elseif client then
		clientName = client.class and client.class:lower():gsub(" ", "") .. ".svg"
			or client.name and client.name:lower():gsub(" ", "") .. ".svg"
			or (client.icon and client.icon)
			or "default-application.svg"
	else
		clientName = (program_string or class_string) .. ".svg"
	end

	-- Check cache first
	for _, icon in ipairs(icon_cache) do
		if icon:match(clientName) then
			return icon
		end
	end

	-- Define icon directories for checking
	local iconDirs = {
		home_var .. "/.icons/" .. theme .. "/apps/scalable/",
		home_var .. "/.icons/" .. theme .. "/apps/scalable/", -- Uppercase fallback
	}

	-- Check both lowercase and uppercase variants
	for _, dir in ipairs(iconDirs) do
		local iconPath = dir .. clientName
		if io.open(iconPath, "r") then
			icon_cache[#icon_cache + 1] = iconPath
			return iconPath
		end
		clientName = clientName:gsub("^%l", string.upper) -- Uppercase fallback
	end

	-- Default icon as fallback
	return home_var .. "/.icons/" .. theme .. "/apps/scalable/default-application.svg"
end

return Get_icon
