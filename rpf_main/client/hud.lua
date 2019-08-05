AddEventHandler('lsv:init', function()
	--https://pastebin.com/amtjjcHb
	local tips = {
	    "Ton menu personnel sur ~INPUT_REPLAY_TIMELINE_SAVE~ pour voir argents, identiter, inventaire...",
		"Appuis sur ~INPUT_HUD_SPECIAL~ pour voir le scoreboard XP, equipe selon couleur...",
		"Effectuer des missions sur le telephone ~INPUT_CELLPHONE_UP~ et gagner du cash !",
		--"Argent supplementaire si vous tuer des joueurs qui font une mission.",
		"Stunt Jumps va vous donner du cash selon la distance et la hauteur.",
		"Presse ~INPUT_INTERACTION_MENU~ pour le menu Interaction, offrir un travail, GPS, demarche...",
		"Utilise le menu Interaction ou visite directement ~BLIP_GUN_SHOP~ pour ameliore vos armes.",
		"Presse ~INPUT_HUD_SPECIAL~ pour agrandir le Radar, nom du vehicule et lieu ou tu est.",
		"Les parking te permete de sauvegarde le tuning des vehicules pas les garages !",
		"Visite ~BLIP_CLOTHES_STORE~ pour changer tes affaires et le coiffeure pour le visage.",
		"Utilise ton menu Interaction pour reporter un probleme ou partage ton experience de jeux.",
	}
	local tipTime = 10000
	local tipInterval = 30000

	for _, tip in ipairs(tips) do
		SetTimeout(tipTime, function()
			Gui.DisplayHelpText(tip)
		end)

		tipTime = tipTime + tipInterval
	end
end)


RegisterNetEvent('lsv:playerDisconnected')
AddEventHandler('lsv:playerDisconnected', function(name, player, reason)
	Gui.DisplayNotification('<C>'..name..'</C> left ~m~('..reason..')')
end)


RegisterNetEvent('lsv:playerConnected')
AddEventHandler('lsv:playerConnected', function(player)
	local playerId = GetPlayerFromServerId(player)
	if PlayerId() ~= playerId and NetworkIsPlayerActive(playerId) then
		Gui.DisplayNotification(Gui.GetPlayerName(player).." connecter.")
		Map.SetBlipFlashes(GetBlipFromEntity(GetPlayerPed(playerId)))
	end
end)


RegisterNetEvent('lsv:onPlayerDied')
AddEventHandler('lsv:onPlayerDied', function(player, suicide)
	if NetworkIsPlayerActive(GetPlayerFromServerId(player)) then
		if suicide then
			Gui.DisplayNotification(Gui.GetPlayerName(player).." c\'est suicider.")
		else
			Gui.DisplayNotification(Gui.GetPlayerName(player).." est mort.")
		end
	end
end)


RegisterNetEvent('lsv:onPlayerKilled')
AddEventHandler('lsv:onPlayerKilled', function(player, killer, message)
	if NetworkIsPlayerActive(GetPlayerFromServerId(player)) and NetworkIsPlayerActive(GetPlayerFromServerId(killer)) then
		Gui.DisplayNotification(Gui.GetPlayerName(killer).." "..message.." "..Gui.GetPlayerName(player, nil, true))
	end
end)


-- GUI
AddEventHandler('lsv:init', function()
	while true do
		Citizen.Wait(0)

		if IsControlPressed(0, 20) then
			Scoreboard.DisplayThisFrame()
		elseif IsPlayerDead(PlayerId()) then
			if DeathTimer then
				if IsControlJustReleased(0, 24) then DeathTimer = DeathTimer - Settings.spawn.respawnFasterPerControlPressed end
				Gui.DrawProgressBar('RESPAWNING', GetTimeDifference(GetGameTimer(), DeathTimer) / TimeToRespawn, Color.GetHudFromBlipColor(Color.BlipRed()))
			end
		end
	end
end)


