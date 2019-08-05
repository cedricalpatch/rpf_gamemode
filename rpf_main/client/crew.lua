local alreadyInvited = false


AddEventHandler('lsv:playerDisconnected', function(playerName, player)
	local playerIndex = Player.isCrewMember(player)
	if playerIndex then table.remove(Player.crewMembers, playerIndex) end
end)


RegisterNetEvent('lsv:crewLeaved')
AddEventHandler('lsv:crewLeaved', function(player)
	local playerIndex = Player.isCrewMember(player)

	if playerIndex then
		FlashMinimapDisplay()
		table.remove(Player.crewMembers, playerIndex)
		Gui.DisplayNotification(Gui.GetPlayerName(player, "~b~").." qui votre entreprise.")
	elseif player == Player.ServerId() then
		Utils.Clear(Player.crewMembers)
		Gui.DisplayNotification(Gui.GetPlayerName(player, "~b~").." qui votre entreprise.")
	end
end)


RegisterNetEvent('lsv:invitedToCrew')
AddEventHandler('lsv:invitedToCrew', function(player)
	if not Utils.IsTableEmpty(Player.crewMembers) or alreadyInvited then TriggerServerEvent('lsv:alreadyInCrew', player)
	else
		PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
		Gui.DisplayNotification("Je vous propose une offre de travaille .", "CHAR_MULTIPLAYER", Gui.GetPlayerName(player))

		alreadyInvited = true
		local inviteTimer = GetGameTimer()

		while true do
			Citizen.Wait(0)

			if GetTimeDifference(GetGameTimer(), inviteTimer) >= Settings.crewInvitationTimeout then
				Gui.DisplayNotification('Vous avez refusez le travaille offert par '..Gui.GetPlayerName(player))
				TriggerServerEvent('lsv:declineInvitation', player)
				alreadyInvited = false
				return
			end

			if IsControlPressed(0, 166) then
				Utils.Clear(Player.crewMembers)
				table.insert(Player.crewMembers, player)
				TriggerServerEvent('lsv:acceptInvitation', player)
				Gui.DisplayNotification('Vous avez accepte le travaille de '..Gui.GetPlayerName(player)..'.')
				alreadyInvited = false
				return
			end

			Gui.DisplayHelpText('Presse ~INPUT_SELECT_CHARACTER_MICHAEL~ pour accepte le travaille de '..Gui.GetPlayerName(player))
		end
	end
end)


RegisterNetEvent('lsv:invitationAccepted')
AddEventHandler('lsv:invitationAccepted', function(player)
	TriggerServerEvent('lsv:updateCrewMembers', player, Player.crewMembers)
	table.insert(Player.crewMembers, player)

	FlashMinimapDisplay()
	PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
	Gui.DisplayNotification(Gui.GetPlayerName(player)..' a accepte votre offre de travaille.')
	TriggerServerEvent('lsv:addCrewMember', player)
end)


RegisterNetEvent('lsv:crewMembersUpdated', function(members)
	for _, crewMember in ipairs(members) do
		table.insert(Player.crewMembers, crewMember)
	end
end)


RegisterNetEvent('lsv:invitationDeclined')
AddEventHandler('lsv:invitationDeclined', function(player)
	PlaySoundFrontend(-1, "MP_IDLE_TIMER", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
	Gui.DisplayNotification(Gui.GetPlayerName(player)..' a refuse votre offre.')
end)


RegisterNetEvent('lsv:addedCrewMember')
AddEventHandler('lsv:addedCrewMember', function(player, member, members)
	if player ~= Player.ServerId() and Player.ServerId() ~= member and Player.isCrewMember(player) then
		table.insert(Player.crewMembers, member)

		FlashMinimapDisplay()
		PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
		Gui.DisplayNotification(GetPlayerName(member)..' a rejoint votre entreprise.')
	end
end)


RegisterNetEvent('lsv:alreadyInCrew')
AddEventHandler('lsv:alreadyInCrew', function(player)
	PlaySoundFrontend(-1, "MP_IDLE_TIMER", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
	Gui.DisplayNotification(Gui.GetPlayerName(player).." est deja dans une entreprise.")
end)