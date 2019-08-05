local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","lsv-main")

RegisterServerEvent('lsv:updateWeaponTint')
AddEventHandler('lsv:updateWeaponTint', function(weaponHash, weaponTintIndex)
	local player = source

	local isEnoughKills = Scoreboard.GetPlayerKills(player) >= Settings.weaponTints[weaponTintIndex].kills

	TriggerClientEvent('lsv:weaponTintUpdated', player, isEnoughKills and weaponHash, weaponTintIndex)
end)


RegisterServerEvent('lsv:updateWeaponComponent')
AddEventHandler('lsv:updateWeaponComponent', function(weapon, componentIndex)
	local user_id = vRP.getUserId({source})

	local componentPrice = Weapon.GetWeapon(weapon).components[componentIndex].cash
    if vRP.tryPayment({user_id,componentPrice}) then
	--if Scoreboard.GetPlayerCash(player) >= componentPrice then
	--	Db.UpdateCash(player, -componentPrice, function()
			TriggerClientEvent('lsv:weaponComponentUpdated', user_id, weapon, componentIndex)
		--end
	else TriggerClientEvent('lsv:weaponComponentUpdated', user_id, nil) end
end)


RegisterServerEvent('lsv:purchaseWeapon')
AddEventHandler('lsv:purchaseWeapon', function(weapon)
	local user_id = vRP.getUserId({source})

	local weaponPrice = Weapon.GetWeapon(weapon).cash
    if vRP.tryPayment({user_id,weaponPrice}) then
	--if Scoreboard.GetPlayerCash(player) >= weaponPrice then
		--Db.UpdateCash(player, -weaponPrice, function()
			TriggerClientEvent('lsv:weaponPurchased', user_id, weapon)
		--end
	else 
		TriggerClientEvent('lsv:weaponPurchased', user_id, nil) end
end)




RegisterServerEvent('lsv:refillAmmo')
AddEventHandler('lsv:refillAmmo', function(ammoType, weapon)
	local user_id = source

	local refillPrice = Settings.ammuNationRefillAmmo[ammoType].price
    if vRP.tryPayment({user_id,refillPrice}) then
	--if Scoreboard.GetPlayerCash(player) >= refillPrice then
		--Db.UpdateCash(player, -refillPrice, function()
			TriggerClientEvent('lsv:ammoRefilled', user_id, weapon, Settings.ammuNationRefillAmmo[ammoType].ammo)
		--end
	else TriggerClientEvent('lsv:ammoRefilled', user_id, weapon, nil) end
end)
