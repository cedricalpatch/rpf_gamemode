AddEventHandler('playerConnecting', function()
	TriggerClientEvent('showNotify', -1,"~w~".. GetPlayerName(source).."~g~ s'est connecté.")
end)

AddEventHandler('playerDropped', function(reason)
	TriggerClientEvent('showNotify', -1,"~w~".. GetPlayerName(source).."~r~ s'est deconnecté.")
end)