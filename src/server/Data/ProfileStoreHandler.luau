local ProfileStoreHandler = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local function GetStoreName()
	return RunService:IsStudio() and "Test" or "Live"
end

local DataTemplate = require(ServerScriptService.Server.Data.DataTemplate)
local DataManager = require(ServerScriptService.Server.Data.DataManager)

local ProfileStore = require(ServerScriptService.ServerPackages.profilestore)

local PlayerStore = ProfileStore.New(GetStoreName(), DataTemplate)

-- Initilizes player data
-- This will do some leaderstats
local function Initialize(player: Player, profile: typeof(PlayerStore.StartSessionAsync()))
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"

	local coins = Instance.new("NumberValue", leaderstats)
	coins.Name = "Coins"
	coins.Value = profile.Data.Coins
end

-- Creates and stores profile
local function PlayerAdded(player: Player)
	local profile = PlayerStore:StartSessionAsync("Player_" .. player.UserId, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	if profile then
		profile:AddUserId(player.UserId) -- GDPR Compliance (allows finding userid easy to delete)
		profile:Reconcile() -- Fill in missing variables (old template update to new template etc)

		-- Session locking
		profile.OnSessionEnd:Connect(function()
			DataManager.Profiles[player] = nil
			player:Kick("Data error occured, please rejoin.")
		end)

		if player.Parent == Players then
			DataManager.Profiles[player] = profile
			Initialize(player, profile)
		else
			profile:EndSession()
		end
	else
		-- Server shuts down while joining
		player:Kick("Data error occured, please rejoin.")
	end
end

local function PlayerRemoving(player: Player)
	local profile = DataManager.Profiles[player]
	if not profile then
		return
	end

	profile:EndSession()
	DataManager.Profiles[player] = nil
end

function ProfileStoreHandler.start()
	for _, player in Players:GetPlayers() do
		task.spawn(PlayerAdded, player)
	end

	Players.PlayerAdded:Connect(PlayerAdded)
	Players.PlayerRemoving:Connect(PlayerRemoving)
end

return ProfileStoreHandler
