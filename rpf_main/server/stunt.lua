local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","lsv-main")

local logger = Logger:CreateNamedLogger('Stunt Jump')


RegisterServerEvent('lsv:stuntJumpCompleted')
AddEventHandler('lsv:stuntJumpCompleted', function(height, distance)
	local player = source

	local reward = math.min(Settings.stuntJumpMaxReward, math.floor(math.max(height, distance) * Settings.stuntJumpCashPerMeter))
	vRP.giveMoney({player,reward})
	--Db.UpdateCash(player, reward, function()
		TriggerClientEvent('lsv:stuntJumpCompleted', player, height, distance)
		logger:Info('Completed: { player: '..player..', height: '..height..', distance: '..distance..', reward: '..reward..' }')
	--end)
end)