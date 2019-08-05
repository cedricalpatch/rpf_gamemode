local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","lsv-main")

local players = { }


RegisterServerEvent('lsv:velocityFinished')
AddEventHandler('lsv:velocityFinished', function()
	local user_id = source

	local reward = Settings.velocity.maxReward
	if players[user_id] then reward = reward - math.min(Settings.velocity.maxReward - Settings.velocity.minReward, players[user_id] * Settings.velocity.cashPerAboutToDetonate) end

	vRP.giveMoney({user_id,reward}) 
		TriggerClientEvent('lsv:velocityFinished', user_id, true)
		players[user_id] = nil
end)


RegisterServerEvent('lsv:velocityAboutToDetonate')
AddEventHandler('lsv:velocityAboutToDetonate', function()
	local player = source

	if not players[player] then players[player] = 0 end

	players[player] = players[player] + 1
end)


AddEventHandler('lsv:playerDropped', function(player)
	players[player] = nil
end)