local CollectionService = game:GetService("CollectionService")
local NPC = require(game.ReplicatedStorage.Shared.NPC.npc)
local NPCHandler = {}

function NPCHandler.start()
	for _, v in CollectionService:GetTagged("NPC") do
		local npc = NPC.new(v, 100)
	end

	CollectionService:GetInstanceAddedSignal("NPC"):Connect(function(v)
		local npc = NPC.new(v, 100)
	end)
end

return NPCHandler
