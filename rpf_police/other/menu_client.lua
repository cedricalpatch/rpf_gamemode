----------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------/ W A R  M E N U \-------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local player = GetPlayerPed(-1)
	
    WarMenu.CreateMenu('PIS:main', 'Menu Police')
	WarMenu.SetTitleBackgroundColor('PIS:main', 15, 60, 125, 255)
	WarMenu.SetTitleColor('PIS:main', 255, 255, 255, 255)
	
	WarMenu.CreateSubMenu('PIS:wep', 'PIS:main', 'Armes')
	WarMenu.SetTitleBackgroundColor('PIS:wep', 15, 60, 125, 255)
	WarMenu.SetTitleColor('PIS:wep', 255, 255, 255, 255)
	
	WarMenu.CreateSubMenu('PIS:arr', 'PIS:main', 'Arrestation')
	WarMenu.SetTitleBackgroundColor('PIS:arr', 15, 60, 125, 255)
	WarMenu.SetTitleColor('PIS:arr', 255, 255, 255, 255)
	
	WarMenu.CreateSubMenu('PIS:int', 'PIS:main', 'Interactions')
	WarMenu.SetTitleBackgroundColor('PIS:int', 15, 60, 125, 255)
	WarMenu.SetTitleColor('PIS:int', 255, 255, 255, 255)
	
	WarMenu.CreateSubMenu('PIS:rdo', 'PIS:main', 'Appel')
	WarMenu.SetTitleBackgroundColor('PIS:rdo', 15, 60, 125, 255)
	WarMenu.SetTitleColor('PIS:rdo', 255, 255, 255, 255)
	
	WarMenu.CreateSubMenu('PIS:misc', 'PIS:main', 'Autre')
	WarMenu.SetTitleBackgroundColor('PIS:misc', 15, 60, 125, 255)
	WarMenu.SetTitleColor('PIS:misc', 255, 255, 255, 255)
	
    WarMenu.CreateSubMenu('closeMenu', 'PIS:main', 'Vous ete sur ?')

    while true do
        if WarMenu.IsMenuOpened('PIS:main') then
			if WarMenu.MenuButton('Arrestation', 'PIS:arr') then
			elseif WarMenu.MenuButton('Interactions', 'PIS:int') then
			elseif WarMenu.MenuButton('Appel', 'PIS:rdo') then
			elseif WarMenu.MenuButton('Armes', 'PIS:wep') then
			elseif WarMenu.MenuButton('Autre', 'PIS:misc') then
            elseif WarMenu.MenuButton('Sortir', 'closeMenu') then
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('closeMenu') then
            if WarMenu.Button('Yes') then
                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('No', 'PIS:main') then
            end
		
			WarMenu.Display()
        elseif WarMenu.IsMenuOpened('PIS:wep') then
            if WarMenu.Button('Equip Armes') then
				TriggerEvent("ldt:cop")
			elseif IsPedInAnyPoliceVehicle(player) then
				if WarMenu.Button('Equip Carbine') then
					TriggerEvent("ldt:carbine")
			elseif WarMenu.Button('Equip Shotgun') then
					TriggerEvent("ldt:shotgun")
			end
            end
			
			WarMenu.Display()
        elseif WarMenu.IsMenuOpened('PIS:arr') then
            if WarMenu.Button('Menotter') then
				TriggerEvent("pis:arr:handcuff")
			elseif WarMenu.Button('Grab') then
				TriggerEvent("pis:arr:grab")
			elseif WarMenu.Button('Kneel') then
				TriggerEvent("pis:arr:kneel")
			elseif WarMenu.Button('Unsecure') then					
				TriggerEvent("pis:arr:unsecure")
			elseif WarMenu.Button('Book') then
				TriggerEvent("pis:arr:book")
			end
			
			WarMenu.Display()
        elseif WarMenu.IsMenuOpened('PIS:int') then
			if WarMenu.Button('Test Alcool') then
				TriggerEvent("pis:breath")
			elseif WarMenu.Button('Test Drug') then
				TriggerEvent("pis:drug")
			elseif WarMenu.Button('Recherche') then
				TriggerEvent("pis:search")
            end
			
			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('PIS:rdo') then
			if WarMenu.Button('Recherche plaque') then
					TriggerEvent("pis:getplate")
					vehPlateNum = tostring(vehPlateNum)
					if vehPlateNum == "nil" then
						numPlate = ""
					else
						numPlate = vehPlateNum
					end
					DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", numPlate, "", "", "", 30)
						while (UpdateOnscreenKeyboard() == 0) do
							DisableAllControlActions(0);
							Wait(0);
						end
						if (GetOnscreenKeyboardResult()) then
							local result = GetOnscreenKeyboardResult()
							plate = result
							plate = string.upper(plate)
							TriggerEvent("pis:runplate")
						end
			elseif WarMenu.IsMenuOpened('PIS:rdo') then
				if WarMenu.Button('Recherche ID') then
					driverName = tostring(driverName)
					if driverQuestioned == true then
						name = driverName
					elseif driverName == "nil" then
						name = ""
					elseif driverQuestioned == false then
						name = ""
					end
					DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", tostring(name), "", "", "", 30)
						while (UpdateOnscreenKeyboard() == 0) do
							DisableAllControlActions(0);
							Wait(0);
						end
						if (GetOnscreenKeyboardResult()) then
							local result = GetOnscreenKeyboardResult()
							name = result
							name = string.gsub(name, "(%a)([%w_']*)", titleCase)
							TriggerEvent("pis:runid")
						end
				end
            end
			
			WarMenu.Display()
        elseif WarMenu.IsMenuOpened('PIS:misc') then
			if WarMenu.Button('Deppaneuse') then
				TriggerEvent('pis:spawnTow')
			elseif WarMenu.Button('Transport de Prisonier') then
				TriggerEvent("pis:arr:pt")
            end
	
		
            WarMenu.Display()
        elseif IsDisabledControlPressed(1, modifier) and IsDisabledControlJustPressed(1, mainmnu) then
            WarMenu.OpenMenu('PIS:main')
        elseif IsDisabledControlPressed(1, modifier) and IsDisabledControlJustPressed(1, callmenu) then
            WarMenu.OpenMenu('PIS:call:mnu')
        end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
	--local player = GetPlayerPed(-1)
	local speechType = {"Normal", "Aggressive"}
	local prices = { "$50", "$100", "$150", "$200", "$250", "$500", "$1000"  }
	local currentItemIndex = 1
    local selectedItemIndex = 1
	
    WarMenu.CreateMenu('PIS:trfc', 'Traffic Stop')
	WarMenu.SetTitleBackgroundColor('PIS:trfc', 15, 60, 125, 255)
	WarMenu.SetTitleColor('PIS:trfc', 255, 255, 255, 255)
	
	WarMenu.CreateSubMenu('trfc:qstn', 'PIS:trfc','Traffic Stop')
	WarMenu.SetTitleBackgroundColor('trfc:qstn', 15, 60, 125, 255)
	WarMenu.SetTitleColor('trfc:qstn', 255, 255, 255, 255)
	
	WarMenu.CreateSubMenu('trfc:tkt', 'PIS:trfc','Traffic Stop')
	WarMenu.SetTitleBackgroundColor('trfc:tkt', 15, 60, 125, 255)
	WarMenu.SetTitleColor('trfc:tkt', 255, 255, 255, 255)

    while true do		
        if WarMenu.IsMenuOpened('PIS:trfc') then
				if WarMenu.ComboBox('Speech', speechType, currentItemIndex, selectedItemIndex, function(currentIndex, selectedIndex)
						currentItemIndex = currentIndex
						selectedItemIndex = selectedIndex
						speech = speechType[selectedItemIndex]
					end) then
				elseif WarMenu.Button('Hello') then
					TriggerEvent("pis:hello")
				elseif WarMenu.Button('Ask for Identification') then
					TriggerEvent("pis:askid")
				elseif WarMenu.MenuButton('Question Driver', "trfc:qstn") then
				elseif WarMenu.MenuButton('Issue Ticket', "trfc:tkt") then
				elseif WarMenu.Button('Issue Warning') then
					TriggerEvent("pis:warn")
				elseif IsPedInAnyVehicle(stoppedDriver) then
					if WarMenu.Button('Order out of vehicle') then
						TriggerEvent("pis:exit")
					elseif WarMenu.Button('Release') then
						TriggerEvent("pis:release")
					end
				elseif not IsPedInAnyVehicle(stoppedDriver) then
					if WarMenu.Button('Order back in vehicle') then
						TriggerEvent("pis:mount")
					elseif WarMenu.Button('Release') then
						TriggerEvent("pis:release")
					end
				end
		
			WarMenu.Display()
        elseif WarMenu.IsMenuOpened('trfc:qstn') then
            if WarMenu.Button('Have you had anything to drink today?') then
				TriggerEvent("pis:drunk:q")
            elseif WarMenu.Button('Have you took any drugs recently?') then
				TriggerEvent("pis:drug:q")
            elseif WarMenu.Button('Anything illegal in the vehicle?') then
				TriggerEvent("pis:illegal:q")
            elseif WarMenu.Button('Can i search your vehicle?') then
				TriggerEvent("pis:search:q")
            end
			
			WarMenu.Display()
        elseif WarMenu.IsMenuOpened('trfc:tkt') then
            if WarMenu.ComboBox('Price', prices, currentItemIndex, selectedItemIndex, function(currentIndex, selectedIndex)
                    currentItemIndex = currentIndex
                    selectedItemIndex = selectedIndex
					price = prices[selectedItemIndex]
                end) then
					ShowNotification("You have selected:~g~ " .. price .. "~w~.")
			elseif WarMenu.Button('Reason') then
				DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
					while (UpdateOnscreenKeyboard() == 0) do
						DisableAllControlActions(0);
						Wait(0);
					end
					if (GetOnscreenKeyboardResult()) then
						local result = GetOnscreenKeyboardResult()
						reason = result
					end
			elseif WarMenu.Button('Ticket') then
				local myname = NetworkPlayerGetName(PlayerId())
				if reason == nil or price == nil then
					ShowNotification("~r~Please select a reason and a price!")
				else
				TriggerEvent('pis:ticket')
				end
            end
			
            WarMenu.Display()
		elseif IsDisabledControlPressed(1, modifier) and IsDisabledControlJustPressed(1, trfmnu) and stopped == true and GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(stoppedDriver)) < 3 then --E
            WarMenu.OpenMenu('PIS:trfc')
		
       end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
	local player = GetPlayerPed(-1)
	local speechType = {"Normal", "Aggressive"}
	local currentItemIndex = 1
    local selectedItemIndex = 1
	
    WarMenu.CreateMenu('PIS:trfc:veh', 'Traffic Stop')
	WarMenu.SetTitleBackgroundColor('PIS:trfc:veh', 15, 60, 125, 255)
	WarMenu.SetTitleColor('PIS:trfc:veh', 255, 255, 255, 255)
	

    while true do
        if WarMenu.IsMenuOpened('PIS:trfc:veh') then
			if WarMenu.Button('Mimic') then
				TriggerEvent("pis:mimic")
            elseif WarMenu.Button('Follow') then
				TriggerEvent("pis:follow")
            end
		
            WarMenu.Display()
		elseif IsDisabledControlPressed(1, modifier) and IsDisabledControlJustPressed(1, trfcveh) and stopped == true then
            WarMenu.OpenMenu('PIS:trfc:veh')
		end

        Citizen.Wait(0)
	end
