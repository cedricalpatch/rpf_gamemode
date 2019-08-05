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

local assistant = nil

local function CreateAssistantPed()
	if not DoesEntityExist(assistant) then

		RequestModel(GetHashKey("mp_f_execpa_01"))
		while not HasModelLoaded(GetHashKey("mp_f_execpa_01")) do
			Wait(0)
		end

		assistant = CreatePed(5, GetHashKey("mp_f_execpa_01"),963.78698730469,-3007.8579101563,-39.63988494873-1.0001, false, false)
		SetEntityHeading(assistant, 1.236)
		
		SetPedComponentVariation(assistant, 3, 2, 0, 0)
		SetPedComponentVariation(assistant, 11, 1, 0, 0)
		SetPedComponentVariation(assistant, 8, 2, 0, 0)
		SetPedComponentVariation(assistant, 4, 2, 0, 0)

		SetBlockingOfNonTemporaryEvents(assistant, true)
		SetEntityInvincible(assistant, true)
	end
end

local function EnableOfficeInterior(interiorID)		

	
	--EnableInteriorProp(interiorID, "swag_counterfeit3")

	--RefreshInterior(interiorID)
end

local function SetOrganisationName()
	local targetHash = -2082168399
	banner = RequestScaleformMovie("ORGANISATION_NAME")

	if HasScaleformMovieLoaded(banner) then
		playerID = PlayerId()
		playerName = GetPlayerName(playerID)

		PushScaleformMovieFunction(banner, "SET_ORGANISATION_NAME")
		PushScaleformMovieFunctionParameterString(tostring(playerName))

		PushScaleformMovieFunctionParameterInt(-1) -- scale
		PushScaleformMovieFunctionParameterInt(0) -- color
		PushScaleformMovieFunctionParameterInt(2) -- font
		PopScaleformMovieFunction()
	end

	if (not IsNamedRendertargetRegistered("prop_ex_office_text")) then
	    RegisterNamedRendertarget("prop_ex_office_text", 0)
        LinkNamedRendertarget(targetHash)

        Wait(500)

        if (not IsNamedRendertargetLinked(targetHash)) then
            ReleaseNamedRendertarget(GetHashKey("prop_ex_office_text"))
        end
    end

	--local renderID = GetNamedRendertargetRenderId("prop_ex_office_text")
	--SetTextRenderId(renderID)
	--DrawScaleformMovie(banner, 0.196*1.75, 0.345*1.5, 0.46*2.5, 0.66*2.5, 255, 255, 255, 255, 1)
	--SetTextRenderId(GetDefaultScriptRendertargetRenderId())
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId(), true)
		local interiorCode = GetInteriorFromEntity(PlayerPedId())
		local intCoords = GetInteriorAtCoords( 956.40850830078,-2991.8747558594,-39.646968841553)

		if GetDistanceBetweenCoords(playerCoords, 956.23120117188,-2988.7634277344,-39.646987915039, true) <= 3.0 then
			DrawMarker(20, 896.76483154297,-143.82655334473,76.823303222656, 0.0, 0.0, 0.0, 180.0, 0.0, 180.0, 1.5, 1.5, 1.0, 240, 200, 80, 180, false, true, 2, false, false, false, false)
			TriggerEvent("fs_freemode:displayHelp", i18n.translate("exit_taxi"))
		    if IsControlJustPressed(0, 38) then
			    SetEntityCoords(PlayerPedId(), 896.76483154297,-143.82655334473,76.823303222656, 90.790, false)
		        SetEntityAsNoLongerNeeded(assistant)
		        PlayerInsideOffice = false
	        end
        end

		if GetDistanceBetweenCoords(playerCoords, 896.76483154297,-143.82655334473,76.823303222656-1.0001) <= 50.0 then
			DrawMarker(20, 896.76483154297,-143.82655334473,76.823303222656, 0.0, 0.0, 0.0, 180.0, 0.0, 180.0, 1.5, 1.5, 1.0, 240, 200, 80, 180, false, true, 2, false, false, false, false)
		end

		if GetDistanceBetweenCoords(playerCoords, 896.76483154297,-143.82655334473,76.823303222656-1.0001, true) <= 2.0 then
			TriggerEvent("fs_freemode:displayHelp", i18n.translate("enter_taxi"))
		    --vRP.notifyPicture({"CHAR_TAXI", 2,"Entreprise de Taxi", "~g~Taxi 13","Si tu es le Boss de cette entreprise. Elle rapporte ~g~26400€ ~w~toutes les 30 mn a chaque actionnaire !"})
			if IsControlJustPressed(1, 38) then
				--vRP.notifyPicture({"CHAR_TAXI", 2,"Entreprise de Taxi", "~g~Taxi 13","Si tu es le Boss de cette entreprise. Elle rapporte ~g~26400€ ~w~toutes les 30 mn a chaque actionnaire !"})
				if not DoesEntityExist(assistant) then
					CreateAssistantPed()
				end
				Citizen.Wait(500)
                DoScreenFadeIn(500)
				TriggerServerEvent('business:checkmoney8')
				--vRP.notifyPicture({"CHAR_TAXI", 2,"Entreprise de Taxi", "~g~Taxi 13","Si tu es le Boss de cette entreprise. Elle rapporte ~g~26400€ ~w~toutes les 30 mn a chaque actionnaire !"})
				--end
				--SetEntityCoords(PlayerPedId(), 956.40850830078,-2991.8747558594,-39.646968841553)
				--SetPedCoordsKeepVehicle(player, 956.40850830078,-2991.8747558594,-39.646968841553-1.0)
						--else
				
				--TriggerServerEvent('fs_freemode:pay', 10000)


				--EnableOfficeInterior(intCoords)
				--PlayerInsideOffice = true
			--else
				--TriggerServerEvent('business:checkmoney5')
			end
		end
	end
end)

RegisterNetEvent('business:success')
AddEventHandler('business:success', function()
	--vRP.teleport(956.40850830078,-2991.8747558594,-39.646968841553)
	vRP.notifyPicture({"CHAR_BANK_FLEECA", 2,"Information de la Banque", "~g~Entreprise Aquis !","Tu es le Boss de cette entreprise. Cette entreprise rapporte ~g~26400€ ~w~toutes les 30 mn !"})
end)

RegisterNetEvent('business:notenough')
AddEventHandler('business:notenough', function()
    vRP.notifyPicture({"CHAR_TAXI", 2,"Entreprise de Taxi", "~g~Taxi 13","Si tu es le Boss de cette entreprise. Elle rapporte ~g~26400€ ~w~toutes les 30 mn a chaque actionnaire !"})--vRP.teleport(956.40850830078,-2991.8747558594,-39.646968841553)
end)

RegisterNetEvent('business:alreadyin')
AddEventHandler('business:alreadyin', function()
	--vRP.teleport(956.40850830078,-2991.8747558594,-39.646968841553)
    vRP.notifyPicture({"CHAR_TAXI", 2,"Entreprise de Taxi", "~g~Taxi 13","Si tu es le Boss de cette entreprise. Elle rapporte ~g~26400€ ~w~toutes les 30 mn a chaque actionnaire !"})--vRP.teleport(956.40850830078,-2991.8747558594,-39.646968841553)
end)

RegisterNetEvent('business:note')
AddEventHandler('business:note', function()
	vRP.notify({"~r~Il faut ouvrir votre registre de commerce avant."})
end)

