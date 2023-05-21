_G.IconicDetailedCarryInfo = _G.IconicDetailedCarryInfo or {}
IconicDetailedCarryInfo._path = ModPath
IconicDetailedCarryInfo._data_path = SavePath .. 'IconicDetailedCarryInfo.txt'
IconicDetailedCarryInfo.settings = {
    item_name_case = 2, -- upper, normal, lower
	show_worth_panel = true,
	colorize_sprint_indicator = true,
    scroll_phase_time = 50,
    scroll_phase_width = 0.5,
    scroll_phase_offset = 0.475,
}

function IconicDetailedCarryInfo:load()
	local file = io.open(self._data_path, 'r')
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
			self.settings[k] = v
		end
		file:close()
	end
end

function IconicDetailedCarryInfo:save()
	local file = io.open(self._data_path, 'w+')
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end