-- Provides the attributes of the lucky coin
if modifier_global_boost == nil then
	modifier_global_boost = class({})
end

-- Returns the attributes and functions that the modifier will have
function modifier_global_boost:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXP_RATE_BOOST,
        MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE
    }

    return funcs
end

-- Returns if the buff is hidden.
function modifier_global_boost:IsHidden()
    return true
end

-- Returns if it is a debuff
function modifier_global_boost:IsDebuff()
    return false
end

-- 
function modifier_global_boost:AllowIllusionDuplicate()
    return false
end

--
function modifier_global_boost:IsPermanent()
    return true
end

--
function modifier_global_boost:IsPurgable()
    return false
end

-- Returns the amount of exp boost that will be provided
function modifier_global_boost:GetModifierPercentageExpRateBoost()
    return 10
end

--
function modifier_global_boost:GetModifierPercentageRespawnTime()
    return 0.4
end