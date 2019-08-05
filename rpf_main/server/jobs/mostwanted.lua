local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","lsv-main")


RegisterServerEvent('lsv:mostWantedFinished')
AddEventHandler('lsv:mostWantedFinished', function(timeSurvived)
	local user_id = source

	local reward = math.floor(math.min(Settings.mostWanted.maxReward, timeSurvived / Settings.mostWanted.time * Settings.mostWanted.maxReward))

	vRP.giveMoney({user_id,reward})
		TriggerClientEvent('lsv:mostWantedFinished', user_id, true)
end)