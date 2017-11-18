local LuckyCoinSystem = nil
local AntimageSystem = nil

-- 
if CBalancedGameMode == nil then
	CBalancedGameMode = class({})
end

-- Modifiers
LinkLuaModifier('modifier_global_boost', 'modifiers/modifier_global_boost', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_courier_speed', 'modifiers/modifier_courier_speed', LUA_MODIFIER_MOTION_NONE)

-- Initialize the Game Mode
function CBalancedGameMode:InitGameMode()
    -- System's
	LuckyCoinSystem = CLuckyCoinSystem()
	AntimageSystem = CAntimageSystem()
	
	-- Game Rules
	GameRules:SetGoldTickTime(0.3)
	GameRules:SetCustomGameSetupAutoLaunchDelay(20)
	GameRules:SetHeroSelectionTime(30)
	GameRules:SetStrategyTime(15)
	GameRules:SetPreGameTime(50)
	
	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen(8.0)
	--GameRules:GetGameModeEntity():SetFountainPercentageManaRegen(6.0)
	GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
    
	-- Events
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap( CBalancedGameMode, "OnGameRulesStateChange" ), self)
	ListenToGameEvent("last_hit", Dynamic_Wrap( CLuckyCoinSystem, "OnLastHit" ), LuckyCoinSystem)

	--ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap( CAntimageSystem, 'OnPlayerUsedAbility' ), AntimageSystem)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap( CAntimageSystem, 'OnPlayerLearnedAbility' ), AntimageSystem)

	-- Global Think
	GameRules:GetGameModeEntity():SetThink( 'OnThink', self, 'GlobalThink', 0.5 )
end

-- 
function CBalancedGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()

	print(nNewState)

	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:ApplyBotDifficulty()
		self:ApplyBoost()
	end
end

-- Evaluate the state of the game
function CBalancedGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		return self:OnThinkGameProgress()
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end

	return 1
end

-- 
function CBalancedGameMode:OnThinkGameProgress()
	self:CheckHeroes()
	self:ApplyCourierBoost()
	self:ApplyTrueSight()
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

-- Applies a modifier to the heroes to offer base benefits
function CBalancedGameMode:ApplyBoost()
	for _,hHero in pairs(HeroList:GetAllHeroes()) do
		if ( hHero:IsRealHero() ) then
			hHero:AddNewModifier(hHero, nil, 'modifier_global_boost', nil)
		end
	end
end

-- Applies the Bot difficulty for all bots
function CBalancedGameMode:ApplyBotDifficulty()
	for _,hHero in pairs(HeroList:GetAllHeroes()) do
		if ( hHero:IsRealHero() and PlayerResource:GetConnectionState(hHero:GetPlayerOwnerID()) == 1 ) then
			hHero:SetBotDifficulty(3) -- Hard
		end
	end
end

-- Applies a modifier to the couriers to increase their movement speed
function CBalancedGameMode:ApplyCourierBoost()
	local hCourier = Entities:FindByClassname(nil, 'npc_dota_courier')

	while hCourier do
		if ( not hCourier:HasModifier('modifier_courier_speed') ) then
			print('modifier_courier_speed')
			hCourier:AddNewModifier(hCourier, nil, 'modifier_courier_speed', nil)
		end

		hCourier = Entities:FindByClassname(hCourier, 'npc_dota_courier')
	end
end

-- Provide observers with true sight
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