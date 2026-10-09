local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local DataTester = {}
local DataManager = require(ServerScriptService.Server.Data.DataManager)

function DataTester.start()
	while true do
		for _, player in Players:GetPlayers() do
			DataManager.addCoins(player, 5)
		end
		task.wait(3)
	end
end

return DataTester
