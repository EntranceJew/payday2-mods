local key = ModPath .. '	' .. RequiredScript
if _G[key] then return else _G[key] = true end

DB:create_entry(
	Idstring('texture'),
	Idstring('guis/textures/idci/transporter_throw'),
	ModPath .. 'assets/transporter_throw.texture'
)

-- function HUDTemp:carry_weight_string(carry_id)
-- 	if carry_id == "coke_light" then
-- 		return "Very Light"
-- 	elseif carry_id == "light" then
-- 		return "Light"
-- 	elseif carry_id == "medium" or carry_id == "being" or carry_id == "explosives" then
-- 		return "Medium"
-- 	elseif carry_id == "heavy" or carry_id == "slightly_very_heavy" then
-- 		return "Heavy"
-- 	elseif carry_id == "very_heavy" then
-- 		return "Heavier"
-- 	elseif carry_id == "mega_heavy" then
-- 		return "Heaviest"
-- 	else
-- 		return "???"
-- 	end
-- end

local number_to_percent = function(value)
	return value and tostring(value * 100) .. "%" or "???"
end

-- function HUDTemp:carry_properties(carry_id, type)
-- 	if type == "sprint" then
-- 		return tweak_data.carry.types[carry_id].can_run and "O" or "X"
-- 	elseif type == "move" then
-- 		return tweak_data.carry.types[carry_id].move_speed_modifier and
-- 			tostring(tweak_data.carry.types[carry_id].move_speed_modifier * 100) .. "%" or "??"
-- 	elseif type == "jump" then
-- 		return tweak_data.carry.types[carry_id].jump_modifier and
-- 			tostring(tweak_data.carry.types[carry_id].jump_modifier * 100) .. "%" or "??"
-- 	elseif type == "throw" then
-- 		return tweak_data.carry.types[carry_id].throw_distance_multiplier and
-- 			tostring(tweak_data.carry.types[carry_id].throw_distance_multiplier * 100) .. "%" or "??"
-- 	end
-- end

