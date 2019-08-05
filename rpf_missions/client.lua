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

i18n.setLang(Setup.Language)
MissionStarted = false

firstTick = false
firstJoin = true

spawnLock = false
sendmsg = false
playerName = nil

scaleform = nil
instructional = nil

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

local isRadarExtended = false

Citizen.CreateThread(function()

	while true do

		Wait( 1 )

		-- extend minimap on keypress
		if IsControlJustPressed( 0, 20 ) then

			if not isRadarExtended then

				SetRadarBigmapEnabled( true, false )
				isRadarExtended = true

				Citizen.CreateThread(function()

					run = true

					while run do

						for i = 0, 500 do

							Wait(1)

							if not isRadarExtended then

								run = false
								break

							end

						end

						SetRadarBigmapEnabled( false, false )
						isRadarExtended = false

					end

				end)

			else

				SetRadarBigmapEnabled( false, false )
				isRadarExtended = false

			end

		end

		-- show blips
		for id = 0, 64 do

			if NetworkIsPlayerActive( id ) and GetPlayerPed( id ) ~= GetPlayerPed( -1 ) then

				ped = GetPlayerPed( id )
				blip = GetBlipFromEntity( ped )

				-- HEAD DISPLAY STUFF --

				-- Create head display (this is safe to be spammed)
				headId = Citizen.InvokeNative( 0xBFEFE3321A3F5015, ped, GetPlayerName( id ), false, false, "", false )
				wantedLvl = GetPlayerWantedLevel( id )

				-- Wanted level display
				if wantedLvl then

					Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 7, true ) -- Add wanted sprite
					Citizen.InvokeNative( 0xCF228E2AA03099C3, headId, wantedLvl ) -- Set wanted number

				else

					Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 7, false ) -- Remove wanted sprite

				end

				-- Speaking display
				if NetworkIsPlayerTalking( id ) then

					Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 9, true ) -- Add speaking sprite

				else

					Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 9, false ) -- Remove speaking sprite

				end

				-- BLIP STUFF --

				if not DoesBlipExist( blip ) then -- Add blip and create head display on player

					blip = AddBlipForEntity( ped )
					SetBlipSprite( blip, 1 )
					Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true ) -- Player Blip indicator

				else -- update blip

					veh = GetVehiclePedIsIn( ped, false )
					blipSprite = GetBlipSprite( blip )

					if not GetEntityHealth( ped ) then -- dead

						if blipSprite ~= 274 then

							SetBlipSprite( blip, 274 )
							Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false ) -- Player Blip indicator

						end

					elseif veh then

						vehClass = GetVehicleClass( veh )
						vehModel = GetEntityModel( veh )
						
						if vehClass == 15 then -- jet

							if blipSprite ~= 422 then

								SetBlipSprite( blip, 422 )
								Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false ) -- Player Blip indicator

							end

						elseif vehClass == 16 then -- plane

							if vehModel == GetHashKey( "besra" ) or vehModel == GetHashKey( "hydra" )
								or vehModel == GetHashKey( "lazer" ) then -- jet

								if blipSprite ~= 424 then

									SetBlipSprite( blip, 424 )
									Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false ) -- Player Blip indicator

								end

							elseif blipSprite ~= 423 then

								SetBlipSprite( blip, 423 )
								Citizen.InvokeNative (0x5FBCA48327B914DF, blip, false ) -- Player Blip indicator

							end

						elseif vehClass == 14 then -- boat

							if blipSprite ~= 427 then

								SetBlipSprite( blip, 427 )
								Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false ) -- Player Blip indicator

							end

						elseif vehModel == GetHashKey( "insurgent" ) or vehModel == GetHashKey( "insurgent2" )
						or vehModel == GetHashKey( "limo2" ) then -- insurgent (+ turreted limo cuz limo blip wont work)

							if blipSprite ~= 426 then

								SetBlipSprite( blip, 426 )
								Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false ) -- Player Blip indicator

							end

						elseif vehModel == GetHashKey( "rhino" ) then -- tank

							if blipSprite ~= 421 then

								SetBlipSprite( blip, 421 )
								Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false ) -- Player Blip indicator

							end

						elseif blipSprite ~= 1 then -- default blip

							SetBlipSprite( blip, 1 )
							Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true ) -- Player Blip indicator

						end

						-- Show number in case of passangers
						passengers = GetVehicleNumberOfPassengers( veh )

						if passengers then

							if not IsVehicleSeatFree( veh, -1 ) then

								passengers = passengers + 1

							end

							ShowNumberOnBlip( blip, passengers )

						else

							HideNumberOnBlip( blip )

						end

					else

						-- Remove leftover number
						HideNumberOnBlip( blip )

						if blipSprite ~= 1 then -- default blip

							SetBlipSprite( blip, 1 )
							Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true ) -- Player Blip indicator

						end

					end

					SetBlipRotation( blip, math.ceil( GetEntityHeading( veh ) ) ) -- update rotation
					SetBlipNameToPlayerName( blip, id ) -- update blip name
					SetBlipScale( blip,  0.85 ) -- set scale

					-- set player alpha
					if IsPauseMenuActive() then

						SetBlipAlpha( blip, 255 )

					else

						x1, y1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
						x2, y2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
						distance = ( math.floor( math.abs( math.sqrt( ( x1 - x2 ) * ( x1 - x2 ) + ( y1 - y2 ) * ( y1 - y2 ) ) ) / -1 ) ) + 900
						-- Probably a way easier way to do this but whatever im an idiot

						if distance < 0 then

							distance = 0

						elseif distance > 255 then

							distance = 255

						end

						SetBlipAlpha( blip, distance )

					end

				end

			end

		end

	end

end)

Citizen.CreateThread(function() 
    while true do   
		
        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
            local lock = GetVehicleDoorLockStatus(veh)

            if lock == 7 then
                SetVehicleDoorsLocked(veh, 2)
            end
                 
            local pedd = GetPedInVehicleSeat(veh, -1)

            if pedd then                   
                SetPedCanBeDraggedOut(pedd, false)
            end             
        end   
        Citizen.Wait(1)	
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -1028.50646972656,-2719.64575195313,20.4863452911377, true) <= 22 then 
			Drawing.draw3DText(-1028.50646972656, -2719.64575195313, 20.4863452911377 + 1.700, "Bienvenue sur ~b~RPF ~w~Stu~r~dio !", 6, 1.0, 0.8)
			Drawing.draw3DText(-1028.50646972656, -2719.64575195313, 20.4863452911377 + 2.800, "~r~!~y~ Serveur Role Play Libre, PvP, PvE Interaction ~r~!", 8, 0.4, 0.3)
			Drawing.draw3DText(-1028.50646972656, -2719.64575195313, 20.4863452911377, "Reglement et Informations sur : ~y~discord.gg/7tPsXT7 ", 8, 0.4, 0.3)
			Drawing.draw3DText(-1028.50646972656, -2719.64575195313, 20.4863452911377 - .700, "Bon Jeu à Tous et restez ~g~fair-play !", 8, 0.4, 0.3)
		end
	end
end)


Drawing = setmetatable({}, Drawing)
Drawing.__index = Drawing

function Drawing.draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 150)
    SetTextDropshadow(1, 1, 1, 0, 255)
    SetTextEdge(2, 0, 0, 0, 220)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end