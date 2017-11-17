-- Antimagic Aura
if modifier_antimage_antimagic_aura == nil then
	modifier_antimage_antimagic_aura = class({})
end

-- Returns the attributes and functions that the modifier will have
function modifier_antimage_antimagic_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
    }

    return funcs
end

-- Returns if it is a debuff
function modifier_antimage_antimagic_aura:IsDebuff()
    local hCaster = self:GetCaster()
    local hAffected = self:GetParent()

    if ( hCaster:GetTeamNumber() == hAffected:GetTeamNumber() ) then
        return false
    else
        return true
    end
end

-- Returns if the buff is hidden.
function modifier_antimage_antimagic_aura:IsHidden()
    return false
end

-- 
function modifier_antimage_antimagic_aura:AllowIllusionDuplicate()
    return false
end

--
function modifier_antimage_antimagic_aura:IsPermanent()
    return false
end

--
function modifier_antimage_antimagic_aura:IsPurgable()
    return false
end

-- 
function modifier_antimage_antimagic_aura:GetModifierTotalPercentageManaRegen()
    local hCaster = self:GetCaster()
    local hAffected = self:GetParent()
    local hAbility = self:GetAbility()

    if ( hCaster:GetTeamNumber() == hAffected:GetTeamNumber() ) then
        return hAbility:GetSpecialValueFor('mana_regen_allies')
    else
        return hAbility:GetSpecialValueFor('mana_regen_enemies')
    end
end