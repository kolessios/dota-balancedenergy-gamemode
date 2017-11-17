--
if CLuckyCoinSystem == nil then
	CLuckyCoinSystem = class({})
end

-- Someone has made a last hit
function CLuckyCoinSystem:OnLastHit(event)
	-- Only units
	if ( event.TowerKill == '1' ) then
		return
	end

	local victim = EntIndexToHScript(event.EntKilled)
	local player = PlayerResource:GetPlayer(event.PlayerID)

	-- No player?
	if ( not player ) then
		print("A last hit has been detected without a responsible player\n")
		return
	end

	-- Only creeps
	if ( not victim:IsCreep() ) then
		return
	end

	local killer = player:GetAssignedHero()

	-- No hero??
	if ( not killer ) then
		print("A last hit was detected without an assigned hero\n")
		return
    end

    self:Activate(victim, killer)
end

-- Look for heroes (allies of the killer) with the lucky_coin near the position of the victim
function CLuckyCoinSystem:Activate(victim, killer)
    local heroes = FindLuckyCoinsInRadius(killer:GetTeamNumber(), victim, 800.0)

    for _,hero in pairs(heroes) do
        -- The killer does not count
        if ( hero ~= killer ) then
            self:Cast(hero)
        end
	end
end

-- Applies the effects of the coin on the specific hero
function CLuckyCoinSystem:Cast(hHero)
    local hCoin = hHero:GetItem('item_lucky_coin')

    -- So...
    if ( not hCoin ) then
        print('[CLuckyCoinSystem:Cast] on a hero without lucky coin! \n')
        return
    end

    -- Not ready!
    if ( not hCoin:IsCooldownReady() ) then
        return
    end

    local iChance = 100

    if ( hHero:IsSupport() ) then
        iChance = hCoin:GetSpecialValueFor('chance_hero_support')
    else
        iChance = hCoin:GetSpecialValueFor('chance_hero_common')
    end

    local iLuck = RandomInt(1, 100)

    -- Without luck!
    if ( iLuck > iChance ) then
        print('[' .. hHero:GetClassname() .. '] Luck: ' .. iLuck .. ' - Chance: ' .. iChance)
        return
    end

    -- Go to cooldown
    hCoin:StartCooldown(hCoin:GetSpecialValueFor('cooldown_gold'))

    -- Additional gold
    local iGold = hCoin:GetSpecialValueFor('bonus_gold')

    -- Congratulations, your carry has done a last-hit
    hHero:ModifyGold(iGold, true, DOTA_ModifyGold_CreepKill)

    -- We increase the number of charges to reflect how much gold you have earned with the coin
    local charges = hCoin:GetCurrentCharges() + iGold
    hCoin:SetCurrentCharges(charges)

    -- Coin effect!
    local nCasterFX = ParticleManager:CreateParticle("particles/generic_gameplay/lasthit_coins_local.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero)
	ParticleManager:SetParticleControlEnt(nCasterFX, 1, hHero, PATTACH_ABSORIGIN_FOLLOW, nil, hHero:GetOrigin(), false)
	ParticleManager:ReleaseParticleIndex(nCasterFX)
end