Hooks:PostHook(HUDTemp, "show_carry_bag", "DetailedBagsPostShowCarryBag", function(self, carry_id, value)
	local bag_panel = self._temp_panel:child("bag_panel")

	local carry_data = tweak_data.carry[carry_id]
	local carry_type = tweak_data.carry.types[carry_data.type]

	local monetary_value = managers.experience:cash_string(
		managers.money:get_secured_bonus_bag_value(
			carry_id,
			tweak_data:get_value(
				"money_manager",
				"bag_value_multiplier",
				managers.job:has_active_job() and managers.job:current_job_and_difficulty_stars() or 1
			)
		)
	)

	local type_text = carry_data.name_id and managers.localization:text(carry_data.name_id)
	if IconicDetailedCarryInfo.settings.item_name_case == 1 then
		---@diagnostic disable-next-line: undefined-field
		type_text = utf8.to_upper(type_text)
	elseif IconicDetailedCarryInfo.settings.item_name_case == 3 then
		---@diagnostic disable-next-line: undefined-field
		type_text = utf8.to_lower(type_text)
	end
	-- local carrying_text = managers.localization:text("hud_carrying")

	local bag_text = self._bg_box:child("bag_text")
	bag_text:set_text("")
	bag_text:set_left(0)

	local row_height = bag_panel:h() / 2
	local show_worth = IconicDetailedCarryInfo.settings.show_worth_panel

	local top_font_size = row_height * 0.65
	local font_size = row_height * 0.8
	local box_width = bag_panel:w()
	local text_margin = 4

	self._real_box = bag_text:parent()

	if self._real_box:child('top_row') then
		self._real_box:remove(self._real_box:child('top_row'))
	end
	if self._real_box:child('bottom_row') then
		self._real_box:remove(self._real_box:child('bottom_row'))
	end

	local top_row = self._real_box:panel({
		name = "top_row",
        x = 0,
        y = 0,
        w = box_width,
        h = row_height
    })
	local bottom_row = self._real_box:panel({
		name = "bottom_row",
        x = 0,
		y = row_height,
        w = box_width,
        h = row_height
    })

	local top_row_width = show_worth and top_row:w()/2 or top_row:w()

	local panel_name = top_row:panel({
		name = "panel_name",
		visible = true,
		w = top_row_width,
		x = 0,
	})
	self._panel_name = panel_name

	local name_icon_size = math.min(
		panel_name:w() / 2,
		row_height
	)

	local name_texture, name_texture_rect = tweak_data.hud_icons:get_icon_or('pd2_loot', nil)
	panel_name:bitmap({
		name = "icon_panel_name",
		texture = name_texture,
		texture_rect = name_texture_rect,
		color = Color.white,
		alpha = 1,
		visible = true,
		x = 0,
		w = name_icon_size,
		h = name_icon_size,
		layer = 1,
	})

	local panel_panel_name = panel_name:panel({
		name = "panel_panel_name",
		visible = true,
		w = (panel_name:w() - name_icon_size),
		x = name_icon_size,
	})
	self._panel_panel_name = panel_panel_name

	self._text_panel_name = panel_panel_name:text({
		name = "text_panel_name",
		text = type_text,
		align = "left",
		vertical = "center",
		color = Color.white,
		x = 0,
		w = panel_name:w(),
		font = tweak_data.menu.pd2_large_font,
		font_size = top_font_size,
		layer = 1,
	})

	if show_worth then
		local panel_worth = top_row:panel({
			name = "panel_worth",
			visible = true,
			w = top_row_width,
			x = top_row_width,
		})

		local worth_icon_size = math.min(
			panel_worth:w() / 2,
			row_height
		)

		local worth_texture, worth_texture_rect = tweak_data.hud_icons:get_icon_or('equipment_plates', nil)
		panel_worth:bitmap({
			name = "icon_panel_worth",
			texture = worth_texture,
			texture_rect = worth_texture_rect,
			color = Color.white,
			alpha = 1,
			visible = true,
			x = 0,
			w = worth_icon_size,
			h = worth_icon_size,
			layer = 1,
		})

		panel_worth:text({
			name = "text_panel_worth",
			text = monetary_value,
			align = "left",
			vertical = "center",
			color = Color.white,
			x = worth_icon_size,
			w = (panel_worth:w() - worth_icon_size),
			font = tweak_data.menu.pd2_large_font,
			font_size = top_font_size,
			layer = 1,
		})
	end

	local concerns = {
		{ type = "move", color = Color.blue, key="move_speed_modifier",
			texture = 'guis/textures/pd2/skilltree/icons_atlas',
			texture_rect = {64, 512, 64, 64}
		},
		{ type = "jump", color = Color.green, icon = 'Other_H_Any_IWant', key="jump_modifier" },
		{ type = "throw", color = Color.red, icon = 'C_Escape_H_Garage_TheySeeMe', key="throw_distance_multiplier",
			texture = 'guis/textures/idci/transporter_throw',
			texture_rect = {0, 0, 64, 64}
		},
	}
	local segment_width = box_width / 3

	for i, concern in ipairs(concerns) do
		local panel = bottom_row:panel({
			name = "panel_" .. concern.type,
			visible = true,
			w = segment_width,
			x = segment_width * (i-1),
		})

		local icon_size = math.min(
			segment_width / 2,
			row_height
		)

		local concern_color = Color.white
		local texture, texture_rect = nil, nil
		if concern.icon then
			texture, texture_rect = tweak_data.hud_icons:get_icon_or(concern.icon, nil)
		end
		if concern.texture then
			texture = concern.texture
		end
		if concern.texture_rect then
			texture_rect = concern.texture_rect
		end

		if concern.type == "move" then
			if IconicDetailedCarryInfo.settings.colorize_sprint_indicator then
				concern_color = carry_type.can_run and Color.green or Color.red
			end
			if carry_type.can_run then
				texture_rect = {448, 192, 64, 64}
			end
		end

		panel:bitmap({
			name = "icon_" .. concern.type,
			texture = texture,
			texture_rect = texture_rect,
			color = concern_color,
			alpha = 1,
			visible = true,
			x = 0,
			w = icon_size,
			h = icon_size,
			layer = 1,
		})

		panel:text({
			name = "text_" .. concern.type,
			text = number_to_percent(carry_type[concern.key]),
			align = "left",
			vertical = "center",
			color = Color.white,
			x = icon_size + text_margin,
			w = segment_width - icon_size - text_margin,
			font = tweak_data.menu.pd2_large_font,
			font_size = font_size,
			layer = 1,
		})
	end

	self._text_panel_name:set_left(0)
	local _, _, w, _ = self._text_panel_name:text_rect()
	w = w + text_margin
	self._text_panel_name:set_w(w)

	self._panel_panel_name:animate(callback(self, self, "_animate_carry_label"), math.max(w - self._panel_panel_name:w(), 0))
end)

function HUDTemp:_animate_carry_label(panel, width)
	local t = 0
	local element = self._text_panel_name

	while true do
		t = t + coroutine.yield()
		element:set_left(width * (math.sin(90 + t * IconicDetailedCarryInfo.settings.scroll_phase_time) * IconicDetailedCarryInfo.settings.scroll_phase_width - IconicDetailedCarryInfo.settings.scroll_phase_offset))
	end
end
