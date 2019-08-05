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
    {x= 1982.0187988281, y= 3829.4675292969, z= 32.6045341},
}

local CarModels = {"boxville"}

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
  local VehicleBlip = AddBlipForCoord(-109.97756958008,-62.113498687744,56.423175811768)
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

local function SpawnPoste(x, y, z)
  local modelHash = GetHashKey("s_m_m_postal_01")
  
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
         if Vdist2(Px, Py, Pz, 1979.8670654297,3816.1584472656,32.604919433594) then
            --TriggerServerEvent('fs_freemode:coke')
            if not DoesEntityExist(trevor) then
               trevor = SpawnTrevor(1974.8109130859,3814.1235351563,33.534881591797)
            end

            if DoesEntityExist(trevor) then
               if not DoesBlipExist(trevorBlip) then
                  trevorBlip = AddBlipForEntity(trevor)
                  SetBlipSprite(trevorBlip, 383)
                  
                  BeginTextCommandSetBlipName("STRING")
                  AddTextComponentString("Mission trafic carte pirate (Trevor 250000€)")
                  EndTextCommandSetBlipName(trevorBlip)
               end

               TaskTurnPedToFaceEntity(trevor, PlayerPedId(), -1)
            end
           end

           if Vdist2(Px, Py, Pz,1979.8670654297,3816.1584472656,32.604919433594) < 4.5 then
              TriggerEvent("fs_freemode:displayHelp", i18n.translate("StartMissionDialog"))
            --TriggerServerEvent('fs_freemode:coke')            
              if IsControlJustPressed(0, 38) then
                 PlayAmbientSpeech1(trevor, "GENERIC_HI", "SPEECH_PARAMS_FORCE")
                 TaskTurnPedToFaceEntity(PlayerPedId(), trevor, -1)
                 DisableAllControlActions(0)

                 Wait(1000)
                 TriggerEvent("fs_freemode:displaytext", i18n.translate("trevor_firstline"), 5000)
                 Wait(5000)
                 TriggerEvent("fs_freemode:displaytext",  i18n.translate("trevor_secondline"), 6000)
                 Wait(6000)
                 TriggerEvent("fs_freemode:displaytext",  i18n.translate("trevor_thirthline"), 7000)
                 Wait(7000)
                 DoScreenFadeOut(500)
                 Citizen.Wait(500)

                 if not DoesEntityExist(vehicle) then
                    spawn = GenerateDestinationCoords()
                    vehicle = CreateRandomVehicle(spawn.x, spawn.y, spawn.z)


                       ClearPedTasksImmediately(PlayerPedId())
                       EnableAllControlActions(0)

                 Citizen.Wait(500)
                 DoScreenFadeIn(500)
                 --TriggerEvent("Selling")
                 TriggerServerEvent('laposte:job')
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

  RegisterNetEvent('Selling')
  AddEventHandler('Selling', function()
  DeleteEntity(trevor)
  MissionStarted = true
  MissionStep = 1
  end)

-- police

Citizen.CreateThread(function()
  while true do
    Wait(1)
      Px, Py, Pz = table.unpack(GetEntityCoords(PlayerPedId(), true))

    if not MissionStarted then
         if Vdist2(Px, Py, Pz, 449.55044555664,-976.42785644531,30.686702728271) then
            --TriggerServerEvent('fs_freemode:coke')
            if not DoesEntityExist(trevor) then
               trevor = SpawnTrevor(451.15948486328,-975.00842285156,30.689588546753)
            end

            if DoesEntityExist(trevor) then
               if not DoesBlipExist(trevorBlip) then
                  trevorBlip = AddBlipForEntity(trevor)
                  SetBlipSprite(trevorBlip, 60)
                  
                  BeginTextCommandSetBlipName("STRING")
                  AddTextComponentString("Ecole de Police")
                  EndTextCommandSetBlipName(trevorBlip)
               end

               TaskTurnPedToFaceEntity(trevor, PlayerPedId(), -1)
            end
           end

           if Vdist2(Px, Py, Pz,449.55044555664,-976.42785644531,30.686702728271) < 4.5 then
              TriggerEvent("fs_freemode:displayHelp", i18n.translate("StartMissionDialog"))
            --TriggerServerEvent('fs_freemode:coke')            
              if IsControlJustPressed(0, 38) then
                 PlayAmbientSpeech1(trevor, "GENERIC_HI", "SPEECH_PARAMS_FORCE")
                 TaskTurnPedToFaceEntity(PlayerPedId(), trevor, -1)
                 DisableAllControlActions(0)

                 Wait(1000)
                 TriggerEvent("fs_freemode:displaytext", i18n.translate("trevor_firstline"), 5000)
                 Wait(5000)
                 TriggerEvent("fs_freemode:displaytext",  i18n.translate("trevor_secondline"), 6000)
                 Wait(6000)
                 TriggerEvent("fs_freemode:displaytext",  i18n.translate("trevor_thirthline"), 7000)
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
                       RemoveBlip(trevorBlip)
                    end
                 end

                 Citizen.Wait(500)
                 DoScreenFadeIn(500)
                 --TriggerEvent("Selling")
                 TriggerServerEvent('business:checkmoney20')
                 vRP.notifyPicture({"CHAR_PROPERTY_CINEMA_VINEWOOD", 1, "Votre Entreprise", "~r~Action impossible !","Cette entreprise est deja a toi.\nElle te rapporte ~g~26400€ ~w~toutes les 30 mn !"})
            end
         end
      end
    end
  end
end)
