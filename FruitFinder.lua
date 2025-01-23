local Config = {
	Name = "Blox Fruits - Auto Fruit",
	Team = "Marines",
	TweenSpeed = 200,
	SkipFruits = true,
	MaxIndividualFruit = 2,
	ServerHop = {
		MaxStore = 3600,
		CheckInterval = 2500,
		TeleportInterval = 1000,
	},
}

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF_ = Remotes:WaitForChild("CommF_")

local function Notify(Text)
	StarterGui:SetCore("SendNotification", {
		Title = Config.Name,
		Text = Text,
	})
end

local function SetTeam(Team)
	Notify(`Setting Team: {Team}`)
	CommF_:InvokeServer("SetTeam", Team)
end

local function GetCharacter(Player)
	return Player.Character or Player.CharacterAdded:Wait()
end

local function GetHumanoid(Player)
	local Character = GetCharacter(Player)
	return Character:WaitForChild("Humanoid")
end

local function GetRootPart(Player)
	local Character = GetCharacter(Player)
	return Character:WaitForChild("HumanoidRootPart")
end

local function TeleportTo(CFrame)
	local RootPart = GetRootPart(Player)
	local CurrentPos = RootPart.Position
	local TargetPos = CFrame.Position
	local Distance = (TargetPos - CurrentPos).magnitude
	local Duration = Distance / Config.TweenSpeed
	local TweenInfo = TweenInfo.new(Duration, Enum.EasingStyle.Linear)
	local Tween = TweenService:Create(RootPart, TweenInfo, {
		CFrame = CFrame,
	})

	Tween:Play()
	Tween.Completed:Wait()
end

local NoClipConnection

local function DisableNoClip()
	if NoClipConnection then
		NoClipConnection:Disconnect()
		NoClipConnection = nil
	end
end

local function EnableNoClip()
	DisableNoClip()

	NoClipConnection = RunService.Stepped:Connect(function()
		if not Player.Character then
			return
		end

		for _, Item in pairs(Player.Character:GetDescendants()) do
			if Item:IsA("BasePart") and Item.CanCollide then
				Item.CanCollide = false
			end
		end
	end)
end

local function DisableSitting()
	local Humanoid = GetHumanoid(Player)
	Humanoid:SetStateEnabled("Seated", false)
	Humanoid.Sit = true
end

local function EnableSitting()
	local Humanoid = GetHumanoid(Player)
	Humanoid:SetStateEnabled("Seated", true)
	Humanoid.Sit = false
end

local function GetStoreName(Name)
	local Word = Name:split(" ")[1]
	return `{Word}-{Word}`
end

local CharacterConnection

local function DisableCharacterMonitor()
	if CharacterConnection then
		CharacterConnection:Disconnect()
		CharacterConnection = nil
	end
end

local function EnableCharacterMonitor()
	DisableCharacterMonitor()
	local Character = GetCharacter(Player)

	CharacterConnection = Character.ChildAdded:Connect(function(Item)
		local Fruit = Item:FindFirstChild("Fruit")

		if Fruit then
			Notify(`Storing: {Item.Name}`)
			CommF_:InvokeServer("StoreFruit", GetStoreName(Item.Name), Item)
		end
	end)
end

local function GetFruitInventory()
	local Inventory = CommF_:InvokeServer("getInventoryFruits")
	local Names = {}

	for _, Fruit in pairs(Inventory) do
		if Fruit.Name then
			table.insert(Names, Fruit.Name)
		end
	end

	return Names
end

local function CountOccurrences(Table, Target)
	local Count = 0

	for _, Value in pairs(Table) do
		if Value == Target then
			Count = Count + 1
		end
	end

	return Count
end

local function TeleportToFruits()
	local Found = false

	for _, Item in pairs(game.Workspace:GetChildren()) do
		local Fruit = Item:FindFirstChild("Handle")
		local Handle = Item:FindFirstChild("Handle")

		if not Fruit and not Handle then
			continue
		end

		if Config.SkipFruits then
			local Inventory = GetFruitInventory()
			local StoreName = GetStoreName(Item.Name)
			local Occurrences = CountOccurrences(Inventory, StoreName)

			if (Occurrences + 1) > Config.MaxIndividualFruit then
				Notify(`Skipping: {Item.Name}`)
				continue
			end
		end

		if not Found then
			Found = true
		end

		Notify(`Collecting: {Item.Name}`)
		TeleportTo(Handle.CFrame)
		task.wait()
	end

	if Found then
		task.wait(0.5)
	end

	Notify(Found and "Collected Fruits" or "No Fruits")
end

local function ServerHop()
	local PlaceId = game.PlaceId
	local JobId = game.JobId

	local RootFolder = "ServerHop"
	local StorageFile = `{RootFolder}/{tostring(PlaceId)}.json`
	local Data = {
		Start = tick(),
		Jobs = {},
	}

	if not isfolder(RootFolder) then
		makefolder(RootFolder)
	end

	if isfile(StorageFile) then
		local NewData = HttpService:JSONDecode(readfile(StorageFile))

		if tick() - NewData.Start < Config.ServerHop.MaxStore then
			Data = NewData
		end
	end

	if not table.find(Data.Jobs, JobId) then
		table.insert(Data.Jobs, JobId)
	end

	writefile(StorageFile, HttpService:JSONEncode(Data))

	local Servers = {}
	local Cursor = ""

	while Cursor and #Servers <= 0 and task.wait(Config.ServerHop.CheckInterval / 1000) do
		local Request = request or HttpService.RequestAsync
		local RequestSuccess, Response = pcall(Request, {
			Url = `https://games.roblox.com/v1/games/{PlaceId}/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true&cursor{Cursor}`,
			Method = "GET",
		})

		if not RequestSuccess then
			continue
		end

		local DecodeSuccess, Body = pcall(HttpService.JSONDecode, HttpService, Response.Body)

		if not DecodeSuccess or not Body or not Body.data then
			continue
		end

		task.spawn(function()
			for _, Server in pairs(Body.data) do
				if
					typeof(Server) ~= "table"
					or not Server.id
					or not tonumber(Server.playing)
					or not tonumber(Server.maxPlayers)
				then
					continue
				end

				if Server.playing < Server.maxPlayers and not table.find(Data.Jobs, Server.id) then
					table.insert(Servers, 1, Server.id)
				end
			end
		end)

		if Body.nextPageCursor then
			Cursor = Body.nextPageCursor
		end
	end

	if #Servers > 0 then
		Notify("Server Hopping")
	end

	while #Servers > 0 and task.wait(Config.ServerHop.TeleportInterval / 1000) do
		local Server = Servers[math.random(1, #Servers)]
		TeleportService:TeleportToPlaceInstance(PlaceId, Server, Player)
	end
end

SetTeam(Config.Team)
EnableNoClip()
DisableSitting()
EnableCharacterMonitor()
TeleportToFruits()
DisableCharacterMonitor()
EnableSitting()
DisableNoClip()
ServerHop()
game:GetService("RunService"):Set3dRenderingEnabled(false)
