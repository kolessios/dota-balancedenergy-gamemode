printf = function(s,...)
	return io.write(s:format(...))
end

--function randomInt(min, max)
--	math.randomseed(os.time())
--	return math.random(min,max)
--end

function table.contains(table, element)
	for _, value in pairs(table) do
	  if value == element then
		return true
	  end
	end
	return false
end

--
function CDOTA_BaseNPC_Hero:GetItem(item_name)
    for i = 20, 0, -1 do
		local item = self:GetItemInSlot( i )

		if ( item ~= nil ) then
			if ( item:GetName() == item_name ) then
				return item
			end
		end
	end

	return nil
end

--
function CDOTA_BaseNPC_Hero:GetItemSlot(item_name)
    for i = 20, 0, -1 do
		local item = self:GetItemInSlot( i )

		if ( item ~= nil ) then
			if ( item:GetName() == item_name ) then
				return i
			end
		end
	end

	return -1
end

--
function CDOTA_BaseNPC_Hero:IsSupport()
	local tSupports = {
		'npc_dota_hero_abaddon',
		'npc_dota_hero_wisp',
		'npc_dota_hero_omniknight',
		'npc_dota_hero_treant',
		'npc_dota_hero_vengefulspirit',
		'npc_dota_hero_venomancer',
		'npc_dota_hero_ancient_apparition',
		'npc_dota_hero_bane',
		'npc_dota_hero_chen',
		'npc_dota_hero_crystal_maiden',
		'npc_dota_hero_dark_willow',
		'npc_dota_hero_dazzle',
		'npc_dota_hero_disruptor',
		'npc_dota_hero_enchantress',
		'npc_dota_hero_keeper_of_the_light',
		'npc_dota_hero_lich',
		'npc_dota_hero_lion',
		'npc_dota_hero_ogre_magi',
		'npc_dota_hero_oracle',
		'npc_dota_hero_rubick',
		'npc_dota_hero_shadow_demon',
		'npc_dota_hero_shadow_shaman',
		'npc_dota_hero_skywrath_mage',
		'npc_dota_hero_winter_wyvern',
		'npc_dota_hero_witch_doctor'
	}

	if ( table.contains(tSupports, self:GetClassname())	) then
		return true
	end

	return false
end

--
function CDOTA_BaseNPC_Hero:GetFountainPosition()
	local vOrigin = Vector(0,0,0)

	if ( self:GetTeamNumber() == DOTA_TEAM_GOODGUYS ) then
		vOrigin = Vector(-7129, -6627, 520.75)
	elseif ( self:GetTeamNumber() == DOTA_TEAM_BADGUYS ) then
		vOrigin = Vector(7129, 6627, 520.75)
	end

	return vOrigin
end

-- 
function FindLuckyCoinsInRadius(teamNumber, victim, radius)
	local result = {}

	for _,hero in pairs(HeroList:GetAllHeroes()) do
		-- This player has lucky coin
		if ( hero:IsRealHero() and hero:GetTeamNumber() == teamNumber and hero:HasItemInInventory("item_lucky_coin") ) then
			local distance = CalcDistanceBetweenEntityOBB(hero, victim)

			-- Inside radius!
			if ( distance <= radius ) then
				table.insert(result, hero)
			end
		end
	end

	return result
end