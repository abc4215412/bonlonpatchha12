-- Chạy từ executor

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ===================== CHỐNG CHẠY 2 LẦN =====================
if _G.AutoTpLoaded then return end
_G.AutoTpLoaded = true

-- ===================== KEEP ALIVE (Xeno) =====================
local queueteleport = queue_on_teleport

local TeleportCheck = false
Players.LocalPlayer.OnTeleport:Connect(function(State)
    if not TeleportCheck and queueteleport then
        TeleportCheck = true
        _G.AutoTpLoaded = nil
        queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/abc4215412/chest-farmer/refs/heads/main/chestfarm.lua'))()")
    end
end)

-- ===================== TELEPORT =====================
local target = CFrame.new(-8.29012299, 20.4728603, -19.6051674, 1, 0, 0, 0, 1, 0, 0, 0, 1)

local function doTeleport()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    root.CFrame = target
end

-- Teleport ngay khi load
task.spawn(function()
    task.wait(10) -- chờ character sẵn sàng
    doTeleport()
end)

-- Teleport lại mỗi khi respawn
player.CharacterAdded:Connect(function()
    task.wait(10)
    doTeleport()
end)
