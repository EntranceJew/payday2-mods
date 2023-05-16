SkipAndAutoSelectPlus = SkipAndAutoSelectPlus or {}
SkipAndAutoSelectPlus.mod_path = SkipAndAutoSelectPlus.mod_path or ModPath
SkipAndAutoSelectPlus.save_path = SkipAndAutoSelectPlus.save_path or SavePath .. "skipandautoselectplus_settings.txt"
SkipAndAutoSelectPlus.settings = { -- Defaults from WolfHud.
	SKIP_STAT_SCREEN_DELAY = 3,
	SKIP_LOOT_SCREEN_DELAY = 5,
	SKIP_BLACK_SCREEN_DELAY = 1,
	SKIP_BLACK_SCREEN_DELAY_difficulty_screen_animation_compatibility = false,
}

function SkipAndAutoSelectPlus:save()
	local file = io.open(self.save_path,"w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function SkipAndAutoSelectPlus:load()
	local file = io.open(self.save_path, "r")
	if file then
		for k, v in pairs(json.decode(file:read("*all"))) do
			self.settings[k] = v
		end
	else
		self:save()
	end
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_SkipAndAutoSelectPlus", function( loc )
	-- no other languages, just load English
	loc:load_localization_file( SkipAndAutoSelectPlus.mod_path .. "localization/english.txt")
end)

SkipAndAutoSelectPlus:load()

--if string.lower(RequiredScript) == "lib/tweak_data/guitweakdata" then
-- 	local GuiTweakData_init_orig = GuiTweakData.init
-- 	function GuiTweakData:init(...)
-- 		GuiTweakData_init_orig(self, ...)
-- 		self.rename_max_letters = SkipAndAutoSelectPlus.settings.mask_weapon_name_max_letters
-- 		self.rename_skill_set_max_letters = SkipAndAutoSelectPlus.settings.skillset_max_letters
-- 	end
-- elseif string.lower(RequiredScript) == "lib/managers/menu/multiprofileitemgui" then
-- 	local init_orig = MultiProfileItemGui.init
-- 	function MultiProfileItemGui:init(...)
-- 		init_orig(self, ...)

-- 		self._max_length = SkipAndAutoSelectPlus.settings.profile_max_letters
-- 	end
if string.lower(RequiredScript) == "lib/managers/menu/stageendscreengui" then

	local update_original = StageEndScreenGui.update

	function StageEndScreenGui:update(t, ...)
		update_original(self, t, ...)
		if not self._button_not_clickable and SkipAndAutoSelectPlus.settings.SKIP_STAT_SCREEN_DELAY >= 0 then
			self._auto_continue_td = self._auto_continue_td or (t + SkipAndAutoSelectPlus.settings.SKIP_STAT_SCREEN_DELAY)
			if t >= self._auto_continue_td then
				managers.menu_component:post_event("menu_enter")
				game_state_machine:current_state()._continue_cb()
			end
		end
	end

elseif string.lower(RequiredScript) == "lib/managers/menu/lootdropscreengui" then

	local update_original = LootDropScreenGui.update

	function LootDropScreenGui:update(t, ...)
		update_original(self, t, ...)

		if not self._card_chosen then
			self:_set_selected_and_sync(2)
			self:confirm_pressed()
		end

		if not self._button_not_clickable and SkipAndAutoSelectPlus.settings.SKIP_LOOT_SCREEN_DELAY >= 0 then
			self._auto_continue_t = self._auto_continue_t or (t + SkipAndAutoSelectPlus.settings.SKIP_LOOT_SCREEN_DELAY)
			if t >= self._auto_continue_t then
				self:continue_to_lobby()
			end
		end
	end

elseif string.lower(RequiredScript) == "lib/states/ingamewaitingforplayers" then
	local update_original = IngameWaitingForPlayersState.update

	function IngameWaitingForPlayersState:update(t, ...)
		update_original(self, t, ...)

		local goal_time = SkipAndAutoSelectPlus.settings.SKIP_BLACK_SCREEN_DELAY
		if SkipAndAutoSelectPlus.settings.SKIP_BLACK_SCREEN_DELAY_difficulty_screen_animation_compatibility then
			if managers.job:has_active_job() then
				local difficulty = managers.job:current_difficulty_stars()
				for i = 1, difficulty do
					goal_time = goal_time + 0.4
				end
				if difficulty + 2 == #tweak_data.difficulties then
					goal_time = goal_time + 0.5
				end
			end
		end

		if self._skip_promt_shown and goal_time >= 0 then
			self._auto_continue_t = self._auto_continue_t or (t + goal_time)
			if t >= self._auto_continue_t then
				self:_skip()
			end
		end
	end
elseif string.lower(RequiredScript) == "lib/managers/menumanager" then
	Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_SkipAndAutoSelectPlus", function(menu_manager)
		MenuCallbackHandler.callback_skipandautoselectplus_SKIP_STAT_SCREEN_DELAY = function(self,item)
			SkipAndAutoSelectPlus.settings.SKIP_STAT_SCREEN_DELAY = tonumber(item:value())
		end

		MenuCallbackHandler.callback_skipandautoselectplus_SKIP_LOOT_SCREEN_DELAY = function(self,item)
			SkipAndAutoSelectPlus.settings.SKIP_LOOT_SCREEN_DELAY = tonumber(item:value())
		end

		MenuCallbackHandler.callback_skipandautoselectplus_SKIP_BLACK_SCREEN_DELAY = function(self,item)
			SkipAndAutoSelectPlus.settings.SKIP_BLACK_SCREEN_DELAY = tonumber(item:value())
		end

		MenuCallbackHandler.callback_skipandautoselectplus_SKIP_BLACK_SCREEN_DELAY_difficulty_screen_animation_compatibility = function(this, item)
			SkipAndAutoSelectPlus.settings.SKIP_BLACK_SCREEN_DELAY_difficulty_screen_animation_compatibility = item:value() == 'on'
		end

		MenuCallbackHandler.callback_skipandautoselectplus_close = function(self)
			SkipAndAutoSelectPlus:save()

			QuickMenu:new(
				managers.localization:text("skipandautoselectplus_restart_required"),
				managers.localization:text("skipandautoselectplus_restart_required_desc"),
				{
					{
						text = managers.localization:text("skipandautoselectplus_button_ok"),
						is_cancel_button = true
					}
				},
				true
			)
		end
		SkipAndAutoSelectPlus:load()
		MenuHelper:LoadFromJsonFile(SkipAndAutoSelectPlus.mod_path .. "menu/options.txt", SkipAndAutoSelectPlus, SkipAndAutoSelectPlus.settings)
	end)
end