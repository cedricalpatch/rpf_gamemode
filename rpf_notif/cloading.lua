

Citizen.CreateThread(function()
    Wait(15000)
    SetNotificationTextEntry("STRING");
    AddTextComponentString("Recherche de materiel !\n~y~Trouve les maisons pour les ~g~Cambrioler ~y~ avec votre Boxville...");
    SetNotificationMessage("CHAR_DEVIN", "CHAR_DEVIN", true, 1, "CAMBRIOLAGE", "~r~Entre 00h et 05h");
    Wait(0)
end)

Citizen.CreateThread(function()
    Wait(25000)
    SetNotificationTextEntry("STRING");
    AddTextComponentString("Bienvenue a toi !\n~y~Trouve ton téléphone sur ~g~RB ~y~ ou sur ~g~Fleche du haute ~w~du clavier...");
    SetNotificationMessage("CHAR_ALL_PLAYERS_CONF", "CHAR_ALL_PLAYERS_CONF", true, 1, "~r~RPF ~w~Stu~b~dio Mode Libre", "BETA 1.5");
    Wait(0)
end)

Citizen.CreateThread(function()
    Wait(50000)
    SetNotificationTextEntry("STRING");
    AddTextComponentString("Pour appel un taxi presse la touche ~g~F7 ~b~pour le faire venir ~w~et met un point sur la carte.");
    SetNotificationMessage("CHAR_TAXI", "CHAR_TAXI", true, 1, "Taxi 13", "Disponible !");
    Wait(0)
end)

Citizen.CreateThread(function()
    Wait(100000)
    TriggerEvent("fs_freemode:notify", "CHAR_BANK_FLEECA", 3, 20, "Braquage de Banque", "Disponible !", "Va sur la carte,\nTrouve les ~b~étoiles blanche en ville~w~ pour localise les ~b~Banque...")
    Wait(0)
end)

Citizen.CreateThread(function()
    Wait(150000)
    TriggerEvent("fs_freemode:notify", "CHAR_MARTIN", 2, 27, "Martin", "Braquage de fourgon", "Salut tu sais quoi, des fourgon de la ~b~Brinks~w~ traine en ville ! Equipe toi de bombe collante...")
    Wait(0)
end)

Citizen.CreateThread(function()
    while true do
        --This is the Application ID (Replace this with you own)
        SetDiscordAppId(540230609910628362)

        --Here you will have to put the image name for the "large" icon.
        SetDiscordRichPresenceAsset('logo')
        
        --(11-11-2018) New Natives:

        --Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('Serveur RP Libre 1.5')
       
        --Here you will have to put the image name for the "small" icon.
        SetDiscordRichPresenceAssetSmall('logo')

        --Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('Connecter sur RPF Studio')

        --It updates every one minute just in case.
        Citizen.Wait(60000)
    end
end)