-- The Lucky Coin
if item_lucky_coin == nil then
	item_lucky_coin = class({})
end

-- Indicates if the channeling has been interrupted
-- For now it is only used to decide how the teleportation effect will end.
item_lucky_coin._bInterrupted = false

-- Modifiers
LinkLuaModifier('modifier_lucky_coin', 'modifiers/modifier_lucky_coin', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_lucky_coin_teleporting', 'modifiers/modifier_lucky_coin_teleporting', LUA_MODIFIER_MOTION_NONE)

-- Returns the name of modifier applied passively.
function item_lucky_coin:GetIntrinsicModifierName()
    return 'modifier_lucky_coin'
end

-- Returns if the channeling has been interrupted
function item_lucky_coin:HasInterrupted()
    return self._bInterrupted
end

-- It is called when the item is activated
function item_lucky_coin:OnSpellStart()
    local hCaster = self:GetCaster()
    hCaster:AddNewModifier(hCaster, self, 'modifier_lucky_coin_teleporting', nil)
end

-- It is called when the channeling ends
function item_lucky_coin:OnChannelFinish(bInterrupted)
    -- Has it been interrupted?
    self._bInterrupted = bInterrupted

    local hCaster = self:GetCaster()

    -- Remove the teleportation effect
    hCaster:RemoveModifierByName('modifier_lucky_coin_teleporting')

    -- We teleport!
    if ( not bInterrupted ) then
        self:Teleport()
    end
end

-- Teleports the hero to his base
function item_lucky_coin:Teleport()
    local hCaster = self:GetCaster()

    if ( not hCaster ) then
        return
    end

    local vOrigin = Vector(0,0,0)

    if ( hCaster:GetTeamNumber() == DOTA_TEAM_GOODGUYS ) then
        vOrigin = Vector(-7129, -6627, 520.75)
    elseif ( hCaster:GetTeamNumber() == DOTA_TEAM_BADGUYS ) then
        vOrigin = Vector(7129, 6627, 520.75)
    end

    StartSoundEventFromPosition('Portal.Hero_Disappear', hCaster:GetAbsOrigin())
    StartSoundEventFromPosition('Portal.Hero_Appear', vOrigin)

    hCaster:SetAbsOrigin(vOrigin)
end