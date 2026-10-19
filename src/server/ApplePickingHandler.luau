local CollectionService = game:GetService("CollectionService")
local ApplePickingHandler = {}

function ApplePickingHandler.start()
	for _, v in CollectionService:GetTagged("Apple") do
		local prompt = v:FindFirstChild("ProximityPrompt")
		if prompt then
			prompt.Triggered:Connect(function(player: Player)
				local tool = v.Parent
				tool.Enabled = true
				tool.Parent = player.Backpack
				v.Anchored = false
				prompt.Enabled = false
			end)
		else
			print("Prompt not found")
		end
	end

	CollectionService:GetInstanceAddedSignal("Apple"):Connect(function(v)
		local prompt = v:FindFirstChild("ProximityPrompt")
		if prompt then
			prompt.Triggered:Connect(function(player: Player)
				local tool = v.Parent
				tool.Enabled = true
				tool.Parent = player.Backpack
				v.Anchored = false
				prompt.Enabled = false
			end)
		else
			print("Prompt not found")
		end
	end)
end

return ApplePickingHandler
