local resourceName = tostring(GetCurrentResourceName())
local function savePlayerFile(player, data)
    local fileName = GetPlayerIdentifiers(player)[2]
    local ret = SaveResourceFile(resourceName, "saves/"..fileName..".json", data, -1)
    return ret
end
local function loadPlayerFile(player)
    local fileName = GetPlayerIdentifiers(player)[2]
    local ret = LoadResourceFile(resourceName, "saves/"..fileName..".json")
    if ret then return ret else return "[]" end
end

RegisterServerEvent("xnov:reqVehicles")
AddEventHandler("xnov:reqVehicles", function(player)
    local ply = player or source
    local data = json.decode(loadPlayerFile(ply)) or {}
    TriggerClientEvent("xnov:recVehicles",source,data)
end)

RegisterServerEvent("xnov:saveVehicle")
AddEventHandler("xnov:saveVehicle", function(vehicleData, location, position, oldLocation)
    local player = source
    local data = json.decode(loadPlayerFile(player)) or {}
    if not data[location] then data[location] = {} end
    local oldLocation = oldLocation or location
    if not data[oldLocation] then data[oldLocation] = {} end

    if location == oldLocation then
        if not position then
            local found = false
            for i=1,#xnGarageConfig.locations[location].carLocations do
                if data[location][i] == nil or data[location][i] == "none" then
                    data[location][i] = vehicleData
                    found = true
                    break
                end
            end
            if not found then TriggerClientEvent("xnov:savecallback", source, "no_slot") return end
        else
            data[location][position] = vehicleData
        end
    else
        if data[oldLocation] then
            data[oldLocation][position] = "none"
        end

        local found = false
        for i=1,#xnGarageConfig.locations[location].carLocations do
            if data[location][i] == nil or data[location][i] == "none" then
                data[location][i] = vehicleData
                found = true
                break
            end
        end
        if not found then TriggerClientEvent("xnov:savecallback", source, "no_slot") return end
    end
    savePlayerFile(player, json.encode(data))

    TriggerClientEvent("xnov:savecallback", source, "success")
end)

RegisterServerEvent("xnov:deleteVehicle")
AddEventHandler("xnov:deleteVehicle", function(location, position)
    local player = source
    local data = json.decode(loadPlayerFile(player)) or {}
    if data[location] and data[location][position] then data[location][position] = "none" end

    savePlayerFile(player, json.encode(data))

    TriggerClientEvent("xnov:message", source, "Vehicule suprime")
end)

RegisterServerEvent("xnov:moveVehicle")
AddEventHandler("xnov:moveVehicle", function(location, oldPosition, newPosition)
    local player = source
    local data = json.decode(loadPlayerFile(player)) or {}
    if data[location] then
        local oldVehicleData
        if data[location][newPosition] then
            oldVehicleData = data[location][newPosition]
        else
            oldVehicleData = "none"
        end
        data[location][newPosition] = data[location][oldPosition]
        data[location][oldPosition] = oldVehicleData
    end

    savePlayerFile(player, json.encode(data))

    TriggerClientEvent("xnov:message", source, "Vehicule Changer")
end)

RegisterServerEvent('business:salary5')
AddEventHandler('business:salary5', function()
    local user_id = vRP.getUserId({source})
    if vRP.hasPermission({user_id,'gang.paycheck'}) then
        vRP.giveMoney({user_id,13200})
    end                                                                                                                     
end)

RegisterServerEvent('business:checkmoney5')
AddEventHandler('business:checkmoney5', function()
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    if vRP.hasGroup({user_id,'club'}) then
    TriggerClientEvent('business:alreadyin', player)
    else if vRP.tryFullPayment({user_id,132000000000}) then
        vRP.addUserGroup({user_id,'club'})
        TriggerClientEvent('business:success', player)
      else
        TriggerClientEvent('business:notenough', player)
      end
     end
end)