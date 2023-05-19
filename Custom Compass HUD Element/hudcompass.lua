if RequiredScript == "lib/managers/menumanager" then

	_G.CustomCompassHUDElement = {}
	CustomCompassHUDElement._save_path = SavePath .. "CustomCompassHUDElementSettings.txt"
	CustomCompassHUDElement._path = ModPath or "mods/Custom Compass HUD Element/"

	CustomCompassHUDElement.settings = {
		enabled = true,
		panel_compass_alpha = 1,
		panel_compass_width = 0.8,
		panel_compass_height = 16,
		panel_compass_spacing = 1,
		panel_compass_horizontal_align = 2,
		panel_compass_horizontal_pos = 0,
		panel_compass_vertical_align = 2,
		panel_compass_vertical_pos = 0,
		compass_color = "2EA1FF", --halo reach blue
		compass_color_bg = "2EA1FF",
		compass_bg_blend_mode = "add" --(non-exhaustive) options include "add", "sub", or "multiply" 
	}

	function CustomCompassHUDElement:IsEnabled()
		return self.settings.enabled
	end

	function CustomCompassHUDElement.get_cardinal(angle)
		angle = tostring(angle)
		local cardinal = {
			["0"] = "N",
			["45"] = "NE",
			["90"] = "E",
			["135"] = "SE",
			["180"] = "S",
			["225"] = "SW",
			["270"] = "W",
			["315"] = "NW",
			["360"] = "N",
		}
		return cardinal[angle] or angle
	end

	function CustomCompassHUDElement:Update(t,dt)
		local player = managers.player:local_player()
		if player then
			local rotlook = player:movement():m_head_rot()
			self:_set_compass(rotlook)
		end
	end

	function CustomCompassHUDElement:_create_khud_compass(hud)
		local debug = false

		self._hud = hud
		self._hud_panel = hud.panel
		local hud_panel = self._hud_panel

		local old_clip_panel = self._hud_panel:child('compass_clip_panel')
		if old_clip_panel then
			self._hud_panel:remove(old_clip_panel)
		end

		local compass_color = Color(self.settings.compass_color)
		local compass_color_bg = Color(self.settings.compass_color_bg)

		-- self.settings.panel_compass_spacing = 1
		self._element_width = hud_panel:w() * self.settings.panel_compass_width
		self._slice_width = self._element_width * self.settings.panel_compass_spacing
		self._res = 3
		self._full_width = self._slice_width * self._res
		-- self._slice_res = self._slice_width / self._element_width

		--[[
			at spacing = 4,
				the min width of the child element must be 1.5x the width of the clip panel
				0.125 + 1.00 + 1.25
			at spacing = 2,
				the min width of the child element must be 1.5x the width of the clip panel
				0.25 + 1.00 + 0.25
			at spacing = 1,
				the min width of the child element must be 2x the width of the clip_panel
				0.50 + 1.00 + 0.50 for rollover
			at spacing = 0.50,
				the min width of the child element must be 3.0x the width of the clip panel
				1.00 + 1.00 + 1.00
		]]

		local clip_panel = hud_panel:panel({
			name = "compass_clip_panel",
			x = 0,
			y = 0,
			w = self._element_width,
			h = hud_panel:h(),
		})
		clip_panel:set_top(0)
		clip_panel:set_left(0)

		local compass_h = self.settings.panel_compass_height

		local degrees = 360
		local tick_margin = self._slice_width / degrees

		local compass_panel = clip_panel:panel({
			name = "compass_panel",
			visible = true,
			layer = 0,
			x = 0,
			y = 0,
			w = self._full_width
		})
		compass_panel:set_left(0)
		compass_panel:set_top(0)
		local compass_strip = compass_panel:panel({
			-- align = "center",
			-- vertical = "center",
			name = "compass_strip",
			layer = 0,
			x = 0,
			h = compass_h * 3,
			w = self._full_width
		})
		compass_strip:set_left(0)
		compass_strip:set_top(0)

		local ticks = degrees * self._res

		local ammo_font = tweak_data.hud_players.ammo_font

		local alpha = 0.5
		for i = 0, ticks, 1 do
			local regional_color = Color.white
			if debug then
				if i < 360 then
					regional_color = Color.red
				elseif i >= 360 and i < 720 then
					regional_color = compass_color
				elseif i >= 720 then
					regional_color = Color.green
				end
			else
				regional_color = compass_color
			end
			if (i % (degrees / 4)) == 0 then --90
				alpha = 1
				local newtick = compass_strip:text({
					name = "direction_" .. tostring(i),
					color = regional_color,
					layer = 2,
					font = ammo_font,
					font_size = compass_h,
					x = (i * tick_margin),
					vertical = "top",
					y = compass_h * 1,
					alpha = alpha,
					text = self.get_cardinal(i % degrees)
				})
				local _,_,text_w,_ = newtick:text_rect()
				newtick:move(-text_w * 0.25)
			elseif (i % (degrees / 8)) == 0 then --45
				alpha = 0.75
				local newtick = compass_strip:text({
					name = "direction_" .. tostring(i),
					color = regional_color,
					layer = 2,
					font = ammo_font,
					font_size = compass_h * 0.75,
					x = (i * tick_margin),
					vertical = "top",
					y = compass_h * 1,
					alpha = alpha,
					text = self.get_cardinal(i % degrees)
				})
				local _,_,text_w,_ = newtick:text_rect()
				newtick:move(-text_w * 0.25)
			elseif (i % (degrees / 24)) == 0 then --15
				alpha = 0.5
				compass_strip:text({
					name = "direction_" .. tostring(i),
					color = regional_color,
					layer = 2,
					font = ammo_font,
					font_size = compass_h * 0.5,
					x = (i * tick_margin) + 4,
					alpha = alpha,
					text = self.get_cardinal(i % degrees)
				})
			else
				alpha = 0.25
			end
			compass_strip:text({
				name = "tick_" .. tostring(i),
				color = regional_color,
				layer = 1,
				font = ammo_font,
				font_size = compass_h,
				x = i * tick_margin,
				alpha = alpha,
				text = "|"
			})
		end
		alpha = 1
		local direction_indicator = compass_panel:text({
			name = "direction_indicator",
			color = compass_color,
			layer = 2,
			font = ammo_font,
			font_size = compass_h,
			x = self._element_width/2,
			vertical = "top",
			y = compass_h * 2,
			alpha = alpha,
			text = "^"
		})
		local _,_,text_w,_ = direction_indicator:text_rect()
		direction_indicator:move(-text_w * 0.25)
		local backdrop = compass_panel:rect({
			name = "backdrop",
			layer = 0,
			blend_mode = "sub",
			color = Color.black:with_alpha(0.5),
		})

		local shine = compass_panel:gradient({
			name = "khud_compass_shine",
			layer = 1,
			blend_mode = self.settings.compass_bg_blend_mode or "add",
			w = self._element_width,
			h = compass_h,
			valign = "grow",
			gradient_points = {
				0,
				Color(0,1,1,1), --argb
				0.3,
				compass_color_bg:with_alpha(0),
				0.5,
				compass_color_bg:with_alpha(0.2),
				0.8,
				compass_color_bg:with_alpha(0),
				1,
				Color(0,1,1,1)
			}
		})
		if debug then
			local debug_compass = compass_panel:rect({
				name = "debug_compass",
				visible = true,
				color = Color.red:with_alpha(0.1)
			})
			local debug_clip = clip_panel:rect({
				name = "debug_clip",
				visible = true,
				color = Color.blue:with_alpha(0.1)
			})
		end

		self._panel = compass_panel
		self._clip_panel = clip_panel

		return compass_panel
	end

	function CustomCompassHUDElement:_update_layout()
		-- self._clip_panel:set_w(self._hud_panel:w() * self.settings.panel_compass_width)
		self._clip_panel:set_center(
			self._hud_panel:w() * self.settings.panel_compass_horizontal_pos,
			self._hud_panel:h() * self.settings.panel_compass_vertical_pos
		)
		-- self._panel:set_center(self._parent:w() / 2, self._parent:h() / 2)

		if self.settings.panel_compass_horizontal_align == 1 then
			self._clip_panel:set_left(self._hud_panel:w() * self.settings.panel_compass_horizontal_pos)
		elseif self.settings.panel_compass_horizontal_align == 3 then
			self._clip_panel:set_right(self._hud_panel:w() * self.settings.panel_compass_horizontal_pos)
		end

		if self.settings.panel_compass_vertical_align == 1 then
			self._clip_panel:set_top(self._hud_panel:h() * self.settings.panel_compass_vertical_pos)
		elseif self.settings.panel_compass_vertical_align == 3 then
			self._clip_panel:set_bottom(self._hud_panel:h() * self.settings.panel_compass_vertical_pos)
		end
	end

	function CustomCompassHUDElement:_set_compass(veclook)
		local panel = self._panel:child('compass_strip')
		if panel and self:IsEnabled() then
			self._panel:set_left(0)
			panel:set_left(0)

			local yaw = veclook:yaw()
			local offset = -90
			-- shift north to 90 yaw look
			-- @TODO: patch in map rotation values here
			local ratio = ((yaw + (offset%360))/360)
			local position_shifter = 0
			position_shifter = position_shifter - (self._slice_width * 2)
			-- position the compass to put east on the leftmost edge
			-- [red | blue | green]
			--      ^
			position_shifter = position_shifter + (self._element_width/2)
			-- nudge the cardinal direction of interest to the center of the the meter
			position_shifter = position_shifter + (self._slice_width * ratio)
			-- respond to the current facing direction now we have our starting position
			panel:set_x(position_shifter)
		end
	end

	function CustomCompassHUDElement:_layout_compass_panel()
		local compass = self._panel
		if compass and alive(compass) then

			local settings = self.settings

			-- local strip = compass:child("compass_strip")

			local alpha = settings.panel_compass_alpha or 1

			compass:set_alpha(alpha)
			compass:set_visible(self:IsEnabled())

			self:_update_layout()
		end
	end

	function CustomCompassHUDElement:Load()
		local file = io.open(self._save_path, "r")
		if (file) then
			for k, v in pairs(json.decode(file:read("*all"))) do
				self.settings[k] = v
			end
		else
			self:Save() --create data in case there's no mod save data
		end
		return self.settings
	end

	function CustomCompassHUDElement:Save()
		local file = io.open(self._save_path,"w+")
		if file then
			file:write(json.encode(self.settings))
			file:close()
		end
	end

	Hooks:Add("MenuManagerInitialize", "customcompasshudelement_menumanagerinit", function(menu_manager)

		MenuCallbackHandler.callback_customcompasshudelement_onclosedmenu = function(self)
			CustomCompassHUDElement:Save()
		end
		MenuCallbackHandler.callback_customcompasshudelement_set_enabled = function(self,item)
			local value = item:value() == "on"
			CustomCompassHUDElement.settings.enabled = value
			if managers.hud then
				if value then
					managers.hud:add_updator("_update_hud_customcompasshudelement", callback(CustomCompassHUDElement,CustomCompassHUDElement,"Update"))
				else
					managers.hud:remove_updator("_update_hud_customcompasshudelement")
				end
			end
			CustomCompassHUDElement:_layout_compass_panel()
		end

		MenuCallbackHandler.callback_customcompasshudelement_set_alpha = function(self,item)
			local value = tonumber(item:value())
			CustomCompassHUDElement.settings.panel_compass_alpha = value
			CustomCompassHUDElement:_layout_compass_panel()
		end

		MenuCallbackHandler.callback_customcompasshudelement_horizontal_align = function(self,item)
			local value = tonumber(item:value())
			CustomCompassHUDElement.settings.panel_compass_horizontal_align = value
			CustomCompassHUDElement:_layout_compass_panel()
		end

		MenuCallbackHandler.callback_customcompasshudelement_horizontal_pos = function(self,item)
			local value = tonumber(item:value())
			CustomCompassHUDElement.settings.panel_compass_horizontal_pos = value
			CustomCompassHUDElement:_layout_compass_panel()
		end

		MenuCallbackHandler.callback_customcompasshudelement_vertical_align = function(self,item)
			local value = tonumber(item:value())
			CustomCompassHUDElement.settings.panel_compass_vertical_align = value
			CustomCompassHUDElement:_layout_compass_panel()
		end

		MenuCallbackHandler.callback_customcompasshudelement_vertical_pos = function(self,item)
			local value = tonumber(item:value())
			CustomCompassHUDElement.settings.panel_compass_vertical_pos = value
			CustomCompassHUDElement:_layout_compass_panel()
		end

		MenuCallbackHandler.callback_customcompasshudelement_width = function(self,item)
			local value = tonumber(item:value())
			CustomCompassHUDElement.settings.panel_compass_width = value
			local hud = CustomCompassHUDElement._hud or managers.hud and managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
			if hud then
				CustomCompassHUDElement:_create_khud_compass(hud)
				CustomCompassHUDElement:_layout_compass_panel()
			end
		end

		MenuCallbackHandler.callback_customcompasshudelement_spacing = function(self,item)
			local value = tonumber(item:value())
			CustomCompassHUDElement.settings.panel_compass_spacing = value
			local hud = CustomCompassHUDElement._hud or managers.hud and managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)
			if hud then
				CustomCompassHUDElement:_create_khud_compass(hud)
				CustomCompassHUDElement:_layout_compass_panel()
			end
		end

		MenuHelper:LoadFromJsonFile(CustomCompassHUDElement._path .. "options.txt", CustomCompassHUDElement, CustomCompassHUDElement.settings)

		CustomCompassHUDElement:Load()
	end)

	Hooks:Add("LocalizationManagerPostInit", "customcompasshudelement_localization", function( loc )
		loc:add_localized_strings({
			customcompasshudelement_title = "Custom Compass HUD Element",
			customcompasshudelement_desc = "Based on KineticHUD's Compass Standalone",
			customcompasshudelement_enabled_title = "Enabled",
			customcompasshudelement_enabled_desc = "Enable HUD Compass Panel",
			customcompasshudelement_alpha_title = "Opacity",
			customcompasshudelement_alpha_desc = "Higher numbers are more visible",
			customcompasshudelement_y_title = "Vertical Position",
			customcompasshudelement_y_desc = "HUD Compass Panel Y Position",

			customcompasshudelement_vertical_align_name = "Vertical Alignment",
			customcompasshudelement_vertical_align_desc = "Set the vertical alignment of the compass",
			customcompasshudelement_vertical_pos_name = "Vertical Position",
			customcompasshudelement_vertical_pos_desc = "Set the vertical position of the compass",
			customcompasshudelement_horizontal_align_name = "Horizontal Alignment",
			customcompasshudelement_horizontal_align_desc = "Set the horizontal alignment of the compass",
			customcompasshudelement_horizontal_pos_name = "Horizontal Position",
			customcompasshudelement_horizontal_pos_desc = "Set the horizontal position of the compass",
			customcompasshudelement_vertical_align_top = "Top",
			customcompasshudelement_vertical_align_center = "Center",
			customcompasshudelement_vertical_align_bottom = "Bottom",
			customcompasshudelement_horizontal_align_left = "Left",
			customcompasshudelement_horizontal_align_center = "Center",
			customcompasshudelement_horizontal_align_right = "Right",
			customcompasshudelement_width_name = "Width",
			customcompasshudelement_width_desc = "Set the horizontal space the compass should fill",
			customcompasshudelement_spacing_name = "Spacing",
			customcompasshudelement_spacing_desc = "Width between needles on the compass",
		})
	end)

elseif RequiredScript == "lib/managers/hudmanagerpd2" then

	Hooks:PostHook(HUDManager,"_create_assault_corner","customcompasshudelement_init_hud",function(self)
		local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2) --or _hud
		if hud then
			CustomCompassHUDElement:_create_khud_compass(hud)
			CustomCompassHUDElement:_layout_compass_panel()
			if CustomCompassHUDElement:IsEnabled() then
				self:add_updator("_update_hud_customcompasshudelement",callback(CustomCompassHUDElement,CustomCompassHUDElement,"Update"))
			end
		end
	end)

end