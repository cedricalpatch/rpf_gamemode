AddEventHandler('lsv:startEnnemiPublique', function()
	JobWatcher.StartJob('Ennemi publique')

	local eventStartTime = GetGameTimer()
	local jobId = JobWatcher.GetJobId()
	local lastNotificationTime = nil

	Citizen.CreateThread(function()
		Gui.StartJob('Ennemi publique', 'Survivre le plus longtemp possible.')
	end)

	while true do
		Citizen.Wait(0)

		if GetTimeDifference(GetGameTimer(), eventStartTime) < Settings.mostWanted.time then
			World.SetWantedLevel(5)

			local passedTime = GetGameTimer() - eventStartTime

			if IsPlayerDead(PlayerId()) then
				TriggerServerEvent('lsv:mostWantedFinished', passedTime)
				return
			end

			if not lastNotificationTime or GetTimeDifference(GetGameTimer(), lastNotificationTime) >= Settings.mostWanted.notification.timeout then
				Gui.DisplayNotification(Utils.GetRandom(Settings.mostWanted.notification.messages), 'CHAR_DEFAULT', GetPlayerName(PlayerId()))
				lastNotificationTime = GetGameTimer()
			end

			local secondsLeft = math.floor((Settings.mostWanted.time - passedTime) / 1000)
			Gui.DrawTimerBar('Temp limite', secondsLeft)
			Gui.DrawTimerBar('Temp de survie', math.floor(passedTime / 1000), nil, 2)
			Gui.DisplayObjectiveText('Survivre le plus longtemp possible.')
		else
			TriggerServerEvent('lsv:mostWantedFinished', Settings.mostWanted.time)
			return
		end
	end
end)


RegisterNetEvent('lsv:mostWantedFinished')
AddEventHandler('lsv:mostWantedFinished', function(success, reason)
	JobWatcher.FinishJob('Ennemi publique')

	World.SetWantedLevel(0)

	Gui.FinishJob('Ennemi publique', success, reason)
end)
