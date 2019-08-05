-- C O N F I G --
local companyName = "DVTowing"

local towOffset = 3.0

local deleteLastTruck = true --Deletes the last spawned truck.
local spawnDistance = 50 	--	Default 50
							---								---
local drivingStyle = 786603  	--	**786603  - "Normal" - Default**
								--	**1074528293 - "Rushed"**
								--	**2883621 - "Ignore Lights"**
								--	**5 - "Sometimes Overtake Traffic"**
								--	**Customize Driving Style: https://vespura.com/drivingstyle/

local towDriverQuoteOfTheDay = {
	"Howdy! Je vais le faire remorquer.",
	"Avez-vous soulevé le véhicule? Parce que je le fais.",
	"Vous avez appelé le bon gars, parce que j'ai des armes à feu de la tête aux pieds.",
	"Pas d'inquiétude, je vais le faire remorquer!",
	"Je ne vous chargerai pas un bras et une jambe! Je veux seulement vos orteils.",
	"Vous voulez aussi passer un peu de temps?",
	"Je déteste mon travail.",
	"Désolé j'ai mis beaucoup de temps!",
	"Nous avons certains des meilleurs prostituées de la ville!",
	"Voilà!",
	"Prends soin.",
	"Cela ira bien dans la fourrière!",
	"Va te faire enculer",
	"J' ai compris!",
	"Merci d'utiliser " .. companyName .. "!",
	"Ce sera à l'enceinte."
}	
								
-- Register a network event 
RegisterNetEvent('pis:spawnTow')
RegisterNetEvent('pis:cancelTow')

-- Gets a vehicle in a certain direction
-- Credit to Konijima
function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end

-- The distance to check in front of the player for a vehicle
-- Distance is in GTA units, which are quite big  
local distanceToCheck = 5.0

