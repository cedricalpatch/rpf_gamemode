local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","lsv-main")


local players = { }


RegisterServerEvent('lsv:marketManipulationFinished')
AddEventHandler('lsv:marketManipulationFinished', function()
	local user_id = source

	if not players[user_id] then
		TriggerClientEvent('lsv:marketManipulationFinished', user_id, false, 'Le temps est fini.')
		return
	end

	local reward = Settings.marketManipulation.minReward +
		math.min(Settings.marketManipulation.maxReward - Settings.marketManipulation.minReward, players[user_id] * Settings.marketManipulation.cashPerRobbery)

	vRP.giveMoney({user_id,reward}) 
		TriggerClientEvent('lsv:marketManipulationFinished', user_id, true)
		players[user_id] = nil
end)


RegisterServerEvent('lsv:marketManipulationRobbed')
AddEventHandler('lsv:marketManipulationRobbed', function()
	local player = source

	if not players[player] then players[player] = 0 end

	players[player] = players[player] + 1
end)


AddEventHandler('lsv:playerDropped', function(player)
	players[player] = nil
end)