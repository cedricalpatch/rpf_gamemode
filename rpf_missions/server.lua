--[[
            fs_freemode - game mode for FiveM.
              Copyright (C) 2018 FiveM-Scripts
              
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.
You should have received a copy of the GNU Affero General Public License
along with fs_freemode in the file "LICENSE". If not, see <http://www.gnu.org/licenses/>.
]]

local carList = {}
--local personalvehicles = {}

TriggerEvent("es:setDefaultSettings", {
        debugInformation = false,
        moneyIcon = Setup.Currency,
        nativeMoneySystem = Setup.NativeMoney,
        pvpEnabled = true,
        startingCash = Setup.Money,
        commandDelimeter= "/"
})

RegisterServerEvent('fs_freemode:notifyAll')
AddEventHandler('fs_freemode:notifyAll', function(icon, sender, title, text)
	TriggerEvent("es:getPlayers", function(users)
		for k,v in pairs(users) do
			TriggerClientEvent("fs_freemode:notify", k, tostring(icon), 4, 2, tostring(sender), tostring(title), tostring(text))
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
			if(database.driver == "couchdb") then
				TriggerEvent('es:exposeDBFunctions', function(db)
					db.getDocumentByRow('fs_freemode', 'identifier', player, function(freemodeuser)
						local myWeapons = false
						for k,v in ipairs(freemodeuser.weapons) do
							if (v == s.Name) then
								myWeapons = true
							end
						end

						if not myWeapons then
							freemodeuser.weapons[#freemodeuser.weapons+1] = s.Name
							db.updateDocument('fs_freemode', freemodeuser._id, {weapons = freemodeuser.weapons}, function()  end)
							user.removeMoney(tonumber(s.Price))
						end
					end)
				end)
			elseif(database.driver == "mysql-async") then
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
				end)
			else
				print("Error: No database driver has been set in the server config.")
			end
		 end
	end)
end)
--[[
RegisterServerEvent('fs_freemode:CheckMoneyForTheater')
AddEventHandler('fs_freemode:CheckMoneyForTheater', function(price)
	local Source = tonumber(source)
	TriggerEvent('es:getPlayerFromId', Source, function(user)
		if user.getMoney() >= tonumber(price) then
			user.removeMoney(tonumber(price))
			TriggerClientEvent('fs_freemode:cinemaPayed', Source)
		end
	end)
end)

RegisterServerEvent('fs_freemode:CheckMoneyForWeed')
AddEventHandler('fs_freemode:CheckMoneyForWeed', function(price)
	local Source = tonumber(source)
	TriggerEvent('es:getPlayerFromId', Source, function(user)   
		if user.getMoney() >= tonumber(price) then
			user.removeMoney(tonumber(price))
			TriggerClientEvent('fs_freemode:buyweed', Source)
		end
	end)
end)
]]
RegisterServerEvent('CheckMoneyForVeh')
AddEventHandler('CheckMoneyForVeh', function(vehicle, price)
	local src = source
  --TriggerEvent('es:getPlayerFromId', Source, function(user)
    --local player = user.getIdentifier()
      if user.cash >= tonumber(price) then
	  TriggerEvent('vf_base:ClearCash', src, tonumber(price))
  --  if user.getMoney() >= tonumber(price) then
    --  user.removeMoney(tonumber(price))
     -- personalvehicles[#personalvehicles + 1] = vehicle
     -- TriggerClientEvent('es_vehshop:myVehicles', Source, personalvehicles)
      TriggerClientEvent('FinishMoneyCheckForVeh', Source, "valid")
      
      if database.driver == "mysql-async" then
          MySQL.Async.fetchScalar("SELECT vehicles FROM fs_freemode WHERE identifier = '"..player.."'", { ['@identifier'] = player}, function (vehicles)
            if vehicles then
            	arrayVehicles = json.decode(vehicles)
            	for k,v in ipairs(arrayVehicles) do
            		if (v == vehicle) then
            			vehicleExists = true
            		end
            	end

                if not vehicleExists then
                  arrayVehicles[#arrayVehicles+1] = vehicle
                  local update = json.encode(arrayVehicles)
                  MySQL.Async.execute("UPDATE fs_freemode SET vehicles='"..update.."' WHERE identifier = '"..player.."'", {})
                else
                  TriggerClientEvent('FinishMoneyCheckForVeh', Source, "exists")
                end
            end
           end)
          else
            print("Error: No database driver has been set in the server config.")
          end
       else
      TriggerClientEvent('FinishMoneyCheckForVeh', Source, "invalid")
    end
  end)
end)