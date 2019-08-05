local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","lsv-main")


RegisterServerEvent('lsv:assetRecoveryFinished')
AddEventHandler('lsv:assetRecoveryFinished', function(vehicleHealthRatio)
	local user_id = source

	local reward = Settings.assetRecovery.minReward + math.floor(vehicleHealthRatio * (Settings.assetRecovery.maxReward - Settings.assetRecovery.minReward))
        vRP.giveMoney({user_id,reward}) 
	    --Db.UpdateCash(player, reward, function()
		TriggerClientEvent('lsv:assetRecoveryFinished', user_id, true)
	--end)
end)