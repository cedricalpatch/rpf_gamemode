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

local CarModels = {"911gt3r"}

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

local function SpawnTrevor(x, y, z)
  local modelHash = GetHashKey("player_two")
  
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

local function SpawnPolice(x, y, z)
  local modelHash = GetHashKey("s_f_y_cop_01")
  
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
                 TriggerEvent("Selling")
                 TriggerServerEvent('fs_freemode:carte')
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
                  TriggerEvent("fs_freemode:displaytext", i18n.translate("trevor_coordinates"), 6000)
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
                TriggerEvent("fs_freemode:displayHelp", i18n.translate("trevor_wantedLevel"))
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
                        if not DoesEntityExist(trevor) then
                           trevor = SpawnTrevor(-104.7845916748,-65.765464782715,56.423175811768)
                        end

                        if Vdist2(GetEntityCoords(PlayerPedId(), true), -109.97756958008,-62.113498687744,56.423175811768) <= 10.0 then
                           TaskTurnPedToFaceEntity(trevor, PlayerPedId(), -1)
                           Citizen.Wait(500)
                           
                           TaskLeaveVehicle(PlayerPedId(), vehicle, 64)
                           PlayAmbientSpeech1(trevor, "GENERIC_HI", "SPEECH_PARAMS_FORCE")
                           Citizen.Wait(3000)

                           --cashOut = tonumber(math.random(10000, 50000))
                           TriggerServerEvent('fs_freemode:pay', 250000)
                           --TriggerServerEvent('vf_base:AddCash', 25000))
                           PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

                           Wait(5000)
                           DeleteCar(vehicle)

                           if DoesEntityExist(trevor) then
                              SetEntityAsNoLongerNeeded(trevor)
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
            if not DoesEntityExist(police) then
               police = SpawnPolice(451.15948486328,-975.00842285156,30.689588546753)
            end

            if DoesEntityExist(police) then
               if not DoesBlipExist(policeBlip) then
                  policeBlip = AddBlipForEntity(police)
                  SetBlipSprite(policeBlip, 60)
                  
                  BeginTextCommandSetBlipName("STRING")
                  AddTextComponentString("Ecole de Police")
                  EndTextCommandSetBlipName(policeBlip)
               end

               TaskTurnPedToFaceEntity(police, PlayerPedId(), -1)
            end
           end

           if Vdist2(Px, Py, Pz,449.55044555664,-976.42785644531,30.686702728271) < 4.5 then
              TriggerEvent("fs_freemode:displayHelp", "Devenir policier touche ~INPUT_PICKUP~ et suivre les instructions !")
            --TriggerServerEvent('fs_freemode:coke')            
              if IsControlJustPressed(0, 38) then
                 PlayAmbientSpeech1(police, "GENERIC_HI", "SPEECH_PARAMS_FORCE")
                 TaskTurnPedToFaceEntity(PlayerPedId(), police, -1)
                 DisableAllControlActions(0)

                 Wait(1000)
                 TriggerEvent("fs_freemode:notify", "CHAR_BRYONY", 2, 20, "Police Nationnal", "~y~Agent recruteur !", "Appuyer sur ~g~Ctrl + U~w~ pour ouvrir le ~b~Menu Police~w~ et ~g~Ctrl + Espace~w~ pour les missions !")
                 Wait(5000)
                 TriggerEvent("fs_freemode:notify", "CHAR_BRYONY", 2, 20, "Police Nationnal", "~y~Agent recruteur !", "Vous voulez devenir policier ! Bon j'espere que vous avez les competences pour le devenir.")
                 --TriggerEvent("fs_freemode:displaytext",  "~y~Agent recruteur :~w~ Vous voulez devenir policier ! Bon j'espere que vous avez les competences pour le devenir.", 6000)
                 Wait(6000)
                 --TriggerEvent("fs_freemode:displaytext",  "~y~Agent recruteur :~w~ Vous pouvez mettre votre tenue et chercher un vehicule de patrouile deriere.", 7000)
                 Wait(7000)
                 DoScreenFadeOut(500)
                 Citizen.Wait(500)

                 ClearPedTasksImmediately(PlayerPedId())
                 EnableAllControlActions(0)

                 Citizen.Wait(500)
                 DoScreenFadeIn(500)
                 --TriggerEvent("Selling")
                 TriggerServerEvent('business:checkmoney20')
                 TriggerEvent("fs_freemode:notify", "CHAR_BRYONY", 2, 20, "Police Nationnal", "Aller au travaille !", "Vous pouvez mettre votre tenue et chercher un vehicule de patrouile deriere le batiment.")
                 Wait(8000)
                 TriggerEvent("fs_freemode:notify", "CHAR_BRYONY", 2, 20, "Police Nationnal", "Bon a savoir !", "Arreter un ~g~PNJ ~w~Vise le et fleche de ~b~Droite~w~ en ~g~Voiture~w~ mettre le giro et Shift  !")
            end
        -- end
        --TriggerEvent("fs_freemode:notify", "WEB_NATIONALOFFICEOFSECURITYENFORCEMENT", 6, 1, "Police Nationnal", "Action !", "Appuyer sur ~g~Ctrl + U~w~ pour ouvrir le ~b~Menu Police~w~ et ~g~Ctrl + Espace~w~ pour les missions !")
      end
    end
  end
