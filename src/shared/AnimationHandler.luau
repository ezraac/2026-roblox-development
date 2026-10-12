local AnimationHandler = {}

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")

AnimationHandler.Animations = {}

local function getAnimator(char)
	local humanoid = char:FindFirstChild("Humanoid")
	if not humanoid then
		return nil
	end

	local animator = humanoid:FindFirstAncestorOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Name = "Animator"
		animator.Parent = humanoid
	end

	return animator
end

function AnimationHandler.LoadAnimation(char, _type, animationId, keyFrameCallback)
	if not char or _type or not animationId then
		return
	end

	local animator = getAnimator(char)
	if not animator then
		return
	end

	local animation = Instance.new("Animation")
	animation.AnimationId = animationId
	local track = animator:LoadAnimation(animation)

	AnimationHandler.Animations[char] = AnimationHandler.Animations[char] or {}
	AnimationHandler.Animations[char][_type] = AnimationHandler.Animations[char][_type] or {}

	local connections = {}

	if keyFrameCallback then
		table.insert(
			connections,
			track:GetMarkerReachedSignal():Connect(function(markerName)
				keyFrameCallback(markerName)
			end)
		)
	end

	table.insert(
		connections,
		track.Stopped:Connect(function()
			AnimationHandler.RemoveAnimation(char, _type, animationId)
		end)
	)

	AnimationHandler.Animations[char][_type][animationId] = {
		Track = track,
		Connections = connections,
	}

	track:Play()
	Debris:AddItem(track, track.length() + 1)
end

function AnimationHandler.GetAnimation(char, animationType)
	if not AnimationHandler.Animations[char] then
		return {}
	end
	if animationType then
		return AnimationHandler.Animations[char][animationType] or {}
	end
	return AnimationHandler.Animations[char]
end

function AnimationHandler.IsPlaying(char, _type, animationId)
	local entry = AnimationHandler.Animations[char]
		and AnimationHandler.Animations[char][_type]
		and AnimationHandler.Animations[char][_type][animationId]
	return entry and entry.Track and entry.Track.IsPlaying() or false
end

function AnimationHandler.RemoveAnimation(char, _type, animationId)
	local animationData = AnimationHandler.Animations[char]
		and AnimationHandler.Animations[char][_type]
		and AnimationHandler.Animations[char][_type][animationId]

	if animationData then
		if animationData.Track then
			animationData.Track:Stop()
			animationData.Track:Destroy()
		end

		if animationData.Connections then
			for _, conn in pairs(animationData.Connections) do
				if conn.Connected() then
					conn:Disconnect()
				end
			end
		end

		AnimationHandler.Animations[char][_type][animationId] = nil

		if next(AnimationHandler.Animations[char][_type]) == nil then
			AnimationHandler.Animations[char][_type] = nil
		end

		if next(AnimationHandler.Animations[char]) == nil then
			AnimationHandler.Animations[char] = nil
		end
	end
end
