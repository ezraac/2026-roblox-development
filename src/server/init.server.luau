local Players = game:GetService("Players")
--local firebase = require(game.ReplicatedStorage.Shared.firebase_test)
local npc = require(script.NPCHandler)
local ProfileStoreHandler = require(script.Data.ProfileStoreHandler)
local DataTester = require(script.Data.DataTester)

npc.start()
ProfileStoreHandler.start()
DataTester.start()

--firebase.start()