AddEventHandler('lsv:init', function()
	local scaleform = Scaleform:Request('MP_BIG_MESSAGE_FREEMODE')
	scaleform:Call('SHOW_SHARD_WASTED_MP_MESSAGE', '~r~TU EST MORT')

	local respawnFasterScaleform = Scaleform:Request('INSTRUCTIONAL_BUTTONS')
	respawnFasterScaleform:Call('SET_DATA_SLOT', 0, '~INPUT_ATTACK~', 'Respawn vite')
	respawnFasterScaleform:Call('DRAW_INSTRUCTIONAL_BUTTONS')

	RequestScriptAudioBank('MP_WASTED', 0)

	while true do
		Citizen.Wait(0)

		if IsPlayerDead(PlayerId()) then
			StartScreenEffect('DeathFailOut', 0, true)
			ShakeGameplayCam('DEATH_FAIL_IN_EFFECT_SHAKE', 1.0)
			PlaySoundFrontend(-1, 'MP_Flash', 'WastedSounds', 1)

			local scaleformTimer = GetGameTimer()
			while GetTimeDifference(GetGameTimer(), scaleformTimer) <= 500 do
				respawnFasterScaleform:RenderFullscreen()
				Citizen.Wait(0)
			end

			while IsPlayerDead(PlayerId()) do
				scaleform:RenderFullscreen()
				respawnFasterScaleform:RenderFullscreen()
				Citizen.Wait(0)
			end

			StopScreenEffect('DeathFailOut')
			StopGameplayCamShaking(true)
		end
	end
end)


RegisterNetEvent('lsv:setupHud')
AddEventHandler('lsv:setupHud', function(hud)
	if hud.pauseMenuTitle ~= '' then
		AddTextEntry('FE_THDR_GTAO', hud.pauseMenuTitle)
	end

	while true do
		Citizen.Wait(0)

		if hud.discordUrl ~= '' then
			Gui.SetTextParams(7, { r = 254, g = 254, b = 254, a = 96 }, 0.25, true, false, true)
			Gui.DrawText(hud.discordUrl, { x = 0.5, y = 0.98 })
		end

		RemoveMultiplayerBankCash()
		RemoveMultiplayerHudCash()
	end
end)


AddEventHandler('lsv:init', function()
	local isBigMapEnabled = false

	while true do
		if IsControlJustReleased(0, 243) then
			isBigMapEnabled = not isBigMapEnabled
			Citizen.InvokeNative(0x231C8F89D0539D8F, isBigMapEnabled, false)
		end

		Citizen.Wait(0)
	end
end)


AddEventHandler('lsv:init', function()
	while true do
		local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId()))

		for id = 0, Settings.maxPlayerCount do
			if id ~= PlayerId() then
				local ped = GetPlayerPed(id)
				local blip = GetBlipFromEntity(ped)

				if NetworkIsPlayerActive(id) and ped ~= nil then
					if not DoesBlipExist(blip) then
						blip = AddBlipForEntity(ped)
						SetBlipHighDetail(blip, true)
						SetBlipCategory(blip, 7)
					end

					local isPlayerDead = IsPlayerDead(id)

					local serverId = GetPlayerServerId(id)
					local isPlayerBounty = serverId == World.BountyPlayer
					local isPlayerHotProperty = serverId == World.HotPropertyPlayer
					local isPlayerInCrew = Player.isCrewMember(serverId)
					local isPlayerDoingJob = JobWatcher.IsDoingJob(serverId)

					local blipSprite = Blip.Standard()
					if isPlayerDead then blipSprite = Blip.Dead()
					elseif isPlayerHotProperty then blipSprite = Blip.HotProperty()
					elseif isPlayerBounty then blipSprite = Blip.BountyHit()
					elseif isPlayerDoingJob then blipSprite = Blip.PolicePlayer() end

					local scale = 0.85
					if isPlayerHotProperty or isPlayerDoingJob or isPlayerBounty then scale = 1.0 end
					SetBlipScale(blip, scale)

					local blipColor = Color.BlipWhite()
					if isPlayerInCrew then blipColor = Color.BlipBlue()
					elseif isPlayerHotProperty then blipColor = Color.BlipRed()
					elseif isPlayerBounty then blipColor = Color.BlipRed()
					elseif isPlayerDoingJob then blipColor = Color.BlipPurple() end

					local blipAlpha = 0
					if isPlayerInCrew or isPlayerBounty or isPlayerHotProperty or isPlayerDoingJob or isPlayerDead then
						blipAlpha = 255
					elseif not GetPedStealthMovement(ped) then
						local x, y, z = table.unpack(GetEntityCoords(ped))
						if GetDistanceBetweenCoords(playerX, playerY, playerZ, x, y, z, false) < Settings.playerBlipDistance then
							blipAlpha = 255
						end
					end

					if GetBlipSprite(blip) ~= blipSprite then SetBlipSprite(blip, blipSprite) end
					if GetBlipAlpha(blip) ~= blipAlpha then SetBlipAlpha(blip, blipAlpha) end

					ShowHeadingIndicatorOnBlip(blip, blipSprite == Blip.Standard())
					SetBlipFriendly(blip, isPlayerInCrew)
					SetBlipColour(blip, blipColor)
					SetBlipNameToPlayerName(blip, id)
				else
					SetBlipAlpha(blip, 0)
				end
			end
		end

		Citizen.Wait(0)
	end
end)
