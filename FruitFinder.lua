repeat wait() until game:IsLoaded()
repeat wait() until game.Players
repeat wait() until game.Players.LocalPlayer
repeat wait() until game.ReplicatedStorage
repeat wait() until game.ReplicatedStorage:FindFirstChild("Remotes");
repeat wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui");
repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main");
repeat wait()
until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen") == nil 
ServerHopTimer = 5
TeleportSafe = true
Webhook = "https://discord.com/api/webhooks/1330497976530899016/Fd3II8yhiM_wVjTQzPDDv_MVTAHAwtIKwCc1futvX3ztqFOe7zrWquc-wjdn0fbPDwpn"
_G.Version="Fruit Farm"loadstring(game:HttpGet("https://raw.githubusercontent.com/Efe0626/RaitoHub/main/Script"))()

