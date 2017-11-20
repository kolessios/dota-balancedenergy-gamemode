local LuckyCoinSystem = nil
local AntimageSystem = nil
local RoshanSystem = nil
local BotSystem = nil

-- 
if CBalancedGameMode == nil then
	CBalancedGameMode = class({})
end

-- Modifiers
LinkLuaModifier('modifier_global_boost', 'modifiers/modifier_global_boost', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_courier_speed', 'modifiers/modifier_courier_speed', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_roshan_bonus', 'modifiers/modifier_roshan_bonus', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_roshan_bonus_burn', 'modifiers/modifier_roshan_bonus_burn', LUA_MODIFIER_MOTION_NONE)

--
function CBalancedGameMode:CreateSystems()
	if ( not LuckyCoinSystem ) then
		LuckyCoinSystem = CLuckyCoinSystem()
	end 

	if ( not AntimageSystem ) then
		AntimageSystem = CAntimageSystem()
	end 

	if ( not RoshanSystem ) then
		RoshanSystem = CRoshanSystem()
	end 

	if ( not BotSystem ) then
		BotSystem = CBotSystem()
	end
end

-- Initialize the Game Mode
function CBalancedGameMode:InitGameMode()
    -- System's
	self:CreateSystems()
	
	-- Game Rules
	GameRules:SetGoldTickTime(0.2)
	GameRules:SetCustomGameSetupAutoLaunchDelay(20)
	GameRules:SetHeroSelectionTime(30)
	GameRules:SetStrategyTime(15)
	GameRules:SetPreGameTime(50)
	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen(8.0)
	--GameRules:GetGameModeEntity():SetFountainPercentageManaRegen(6.0)
	GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
    
	-- Events
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap( CBalancedGameMode, 'OnGameRulesStateChange' ), self)
	ListenToGameEvent('last_hit', Dynamic_Wrap( CLuckyCoinSystem, 'OnLastHit' ), LuckyCoinSystem)
	ListenToGameEvent('entity_killed', Dynamic_Wrap( CRoshanSystem, 'OnEntityKilled' ), RoshanSystem)

	--ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap( CAntimageSystem, 'OnPlayerUsedAbility' ), AntimageSystem)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap( CAntimageSystem, 'OnPlayerLearnedAbility' ), AntimageSystem)

	-- Global Think
	GameRules:GetGameModeEntity():SetThink( 'OnThink', self, 'GlobalThink', 0.5 )
end

-- 
function CBalancedGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()

	if ( nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION ) then
		BotSystem:Init()
	elseif ( nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME ) then
		BotSystem:CheckPlayers()
	elseif ( nNewState == DOTA_GAMERULES_STATE_PRE_GAME ) then
		BotSystem:SetDifficulty()
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		BotSystem:ApplyBoost()
	end
end

-- Evaluate the state of the game
function CBalancedGameMode:OnThink()
	local nState = GameRules:State_Get()

	if IsInToolsMode() then
		-- This prevents us from having to restart the entire game mode to try new changes
		self:CreateSystems()
	end

	if ( nState == DOTA_GAMERULES_STATE_PRE_GAME ) then
		RoshanSystem:Init()
	end

	if ( nState == DOTA_GAMERULES_STATE_PRE_GAME or nState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS ) then
		self:CheckHeroes()
		self:ApplyTrueSight()
		self:ApplyCourierBoost()

		RoshanSystem:Think()
		BotSystem:Think()

		return 1
	elseif nState == DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end

	return 1
end

-- Constantly check the status of the heroes
function CBalancedGameMode:CheckHeroes()
	for _,hHero in pairs(HeroList:GetAllHeroes()) do
		if ( hHero:IsRealHero() and hHero:IsAlive() ) then
			-- This player has wards
			if ( hHero:HasItemInInventory("item_ward_observer") ) then
				self:CheckRefillWards(hHero)
			end
		end
	end
end

-- Applies a modifier to the couriers to increase their movement speed
function CBalancedGameMode:ApplyCourierBoost()
	local hCourier = Entities:FindByClassname(nil, 'npc_dota_courier')

	while hCourier do
		if ( not hCourier:HasModifier('modifier_courier_speed') ) then
			hCourier:AddNewModifier(hCourier, nil, 'modifier_courier_speed', nil)
			print('Adding speed boost to courier!')
		end

		hCourier = Entities:FindByClassname(hCourier, 'npc_dota_courier')
	end
end

-- Provide observer wards with true sight
function CBalancedGameMode:ApplyTrueSight()
	local hWard = Entities:FindByClassname(nil, 'npc_dota_ward_base')
	
	while hWard do
		if ( not hWard:HasModifier('modifier_truesight_aura') ) then		
			hWard:AddNewModifier(hWard, nil, 'modifier_item_ward_true_sight', nil)
			hWard:AddNewModifier(hWard, nil, 'modifier_truesight_aura', nil)
		end

		hWard = Entities:FindByClassname(hWard, 'npc_dota_ward_base')
	end
end