enroute = false
onscene = false
cleartask = false
AddEventHandler( 'pis:spawnTow', function()
	--local spawnDistance = math.random(spawnDistance * -1, spawnDistance)
	local spawnDistance = math.random(spawnDistance, spawnDistance + 25)
	local player = GetPlayerPed(-1)
	local playerPos = GetEntityCoords(player)
	local pmodels = {"mp_m_waremech_01"}
	local vehicles = {"flatbed"}
	local driver = GetHashKey(pmodels[math.random(#pmodels)])
	local vehiclehash = GetHashKey(vehicles[math.random(#vehicles)])
    local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(player, 0.0, distanceToCheck, 0.0)
	RequestModel(vehiclehash)
	RequestModel(driver)
	
	while not HasModelLoaded(vehiclehash) and RequestModel(driver) do
		RequestModel(vehiclehash)
		RequestModel(driver)
		Citizen.Wait(0)
	end
	
	if IsPedSittingInAnyVehicle(player) then 
        targetVeh = GetVehiclePedIsIn(player, false)
	else
		targetVeh = GetVehicleInDirection(playerPos, inFrontOfPlayer)
	end
	
	if DoesEntityExist(vehicle) and deleteLastTruck == true then
		SetEntityAsMissionEntity(driver)
		SetEntityAsMissionEntity(vehicle)
		SetEntityAsMissionEntity(towedVeh)
		
		DeleteEntity(driver)
		DeleteEntity(vehicle)
		DeleteEntity(towedVeh)
		
		while DoesEntityExist(driver) do
			Wait(0)
			DeleteEntity(driver)
		end
	end
	
	if DoesEntityExist(targetVeh) then
	TriggerEvent('radio')
	
		Wait(math.random(2000, 6000))
			
		local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
		local heading, vector = GetNthClosestVehicleNode(x, y, z, spawnDistance, 0, 0, 0)
		local sX, sY, sZ = table.unpack(vector)	
		tow = CreateVehicle(vehiclehash, sX, sY, sZ, heading, true, true)
		
		local vehiclehash = GetHashKey(tow)
		
		driver = CreatePedInsideVehicle(tow, 26, driver, -1, true, false)
		local vehpos = GetEntityCoords(targetVeh)
		TaskVehicleDriveToCoord(driver, tow, vehpos.x, vehpos.y, vehpos.z+2, 5.0, 0, vehiclehash, drivingStyle, 1.0, true)
		SetVehicleFixed(tow)
		SetVehicleOnGroundProperly(tow)
		if DoesEntityExist(driver) and DoesEntityExist(tow) then
		SetEntityAsMissionEntity(driver, true, true)
		towblip = AddBlipForEntity(tow)
		SetBlipColour(towblip, 29)
		SetBlipFlashes(towblip, true)
		
		local distanceToTow = GetDistanceBetweenCoords(GetEntityCoords(tow), GetEntityCoords(targetVeh))
		
		if distanceToTow < 100 then
			eta = '~g~1 Mike'
		elseif distanceToTow < 300 then
			eta = '~g~2 Mikes'
		elseif distanceToTow < 500 then
			eta = '~o~3 Mikes'
		elseif distanceToTow > 500 then
			eta = '~r~5 Mikes'
		end
		
		ShowNotification("Une dépanneuse a été envoyée à votre emplacement. Merci ~y~" .. companyName .. "~w~\nETA: " .. eta)
		enroute = true
		while (enroute) do
			Citizen.Wait(300)
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(tow), GetEntityCoords(targetVeh), 1)
			SetEntityInvincible(tow, true)
			SetEntityInvincible(driver, true)
				if distanceToVeh <= 15 then
					SetVehicleIndicatorLights(tow, 1, true)
					SetVehicleIndicatorLights(tow, 2, true)
					TaskVehicleTempAction(driver, tow, 27, 10000)
					Wait(3000)
					AttachEntityToEntity(targetVeh, tow, 20, -0.5, towOffset, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
					SetDriveTaskDrivingStyle(tow, 786603)
					TaskVehicleDriveWander(driver, tow, 17.0, drivingStyle)
					SetVehicleSiren(tow, true)
					ShowNotification("~o~Chauffeur de dépanneuse :~w~ " .. towDriverQuoteOfTheDay[math.random(#towDriverQuoteOfTheDay)])
					SetEntityAsNoLongerNeeded(tow)
					enroute = false
					towblip = RemoveBlip(towblip)
					SetVehicleIndicatorLights(tow, 1, false)
					SetVehicleIndicatorLights(tow, 2, false)
					SetEntityInvincible(vehicle, false)
					SetEntityInvincible(driver, false)
					Wait(30000)
					dofade(tow)
					dofade(targetVeh)
					dofade(driver)
				end
			end
		end
	else
	ShowNotification("Véhicule pas trouvé!")
	end
end)

AddEventHandler( 'pis:cancelTow', function()
	if enroute == true then
		ShowNotification("La demande de dépanneuse a été annulée. Merci ~y~" .. companyName)
		
		SetEntityAsMissionEntity(tow)
		SetEntityAsMissionEntity(driver)
		
		DeleteEntity(tow)
		DeleteEntity(driver)
		enroute = false
	end
end)

RegisterNetEvent('radio')
AddEventHandler('radio', function()
    Citizen.CreateThread(function()
        TaskPlayAnim(player, "random@arrests", "generic_radio_enter", 1.5, 2.0, -1, 50, 2.0, 0, 0, 0 )
		Citizen.Wait(6000)
		ClearPedTasks(player)
    end)
end)

-- F U N C T I O N S --

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end

function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

function dofade(vehicle)
    Citizen.CreateThread(function()
    local fadeouttim = 0
    local alpha = 255
    SetEntityAlpha(vehicle,alpha)

    while alpha > 5 and DoesEntityExist(vehicle) and fadeouttim < 3 do
        alpha = alpha - 25
        Citizen.Wait(30)
        SetEntityAlpha(vehicle,alpha)
        if alpha <= 5 then
            while alpha < 255 do
                alpha = alpha + 25
                Citizen.Wait(10)
                SetEntityAlpha(vehicle,alpha)
            end
            fadeouttim = fadeouttim + 1
        end
    end
    SetEntityAsMissionEntity(vehicle)
    DeleteEntity(vehicle)
end)
end