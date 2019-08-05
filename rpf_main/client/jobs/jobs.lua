local missionPlaces = { }
local missionIds = { 'EnnemiPublique', 'Nettoyeur', 'AlerteBombe', 'Recouvrement', 'JourDeBraquage' }
local missionNames = {
	['EnnemiPublique'] = 'Ennemi publique',
	['Nettoyeur'] = 'Nettoyeur',
	['AlerteBombe'] = 'Alerte Bombe',
	['Recouvrement'] = 'Recouvrement Amiable',
	['JourDeBraquage'] = 'Jour de raquage',
}


AddEventHandler('lsv:init', function()
	for _, place in ipairs(Settings.mission.places) do
		local mission = { }
		mission.startTime = nil
		mission.mission = Utils.GetRandom(missionIds)
		mission.blip = Map.CreatePlaceBlip(Blip.Mission(), place.x, place.y, place.z, missionNames[mission.mission], Color.BlipPurple())
		table.insert(missionPlaces, mission)
	end

	while true do
		Citizen.Wait(0)

		if not IsPlayerDead(PlayerId()) then
			for _, place in ipairs(missionPlaces) do
				local alpha = 255
				if JobWatcher.IsAnyJobInProgress() or place.startTime then alpha = 0 end
				SetBlipAlpha(place.blip, alpha)

				if place.startTime and GetTimeDifference(GetGameTimer(), place.startTime) >= Settings.mission.timeout then
					place.startTime = nil
					place.mission = Utils.GetRandom(missionIds)
					Map.SetBlipText(place.blip, missionNames[place.mission])
					Map.SetBlipFlashes(place.blip, 5000)
				end

				if not JobWatcher.IsAnyJobInProgress() then
					local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId()))
					local placeX, placeY, placeZ = table.unpack(GetBlipCoords(place.blip))
					if not place.startTime and GetDistanceBetweenCoords(playerX, playerY, playerZ, placeX, placeY, placeZ, true) < Settings.placeMarkerRadius then
						Gui.DisplayHelpText('Presse ~INPUT_PICKUP~ pour demarrer '..missionNames[place.mission]..'.')
						if IsControlJustReleased(0, 38) then
							place.startTime = GetGameTimer()
							SetBlipAlpha(place.blip, 0)
							SetTimeout(1000, function() TriggerEvent('lsv:start'..place.mission) end)
						end
					end
				end
			end
		end
	end
end)