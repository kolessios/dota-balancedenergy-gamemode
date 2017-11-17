-- Check that the hHeroes with wards are at the base to fill their bottle of wards.
function CBalancedGameMode:CheckRefillWards(hHero)
	-- Obviously we need you to be alive
	if ( hHero:IsAlive() == false ) then
		return
	end

	local hWard = hHero:GetItem("item_ward_observer")

	-- So...
	if ( hWard == nil ) then
		print("It has been detected that the hero has wards, but not really...\n");
		return
	end

	-- You already have the maximum of charges
	if ( hWard:GetCurrentCharges() == hWard:GetInitialCharges() ) then
		return
	end

	-- ???
	if ( hWard:RequiresCharges() == false ) then
		return
	end

	if ( hHero:HasModifier("modifier_fountain_aura_buff") ) then
		-- You are at the base, refill!
		hWard:SetCurrentCharges(hWard:GetInitialCharges())
	--elseif ( hHero:HasModifier("modifier_bottle_regeneration") ) then
		-- You are under the effect of a bottle, have a ward.
		--hWard:SetCurrentCharges(1)
	end
end