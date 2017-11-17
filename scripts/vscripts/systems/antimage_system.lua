-- Manage and apply changes to Antimage's skills
if CAntimageSystem == nil then
	CAntimageSystem = class({})
end

-- Modifiers
LinkLuaModifier('modifier_antimage_noblink_manacost', 'modifiers/modifier_antimage_noblink_manacost', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_antimage_antimagic', 'modifiers/modifier_antimage_antimagic', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_antimage_antimagic_aura', 'modifiers/modifier_antimage_antimagic_aura', LUA_MODIFIER_MOTION_NONE)

-- Called when a player upgrades an ability
function CAntimageSystem:OnPlayerLearnedAbility(tData)
    local hPlayer = PlayerResource:GetPlayer(tData.player - 1)

    -- No player?
    if ( not hPlayer ) then
        return
    end

    local hHero = hPlayer:GetAssignedHero()

    -- We are only interested in Antimage
    if ( not hHero or hHero:GetClassname() ~= 'npc_dota_hero_antimage' ) then
        return
    end

    if ( tData.abilityname == 'antimage_bonus_antimagic_aura' ) then
        -- Antimagic Aura!
        local hAbility = hHero:FindAbilityByName('antimage_bonus_antimagic_aura')
        hHero:AddNewModifier(hHero, hAbility, 'modifier_antimage_antimagic', nil)
    elseif ( tData.abilityname == 'antimage_bonus_no_blink_manacost' ) then
        -- No Blink Manacost
        print('modifier_antimage_noblink_manacost')
        local hAbility = hHero:FindAbilityByName('antimage_blink')
        hHero:AddNewModifier(hHero, hAbility, 'modifier_antimage_noblink_manacost', nil)
    end
end