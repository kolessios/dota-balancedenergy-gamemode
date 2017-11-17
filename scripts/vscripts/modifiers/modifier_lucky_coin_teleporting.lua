-- Buff that provides the effects of teleportation
-- It works like a teleportation scroll but is also interrupted when receiving damage.
if modifier_lucky_coin_teleporting == nil then
	modifier_lucky_coin_teleporting = class({})
end

-- ID of the particles of the teleportation effect
modifier_lucky_coin_teleporting._nTeleportStartFX = nil
modifier_lucky_coin_teleporting._nTeleportEndFX = nil
modifier_lucky_coin_teleporting._nCoinsFX = nil

-- Returns the attributes and functions that the modifier will have
function modifier_lucky_coin_teleporting:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

-- Returns if it is a debuff
function modifier_lucky_coin_teleporting:IsDebuff()
    return false
end

-- Returns the duration of the buff
function modifier_lucky_coin_teleporting:GetDuration()
    local hCoin = self:GetAbility()
    return hCoin:GetChannelTime()
end

-- Called when the buff is applied on the hero
function modifier_lucky_coin_teleporting:OnCreated(data)
    if IsServer() then
        local hCaster = self:GetCaster()
        local hCoin = self:GetAbility()

        local vStartPosition = hCaster:GetAbsOrigin()
        local vEndPosition = hCaster:GetFountainPosition()

        -- Create the teleportation start effect
        self._nTeleportStartFX = ParticleManager:CreateParticle("particles/items2_fx/teleport_start.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
        ParticleManager:SetParticleControl(self._nTeleportStartFX, 0, vStartPosition)
        ParticleManager:SetParticleControl(self._nTeleportStartFX, 1, Vector(255, 255, 255))
        ParticleManager:SetParticleControl(self._nTeleportStartFX, 2, Vector(185, 192, 0))

        -- Create the teleportation end effect
        self._nTeleportEndFX = ParticleManager:CreateParticle("particles/items2_fx/teleport_end.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
        ParticleManager:SetParticleControl(self._nTeleportEndFX, 0, vEndPosition)
        ParticleManager:SetParticleControl(self._nTeleportEndFX, 1, vEndPosition)
        ParticleManager:SetParticleControl(self._nTeleportEndFX, 2, Vector(185, 192, 0))

        -- Emit the sounds
        StartSoundEvent('Portal.Loop_Disappear', hCaster)
        --StartSoundEventFromPosition('Portal.Loop_Appear', vEndPosition)

        --
        self._nCoinsFX = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_tnt_rain_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
    end
end

-- Called when the buff is removed
function modifier_lucky_coin_teleporting:OnDestroy()
    if IsServer() then
        local hCaster = self:GetCaster()
        local hCoin = self:GetAbility()

        -- Stop the sounds
        StopSoundEvent('Portal.Loop_Disappear', hCaster)
        --StopSoundEvent('Portal.Loop_Appear', hCaster)

        -- Destroy the teleportation effect
        if ( self._nTeleportStartFX ~= nil ) then
            ParticleManager:DestroyParticle(self._nTeleportStartFX, hCoin:HasInterrupted())
            ParticleManager:ReleaseParticleIndex(self._nTeleportStartFX)
            self._nTeleportStartFX = nil
        end

        if ( self._nTeleportEndFX ~= nil ) then
            ParticleManager:DestroyParticle(self._nTeleportEndFX, hCoin:HasInterrupted())
            ParticleManager:ReleaseParticleIndex(self._nTeleportEndFX)
            self._nTeleportEndFX = nil
        end

        if ( self._nCoinsFX ~= nil ) then
            ParticleManager:DestroyParticle(self._nCoinsFX, hCoin:HasInterrupted())
            ParticleManager:ReleaseParticleIndex(self._nCoinsFX)
            self._nCoinsFX = nil
        end
    end
end

-- Called when a unit receives damage
function modifier_lucky_coin_teleporting:OnTakeDamage(data)
    local hVictim = data.unit
    local hCaster = self:GetCaster()
    local hCoin = self:GetAbility()

    -- We only want to know when the hero has taken damage
    if ( hVictim ~= hCaster ) then
        return
    end

    -- Interrupt the channeling
    hCoin:EndChannel(true)
end