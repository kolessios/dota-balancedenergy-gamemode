-- Manage Game Mode Roshan
if CRoshanSystem == nil then
	CRoshanSystem = class({})
end

-- Configuration
local MAX_PRISION_RANGE = 1000
local BONUS_DURATION = 120
local MIN_RESPAWN_TIME = 5.0
local MAX_RESPAWN_TIME = 6.0

-- Indicates the time Respawn should be done
CRoshanSystem._flRespawnTime = -1.0

-- Indicates that Roshan is currently
CRoshanSystem._iNum = 1

-- Indicates the position where Spawn will be made
CRoshanSystem._SpawnPosition = Vector(-2464.244629, 1900.373291, 159.998383)

-- Indicates which direction Roshan should look at
CRoshanSystem._SpawnAngles = Vector(0, 305.999969, 0)

-- Indicate if Roshan has rotated
CRoshanSystem._bRotated = false

-- Initilization
-- Saves necessary information and removes the roshan spawner
function CRoshanSystem:Init()
    local hSpawner = Entities:FindByClassname(nil, 'npc_dota_roshan_spawner')
    local hRoshan = Entities:FindByClassname(nil, 'npc_dota_roshan')

    -- 
    if ( not hSpawner or not hRoshan ) then
        return
    end

    -- We need to know where you will be
    self._SpawnPosition = hRoshan:GetAbsOrigin()
    self._SpawnAngles = hSpawner:GetAnglesAsVector()

    -- Bye!
    UTIL_Remove(hSpawner)
    UTIL_Remove(hRoshan)

    -- We create our own Roshan
    self:CreateRoshan()
end

-- Returns Roshan
function CRoshanSystem:GetRoshan()
    return Entities:FindByClassname(nil, 'npc_dota_roshan')
end

-- Called when roshan die
function CRoshanSystem:OnEntityKilled(tData)
    local hRoshan = self:GetRoshan()
    local hKiller = EntIndexToHScript(tData.entindex_attacker)

    if ( not hRoshan ) then
        return
    end

    -- We are only interested in Roshan
    if ( hRoshan:GetEntityIndex() ~= tData.entindex_killed ) then
        return
    end

    -- 
    if ( hRoshan:HasModifier('modifier_roshan_bonus') ) then
        if ( hKiller:IsRealHero()  ) then
            hKiller:AddNewModifier(hKiller, nil, 'modifier_roshan_bonus', {duration = BONUS_DURATION})
            print('Roshan #' .. self._iNum .. ' killed, transfering bonus buff!')
        end
    end

    self._iNum = self._iNum + 1
    print('Roshan die! The next roshan will be: #' .. self._iNum)

    -- Random Respawn Time
    self:SetRespawnTime(RandomFloat(MIN_RESPAWN_TIME, MAX_RESPAWN_TIME))
end

-- Thinking!
function CRoshanSystem:Think()
    -- Waiting for respawn...
    if ( self._flRespawnTime > 0 ) then
        self:RespawnThink()
    end

    local hRoshan = self:GetRoshan()

    -- We make sure you do not leave your prison boy
    if ( hRoshan and hRoshan:IsAlive() ) then
        self:RoshanThink(hRoshan)
    end
end

-- Keeps Roshan inside his prison
function CRoshanSystem:RoshanThink(hRoshan)
    local flDistance = CalcDistance(hRoshan:GetAbsOrigin(), self._SpawnPosition)

    if ( flDistance > MAX_PRISION_RANGE or flDistance >= 100.0 and not hRoshan:GetAggroTarget() ) then
        -- Go back to your prison!
        hRoshan:MoveToPosition(self._SpawnPosition)
        self._bRotated = false
    elseif ( flDistance <= 80.0 and not hRoshan:GetAggroTarget() and not self._bRotated ) then
        -- Always look straight ahead
        hRoshan:Interrupt()
        hRoshan:SetAngles(self._SpawnAngles.x, self._SpawnAngles.y, self._SpawnAngles.z)
        self._bRotated = true
    end
end

-- Waiting for respawn
function CRoshanSystem:RespawnThink()
    local flTime = GameRules:GetGameTime()

    -- No time yet!
    if ( flTime < self._flRespawnTime ) then
        return
    end

    self:CreateRoshan()
end

-- Set in how many minutes Respawn should be done
function CRoshanSystem:SetRespawnTime(flMinutes)
    local flTime = GameRules:GetGameTime()
    self._flRespawnTime = flTime + (flMinutes * 60)

    print('Roshan respawning in: ' .. self._flRespawnTime .. ' - Current time: ' .. flTime)
end

-- Create Roshan
function CRoshanSystem:CreateRoshan()
    local hRoshan = self:GetRoshan()

    if ( hRoshan ) then
        print('It has been requested to create Roshan but it already exists!')
        UTIL_Remove(hRoshan)
    end

    -- No more wait...
    self._flRespawnTime = -1.0

    -- Roshan creation
    local hRoshan = CreateUnitByName('npc_dota_roshan', self._SpawnPosition, true, nil, nil, DOTA_TEAM_NEUTRALS)
    hRoshan:SetAngles(self._SpawnAngles.x, self._SpawnAngles.y, self._SpawnAngles.z)

    -- Items
    hRoshan:AddItemByName('item_aegis')
    hRoshan:AddItemByName('item_cheese')

    -- Second kill
    if ( self._iNum >= 2 ) then
        hRoshan:AddItemByName('item_refresher_shard')
        hRoshan:AddNewModifier(hRoshan, nil, 'modifier_roshan_bonus', nil)
    end

    -- Ready!
    return hRoshan
end