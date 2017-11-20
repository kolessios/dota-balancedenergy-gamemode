-- Utils
require('./utils')

-- GameMode
require('./balanced_game_mode')

-- Systems
require('./systems/lucky_coin_system')
require('./systems/ward_refill_system')
require('./systems/antimage_system')
require('./systems/roshan_system')
require('./systems/bot_system')

--
function Precache( context )
	PrecacheResource('particle', 'particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf', context)
	PrecacheResource('particle', 'particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf', context)
	PrecacheResource('particle', 'particles/items2_fx/antimagic_owner.vpcf', context)
	PrecacheResource('particle', 'particles/items2_fx/antimagic.vpcf', context)

	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CBalancedGameMode()
	GameRules.AddonTemplate:InitGameMode()
end