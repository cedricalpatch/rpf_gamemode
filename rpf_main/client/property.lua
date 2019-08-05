local titles = { 'WINNERS', '2ND PLACE', '3RD PLACE' }

local propertyData = nil

local function createBriefcase(x, y, z)
	propertyData.pickup = CreatePickupRotate(GetHashKey('PICKUP_MONEY_CASE'), x, y, z, 0.0, 0.0, 0.0, 8, 1)
	propertyData.blip = Map.CreatePickupBlip(propertyData.pickup, 'PICKUP_MONEY_CASE', Color.BlipGreen())
	SetBlipAsShortRange(propertyData.blip, false)
	SetBlipScale(propertyData.blip, 1.1)
end

local function removeBriefcase()
	if propertyData.pickup then
		RemovePickup(propertyData.pickup)
		propertyData.pickup = nil

		RemoveBlip(propertyData.blip)
		propertyData.blip = nil
	end
end

local function getPlayerTime()
	for i, v in pairs(propertyData.players) do
		if v.id == Player.ServerId() then
			local playerTime = v.totalTime / 1000
			return string.format("%02.f", math.floor(playerTime / 60))..':'..string.format("%02.f", math.floor(playerTime % 60))
		end
	end

	return '00:00'
end


RegisterNetEvent('lsv:startHotProperty')
AddEventHandler('lsv:startHotProperty', function(placeIndex, passedTime, players, currentPlayer)
	local place = Settings.property.places[placeIndex]

	propertyData = { }

	-- This is shit. New players will not see briefcase. Should fix in 1s
	if not currentPlayer and not passedTime then createBriefcase(place.x, place.y, place.z) end

	if propertyData.blip and Player.IsInFreeroam() then
		FlashMinimapDisplay()
		Map.SetBlipFlashes(propertyData.blip)
		PlaySoundFrontend(-1, 'MP_5_SECOND_TIMER', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
		vRP.notifyPicture({"CHAR_TENNIS_COACH", 1, "Malette d\'Argent", "~g~Va vite la recuperer !", "Va cherche la malette et garde la le plus possible pour avoir le cash."})
	end

	propertyData.startTime = GetGameTimer()
	if passedTime then propertyData.startTime = propertyData.startTime - passedTime end

	propertyData.players = { }
	if players then propertyData.players = players end

	World.HotPropertyPlayer = currentPlayer

	local playerColors = { Color.BlipYellow(), Color.BlipGrey(), Color.BlipBrown() }
	local playerPositions = { '1st: ', '2nd: ', '3rd: ' }
	local lastTimeIncreased = GetGameTimer()

	while true do
		Citizen.Wait(0)

		if not propertyData then return end

		if propertyData.pickup then
			if HasPickupBeenCollected(propertyData.pickup) then
				TriggerServerEvent('lsv:hotPropertyCollected')
				removeBriefcase()
			else
				SetBlipAlpha(propertyData.blip, JobWatcher.IsAnyJobInProgress() and 0 or 255)
			end
		end

		if World.HotPropertyPlayer == Player.ServerId() and GetTimeDifference(GetGameTimer(), lastTimeIncreased) >= 1000 then
			TriggerServerEvent('lsv:hotPropertyTimeUpdated')
			lastTimeIncreased = GetGameTimer()
		end

		if Player.IsInFreeroam() then
			if propertyData.pickup then
				local x, y, z = table.unpack(GetPickupCoords(propertyData.pickup))
				DrawMarker(20, x, y, z + 0.25, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.85, 0.85, 0.85, 114, 204, 114, 96, true, true)
			end

			Gui.DrawTimerBar('EVENT FINI', math.max(0, math.floor((Settings.property.duration - GetGameTimer() + propertyData.startTime) / 1000)))

			Gui.DrawBar('TIME HELD', getPlayerTime(), Color.GetHudFromBlipColor(Color.BlipWhite()), 2)

			if not Utils.IsTableEmpty(propertyData.players) then
				local barPosition = 3
				for i = 3, 1, -1 do
					if propertyData.players[i] then
						local playerTime = propertyData.players[i].totalTime / 1000
						Gui.DrawBar(playerPositions[i]..GetPlayerName(GetPlayerFromServerId(propertyData.players[i].id)), string.format("%02.f", math.floor(playerTime / 60))..':'..string.format("%02.f", math.floor(playerTime % 60)),
							Color.GetHudFromBlipColor(playerColors[i]), barPosition, true)
						barPosition = barPosition + 1
					end
				end
			end

			local eventObjectiveText = '' ---- texte au centre de l ecrans
			if World.HotPropertyPlayer then
				if World.HotPropertyPlayer == Player.ServerId() then
					eventObjectiveText = 'Garde la le plus possible pour avoir le cash.'
				else eventObjectiveText = Gui.GetPlayerName(World.HotPropertyPlayer, '~w~')..' a la ~r~malett~w~. va la luis prendre.' end
			end
			Gui.DisplayObjectiveText(eventObjectiveText)
		end
	end
end)


RegisterNetEvent('lsv:updateHotPropertyPlayers')
AddEventHandler('lsv:updateHotPropertyPlayers', function(players)
	if propertyData then
		propertyData.players = players
	end
end)


RegisterNetEvent('lsv:hotPropertyCollected')
AddEventHandler('lsv:hotPropertyCollected', function(player)
	removeBriefcase()

	World.HotPropertyPlayer = player
end)


RegisterNetEvent('lsv:hotPropertyDropped')
AddEventHandler('lsv:hotPropertyDropped', function(player)
	if not propertyData then return end
	local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player))))
	removeBriefcase()
	createBriefcase(x, y, z)
	World.HotPropertyPlayer = nil
end)


RegisterNetEvent('lsv:finishHotProperty')
AddEventHandler('lsv:finishHotProperty', function(winners)
	if propertyData then removeBriefcase() end

	if not winners then
		propertyData = nil
		Gui.DisplayNotification('Recuperation de malette fini.')
		return
	end

	if not Player.IsActive() then
		propertyData = nil
		return
	end

	if Player.IsOnMission() then
		propertyData = nil
		FlashMinimapDisplay()
		Gui.DisplayNotification(Gui.GetPlayerName(winners[1], '~p~')..' personne qui a tenue le plus longtemps.')
		return
	end

	local isPlayerWinner = false
	for i = 1, 3 do
		if winners[i] and winners[i] == Player.ServerId() then
			isPlayerWinner = i
			break
		end
	end

	local messageText = Gui.GetPlayerName(winners[1])..' personne qui a tenue le plus longtemps.'
	if isPlayerWinner then messageText = 'Tu est la personne qui a tenue le plus longtemps '..getPlayerTime() end

	propertyData = nil
	World.HotPropertyPlayer = nil

	if isPlayerWinner then PlaySoundFrontend(-1, 'Mission_Pass_Notify', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
	else PlaySoundFrontend(-1, 'ScreenFlash', 'MissionFailedSounds', true) end

	local scaleform = Scaleform:Request('MIDSIZED_MESSAGE')

	scaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', isPlayerWinner and titles[isPlayerWinner] or 'YOU LOSE', messageText, 21)
	scaleform:RenderFullscreenTimed(10000)

	scaleform:Delete()
end)