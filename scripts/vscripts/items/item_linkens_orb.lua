-- Linkens Orb
if item_linkens_orb == nil then
	item_linkens_orb = class({})
end

-- Modifiers
LinkLuaModifier('modifier_item_linkens_orb', 'modifiers/modifier_item_linkens_orb', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_item_linkens_orb_absorb', 'modifiers/modifier_item_linkens_orb_absorb', LUA_MODIFIER_MOTION_NONE)

-- Returns the name of modifier applied passively.
function item_linkens_orb:GetIntrinsicModifierName()
    return 'modifier_item_linkens_orb'
end

-- It is called when the item is activated
function item_linkens_orb:OnSpellStart()
    local hCaster = self:GetCaster()
    hCaster:AddNewModifier(hCaster, self, 'modifier_item_linkens_orb_absorb', {duration = self:GetSpecialValueFor('duration')})
end