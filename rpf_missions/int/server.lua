local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","rpf_mission")

RegisterServerEvent('fs_freemode:watch')
AddEventHandler('fs_freemode:watch', function(price)
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

RegisterServerEvent('fs_freemode:pay')
AddEventHandler('fs_freemode:pay', function(amount)
        local user_id = vRP.getUserId({source})
    --if vRP.hasGroup({user_id,'citizen'}) then
        vRP.giveMoney({user_id,amount})
			--TriggerClientEvent('fs_freemode:enter', src, true)
		--else
			--TriggerClientEvent('vf_cinema:enter', src, false)
end)

RegisterServerEvent('fs_freemode:CheckMoneyForWeed')
AddEventHandler('fs_freemode:CheckMoneyForWeed', function(price)
	local src = source
	TriggerEvent('vf_base:FindPlayer', src, function(user)
		if user.cash >= tonumber(price) then
			TriggerEvent('vf_base:ClearCash', src, price)
		else
			TriggerClientEvent('fs_freemode:buyweed', source)
		end
	end)
end)

RegisterServerEvent('fivem-stores:weapon-menu:item-selected')
AddEventHandler('fivem-stores:weapon-menu:item-selected', function(s)
	local src = source
	TriggerEvent('es:getPlayerFromId', src, function(user)
		local player = user.getIdentifier()
		if user.getMoney() >= tonumber(s.Price) then
			TriggerClientEvent('fivem-stores:giveWeapon', src, s.Name, s.FriendlyName)
			--MySQL.Async.fetchScalar("SELECT weapons FROM fs_freemode WHERE identifier = '"..player.."'", { ['@identifier'] = player}, function (weapons)
				if(weapons) then
					local arrayWeapons = json.decode(weapons)
					local myWeapons = false

					for k,v in ipairs(arrayWeapons) do
						if (v == s.Name) then
							print(k,v)
							myWeapons = true
						end
					end

					if not myWeapons then
						arrayWeapons[#arrayWeapons+1] = s.Name
						local update = json.encode(arrayWeapons)
						--MySQL.Async.execute("UPDATE fs_freemode SET weapons='"..update.."' WHERE identifier = '"..player.."'", {})
						user.removeMoney(tonumber(s.Price))
					end
				end
			end
		end)
	end)


RegisterServerEvent('fs_freemode:coke')
AddEventHandler('fs_freemode:coke', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if not vRP.tryGetInventoryItem({user_id,"barette",100}) then
		TriggerClientEvent('cancel', player)
	end
end)

RegisterServerEvent('fs_freemode:carte')
AddEventHandler('fs_freemode:carte', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if not vRP.tryGetInventoryItem({user_id,"credit",100}) then
		TriggerClientEvent('cancel', player)
	end
end)

RegisterServerEvent('business:salary')
AddEventHandler('business:salary', function()
  	local user_id = vRP.getUserId({source})
	if vRP.hasPermission({user_id,'admin.god'}) then
		vRP.giveMoney({user_id,13200})
	end																														
end)

RegisterServerEvent('business:checkmoney8')
AddEventHandler('business:checkmoney8', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if vRP.hasGroup({user_id,'police'}) then
	TriggerClientEvent('business:alreadyin', player)
	vRPclient.teleport(player,{956.40850830078,-2991.8747558594,-39.646968841553})
	else if vRP.tryFullPayment({user_id,10000000}) then
		vRP.addUserGroup({user_id,'police'})
		TriggerClientEvent('business:success', player)
		vRPclient.teleport(player,{956.40850830078,-2991.8747558594,-39.646968841553})
	  else
		TriggerClientEvent('business:notenough', player)
	  end
	 end
end)

RegisterServerEvent('business:checkmoney20')
AddEventHandler('business:checkmoney20', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if vRP.hasGroup({user_id,'police'}) then
	TriggerClientEvent('business:alreadyin20', player)
	else if vRP.tryFullPayment({user_id,0}) then
		vRP.addUserGroup({user_id,'police'})
		TriggerClientEvent('business:success20', player)
	  else
		TriggerClientEvent('business:notenough20', player)
	  end
	 end
end)

RegisterServerEvent('laposte:job')
AddEventHandler('laposte:job', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if vRP.hasGroup({user_id,'laposte'}) then
	TriggerClientEvent('business:alreadyin20', player)
	else if vRP.tryFullPayment({user_id,0}) then
		vRP.addUserGroup({user_id,'laposte'})
		TriggerClientEvent('business:success20', player)
	  else
		TriggerClientEvent('business:notenough20', player)
	  end
	 end
end)
