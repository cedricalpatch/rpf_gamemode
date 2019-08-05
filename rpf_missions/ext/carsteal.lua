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

local vehicle = nil

local DestinationCoords = {
    {x= 3046.1838378906, y= -4745.982421875, z= 15.261303901672},
}

local CarModels = {"AVENGER"}

local function GenerateDestinationCoords()
	for i = 1, #DestinationCoords do
		math.randomseed(GetGameTimer())
		math.random(); math.random(); math.random();
		
		local number =  math.random(1, #DestinationCoords)
		local q = DestinationCoords[number]

		return q
	end
end

local function GenerateRandomModel()
	for i = 1, #CarModels do
		math.randomseed(GetGameTimer())
		math.random(); math.random(); math.random(); math.random();

		local number =  math.random(1, #CarModels)
		local q = CarModels[number]

		return q
	end
end	

local function CreateRandomVehicle(x, y, z)
	model = GetHashKey(tostring(GenerateRandomModel()))
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
	end

	vehicle = CreateVehicle(model, x, y, z, 0.0, true, false)
  SetVehicleTyresCanBurst(vehicle, false)
  SetRadioToStationName("OFF")
  Citizen.Wait(800)

	netid = NetworkGetNetworkIdFromEntity(vehicle)
	SetNetworkIdCanMigrate(netid, true)
	NetworkRegisterEntityAsNetworked(VehToNet(vehicle))

	SetModelAsNoLongerNeeded(model)
	return vehicle
end

local function SetDestinationCoords()
	local VehicleBlip = AddBlipForCoord(-5860.4067382813,1217.7939453125,5.8371767997742)
	SetBlipColour(VehicleBlip, 83)
	SetBlipRoute(VehicleBlip, true)

	return VehicleBlip
end

local function DeleteCar(vehicle)
	if DoesBlipExist(destinationBlip) then
		RemoveBlip(destinationBlip)
	end

	if DoesEntityExist(vehicle) then
		RemoveBlip(blip)
		DeleteEntity(vehicle)
	end
end

local function SpawnSimeon(x, y, z)
	local modelHash = GetHashKey("ig_siemonyetarian")
	
	RequestModel(modelHash)
	while not HasModelLoaded(modelHash) do
		Wait(0)
	end

	ped = CreatePed(6, modelHash, x, y, z-1.0001, 0.0, false, false)
  SetBlockingOfNonTemporaryEvents(ped, true)
  SetEntityInvincible(ped, true)
  SetModelAsNoLongerNeeded(modelHash)

  return ped
end

Citizen.CreateThread(function()
   while true do
   	Wait(1)
      Px, Py, Pz = table.unpack(GetEntityCoords(PlayerPedId(), true))

   	if not MissionStarted then
         if Vdist2(Px, Py, Pz, -65.532791137695,-808.10778808594,243.38597106934) then
            if not DoesEntityExist(simeon) then
               simeon = SpawnSimeon(-62.242771148682,-807.16394042969,243.38829040527)
            end

            if DoesEntityExist(simeon) then
               if not DoesBlipExist(simeonBlip) then
                  --simeonBlip = AddBlipForEntity(simeon)
                 -- SetBlipSprite(simeonBlip, 383)
                  
                 -- BeginTextCommandSetBlipName("STRING")
                 -- AddTextComponentString("Mission Simeon")
                 -- EndTextCommandSetBlipName(simeonBlip)
               end

               TaskTurnPedToFaceEntity(simeon, PlayerPedId(), -1)
            end
           end

           if Vdist2(Px, Py, Pz, -65.532791137695,-808.10778808594,243.38597106934) < 4.5 then
            TriggerEvent("fs_freemode:displayHelp", i18n.translate("StartMissionDialog"))
            if IsControlJustPressed(0, 38) then
               PlayAmbientSpeech1(simeon, "GENERIC_HI", "SPEECH_PARAMS_FORCE")
               TaskTurnPedToFaceEntity(PlayerPedId(), simeon, -1)
               DisableAllControlActions(0)

               Wait(0)
               TriggerEvent("fs_freemode:notify", "CHAR_SIMEON", 3, 20, "Trensport de LSD", "Action !", "Va sur la carte,\nTrouve le ~b~AVENGER~w~ pour trasporte la ~b~Cargaison de Drogue...")
               Wait(5000)

               DoScreenFadeOut(500)
               Citizen.Wait(500)

               if not DoesEntityExist(vehicle) then
                  spawn = GenerateDestinationCoords()
                  vehicle = CreateRandomVehicle(spawn.x, spawn.y, spawn.z)

                  if DoesEntityExist(vehicle) then
                     VehicleBlip = AddBlipForEntity(vehicle)
                     SetBlipColour(VehicleBlip, 8)

                     ClearPedTasksImmediately(PlayerPedId())
                     EnableAllControlActions(0)
                     RemoveBlip(simeonBlip)
                  end
               end

               Citizen.Wait(500)
               DoScreenFadeIn(500)

               SetMissionName(true, "RE_TITLE")
               DeleteEntity(simeon)

               MissionStarted = true
               MissionStep = 1
            end
         end
      end

   	if MissionStarted then
      if GetEntityHealth(PlayerPedId()) <= 0 then
        if DoesBlipExist(blip) then
          RemoveBlip(blip)
        end

        if DoesBlipExist(destinationBlip) then
          RemoveBlip(destinationBlip)
        end

        if DoesEntityExist(vehicle) then
          DeleteCar(vehicle)
        end

        SetMissionName(false, "RE_TITLE")
        MissionStep = nil
        MissionStarted = false
      end

   		if IsPedInVehicle(PlayerPedId(), vehicle, false) then
            if MissionStep == 1 then
               if not DoesBlipExist(destinationBlip) then
                  TriggerEvent("fs_freemode:displaytext", i18n.translate("simeon_coordinates"), 6000)
                  destinationBlip = SetDestinationCoords()

                  Wait(10000)
                  SetVehicleIsStolen(vehicle, true)
                  WantedTimer = GetGameTimer()

                  RemoveBlip(VehicleBlip)                  
                  wantedLevel = math.random(5, 6)

                  SetVehicleAlarm(vehicle, true)
                  SetVehicleAlarmTimeLeft(vehicle, 50000)
                  
                  MissionStep = 2
               end
            end

            if MissionStep == 2 then
              if GetGameTimer() > WantedTimer + 1000 and GetGameTimer() < WantedTimer + 7500 then
                TriggerEvent("fs_freemode:displayHelp", i18n.translate("clear_wantedLevel"))
              end

               if GetGameTimer() > WantedTimer + 1000 and GetGameTimer() < WantedTimer + 35000 then
                  SetPlayerWantedLevel(PlayerId(), wantedLevel, true)
                  SetPlayerWantedLevelNow(PlayerId(), wantedLevel)
               end

               if not IsVehicleDriveable(vehicle, true) then
                  SetEntityHealth(PlayerPedId(), 0)
               end

               if IsEntityInZone(PlayerPedId(), "SANAND") then
                  if IsPedInVehicle(PlayerPedId(), vehicle, false) then
                     if GetPlayerWantedLevel(PlayerId()) > 0 then
                      -- do something
                     else
                        if not DoesEntityExist(simeon) then
                           simeon = SpawnSimeon(-5860.4067382813,1217.7939453125,5.8371767997742)
                        end

                        if Vdist2(GetEntityCoords(PlayerPedId(), true), -5856.5834960938,1214.5524902344,5.8401579856873) <= 10.0 then
                           TaskTurnPedToFaceEntity(simeon, PlayerPedId(), -1)
                           Citizen.Wait(500)
                           
                           TaskLeaveVehicle(PlayerPedId(), vehicle, 64)
                           PlayAmbientSpeech1(simeon, "GENERIC_HI", "SPEECH_PARAMS_FORCE")
                           Citizen.Wait(3000)

                           --cashOut = tonumber(math.random(10000, 50000))
                           --TriggerServerEvent('fs_freemode:missionComplete')
                           TriggerServerEvent('fs_freemode:pay', 25000)
                           PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

                           Wait(5000)
                           DeleteCar(vehicle)

                           if DoesEntityExist(simeon) then
                              SetEntityAsNoLongerNeeded(simeon)
                           end

                           SetMissionName(false, "RE_TITLE")
                           MissionStep = nil
                           MissionStarted = false
                        end
                     end
                  end
               end
            end

            if IsPedInVehicle(PlayerPedId(), vehicle, false) then
              if GetPlayerWantedLevel(PlayerId()) > 1 then
                if DoesBlipExist(destinationBlip) then
                  RemoveBlip(destinationBlip)
                end
              else
                if not DoesBlipExist(destinationBlip) then
                  destinationBlip = SetDestinationCoords()
                end
              end
            end
          end
        end
      end
  end)