local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

_G.MiniMap = _G.MiniMap or {}
MiniMap._path = ModPath
MiniMap._data_path = SavePath .. "jackets_minimap.txt"
MiniMap._data = {}
MiniMap._settings_changed = true

function MiniMap:Save()
	local file = io.open( self._data_path, "w+" )
	if file then
		file:write( json.encode( self._data ) )
		file:close()
		self._settings_changed = true
	end
end

function MiniMap:Load()
	local file = io.open( self._data_path, "r" )
	if file then
		self._data = json.decode( file:read("*all") )
		file:close()
		if type(self._data) ~= "table" then
			self._data = {}
		end
		self._settings_changed = true
	end
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_MiniMap", function( loc )
	loc:load_localization_file( MiniMap._path .. "loc.en.txt")
end)

Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_MiniMap", function( menu_manager )
	MenuCallbackHandler.callback_mm_toggle_key = function(self)
		MiniMap._data.mm_value = not MiniMap._data.mm_value
		MiniMap:Save()
		log("Keybind pressed, toggle is: " .. tostring(MiniMap._data.mm_value))
	end

	MenuCallbackHandler.callback_mm_toggle = function(self, item)
		MiniMap._data.mm_value = item:value() == "on" and true or false
		MiniMap:Save()
		log("Toggle is: " .. item:value())
	end

	MenuCallbackHandler.callback_mm_rotate = function(self, item)
		MiniMap._data.mm_rotate_value = item:value() == "on" and true or false
		MiniMap:Save()
		log("Rotate is: " .. item:value())
	end

	MenuCallbackHandler.callback_mm_stealth_only = function(self, item)
		MiniMap._data.mm_stealth_only_value = item:value() == "on" and true or false
		MiniMap:Save()
		log("Stealth only is: " .. item:value())
	end

	MenuCallbackHandler.callback_mm_zoom = function(self, item)
		MiniMap._data.mm_zoom_value = item:value()
		MiniMap:Save()
		log("Zoom is: " .. item:value())
	end

	MenuCallbackHandler.callback_mm_opacity = function(self, item)
		MiniMap._data.mm_opacity_value = item:value()
		MiniMap:Save()
		log("Opacity is: " .. item:value())
	end

	MenuCallbackHandler.callback_mm_horizontal_align = function(self, item)
		MiniMap._data.mm_horizontal_align_value = item:value()
		MiniMap:Save()
		log("Horizontal Align is: " .. item:value())
	end

	MenuCallbackHandler.callback_mm_horizontal_pos = function(self, item)
		MiniMap._data.mm_horizontal_pos_value = item:value()
		MiniMap:Save()
		log("Horizontal Pos is: " .. item:value())
	end

	MenuCallbackHandler.callback_mm_vertical_align = function(self, item)
		MiniMap._data.mm_vertical_align_value = item:value()
		MiniMap:Save()
		log("Vertical Align is: " .. item:value())
	end

	MenuCallbackHandler.callback_mm_vertical_pos = function(self, item)
		MiniMap._data.mm_vertical_pos_value = item:value()
		MiniMap:Save()
		log("Vertical Pos is: " .. item:value())
	end

	MenuCallbackHandler.callback_mm_size = function(self, item)
		MiniMap._data.mm_size_value = item:value()
		MiniMap:Save()
		log("Size is: " .. item:value())
	end

	MenuCallbackHandler.callback_mm_show_coords = function(self, item)
		MiniMap._data.mm_show_coords_value = item:value() == "on" and true or false
		MiniMap:Save()
		log("Show coords is: " .. item:value())
	end

	MiniMap:Load()

	MenuHelper:LoadFromJsonFile( MiniMap._path .. "menu/menu.json", MiniMap, MiniMap._data )

end )