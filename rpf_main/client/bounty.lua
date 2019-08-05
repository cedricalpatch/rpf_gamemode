local bountyText = 'Attention a toi on a mis une prime sur ta tete !'

RegisterNetEvent('lsv:setBounty')
AddEventHandler('lsv:setBounty', function(bountyServerPlayerId)
	World.BountyPlayer = bountyServerPlayerId

	if not bountyServerPlayerId then return end

	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)

	if Player.ServerId() == bountyServerPlayerId then
		Gui.DisplayNotification(bountyText, 'CHAR_LESTER_DEATHWISH', 'Inconue', '', 2)

		Citizen.Wait(1500)

		local bountyScaleform = Scaleform:Request('MIDSIZED_MESSAGE')

		bountyScaleform:Call('SHOW_SHARD_MIDSIZED_MESSAGE', 'PRIME', bountyText)
		bountyScaleform:RenderFullscreenTimed(7000)

		bountyScaleform:Delete()
	else
		FlashMinimapDisplay()
		Gui.DisplayNotification('Une prime est mis sur la tete de '..Gui.GetPlayerName(bountyServerPlayerId, '~r~')..'.')
	end
end)


RegisterNetEvent('lsv:bountyKilled')
AddEventHandler('lsv:bountyKilled', function(killer)
	if Player.ServerId() ~= killer and World.BountyPlayer then
		Gui.DisplayNotification('La prime sur '..Gui.GetPlayerName(World.BountyPlayer, nil, true)..' est gagner par '..Gui.GetPlayerName(killer))
	end

	World.BountyPlayer = nil
end)