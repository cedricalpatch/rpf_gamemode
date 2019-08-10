-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependencies 'vrp'
-- WarMenu resource
client_script "@warmenu/warmenu.lua"


-- MySQL Async library
server_script '@mysql-async/lib/MySQL.lua'

-- Server modules
server_scripts {
    "@vrp/lib/utils.lua",
	"modules/logger.lua",
	"modules/utils.lua",
	"modules/weapon.lua",
	"modules/blip.lua",
	"modules/settings.lua",

	"modules/server/db.lua",
	"modules/server/scoreboard.lua",
	"modules/server/autosave.lua",
	"modules/server/jobwatcher.lua",
}


-- Server scripts
server_scripts {
	"server/main.lua",
	"server/baseevents.lua",
	"server/session.lua",
	"server/report.lua",
	"server/cratedrop.lua",
	"server/bounty.lua",
	--"server/guard.lua",
	"server/castle.lua",
	"server/property.lua",
	"server/event.lua",
	"server/crew.lua",
	"server/pingkick.lua",
	"server/stunt.lua",

	"server/shop/ammunation.lua",
	"server/shop/skinshop.lua",

	"server/jobs/mostwanted.lua",
	"server/jobs/assetrecovery.lua",
	"server/jobs/headhunter.lua",
	"server/jobs/velocity.lua",
	"server/jobs/marketmanipulation.lua",
}


-- Client modules
client_scripts {
    "Tunnel.lua",
    "Proxy.lua",
    "lsconfig.lua",
	"modules/logger.lua",
	"modules/utils.lua",
	"modules/blip.lua",
	"modules/settings.lua",
	"modules/weapon.lua",

	"modules/client/gui/safezone.lua",
	"modules/client/gui/gui.lua",
	"modules/client/gui/bar.lua",

	"modules/client/world.lua",
	"modules/client/streaming.lua",
	"modules/client/scaleform.lua",
	"modules/client/skin.lua",
	"modules/client/color.lua",
	"modules/client/player.lua",
	"modules/client/pickup.lua",
	"modules/client/map.lua",
	"modules/client/scoreboard.lua",
	"modules/client/jobwatcher.lua",
}


-- Client scripts
client_scripts {
	"client/spawn.lua",
	--"client/enviroment.lua",
	"client/afk.lua",
	"client/session.lua",
	"client/report.lua",
	"client/hud.lua",
	"client/pickup.lua",
	"client/playertags.lua",
	"client/cratedrop.lua",
	"client/interactionmenu.lua",
	"client/bounty.lua",
	"client/castle.lua",
	"client/property.lua",
	"client/menu.lua",
	"client/crew.lua",
	"client/pingkick.lua",
	"client/stunt.lua",

	"client/shop/skinshop.lua",
	"client/shop/ammunation.lua",

	"client/jobs/jobs.lua",
	"client/jobs/mostwanted.lua",
	"client/jobs/assetrecovery.lua",
	"client/jobs/headhunter.lua",
	"client/jobs/velocity.lua",
	"client/jobs/marketmanipulation.lua",
}
