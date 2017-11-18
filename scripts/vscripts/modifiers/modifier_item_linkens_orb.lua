-- Linkens Orb
if modifier_item_linkens_orb == nil then
	modifier_item_linkens_orb = class({})
end

-- Returns the attributes and functions that the modifier will have
function modifier_item_linkens_orb:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }

    return funcs
end

-- Returns if the modifier is hidden.
function modifier_item_linkens_orb:IsHidden()
    return true
end

-- Returns if it is a debuff
function modifier_item_linkens_orb:IsDebuff()
    return false
end

--
function modifier_item_linkens_orb:AllowIllusionDuplicate()
    return true
end

--
function modifier_item_linkens_orb:IsPermanent()
    return false
end

--
function modifier_item_linkens_orb:IsPurgable()
    return false
end

-- Returns the amount of mana regeneration that will be provided
function modifier_item_linkens_orb:GetModifierConstantManaRegen()
    local hAbility = self:GetAbility()

    if ( not hAbility ) then
        return 0
    end

    return hAbility:GetSpecialValueFor('mana_regen')
end