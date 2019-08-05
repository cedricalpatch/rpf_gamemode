DeathTimer = nil
TimeToRespawn = Settings.spawn.deathTime

local isSpawnInProcess = false
local isFirstSpawn = true


local function spawnPlayer()
	if isSpawnInProcess then return end
	isSpawnInProcess = true

	if not GetIsLoadingScreenActive() then
		DoScreenFadeOut(500)
		while IsScreenFadingOut() do Citizen.Wait(0) end
	end

	local spawnPoint = nil
	if isFirstSpawn then
		spawnPoint = Utils.GetRandom(Settings.spawn.points)
	else
		local playerX, playerY, playerZ = table.unpack(GetEntityCoords(PlayerPedId()))
		local radius = Settings.spawn.radius.min
		local z = 1500.
		local tryCount = 0
		local startSpawnTimer = GetGameTimer()

		while true do
			Citizen.Wait(0)

			local diff = { r = radius * math.sqrt(GetRandomFloatInRange(0.0, 1.0)), theta = GetRandomFloatInRange(0.0, 1.0) * 2 * math.pi }
			local xDiff = diff.r * math.cos(diff.theta)
			if xDiff >= 0 then xDiff = math.max(radius, xDiff) else xDiff = math.min(-radius, xDiff) end

			local yDiff = diff.r * math.sin(diff.theta)
			if yDiff >= 0 then yDiff = math.max(radius, yDiff) else yDiff = math.min(-radius, yDiff) end

			local x = playerX + xDiff
			local y = playerY + yDiff

			local _, groundZ = GetGroundZFor_3dCoord(x, y, z)
			local validCoords, coords = GetSafeCoordForPed(x, y, groundZ + 1., false, 16)

			if validCoords then
				spawnPoint = { }
				spawnPoint.x, spawnPoint.y, spawnPoint.z = coords.x, coords.y, coords.z
			else
				if tryCount ~= Settings.spawn.tryCount then tryCount = tryCount + 1
				else
					radius = radius + Settings.spawn.radius.increment
					tryCount = 0
				end
			end

			if GetTimeDifference(GetGameTimer(), startSpawnTimer) >= Settings.spawn.timeout then spawnPoint = Utils.GetRandom(Settings.spawn.points) end
			if spawnPoint then break end
		end
	end

	Player.SetFreeze(true)

	local ped = PlayerPedId()

	RequestCollisionAtCoord(spawnPoint.x, spawnPoint.y, spawnPoint.z)
	SetEntityCoordsNoOffset(ped, spawnPoint.x, spawnPoint.y, spawnPoint.z, false, false, false, true)
	NetworkResurrectLocalPlayer(spawnPoint.x, spawnPoint.y, spawnPoint.z, GetRandomFloatInRange(0.0, 360.0), true, true, false)

	ClearPedTasksImmediately(ped)
	StopEntityFire(ped)
	ClearPedBloodDamage(ped)
	ClearPedWetness(ped)

	while not HasCollisionLoadedAroundEntity(ped) do Citizen.Wait(0) end
	if GetIsLoadingScreenActive() then ShutdownLoadingScreen() end

	DoScreenFadeIn(500)
	while IsScreenFadingIn() do Citizen.Wait(0) end

	TriggerEvent('playerSpawned')
	Player.SetFreeze(false)
	isSpawnInProcess = false
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if DoesEntityExist(PlayerPedId()) then
			if NetworkIsPlayerActive(PlayerId()) then
				if isFirstSpawn then
					spawnPlayer()
					isFirstSpawn = false
				elseif not isSpawnInProcess then
					if DeathTimer and GetTimeDifference(GetGameTimer(), DeathTimer) > TimeToRespawn or isFirstSpawn then
						spawnPlayer()
					end
				end
			end

			if IsPlayerDead(PlayerId()) then
				if not DeathTimer then
					DeathTimer = GetGameTimer()
					TimeToRespawn = Settings.spawn.deathTime
				end
			else DeathTimer = nil end
		end
	end
end)

_charPool = nil			

