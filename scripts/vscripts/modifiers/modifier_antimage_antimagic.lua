-- Antimagic Aura
if modifier_antimage_antimagic == nil then
	modifier_antimage_antimagic = class({})
end

-- Returns the attributes and functions that the modifier will have
function modifier_antimage_antimagic:DeclareFunctions()
    local funcs = {
    }

    return funcs
end

-- Returns if it is a debuff
function modifier_antimage_antimagic:IsDebuff()
    return false
end

-- Returns if the buff is hidden.
function modifier_antimage_antimagic:IsHidden()
    return true
end

-- 
function modifier_antimage_antimagic:AllowIllusionDuplicate()
    return true
end

--
function modifier_antimage_antimagic:IsPermanent()
    return true
end

--
function modifier_antimage_antimagic:IsPurgable()
    return false
end

--
function modifier_antimage_antimagic:IsAura()
    return true
end

--
function modifier_antimage_antimagic:GetModifierAura()
    return 'modifier_antimage_antimagic_aura'
end

--
function modifier_antimage_antimagic:GetAuraRadius()
    local hAbility = self:GetAbility()
    return hAbility:GetCastRange()
end

--
function modifier_antimage_antimagic:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MANA_ONLY
end

--
function modifier_antimage_antimagic:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

--
function modifier_antimage_antimagic:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BASIC
end