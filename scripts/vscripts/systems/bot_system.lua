-- Manage the selection of Heroes and Bots.
if CBotSystem == nil then
	CBotSystem = class({})
end

-- Configuration
local MAX_PLAYERS_COUNT = 10
local BOT_DIFFICULTY = 3 -- Hard

-- Indicates the number of human players
local humanCount = 0

-- List of heroes that Bots can use
-- https://dota2.gamepedia.com/Bots#Lists_of_Heroes_used_by_bots
local botsHeroes = {
	'npc_dota_hero_axe',
	'npc_dota_hero_bane',
	'npc_dota_hero_bounty_hunter',
	'npc_dota_hero_bloodseeker',
	'npc_dota_hero_bristleback',
	'npc_dota_hero_chaos_knight',
	'npc_dota_hero_crystal_maiden',
	'npc_dota_hero_dazzle',
	'npc_dota_hero_death_prophet',
	'npc_dota_hero_dragon_knight',
	'npc_dota_hero_drow_ranger',
	'npc_dota_hero_earthshaker',
	'npc_dota_hero_jakiro',
	'npc_dota_hero_juggernaut',
	'npc_dota_hero_kunkka',
	'npc_dota_hero_lich',
	'npc_dota_hero_lina',
	'npc_dota_hero_lion',
	'npc_dota_hero_luna',
	'npc_dota_hero_necrolyte',
	'npc_dota_hero_oracle',
	'npc_dota_hero_phantom_assassin',
	'npc_dota_hero_pudge',
	'npc_dota_hero_razor',
	'npc_dota_hero_sand_king',
	'npc_dota_hero_nevermore',
	'npc_dota_hero_skywrath_mage',
	'npc_dota_hero_sniper',
	'npc_dota_hero_sven',
	'npc_dota_hero_tidehunter',
	'npc_dota_hero_tiny',
	'npc_dota_hero_vengefulspirit',
	'npc_dota_hero_viper',
	'npc_dota_hero_warlock',
	'npc_dota_hero_windrunner',
	'npc_dota_hero_witch_doctor',
	'npc_dota_hero_skeleton_king',
	'npc_dota_hero_zuus'
}

-- Initialization
function CBotSystem:Init()
    -- We get the amount of humans
    for i = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayer(i) then
            humanCount = humanCount + 1
        end
    end

    print('Human Players: ' .. humanCount)

    -- Fill empty slots with Bots
    self:AddBots()
end

-- Choose a random hero for players who have not selected their hero.
function CBotSystem:CheckPlayers()
	for i = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayer(i) then
            local hPlayer = PlayerResource:GetPlayer(i)

			if ( not PlayerResource:HasSelectedHero(i) ) then
				hPlayer:MakeRandomHeroSelection()
            end
		end
    end
end

-- Fill empty slots with Bots
function CBotSystem:AddBots()
    local availableSlots = (MAX_PLAYERS_COUNT - humanCount)

    if ( IsServer() and availableSlots > 0 ) then
        print('Adding bots in '.. availableSlots .. ' slots')

        for i=1, 5 do
            -- ???
            Tutorial:AddBot('npc_dota_hero_phantom_assassin', "", "", true)
            Tutorial:AddBot('npc_dota_hero_phantom_assassin', "", "", false)
        end
    end
end

-- Applies the Bot difficulty for all bots
function CBotSystem:SetDifficulty()
    Tutorial:StartTutorialMode()

	for _,hHero in pairs(HeroList:GetAllHeroes()) do
		if ( hHero:IsRealHero() and PlayerResource:GetConnectionState(hHero:GetPlayerOwnerID()) == 1 ) then
            hHero:SetBotDifficulty(BOT_DIFFICULTY)
            print('Setting the difficulty of ' .. hHero:GetClassname() .. ' to ' .. BOT_DIFFICULTY)
		end
	end
end

-- Applies a modifier to the heroes to offer base benefits
function CBotSystem:ApplyBoost()
	for _,hHero in pairs(HeroList:GetAllHeroes()) do
		if ( hHero:IsRealHero() ) then
            hHero:AddNewModifier(hHero, nil, 'modifier_global_boost', nil)
            print('Adding boost to ' .. hHero:GetClassname())
		end
	end
end

-- Evaluate the state of the game
function CBotSystem:Think()
    local flTime = GameRules:GetDOTATime(false, false)

    -- Late game!
    if ( flTime >= (60 * 15) ) then
        GameRules:GetGameModeEntity():SetBotsInLateGame(true)
        GameRules:GetGameModeEntity():SetBotsAlwaysPushWithHuman(true)
    else
        GameRules:GetGameModeEntity():SetBotsInLateGame(false)
        GameRules:GetGameModeEntity():SetBotsAlwaysPushWithHuman(false)
    end
end