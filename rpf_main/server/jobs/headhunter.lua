local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","lsv-main")


RegisterServerEvent('lsv:headhunterFinished')
AddEventHandler('lsv:headhunterFinished', function(eventStartTime, loseTheCopsStartTime, eventEndTime)
	--local player = source
	local user_id = source

	local totalLoseTheCopsTime = eventStartTime + Settings.headhunter.time - loseTheCopsStartTime
	local reward = Settings.headhunter.minReward + math.floor((eventEndTime - totalLoseTheCopsTime) / totalLoseTheCopsTime * (Settings.headhunter.maxReward - Settings.headhunter.minReward))

	vRP.giveMoney({user_id,reward})
		TriggerClientEvent('lsv:headhunterFinished', user_id, true)
end)