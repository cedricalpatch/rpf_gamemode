Skinshop = { }

local skinshops = {
	{ blip = nil, ['x'] = -78.678924560547, ['y'] = -812.17694091797, ['z'] = 243.38589477539 },
}

local function skinKills(id)
	if id == Player.skin then return 'Used' end
	if Player.kills >= Settings.skins[id].kills then return '' end
	return Settings.skins[id].kills..' XP'
end


function Skinshop.GetPlaces()
	return skinshops
end


AddEventHandler('lsv:init', function()
	for _, skinshop in pairs(skinshops) do
		skinshop.blip = Map.CreatePlaceBlip(Blip.Clothes(), skinshop.x, skinshop.y, skinshop.z)
	end

	WarMenu.CreateMenu('skinshop', '')
	WarMenu.SetSubTitle('skinshop', 'Select Your Character')
	WarMenu.SetTitleBackgroundColor('skinshop', Color.GetHudFromBlipColor(Color.BlipWhite()).r, Color.GetHudFromBlipColor(Color.BlipWhite()).g, Color.GetHudFromBlipColor(Color.BlipWhite()).b, Color.GetHudFromBlipColor(Color.BlipWhite()).a)
	WarMenu.SetTitleBackgroundSprite('skinshop', 'shopui_title_lowendfashion', 'shopui_title_lowendfashion')
	WarMenu.SetMenuButtonPressedSound('skinshop', 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET')

	local orderedSkins = { }
	for k, v in pairs(Settings.skins) do
		table.insert(orderedSkins, { key = k, value = v})
	end

	table.sort(orderedSkins, function(l, r)
		return l.value.kills < r.value.kills
	end)

	while true do
		if WarMenu.IsMenuOpened('skinshop') then
			for _, v in ipairs(orderedSkins) do
				if WarMenu.Button(v.value.name, skinKills(v.key)) and v.key ~= Player.skin then
					TriggerServerEvent('lsv:updatePlayerSkin', v.key)
				end
			end

			WarMenu.Display()
		end

		Citizen.Wait(0)
	end
end)


AddEventHandler('lsv:init', function()
	local skinshopOpenedMenuIndex = nil
	local skinshopColor = Color.GetHudFromBlipColor(Color.BlipGreen())

	while true do
		Citizen.Wait(0)

		for skinshopIndex, skinshop in ipairs(skinshops) do
			Gui.DrawPlaceMarker(skinshop.x, skinshop.y, skinshop.z - 1, Settings.placeMarkerRadius, skinshopColor.r, skinshopColor.g, skinshopColor.b, Settings.placeMarkerOpacity)

			if Vdist(skinshop.x, skinshop.y, skinshop.z, table.unpack(GetEntityCoords(PlayerPedId(), true))) < Settings.placeMarkerRadius then
				if not WarMenu.IsAnyMenuOpened() then
					Gui.DisplayHelpText('Presse ~INPUT_PICKUP~ pour choisir un personnage special !')

					if IsControlJustReleased(0, 38) then
						skinshopOpenedMenuIndex = skinshopIndex
						WarMenu.OpenMenu('skinshop')
					end
				end
			elseif WarMenu.IsMenuOpened('skinshop') and skinshopIndex == skinshopOpenedMenuIndex then
				WarMenu.CloseMenu()
			end
		end
	end
end)


RegisterNetEvent('lsv:playerSkinUpdated')
AddEventHandler('lsv:playerSkinUpdated', function(id)
	if id then Skin.ChangePlayerSkin(id)
	else Gui.DisplayNotification('~r~Vous avez pas sufisement d\'XP.') end
end)