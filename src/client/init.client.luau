local helloArray = { "h", "e", "l", "l", "o" }
local worldArray = { "w", "o", "r", "l", "d" }

for i, v in helloArray do
	print(v)
end

print(table.concat(worldArray))

local ActionGUIHandler = require(script.ActionGUIHandler)
ActionGUIHandler.start()
