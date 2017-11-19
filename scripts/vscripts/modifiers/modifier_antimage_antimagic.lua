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

-- True/false if this modifier is active on illusions.
function modifier_antimage_antimagic:AllowIllusionDuplicate()
    return true
end

-- Return the types of attributes applied to this modifier (enum value from DOTAModifierAttribute_t)
function modifier_antimage_antimagic:GetAttributes()
    return MODIFIER_ATTRIBUTE_NONE
end

-- Return the attach type of the particle system from GetEffectName.
function modifier_antimage_antimagic:GetEffectAttachType()
    return PATTACH_ROOTBONE_FOLLOW
end

-- Return the name of the particle system that is created while this modifier is active.
function modifier_antimage_antimagic:GetEffectName()
    return 'particles/items2_fx/antimagic_owner.vpcf'
end

-- Return the priority of the modifier, see MODIFIER_PRIORITY_*.
function modifier_antimage_antimagic:GetPriority()
    return MODIFIER_PRIORITY_NORMAL
end

-- Return the name of the buff icon to be shown for this modifier.
function modifier_antimage_antimagic:GetTexture()
    return 'antimage_mana_break'
end

-- True/false if this modifier should be displayed as a debuff.
function modifier_antimage_antimagic:IsDebuff()
    return false
end

-- True/false if this modifier should be displayed on the buff bar.
function modifier_antimage_antimagic:IsHidden()
    return true
end

-- True/false if this modifier can be purged.
function modifier_antimage_antimagic:IsPurgable()
    return false
end

-- True/false if this modifier is considered a stun for purge reasons.
function modifier_antimage_antimagic:IsStunDebuff()
    return false
end

-- True/false if this modifier is an aura.
function modifier_antimage_antimagic:IsAura()
    return true
end

-- The name of the secondary modifier that will be applied by this modifier (if it is an aura).
function modifier_antimage_antimagic:GetModifierAura()
    return 'modifier_antimage_antimagic_aura'
end

-- Return the range around the parent this aura tries to apply its buff.
function modifier_antimage_antimagic:GetAuraRadius()
    local hAbility = self:GetAbility()
    return hAbility:GetCastRange()
end

-- Return the unit flags this aura respects when placing buffs.
function modifier_antimage_antimagic:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MANA_ONLY
end

-- Return the teams this aura applies its buff to.
function modifier_antimage_antimagic:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

-- Return the unit classifications this aura applies its buff to.
function modifier_antimage_antimagic:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end