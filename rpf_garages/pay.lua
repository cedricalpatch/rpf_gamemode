local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vf_garages")

RegisterServerEvent('fs_freemode:watch')
AddEventHandler('fs_freemode:watch', function(amount)
    local user_id = vRP.getUserId({source})
    --if vRP.hasGroup({user_id,'citizen'}) then
        vRP.tryPayment({user_id,amount})                                                                                                                     
end)

RegisterServerEvent('fs_freemode:watch1')
AddEventHandler('fs_freemode:watch1', function(price)
	local src = source

	TriggerEvent('vf_base:FindPlayer', src, function(user)
		if user.cash >= tonumber(price) then
			TriggerEvent('vf_base:ClearCash', src, price)
			--TriggerClientEvent('fs_freemode:enter', src, true)
		--else
			--TriggerClientEvent('vf_cinema:enter', src, false)
		end
	end)
end)