-- Utils
require('./utils')

-- GameMode
require('./balanced_game_mode')

-- Systems
require('./systems/lucky_coin_system')
require('./systems/ward_refill_system')
require('./systems/antimage_system')

--
function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CBalancedGameMode()
	GameRules.AddonTemplate:InitGameMode()
end