function CBalancedGameMode:CreateCouriers()
	local hHeroRadiant = HeroList:GetHero(0)
	local hHeroDire = HeroList:GetHero(5)

	CreateUnitByName("npc_dota_courier", Vector(-6985, -6942, 1243), true, hHeroRadiant, nil, DOTA_TEAM_GOODGUYS)
	CreateUnitByName("npc_dota_courier", Vector(6878, 5772, 1238), true, hHeroDire, nil, DOTA_TEAM_BADGUYS)
end