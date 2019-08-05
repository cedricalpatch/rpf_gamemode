World = { }

World.HotPropertyPlayer = nil
World.BountyPlayer = nil


function World.EnablePvp(enabled)
	NetworkSetFriendlyFireOption(enabled)
	SetCanAttackFriendly(PlayerPedId(), enabled, enabled)
end


function World.SetWantedLevel(level)
	local disable = level == 5
	local player = PlayerId()

	if disable or GetPlayerWantedLevel(player) < level then
		SetIgnoreLowPriorityShockingEvents(player, disable)
		SetPoliceIgnorePlayer(player, disable)
		SetDispatchCopsForPlayer(player, not disable)

		local maxLevel = 6
		if disable then maxLevel = 5 end
		SetMaxWantedLevel(maxLevel)

		SetPlayerWantedLevel(player, level, false)
		SetPlayerWantedLevelNow(player, false)
	end
end