end)

function titleCase(first, rest)
   return first:upper()..rest:lower()
end

RegisterCommand("callouts", function()
	WarMenu.OpenMenu('PIS:call:mnu')
end)

Citizen.CreateThread(function()
	local player = GetPlayerPed(-1)
	local speechType = {"Normal", "Aggressive"}
	local currentItemIndex = 1
    local selectedItemIndex = 1
	
    WarMenu.CreateMenu('PIS:call:mnu', 'Mission appel')
	WarMenu.SetTitleBackgroundColor('PIS:call:mnu', 15, 60, 125, 255)
	WarMenu.SetTitleColor('PIS:call:mnu', 255, 255, 255, 255)
	

    while true do
        if WarMenu.IsMenuOpened('PIS:call:mnu') then
			if WarMenu.Button('Supect armees (Interaction Menu)') then
				TriggerEvent('pis:weapon:spawn', s)
					Wait(2000)
				TriggerEvent('pis:weapon', -1)
				TriggerEvent('pis:notification', -1)
			elseif WarMenu.Button('Coup de feux') then
				TriggerEvent('pis:shots:spawn', s)
					Wait(2000)
				TriggerEvent('pis:shots', -1)
				TriggerEvent('pis:notification', -1)
			elseif WarMenu.Button('Coup de feux v2') then
				TriggerEvent('pis:crazy:spawn', s)
					Wait(2000)
				TriggerEvent('pis:crazy', -1)
				TriggerEvent('pis:notification', -1)
			elseif WarMenu.Button('Attack au couteau') then
				TriggerEvent('pis:knifeCallout', s)
					Wait(1000)
				TriggerEvent('pis:notification', -1)
			elseif WarMenu.Button('Vol a l etalage') then
				TriggerEvent('pis:shoplifting:spawn', s)
					Wait(2000)
				TriggerEvent('pis:shoplifting', -1)
				TriggerEvent('pis:notification', -1)
			elseif WarMenu.Button('Bagare en cour') then
				TriggerEvent('pis:fight:spawn', s)
					Wait(2000)
				TriggerEvent('pis:fight', -1)
				TriggerEvent('pis:notification', -1)
            end	
            WarMenu.Display()
		end
        Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	local player = GetPlayerPed(-1)
	local speechType = {"Normal", "Aggressive"}
	local currentItemIndex = 1
    local selectedItemIndex = 1
	
    WarMenu.CreateMenu('PIS:call', 'Mission Menu')
	WarMenu.SetTitleBackgroundColor('PIS:call', 15, 60, 125, 255)
	WarMenu.SetTitleColor('PIS:call', 255, 255, 255, 255)
	
	WarMenu.CreateSubMenu('call:cd4', 'PIS:call' ,'Vous ete sur ?')
	WarMenu.SetTitleBackgroundColor('call:cd4', 15, 60, 125, 255)
	WarMenu.SetTitleColor('call:cd4', 255, 255, 255, 255)
	

    while true do
        if WarMenu.IsMenuOpened('PIS:call') then
			if callID == "weapon" then
				if WarMenu.ComboBox('Speech', speechType, currentItemIndex, selectedItemIndex, function(currentIndex, selectedIndex)
                    currentItemIndex = currentIndex
                    selectedItemIndex = selectedIndex
					speech = speechType[selectedItemIndex]
				end) then
				elseif WarMenu.Button('Drop the weapon!') then
					TriggerEvent("pis:weapon:drop:q")
				elseif WarMenu.Button('Face away from me!') then
					TriggerEvent("pis:weapon:face:q")
				elseif WarMenu.Button('Get on the ground!') then
					TriggerEvent("pis:weapon:knees:q")
				elseif WarMenu.Button('Threaten') then
					TriggerEvent("pis:weapon:threat:q")
				elseif WarMenu.MenuButton('Code 4', 'call:cd4') then
				end
				
			elseif	callID == "fight" then
				if WarMenu.Button('Fight Call') then
				elseif WarMenu.MenuButton('Code 4', 'call:cd4') then
				end
			end

			WarMenu.Display()
		elseif WarMenu.IsMenuOpened('call:cd4') then
			if WarMenu.Button('Yes') then
				callID = nil
				ShowNotification("Situation is ~g~Code 4~w~.")
				TriggerEvent("pis:code4")
				WarMenu.CloseMenu('call:cd4')
			elseif WarMenu.Button('No') then
				WarMenu.CloseMenu('call:cd4')
			end
		
            WarMenu.Display()
		elseif IsDisabledControlPressed(1, modifier) and IsControlJustPressed(0, trfcveh) and callID ~= nil then --E
            WarMenu.OpenMenu('PIS:call')
       end

        Citizen.Wait(0)
    end
end)