RegisterNetEvent("vf_base:NoCharacter")
AddEventHandler("vf_base:NoCharacter", function()
	warning = CreateWarningMessage(GetLabelText("HUD_CONNPROB"), GetLabelText("TRAN_NOCHAR"))
	local IsTeleported = true
	while HasScaleformMovieLoaded(warning) and not IsTeleported do
		if IsControlJustPressed(0, 201) then
			EnterCharacterCreator()
		end
		Citizen.Wait(1)
	end
end)

RegisterNetEvent("vf_base:CreateCharacter")
AddEventHandler("vf_base:CreateCharacter", function()
	EnterCharacterCreator()
end)

function EnterCharacterCreator()
	if IsPlayerSwitchInProgress() then
		--SetEntityCoordsNoOffset(PlayerPedId(), 403.006225894, -996.8715, -99.00)
		--SetEntityHeading(PlayerPedId(), 182.65637207031)
		IsCharacterCreated = true

		N_0xd8295af639fd9cb8(PlayerPedId())
	end
end

function AddGenderSelection(menu)
    local genders = {GetLabelText("FACE_MALE"), GetLabelText("FACE_FEMALE")}
    local newitem = NativeUI.CreateListItem(GetLabelText("FACE_SEX"), genders, 1, GetLabelText("FACE_MM_H2"))

    menu:AddItem(newitem)
    menu.OnListChange = function(sender, item, index)
        if item == newitem then
    	    SelectedItem = newitem:IndexToItem(index)
    	    if SelectedItem == GetLabelText("FACE_MALE") then
    	    	playerModel = 'mp_m_freemode_01'
    	    else
    	    	playerModel = 'mp_f_freemode_01'
    	    end

    	    GetRandomMultiPlayerModel(playerModel)
    	end
    end
end

function AddHeritageSelection(menu)
	local submenu = _charPool:AddSubMenu(menu, GetLabelText("FACE_HERI"), GetLabelText("FACE_MM_H3"))
    local genders = {GetLabelText("FACE_MALE"), GetLabelText("FACE_FEMALE")}
    local playerPed = PlayerPedId()
    
    local Heritage = NativeUI.CreateHeritageWindow(10, 8)
    submenu:AddWindow(Heritage)

    local females = {"Sophia 1", "Sophia 2", "Sophia3", "Sophia4", "Sophia5", "Sophia6", "Sophia7", "Sophia8", "Sophia9","Sophia"}
    local males   = { "Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Juan", "Alex", "Isaac", "Evan", "Ethan", "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel", "Anthony"}    
    Mum = 10
    Dad = 9

    momList = NativeUI.CreateListItem(GetLabelText("FACE_MUMS"), females, 1, GetLabelText("CHARC_H_30"))
    submenu:AddItem(momList)

    dadList = NativeUI.CreateListItem(GetLabelText("FACE_DADS"), males, 1, GetLabelText("CHARC_H_31"))
    submenu:AddItem(dadList)

    submenu.OnListChange = function(sender, item, index)
        if item == momList then
            Mum = index
        elseif item == dadList then
            Dad = index
        end

        Heritage:Index(Mum, Dad)
        SetPedHeadBlendData(PlayerPedId(), 0, math.random(12), 0,math.random(12), Mum, Dad,1.0,1.0,1.0,true)

        while not HasPedHeadBlendFinished(PlayerPedId()) do
            Wait(500)
        end
    end

    local amount = {}
    
    for i = 1, 10 do 
    	amount[i] = i
    end
    
    local newitem = NativeUI.CreateSliderItem(GetLabelText("FACE_H_DOM"), amount, 1, GetLabelText("CHARC_H_9"))
    submenu:AddItem(newitem)

    local newitem2 = NativeUI.CreateSliderItem(GetLabelText("FACE_H_STON"), amount, 1, GetLabelText("FACE_HER_ST_H"))
    submenu:AddItem(newitem2)
    
    submenu.OnSliderChange = function(sender, item, index)
        if item == newitem then
          	reseamblance = item:IndexToItem(index)
        elseif item == newitem2 then
           	skinTone = item:IndexToItem(index)
        end
    end
end

