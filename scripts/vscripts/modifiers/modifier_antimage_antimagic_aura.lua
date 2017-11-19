-- Antimagic Aura
if modifier_antimage_antimagic_aura == nil then
	modifier_antimage_antimagic_aura = class({})
end

-- Returns the attributes and functions that the modifier will have
function modifier_antimage_antimagic_aura:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP
    }

    return funcs
end

-- True/false if this modifier is active on illusions.
function modifier_antimage_antimagic_aura:AllowIllusionDuplicate()
    return false
end

-- Return the types of attributes applied to this modifier (enum value from DOTAModifierAttribute_t)
function modifier_antimage_antimagic_aura:GetAttributes()
    return MODIFIER_ATTRIBUTE_NONE
end

-- Return the attach type of the particle system from GetEffectName.
function modifier_antimage_antimagic_aura:GetEffectAttachType()
    return PATTACH_ROOTBONE_FOLLOW
end

-- Return the name of the particle system that is created while this modifier is active.
function modifier_antimage_antimagic_aura:GetEffectName()
    return 'particles/items2_fx/antimagic.vpcf'
end

-- Return the priority of the modifier, see MODIFIER_PRIORITY_*.
function modifier_antimage_antimagic_aura:GetPriority()
    return MODIFIER_PRIORITY_NORMAL
end

-- Return the name of the buff icon to be shown for this modifier.
function modifier_antimage_antimagic_aura:GetTexture()
    return 'antimage_mana_break'
end

-- True/false if this modifier should be displayed as a debuff.
function modifier_antimage_antimagic_aura:IsDebuff()
    local hCaster = self:GetCaster()
    local hAffected = self:GetParent()

    if ( not hCaster ) then
        return false
    end

    if ( hCaster:GetTeamNumber() == hAffected:GetTeamNumber() ) then
        return false
    else
        return true
    end
end

-- True/false if this modifier should be displayed on the buff bar.
function modifier_antimage_antimagic_aura:IsHidden()
    return false
end

-- True/false if this modifier can be purged.
function modifier_antimage_antimagic_aura:IsPurgable()
    return false
end

-- True/false if this modifier is considered a stun for purge reasons.
function modifier_antimage_antimagic_aura:IsStunDebuff()
    return false
end

-- Think!
function modifier_antimage_antimagic_aura:OnIntervalThink()
    local hAbility = self:GetAbility()

    -- Apply burn
    self:BurnMana()

    -- Next...
    self:StartIntervalThink(hAbility:GetSpecialValueFor('mana_burn_interval'))
end

-- Apply mana burn
function modifier_antimage_antimagic_aura:BurnMana()
    local hCaster = self:GetCaster()
    local hAffected = self:GetParent()
    local hAbility = self:GetAbility()
    local hMaxMana = hAffected:GetMaxMana()

    if ( hCaster:GetTeamNumber() == hAffected:GetTeamNumber() ) then
        local flPercentage = hAbility:GetSpecialValueFor('mana_regen')
        local flBurn = (flPercentage * hMaxMana) / 100
        hAffected:GiveMana(flBurn)
    else
        local flPercentage = hAbility:GetSpecialValueFor('mana_burn')
        local flBurn = (flPercentage * hMaxMana) / 100
        hAffected:ReduceMana(flBurn)
    end
end

-- Called when the modifier is applied on the hero
function modifier_antimage_antimagic_aura:OnCreated(tData)
    if IsServer() then
        -- Burn mana over time
        self:OnIntervalThink()
    end
end

--
function modifier_antimage_antimagic_aura:OnTooltip()
    local hCaster = self:GetCaster()
    local hAffected = self:GetParent()
    local hAbility = self:GetAbility()

    if ( hCaster:GetTeamNumber() == hAffected:GetTeamNumber() ) then
        return hAbility:GetSpecialValueFor('mana_regen')
    else
        return hAbility:GetSpecialValueFor('mana_burn')
    end
end