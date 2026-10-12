local StateHandler = {}

local states = {}
local stunTimers = {}

function StateHandler.SetState(player, state, value, duration)
	if not states[player] then
		states[player] = {}
	end

	states[player][state] = value

	if duration and type(duration) == "number" then
		task.delay(duration, function()
			if states[player][state] then
				states[player][state] = nil
				if next(states[player]) == nil then
					states[player] = nil
				end
			end
		end)
	end
end

function StateHandler.SetStun(player: Player, value, duration, stunSpeed)
	if not player or not player.Character or not player.Character:FindFirstChild("Humanoid") then
		return
	end

	local humanoid = player.Character:FindFirstChild("Humanoid")

	if not states[player] then
		states[player] = {}
	end

	if value then
		states[player]["Stunned"] = true

		if not states[player].OriginalWalkSpeed then
			states[player].OriginalWalkSpeed = humanoid.WalkSpeed
		end

		humanoid.WalkSpeed = stunSpeed or 0

		local endTime = time() + duration

		if stunTimers[player] then
			stunTimers[player].EndTime = math.max(stunTimers[player].EndTime, endTime)
		else
			stunTimers[player] = { EndTime = endTime }

			coroutine.wrap(function()
				while stunTimers[player] and time() < stunTimers[player].EndTime do
					task.wait(0.1)
				end

				if states[player] then
					states[player]["Stunned"] = nil

					if player.Character and player.Character:FindFirstChild("Humanoid") then
						local currentHumanoid = player.Character:FindFirstChild("Humanoid")
						currentHumanoid.WalkSpeed = states[player].OriginalWalkSpeed or 16
					end

					states[player].OriginalWalkSpeed = nil

					if next(states[player]) == nil then
						states[player] = nil
					end
				end

				stunTimers[player] = nil
			end)()
		end
	else
		states[player]["Stunned"] = nil

		if player.Character and player.Character:FindFirstChild("Humanoid") then
			local currentHumanoid = player.Character:FindFirstChild("Humanoid")
			currentHumanoid.WalkSpeed = states[player].OriginalWalkSpeed or 16
		end

		states[player].OriginalWalkSpeed = nil

		if next(states[player]) == nil then
			states[player] = nil
		end
	end
end

function StateHandler.GetState(player, state)
	if states[player] then
		return states[player][state]
	end
	return nil
end

function StateHandler.ReturnStates(player)
	return states[player]
end

function StateHandler.RemoveStates(player, state)
	if not states[player] then
		return
	end

	if state then
		states[player][state] = nil
		if next(states[player]) == nil then
			states[player] = nil
		end
	else
		states[player] = nil
	end
end

function StateHandler.ClearAllStates()
	for player in pairs(states) do
		states[player] = nil
	end

	for player in pairs(stunTimers) do
		stunTimers[player] = nil
	end
end

function StateHandler.start()
	game.Players.PlayerRemoving:Connect(function(player: Player)
		states[player] = nil
		stunTimers[player] = nil
	end)
end

return StateHandler
