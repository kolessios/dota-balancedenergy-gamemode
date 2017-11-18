-- Linkens Orb: Spell block
if modifier_item_linkens_orb_absorb == nil then
	modifier_item_linkens_orb_absorb = class({})
end

-- ID of the particles
modifier_item_linkens_orb_absorb._nOrbFX = nil

-- Indicates if we have absorbed a spell
modifier_item_linkens_orb_absorb._bAbsorbed = false

-- Returns the attributes and functions that the modifier will have
function modifier_item_linkens_orb_absorb:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ABSORB_SPELL
    }

    return funcs
end

-- Returns if the modifier is hidden.
function modifier_item_linkens_orb_absorb:IsHidden()
    return false
end

-- Returns if it is a debuff
function modifier_item_linkens_orb_absorb:IsDebuff()
    return false
end

--
function modifier_item_linkens_orb_absorb:AllowIllusionDuplicate()
    return false
end

--
function modifier_item_linkens_orb_absorb:IsPermanent()
    return false
end

--
function modifier_item_linkens_orb_absorb:IsPurgable()
    return false
end

-- Returns the correct position for the effect
function modifier_item_linkens_orb_absorb:GetOrigin()
    local hCaster = self:GetCaster()
    local vPosition = hCaster:GetAbsOrigin()
    vPosition.z = vPosition.z + 120.0
    return vPosition
end

-- Thinking!
function modifier_item_linkens_orb_absorb:OnIntervalThink()
    if ( self._bAbsorbed ) then
        -- It is safe to remove the modifier.
        local hCaster = self:GetCaster()
        hCaster:RemoveModifierByName('modifier_item_linkens_orb_absorb')
    end

    self:StartIntervalThink(-1)
end

-- Called when the buff is applied on the hero
function modifier_item_linkens_orb_absorb:OnCreated(data)
    if IsServer() then
        local hCaster = self:GetCaster()
        local hAbility = self:GetAbility()

        -- Create the spell block effect
        self._nOrbFX = ParticleManager:CreateParticle("particles/items_fx/immunity_orb_buff.vpcf", PATTACH_ROOTBONE_FOLLOW, hCaster)
    end
end

-- Called when the buff is removed
function modifier_item_linkens_orb_absorb:OnDestroy()
    if IsServer() then
        local hCaster = self:GetCaster()
        local hAbility = self:GetAbility()

        if ( self._bAbsorbed ) then
            -- Break sound!
            StartSoundEvent('DOTA_Item.LinkensSphere.Activate', hCaster)
        end

        -- Destroy the spell block effect
        if ( self._nOrbFX ~= nil ) then
            ParticleManager:DestroyParticle(self._nOrbFX, false)
            ParticleManager:ReleaseParticleIndex(self._nOrbFX)
            self._nOrbFX = nil
        end
    end
end

--
function modifier_item_linkens_orb_absorb:GetAbsorbSpell(tData)
    self._bAbsorbed = true
    self:StartIntervalThink(0.001)

    -- Absorb!
    return 1
end