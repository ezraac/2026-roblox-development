local ActionGUIHandler = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes.ActionRemotes
local Assets = ReplicatedStorage.Assets.ActionAssets

local player = game.Players.LocalPlayer
local playerGUI = player.PlayerGui
local cooldownGui = playerGUI.Cooldowns
local holder = cooldownGui.Background

local RunService = game:GetService("RunService")

local activeCooldowns = {}

local UIListLayout = holder.UIListLayout

local function updateLayoutOrders()
	local children = {}
	for _, child in ipairs(holder:GetChildren()) do
		if child:IsA("Frame") then
			table.insert(children, child)
		end
	end

	for i = 1, #children do
		local frame = children[i]

		frame.LayoutOrder = #children - i
	end
end

local function startCooldown(abilityName, duration)
	local frame = holder:FindFirstChild(abilityName)
	if not frame then
		local template = Assets.CooldownFrame
		if not template then
			error("[ActionGUIHandler.startCooldown] Template not found.")
		end
		frame = template:Clone()
		frame.Name = abilityName
		frame.CDName.Text = abilityName
		frame.Parent = holder
		frame.Visible = true

		updateLayoutOrders()
	end

	local timerLabel = frame:FindFirstChild("Timer")
	local bar = frame:FindFirstChild("Bar")
	if not timerLabel or not timerLabel:IsA("TextLabel") then
		warn("[ActionGUIHandler.startCooldown] Timer TextLabel missing for " .. abilityName)
	end
	if not bar or not bar:IsA("Frame") then
		warn("[ActionGUIHandler.startCooldown] Bar frame missing for " .. abilityName)
	end

	if activeCooldowns[abilityName] then
		activeCooldowns[abilityName]:Disconnect()
		activeCooldowns[abilityName] = nil
	end

	local startTime = time()

	local function update()
		local elapsed = time() - startTime
		local remaining = math.clamp(duration - elapsed, 0, duration)

		timerLabel.Text = string.format("%.1f", remaining)

		local scaleX = remaining / duration
		bar.Size = UDim2.new(scaleX, 0, bar.Y.Scale, bar.Y.Offset)

		if remaining <= 0 then
			timerLabel.Text = ""
			frame:Destroy()
			if activeCooldowns[abilityName] then
				activeCooldowns[abilityName]:Disconnect()
				activeCooldowns[abilityName] = nil
			end
			updateLayoutOrders()
		end
	end

	activeCooldowns[abilityName] = RunService.Heartbeat:Connect(update)
end

function ActionGUIHandler.start()
	Remotes.CDGUI.OnClientEvent:Connect(function(data, plr)
		if plr ~= player then
			return
		end
		local abilityName = data.Ability
		local cooldownTime = data.Cooldown
		startCooldown(abilityName, cooldownTime)
	end)
end
