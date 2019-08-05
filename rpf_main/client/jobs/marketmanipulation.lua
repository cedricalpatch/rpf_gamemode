local storeBlips = { }
local storePickups = { }


AddEventHandler('lsv:startJourDeBraquage', function()
	local pickupHash = GetHashKey('PICKUP_MONEY_CASE')
	local placesCount = Utils.GetTableLength(Settings.marketManipulation.places)

	for i = 1, placesCount do
		local place = Settings.marketManipulation.places[i]

		storePickups[i] = CreatePickupRotate(pickupHash, place.x, place.y, place.z, 0., 0., 0., 512)

		local blip = AddBlipForCoord(place.x, place.y, place.z)
		SetBlipSprite(blip, Blip.Store())
		SetBlipHighDetail(blip, true)
		Map.SetBlipFlashes(blip)
		storeBlips[i] = blip
	end

	JobWatcher.StartJob('Jour de braquage')

	local eventStartTime = GetGameTimer()
	local totalRobberies = 0
	local jobId = JobWatcher.GetJobId()

	Citizen.CreateThread(function()
		Gui.StartJob('Jour de braquage', 'Braque les magasin et banque dans le temps limite.')
	end)

	while true do
		Citizen.Wait(0)

		if GetTimeDifference(GetGameTimer(), eventStartTime) < Settings.marketManipulation.time then
			if Utils.GetTableLength(storePickups) == 0 then
				TriggerServerEvent('lsv:marketManipulationFinished')
				return
			end

			for i = placesCount, 1, -1 do
				if HasPickupBeenCollected(storePickups[i]) then
					SetBlipSprite(storeBlips[i], Blip.Completed())
					SetBlipAsShortRange(storeBlips[i], true)

					TriggerServerEvent('lsv:marketManipulationRobbed')
					Gui.DisplayNotification('Vous avez pris le cash.')
					totalRobberies = totalRobberies + 1
					storePickups[i] = nil

					World.SetWantedLevel(2)
				end
			end

			Gui.DisplayObjectiveText('Vous avez rien braquez.')

			if not IsPlayerDead(PlayerId()) then
				Gui.DrawTimerBar('TEMPS LIMITE', math.floor((Settings.marketManipulation.time - GetGameTimer() + eventStartTime) / 1000))
				Gui.DrawBar('TOTAL AQUIS', totalRobberies, nil, 2)
			end
		else
			TriggerServerEvent('lsv:marketManipulationFinished')
			return
		end
	end
end)


RegisterNetEvent('lsv:marketManipulationFinished')
AddEventHandler('lsv:marketManipulationFinished', function(success, reason)
	JobWatcher.FinishJob('Jour de braquage')

	for i = Utils.GetTableLength(Settings.marketManipulation.places), 1, -1 do
		RemoveBlip(storeBlips[i])
		RemovePickup(storePickups[i])
	end

	storeBlips = { }
	storePickups = { }

	World.SetWantedLevel(0)

	Gui.FinishJob('Jour de braquage', success, reason)
end)
