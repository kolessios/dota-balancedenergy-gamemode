-- Set the new speed of the courier
if modifier_courier_speed == nil then
	modifier_courier_speed = class({})
end

-- Returns the attributes and functions that the modifier will have
function modifier_courier_speed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

-- Returns if the buff is hidden.
function modifier_courier_speed:IsHidden()
    return false
end

-- Returns if it is a debuff
function modifier_courier_speed:IsDebuff()
    return false
end

-- 
function modifier_courier_speed:AllowIllusionDuplicate()
    return false
end

--
function modifier_courier_speed:IsPermanent()
    return true
end

--
function modifier_courier_speed:IsPurgable()
    return false
end

-- Returns the amount of exp boost that will be provided
-- 100 = Normal XP
function modifier_courier_speed:GetModifierMoveSpeedBonus_Percentage()
    return 30
end