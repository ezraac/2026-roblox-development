local CooldownHandler = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local PlayerAbilities = {
	M1 = "M1",
	M2 = "M2",
	Parry = "Parry",
	Blocking = "Blocking",
	Equip = "Equip",
}

function PlayerAbilities.isValid(abilityName)
	for _, name in pairs(PlayerAbilities) do
		if abilityName == name then
			return true
		end
	end
	return false
end

CooldownHandler.BaseCooldowns = {
	M1 = 0.4,
	M2 = 2,
	Parry = 0.5,
	Blocking = 0.5,
	Equip = 2,
}

CooldownHandler.CDs = {}

function CooldownHandler:GetCooldown(player: Player, abilityName: string)
	if not player or not player.UserId then
		return nil
	end

	if not PlayerAbilities.isValid(abilityName) then
		error("[CooldownHandler:GetCooldown] Invalid ability name: " .. abilityName)
	end

	self.CDs[player.UserId] = self.CDs[player.UserId] or {}
	return self.CDs[player.UserId][abilityName]
end

function CooldownHandler:SetCooldown(player: Player, abilityName: string, modifier)
	if not player or not player.UserId then
		return
	end
	if not PlayerAbilities.isValid(abilityName) then
		error("[CooldownHandler:SetCooldown] Invalid ability name: " .. abilityName)
	end
	if not self.BaseCooldowns[abilityName] then
		error("[CooldownHandler:SetCooldown] No base cooldown found for ability: " .. abilityName)
	end

	self.CDs[player.UserId] = self.CDs[player.UserId] or {}

	local baseCooldown = self.BaseCooldowns[abilityName]
	local finalCooldown = baseCooldown

	if modifier then
		if typeof(modifier) == "table" then
			if modifier.Type == "multiply" then
				finalCooldown = baseCooldown * modifier.Value
			elseif modifier.Type == "add" then
				finalCooldown = baseCooldown + modifier.Value
			elseif modifier.Type == "subtract" then
				finalCooldown = baseCooldown - modifier.Value
			end
		else
			finalCooldown = baseCooldown * modifier
		end
	end
	self.CDs[player.UserId][abilityName] = {
		cooldown = finalCooldown,
		lastused = time(),
	}

	Remotes.ActionRemotes.CDGUI:FireClient(player, { Ability = abilityName, Cooldown = finalCooldown }, player)
end

function CooldownHandler:CanUseAbility(player: Player, abilityName)
	if not player or not player.UserId then
		return true
	end
	if not PlayerAbilities.isValid(abilityName) then
		error("[CooldownHandler:CanUseAbility] Invalid ability name: " .. tostring(abilityName))
	end

	local abilityData = self.CDs[player.UserId][abilityName]
	if not abilityData then
		return true
	end

	return (time() - abilityData.lastused) >= abilityData.cooldown
end

function CooldownHandler:RemoveAllCooldowns(player: Player)
	if not player or not player.UserId then
		return
	end
	self.CDs[player.UserId] = {}
	print("Removed all cooldowns for " .. player.Name)
end

function CooldownHandler:RemoveAllPlayersCooldowns()
	self.CDs = {}
	print("Removed all players cooldowns.")
end

function CooldownHandler:RemoveCooldownByAbility(player: Player, abilityName)
	if not player or not player.UserId then
		return
	end
	if not PlayerAbilities.isValid(abilityName) then
		error("[CooldownHandler:RemoveCooldownsByAbility] Invalid ability name: " .. tostring(abilityName))
	end

	self.CDs[player.UserId][abilityName] = nil
end

function CooldownHandler:RemoveAllPlayersCooldownByAbility(abilityName)
	if not PlayerAbilities.isValid(abilityName) then
		error("[CooldownHandler:RemoveAllPlayersCooldownByAbility] Invalid ability name: " .. tostring(abilityName))
	end

	for playerId, _ in pairs(self.CDs) do
		self.CDs[playerId][abilityName] = nil
	end
end

function CooldownHandler:OnPlayerJoining(player: Player)
	if not player or not player.UserId then
		return
	end
	self.CDs[player.UserId] = {}
	print(player.Name .. "'s cooldowns has been initialized.")
end

function CooldownHandler:OnPlayerRemoving(player: Player)
	if not player or not player.UserId then
		return
	end
	self.CDs[player.UserId] = nil
	print(player.Name .. "'s cooldowns has been cleared.")
end

return { CooldownHandler = CooldownHandler, PlayerAbilities = PlayerAbilities }
