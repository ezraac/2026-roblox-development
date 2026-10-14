local ActionHandler = {}
local UserInputService = game:GetService("UserInputService")
local AnimationHandler = require(game:GetService("ReplicatedStorage").Shared.AnimationHandler)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

UserInputService.InputBegan:Connect(function(key: InputObject)
	if key.UserInputType == Enum.UserInputType.MouseButton1 then
		if not AnimationHandler.IsPlaying(char, "Punch", "rbxassetid://100206433034852") then
			AnimationHandler.LoadAnimation(char, "Punch", "rbxassetid://100206433034852")
		end
	end
end)

return ActionHandler
