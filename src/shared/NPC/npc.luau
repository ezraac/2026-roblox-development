local NPC = {}
NPC.__index = NPC

NPC.allNPCS = {}

function NPC.create(health)
	local self = setmetatable({}, NPC)
	self.health = health
	return self
end

function NPC:takeDamange(damage)
	self.health -= damage
end

return NPC
