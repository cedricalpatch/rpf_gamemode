AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/callout knife" then
		CancelEvent()
		--------------
		TriggerClientEvent('pis:knifeCallout', s)
		Wait(1000)
		TriggerClientEvent('pis:notification', -1)
	elseif message == "/callout veh" then
		CancelEvent()
		--------------
		TriggerClientEvent('pis:abandonedVeh', s)
		Wait(1000)
		TriggerClientEvent('pis:notification', -1)
	elseif message == "/callout shoplift" then
		CancelEvent()
		--------------
		TriggerClientEvent('pis:shoplifting:spawn', s)
		Wait(2000)
		TriggerClientEvent('pis:shoplifting', -1)
		TriggerClientEvent('pis:notification', -1)
	elseif message == "/callout fight" then
		CancelEvent()
		--------------
		TriggerClientEvent('pis:fight:spawn', s)
		Wait(2000)
		TriggerClientEvent('pis:fight', -1)
		TriggerClientEvent('pis:notification', -1)
	elseif message == "/callout shots" then
		CancelEvent()
		--------------
		TriggerClientEvent('pis:shots:spawn', s)
		Wait(2000)
		TriggerClientEvent('pis:shots', -1)
		TriggerClientEvent('pis:notification', -1)
	elseif message == "/callout crazy" then
		CancelEvent()
		--------------
		TriggerClientEvent('pis:crazy:spawn', s)
		Wait(2000)
		TriggerClientEvent('pis:crazy', -1)
		TriggerClientEvent('pis:notification', -1)
	elseif message == "/callout armed" then
		CancelEvent()
		--------------
		TriggerClientEvent('pis:weapon:spawn', s)
		Wait(2000)
		TriggerClientEvent('pis:weapon', -1)
		TriggerClientEvent('pis:notification', -1)
	end
end)