function AddAppearanceSelection(menu)
    local submenu = _charPool:AddSubMenu(menu, GetLabelText("FACE_APP"), GetLabelText("FACE_MM_H6"))
    if IsPedMale(PlayerPedId()) then
        hairstyles = { GetLabelText("CC_M_HS_1"), GetLabelText("CC_M_HS_2"), GetLabelText("CC_M_HS_3"), GetLabelText("CC_M_HS_4"),
                       GetLabelText("CC_M_HS_5"), GetLabelText("CC_M_HS_6"), GetLabelText("CC_M_HS_7"),
                       GetLabelText("CC_M_HS_8"), GetLabelText("CC_M_HS_9"), GetLabelText("CC_M_HS_10"),
                       GetLabelText("CC_M_HS_11"), GetLabelText("CC_M_HS_12"), GetLabelText("CC_M_HS_13"),
                       GetLabelText("CC_M_HS_14"), GetLabelText("CC_M_HS_15"), GetLabelText("CC_M_HS_16"),
                       GetLabelText("CC_M_HS_17"), GetLabelText("CC_M_HS_18"), GetLabelText("CC_M_HS_19"),
                       GetLabelText("CC_M_HS_20"), GetLabelText("CC_M_HS_21"), GetLabelText("CC_M_HS_22")
                    }
    else
        hairstyles = { GetLabelText("CC_F_HS_1"), GetLabelText("CC_F_HS_2"), GetLabelText("CC_F_HS_3"),
                       GetLabelText("CC_F_HS_4"), GetLabelText("CC_F_HS_5"), GetLabelText("CC_F_HS_6"),
                       GetLabelText("CC_F_HS_7"), GetLabelText("CC_F_HS_8"), GetLabelText("CC_F_HS_9"),
                       GetLabelText("CC_F_HS_10"), GetLabelText("CC_F_HS_11"), GetLabelText("CC_F_HS_12"),
                       GetLabelText("CC_F_HS_13"), GetLabelText("CC_F_HS_14"), GetLabelText("CC_F_HS_15"),
                       GetLabelText("CC_F_HS_16"), GetLabelText("CC_F_HS_17"), GetLabelText("CC_F_HS_18"),
                       GetLabelText("CC_F_HS_19"), GetLabelText("CC_F_HS_20"), GetLabelText("CC_F_HS_21"),
                       GetLabelText("CC_F_HS_22"), GetLabelText("CC_F_HS_23")
                   }
    end

    local HairItem = NativeUI.CreateListItem(GetLabelText("FACE_HAIR"), hairstyles, 1, GetLabelText("FACE_APP_H"))
    submenu:AddItem(HairItem)

    local hairColors = {
        {22, 19, 19},
        {30, 28, 25},
        {76, 56, 45},
        {69, 34, 24},
        {123, 59, 31},
        {149, 68, 35},
        {165, 87, 50},
        {175, 111, 72}, 
        {159, 105, 68},
        {198, 152, 108},
    }

    local hairColor = NativeUI.CreateColourPanel(GetLabelText("IB_COLOR"), hairColors)
    HairItem:AddPanel(hairColor)

    submenu.OnListChange = function(sender, item, index)
        if item == HairItem then
            hairId = index
            SetPedComponentVariation(PlayerPedId(), 2, hairId, 2, 0)
        end
    end
end

