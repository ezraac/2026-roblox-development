local firebase = {}

local HttpService = game:GetService("HttpService")
local dbUrl = "https://test-database-e472d-default-rtdb.firebaseio.com"
local apiKey = HttpService:GetSecret("apiKey")
local data = "/users/"

function firebase.start()
	local function request()
		local response = HttpService:RequestAsync({
			Url = `{dbUrl}{data}.json?auth={apiKey}`,
			Method = "GET",
		})

		if response.Success then
			print("yippee")
		end

		print(response.Body)
	end

	local success, error = pcall(request)
	if not success then
		print("failed")
	end
end

return firebase
