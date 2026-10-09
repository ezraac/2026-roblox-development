local DataManager = {}

DataManager.Profiles = {}

function DataManager.addCoins(player: Player, amount: number)
	local profile = DataManager.Profiles[player]
	if not profile then
		return
	end

	profile.Data.Coins += amount
	player.leaderstats.Coins.Value = profile.Data.Coins
end

return DataManager
