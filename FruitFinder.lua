repeat wait() until gameIsLoaded()
repeat wait() until game.Players
repeat wait() until game.Players.LocalPlayer
repeat wait() until game.ReplicatedStorage
repeat wait() until game.ReplicatedStorageFindFirstChild(Remotes);
repeat wait() until game.Players.LocalPlayerFindFirstChild(PlayerGui);
repeat wait() until game.Players.LocalPlayer.PlayerGuiFindFirstChild(Main (minimal));
repeat wait()
until gameGetService(Players).LocalPlayer.PlayerGuiFindFirstChild(LoadingScreen) == nil
setfpscap(7)
gameGetService(RunService)Set3dRenderingEnabled(false)
  local args = {
        [1] = "SetTeam",
        [2] = "Marines"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args)) 
    local args = {
        [1] = "BartiloQuestProgress"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
ServerHopTimer = 6
TeleportSafe = true
Webhook = ""
_G.Version="Fruit Farm"
print(game.PlaceId)
if game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then
loadstring(game:HttpGet("https://raw.githubusercontent.com/SaltyHB/Poggers/refs/heads/main/Main"))()
else
loadstring(game:HttpGet("https://raw.githubusercontent.com/SaltyHB/Poggers/refs/heads/main/Fisch"))()
end

