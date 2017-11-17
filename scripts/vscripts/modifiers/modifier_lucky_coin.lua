-- Provides the attributes of the lucky coin
if modifier_lucky_coin == nil then
	modifier_lucky_coin = class({})
end

-- Returns the attributes and functions that the modifier will have
function modifier_lucky_coin:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }

    return funcs
end

-- Returns if the buff is hidden.
function modifier_lucky_coin:IsHidden()
    return true
end

-- Returns if it is a debuff
function modifier_lucky_coin:IsDebuff()
    return false
end

-- Returns the amount of health regeneration that will be provided
function modifier_lucky_coin:GetModifierConstantHealthRegen()
    local hCoin = self:GetAbility()
    return hCoin:GetSpecialValueFor('hp_regen')
end