function AddApparelSelection(menu)
    local glasses = {}
    local hats = { GetLabelText("CELL_831"), GetLabelText("HT_FMM_2_0")}
    local submenu = _charPool:AddSubMenu(menu, GetLabelText("FACE_APPA"), GetLabelText("FACE_MM_H7"))

    local StyleItem = NativeUI.CreateListItem(GetLabelText("FACE_APP_STY"), genders , 1, GetLabelText("FACE_APP_H"))
    submenu:AddItem(StyleItem)

    TotalGlasses = GetNumberOfPedPropDrawableVariations(PlayerPedId(), 1)
    for i = 0, TotalGlasses do
        table.insert(glasses, i)
    end

    local Hatitem = NativeUI.CreateListItem(GetLabelText("FACE_HAT"), hats, 0, GetLabelText("FACE_APP_H"))
    submenu:AddItem(Hatitem)

    local glassesItem = NativeUI.CreateListItem(GetLabelText("FACE_GLS"), glasses, 1, GetLabelText("FACE_APP_H"))
    submenu:AddItem(glassesItem)

    submenu.OnListChange = function(sender, item, index)
        if item == StyleItem then

        elseif item == Hatitem then
            hatValue = item:IndexToItem(index)
            print(hatValue)
            if hatValue == GetLabelText("CELL_831") then
                hatId = 8
                if IsPedPropValid(PlayerPedId(), 0, hatId, 0) then
                    SetPedPropIndex(PlayerPedId(), 0, hatId, 0, true)
                end
            elseif hatValue == GetLabelText("HT_FMM_2_0") then
                hatId = 2
                if IsPedPropValid(PlayerPedId(), 0, hatId, 0) then
                    SetPedPropIndex(PlayerPedId(), 0, hatId, 0, true)
                end             
            end

        elseif item == glassesItem then
            glassValue = item:IndexToItem(index)
            if IsPedPropValid(PlayerPedId(), 1, glassValue, 0) then
                SetPedPropIndex(PlayerPedId(), 1, glassValue, 0, true)
            end
        end
    end
end

function AddStatsSelection(menu)
    local submenu = _charPool:AddSubMenu(menu, GetLabelText("FACE_STATS"), "")
    local newitem = NativeUI.CreateListItem(GetLabelText("PIM_MAGMSTL"), genders, 1, GetLabelText("FACE_APP_H"))

    submenu:AddItem(newitem)
    submenu.OnListSelect = function(sender, item, index)
        if item == newitem then

        end
    end
end

function AddSaveSelection(menu)
    local submenu = _charPool:AddSubMenu(menu, GetLabelText("FACE_SAVE"), GetLabelText("FACE_MM_H8"))
    local newitem = NativeUI.CreateItem(GetLabelText("FE_HLP29"), GetLabelText("FACE_W_2"))

    submenu:AddItem(newitem)

    local cancelConfirm = NativeUI.CreateItem(GetLabelText("FE_HLP27"), GetLabelText("FACE_W_2"))
    submenu:AddItem(cancelConfirm)

    submenu.OnItemSelect = function(sender, item, index)
        if item == newitem then
            if DoesCamExist(cam) then
            	RenderScriptCams(false, false, 3000, 1, 0, 0)
            	FreezeEntityPosition(PlayerPedId(), false)
            	submenu:Visible(not submenu:Visible())
            	DestroyCam(cam, true)
            end
            
            --local joinCoords = vector3(-1044.645, -2749.844, 21.36343-1.0)

            if not IsScreenFadedOut() then
                DoScreenFadeOut(400)
                while not IsScreenFadedOut() do
                    Wait(50)
                end
            end

        	--SetEntityCoords(PlayerPedId(), -1044.645, -2749.844, 21.36343-1.0)
        	--SetEntityHeading(PlayerPedId(), 328.147)        	           
            while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                Wait(1)
            end

            _charPool:Remove()

            if IsScreenFadedOut() then
                Wait(500)
                DoScreenFadeIn(300)
                Wait(400)
            end

        	SimulatePlayerInputGait(PlayerId(), 1.0, 8500, 1.0, 1, 0)
            --TriggerServerEvent('vf_ammunation:LoadPlayer')
            
            SetPlayerScores(1, 2000, 1, 1000, 1)
        	hidehud = false
        end
    end
end

function DisplayCharacterCreatorMenu(menu)
	AddGenderSelection(menu)
	AddHeritageSelection(menu)
	AddAppearanceSelection(menu)
	AddApparelSelection(menu)
	AddStatsSelection(menu)
	AddSaveSelection(menu)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsGameInProgress() and IsPlayerPlaying(PlayerId()) then
            if IsCharacterCreated then
                if _charPool:IsAnyMenuOpen() then
                    _charPool:ProcessMenus()
                end

                if DoesCamExist(cam) and not IsPlayerSwitchInProgress() then
                    if not _charPool:IsAnyMenuOpen() then
                        charMenu:Visible(not charMenu:Visible())
                    end
                end
            end
        end
    end
end)