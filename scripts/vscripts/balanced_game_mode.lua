local LuckyCoinSystem = nil
local AntimageSystem = nil

-- 
if CBalancedGameMode == nil then
	CBalancedGameMode = class({})
end

-- Modifiers
LinkLuaModifier('modifier_global_boost', 'modifiers/modifier_global_boost', LUA_MODIFIER_MOTION_NONE)

-- Initialize the Game Mode
function CBalancedGameMode:InitGameMode()
    -- System's
	LuckyCoinSystem = CLuckyCoinSystem()
	AntimageSystem = CAntimageSystem()
	
	-- Game Rules
	GameRules:SetGoldTickTime(0.6)
	GameRules:SetCustomGameSetupAutoLaunchDelay(20)
	GameRules:SetHeroSelectionTime(31)
	GameRules:SetStrategyTime(15)
	GameRules:SetPreGameTime(40)
	
	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen(25.0)
	GameRules:GetGameModeEntity():SetFountainPercentageManaRegen(25.0)
    
	-- Events
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap( CBalancedGameMode, "OnGameRulesStateChange" ), self)
	ListenToGameEvent("last_hit", Dynamic_Wrap( CLuckyCoinSystem, "OnLastHit" ), LuckyCoinSystem)

	--ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap( CAntimageSystem, 'OnPlayerUsedAbility' ), AntimageSystem)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap( CAntimageSystem, 'OnPlayerLearnedAbility' ), AntimageSystem)

	-- Global Think
	GameRules:GetGameModeEntity():SetThink( 'OnThink', self, 'GlobalThink', 1.0 )
end

-- 
function CBalancedGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()

	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
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

-- Applies a modifier offering advantages
function CBalancedGameMode:ApplyBoost()
	for _,hHero in pairs(HeroList:GetAllHeroes()) do
		if ( hHero:IsRealHero() ) then
			hHero:AddNewModifier(hHero, nil, 'modifier_global_boost', nil)
		end
	end
end