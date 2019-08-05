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
    {x= -1213.88, y= -959.72, z= 0.12},
}

local CarModels = {"SPEEDER"}

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
	local VehicleBlip = AddBlipForCoord(-5813.0986328125,1146.2390136719,1.1859945058823)
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

local function SpawnLester(x, y, z)
	local modelHash = GetHashKey("ig_lestercrest_2")
	
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
         if Vdist2(Px, Py, Pz, -811.20532226563,-193.63995361328,42.669399261475) then
            --TriggerServerEvent('fs_freemode:coke')
            if not DoesEntityExist(lester) then
               lester = SpawnLester(-811.20532226563,-193.63995361328,42.669399261475)
            end

            if DoesEntityExist(lester) then
               if not DoesBlipExist(lesterBlip) then
                  lesterBlip = AddBlipForEntity(lester)
                  SetBlipSprite(lesterBlip, 383)
                  
                  BeginTextCommandSetBlipName("STRING")
                  AddTextComponentString("Mission trafic Weed (Lester 500000€)")
                  EndTextCommandSetBlipName(lesterBlip)
               end

               TaskTurnPedToFaceEntity(lester, PlayerPedId(), -1)
            end
           end

           if Vdist2(Px, Py, Pz,-811.20532226563,-193.63995361328,42.669399261475) < 4.5 then
              TriggerEvent("fs_freemode:displayHelp", i18n.translate("StartMissionDialog"))
            --TriggerServerEvent('fs_freemode:coke')            
              if IsControlJustPressed(0, 38) then
                 PlayAmbientSpeech1(lester, "GENERIC_HI", "SPEECH_PARAMS_FORCE")
                 TaskTurnPedToFaceEntity(PlayerPedId(), lester, -1)
                 DisableAllControlActions(0)

                 Wait(1000)
                 TriggerEvent("fs_freemode:displaytext", i18n.translate("lester_firstline"), 5000)
                 Wait(5000)
                 TriggerEvent("fs_freemode:displaytext",  i18n.translate("lester_secondline"), 6000)
                 Wait(6000)
                 TriggerEvent("fs_freemode:displaytext",  i18n.translate("lester_thirthline"), 7000)
                 Wait(7000)
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
                       RemoveBlip(lesterBlip)
                    end
                 end

                 Citizen.Wait(500)
                 DoScreenFadeIn(500)
                 TriggerEvent("currentlySelling")
                 TriggerServerEvent('fs_freemode:coke')
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
                  TriggerEvent("fs_freemode:displaytext", i18n.translate("lester_coordinates"), 6000)
                  destinationBlip = SetDestinationCoords()

                  Wait(10000)
                  SetVehicleIsStolen(vehicle, true)
                  WantedTimer = GetGameTimer()

                  RemoveBlip(VehicleBlip)                  
                  wantedLevel = math.random(2, 4)

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
                        if not DoesEntityExist(lester) then
                           lester = SpawnLester(-5816.8481445313,1144.4254150391,1.8474146127701)
                        end

                        if Vdist2(GetEntityCoords(PlayerPedId(), true), -5813.0986328125,1146.2390136719,1.1859945058823) <= 10.0 then
                           TaskTurnPedToFaceEntity(lester, PlayerPedId(), -1)
                           Citizen.Wait(500)
                           
                           TaskLeaveVehicle(PlayerPedId(), vehicle, 64)
                           PlayAmbientSpeech1(lester, "GENERIC_HI", "SPEECH_PARAMS_FORCE")
                           Citizen.Wait(3000)

                           --cashOut = tonumber(math.random(10000, 50000))
                           TriggerServerEvent('fs_freemode:pay', 500000)
                           --TriggerServerEvent('vf_base:AddCash', 25000))
                           PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

                           Wait(5000)
                           DeleteCar(vehicle)

                           if DoesEntityExist(lester) then
                              SetEntityAsNoLongerNeeded(lester)
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

  RegisterNetEvent('cancel')
  AddEventHandler('cancel', function()
  SetMissionName(false, "RE_TITLE")
  MissionStep = nil
  MissionStarted = false
  DeleteCar(vehicle)
  if DoesBlipExist(destinationBlip) then
     RemoveBlip(destinationBlip)
    end
  end)

  RegisterNetEvent('currentlySelling')
  AddEventHandler('currentlySelling', function()
  DeleteEntity(lester)
  MissionStarted = true
  MissionStep = 1
  end)