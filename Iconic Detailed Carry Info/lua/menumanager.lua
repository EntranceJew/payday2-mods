local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

Hooks:Add('LocalizationManagerPostInit', 'LocalizationManagerPostInit_IconicDetailedCarryInfo', function(loc)
	local language_filename

	local modname_to_language = {
		['PAYDAY 2 THAI LANGUAGE Mod'] = 'thai.txt',
	}
	for _, mod in pairs(BLT and BLT.Mods:Mods() or {}) do
		language_filename = mod:IsEnabled() and modname_to_language[mod:GetName()]
		if language_filename then
			break
		end
	end

	if not language_filename then
		for _, filename in pairs(file.GetFiles(IconicDetailedCarryInfo._path .. 'loc/')) do
			local str = filename:match('^(.*).txt$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				language_filename = filename
				break
			end
		end
	end

	if language_filename then
		loc:load_localization_file(IconicDetailedCarryInfo._path .. 'loc/' .. language_filename)
	end
	loc:load_localization_file(IconicDetailedCarryInfo._path .. 'loc/english.txt', false)
end)

Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_IconicDetailedCarryInfo', function(menu_manager)

	MenuCallbackHandler.IconicDetailedCarryInfoMenuCheckboxClbk = function(this, item)
		IconicDetailedCarryInfo.settings[item:name()] = item:value() == 'on'
	end

    MenuCallbackHandler.IconicDetailedCarryInfoMenuFloatClbk = function(this, item)
		IconicDetailedCarryInfo.settings[item:name()] = item:value()
	end

	MenuCallbackHandler.IconicDetailedCarryInfoMenuIntClbk = function(this, item)
		IconicDetailedCarryInfo.settings[item:name()] = math.floor(item:value())
	end

    MenuCallbackHandler.IconicDetailedCarryInfoMenuMultiClbk = function(this, item)
		IconicDetailedCarryInfo.settings[item:name()] = item:value()
	end

	MenuCallbackHandler.IconicDetailedCarryInfoSave = function(this, item)
		IconicDetailedCarryInfo:save()
	end

	IconicDetailedCarryInfo:load()

	MenuHelper:LoadFromJsonFile(IconicDetailedCarryInfo._path .. 'menu/options.txt', IconicDetailedCarryInfo, IconicDetailedCarryInfo.settings)

end)