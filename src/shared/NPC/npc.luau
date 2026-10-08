local NPC = {}
NPC.__index = NPC

NPC.allNPCS = {}

function NPC.new(part, health)
	local npc = {
		health = health,
	}
	local self = setmetatable(npc, NPC)
	if part:IsA("Part") then
		part.Touched:Connect(function(other)
			self:takeDamage(other)
		end)
	end
	return npc
end

function NPC:takeDamage(other)
	local player = game:GetService("Players"):GetPlayerFromCharacter(other.Parent)
	if player and player.Character and player.Character.PrimaryPart then
		self.health -= 2
		print(self.health)
	end
end

return NPC
