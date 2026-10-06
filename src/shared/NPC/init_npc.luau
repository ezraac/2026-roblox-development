local init_npc = {}
local NPC = require("./npc")

function init_npc.start()
	local npc1 = NPC.create(100)
	npc1:takeDamange(10)
	print(npc1.health)
end

return init_npc