end)

--- laposte

Citizen.CreateThread(function()
  while true do
    Wait(1)
      Px, Py, Pz = table.unpack(GetEntityCoords(PlayerPedId(), true))

    if not MissionStarted then
         if Vdist2(Px, Py, Pz, -616.43780517578,-1620.5249023438,33.010547637939) then
            --TriggerServerEvent('fs_freemode:coke')
            if not DoesEntityExist(poste) then
               poste = SpawnPoste(-617.55065917969,-1623.1427001953,33.010547637939)
            end

            if DoesEntityExist(poste) then
               if not DoesBlipExist(posteBlip) then
                  posteBlip = AddBlipForEntity(poste)
                  SetBlipSprite(posteBlip, 478)
                  
                  BeginTextCommandSetBlipName("STRING")
                  AddTextComponentString("Devenir agent de la poste")
                  EndTextCommandSetBlipName(posteBlip)
               end

               TaskTurnPedToFaceEntity(poste, PlayerPedId(), -1)
            end
           end

           if Vdist2(Px, Py, Pz,-616.43780517578,-1620.5249023438,33.010547637939) < 4.5 then
              TriggerEvent("fs_freemode:displayHelp", "Devenir agent de la Poste touche ~INPUT_PICKUP~ et suivre les instructions !")
            --TriggerServerEvent('fs_freemode:coke')            
              if IsControlJustPressed(0, 38) then
                 PlayAmbientSpeech1(poste, "GENERIC_HI", "SPEECH_PARAMS_FORCE")
                 TaskTurnPedToFaceEntity(PlayerPedId(), poste, -1)
                 DisableAllControlActions(0)

                 Wait(1000)
                 TriggerEvent("fs_freemode:notify", "CHAR_MP_JULIO", 2, 46, "La Poste", "~y~Agent recruteur !", "Appuyer sur ~g~Ctrl + U~w~ pour ouvrir le ~b~Menu Police~w~ et ~g~Ctrl + Espace~w~ pour les missions !")
                 Wait(5000)
                 TriggerEvent("fs_freemode:notify", "CHAR_MP_JULIO", 2, 46, "La Poste", "~y~Agent recruteur !", "Vous voulez devenir policier ! Bon j'espere que vous avez les competences pour le devenir.")
                 --TriggerEvent("fs_freemode:displaytext",  "~y~Agent recruteur :~w~ Vous voulez devenir policier ! Bon j'espere que vous avez les competences pour le devenir.", 6000)
                 Wait(6000)
                 --TriggerEvent("fs_freemode:displaytext",  "~y~Agent recruteur :~w~ Vous pouvez mettre votre tenue et chercher un vehicule de patrouile deriere.", 7000)
                 Wait(7000)
                 DoScreenFadeOut(500)
                 Citizen.Wait(500)

                 ClearPedTasksImmediately(PlayerPedId())
                 EnableAllControlActions(0)

                 Citizen.Wait(500)
                 DoScreenFadeIn(500)
                 --TriggerEvent("Selling")
                 TriggerServerEvent('laposte:job')
                 TriggerEvent("fs_freemode:notify", "CHAR_MP_JULIO", 2, 46, "La Poste", "Aller au travaille !", "Vous pouvez mettre votre tenue et chercher un vehicule de patrouile deriere le batiment.")
                 Wait(8000)
                 TriggerEvent("fs_freemode:notify", "CHAR_MP_JULIO", 2, 46, "La Poste", "Bon a savoir !", "Arreter un ~g~PNJ ~w~Vise le et fleche de ~b~Droite~w~ en ~g~Voiture~w~ mettre le giro et Shift  !")
            end
            end
         end
      end
  end)

RegisterNetEvent('business:success20')
AddEventHandler('business:success20', function()
  vRP.notifyPicture({"CHAR_BANK_FLEECA", 2,"Information de la Banque", "~g~Entreprise Aquis !","Tu es le Boss de cette entreprise. Cette entreprise rapporte ~g~26400€ ~w~toutes les 30 mn !"})
end)
RegisterNetEvent('business:notenough20')
AddEventHandler('business:notenough20', function()
  vRP.notify({"~r~Pas assé d'argent."})
end)
RegisterNetEvent('business:alreadyin20')
AddEventHandler('business:alreadyin20', function()
  vRP.notifyPicture({"CHAR_PROPERTY_CINEMA_VINEWOOD", 1, "Votre Entreprise", "~r~Action impossible !","Cette entreprise est deja a toi.\nElle te rapporte ~g~26400€ ~w~toutes les 30 mn !"})
end)