RegisterServerEvent('ticket')
AddEventHandler('ticket', function(string)
  TriggerClientEvent('chatMessage', -1, string)
end)

local pisVersion = "1.0.5"

print("")
print("----------------[P.I.S]----------------")
print("PIS:SYSTEM - PIS SUCCESFULLY LOADED")
print("PIS:SYSTEM - RUNNING ON v" .. pisVersion)
print("---------------------------------------")

TriggerClientEvent('chatMessage', -1, "PIS ^6v" .. pisVersion, { 0, 0, 0}, " SUCCESFULLY LOADED!")