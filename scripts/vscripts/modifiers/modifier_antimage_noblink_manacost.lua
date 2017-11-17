-- Antimagic Aura
if modifier_antimage_noblink_manacost == nil then
	modifier_antimage_noblink_manacost = class({})
end

-- Returns the attributes and functions that the modifier will have
function modifier_antimage_noblink_manacost:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE
    }

    return funcs
end

-- Returns if it is a debuff
function modifier_antimage_noblink_manacost:IsDebuff()
    return false
end

-- Returns if the buff is hidden.
function modifier_antimage_noblink_manacost:IsHidden()
    return true
end

-- 
function modifier_antimage_noblink_manacost:AllowIllusionDuplicate()
    return true
end

--
function modifier_antimage_noblink_manacost:IsPermanent()
    return true
end

--
function modifier_antimage_noblink_manacost:IsPurgable()
    return false
end

--
function modifier_antimage_noblink_manacost:GetModifierPercentageManacost()
    return 100
end