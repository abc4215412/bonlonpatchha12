-- LocalScript — đặt trong StarterPlayerScripts

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- ===================== KEEP ALIVE KHI TELEPORT =====================
local queueteleport = queue_on_teleport 
    or (syn and syn.queue_on_teleport) 
    or (fluxus and fluxus.queue_on_teleport)

if queueteleport then
    local teleportCheck = false
    player.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Started and not teleportCheck then
            teleportCheck = true
            queueteleport([[
                loadstring(game:HttpGet(
                    'https://raw.githubusercontent.com/TenBan/chest-farmer/main/chestfarm.lua'
                ))()
            ]])
        end
    end)
end

-- ===================== GUI =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChestFarmGui"
screenGui.ResetOnSpawn = false

-- Chọn parent an toàn nhất
local ok = pcall(function()
    local hgui = (get_hidden_gui or gethui)()
    screenGui.Parent = hgui
end)

if not ok then
    ok = pcall(function()
        syn.protect_gui(screenGui)
        screenGui.Parent = game:GetService("CoreGui")
    end)
end

if not ok then
    screenGui.Parent = player.PlayerGui
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 270, 0, 400)
mainFrame.Position = UDim2.new(0, 16, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(72, 44, 160)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local patch = Instance.new("Frame")
patch.Size = UDim2.new(1, 0, 0, 10)
patch.Position = UDim2.new(0, 0, 1, -10)
patch.BackgroundColor3 = Color3.fromRGB(72, 44, 160)
patch.BorderSizePixel = 0
patch.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Chest Farmer"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 15
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -16, 0, 24)
statusLabel.Position = UDim2.new(0, 8, 0, 44)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.fromRGB(150, 255, 180)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, -16, 0, 20)
countLabel.Position = UDim2.new(0, 8, 0, 68)
countLabel.BackgroundTransparency = 1
countLabel.Text = "Chests: 0 total | 0 còn lại"
countLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
countLabel.TextSize = 12
countLabel.Font = Enum.Font.Gotham
countLabel.TextXAlignment = Enum.TextXAlignment.Left
countLabel.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -16, 0, 180)
scrollFrame.Position = UDim2.new(0, 8, 0, 92)
scrollFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 200)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame
Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0, 8)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 3)
listLayout.Parent = scrollFrame
Instance.new("UIPadding", scrollFrame).PaddingTop = UDim.new(0, 3)

local logLabel = Instance.new("TextLabel")
logLabel.Size = UDim2.new(1, -16, 0, 80)
logLabel.Position = UDim2.new(0, 8, 0, 280)
logLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
logLabel.BorderSizePixel = 0
logLabel.Text = "[Log chưa có gì]"
logLabel.TextColor3 = Color3.fromRGB(140, 200, 140)
logLabel.TextSize = 11
logLabel.Font = Enum.Font.Code
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.TextYAlignment = Enum.TextYAlignment.Top
logLabel.TextWrapped = true
logLabel.Parent = mainFrame
Instance.new("UICorner", logLabel).CornerRadius = UDim.new(0, 6)

local farmBtn = Instance.new("TextButton")
farmBtn.Size = UDim2.new(1, -16, 0, 34)
farmBtn.Position = UDim2.new(0, 8, 0, 368)
farmBtn.BackgroundColor3 = Color3.fromRGB(34, 140, 60)
farmBtn.BorderSizePixel = 0
farmBtn.Text = "▶  Farm All Chests"
farmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
farmBtn.TextSize = 14
farmBtn.Font = Enum.Font.GothamBold
farmBtn.Parent = mainFrame
Instance.new("UICorner", farmBtn).CornerRadius = UDim.new(0, 8)

-- ===================== STATE =====================
local isFarming = false
local logLines = {}

local function addLog(msg)
    table.insert(logLines, msg)
    if #logLines > 6 then table.remove(logLines, 1) end
    logLabel.Text = table.concat(logLines, "\n")
end

local function setStatus(text, color)
    statusLabel.Text = "Status: " .. text
    statusLabel.TextColor3 = color or Color3.fromRGB(150, 255, 180)
end

-- ===================== CHEST LIST BUILD =====================
local function isChestOpen(part)
    for _, desc in part:GetDescendants() do
        if desc:IsA("ProximityPrompt") then
            return not desc.Enabled
        end
    end
    return true
end

local function getPrompt(part)
    for _, desc in part:GetDescendants() do
        if desc:IsA("ProximityPrompt") and desc.Enabled then
            return desc
        end
    end
    return nil
end

local function rebuildList()
    for _, c in scrollFrame:GetChildren() do
        if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end
    end

    local parts = CollectionService:GetTagged("BonusChestPart")
    local remaining = 0

    for i, part in parts do
        local opened = isChestOpen(part)
        if not opened then remaining += 1 end

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -6, 0, 26)
        btn.BackgroundColor3 = opened 
            and Color3.fromRGB(30, 30, 40) 
            or Color3.fromRGB(40, 50, 80)
        btn.BorderSizePixel = 0
        btn.Text = (opened and "✓ " or "📦 ") .. "Chest #" .. i
                .. "  (" .. math.floor(part.Position.X) .. ", "
                .. math.floor(part.Position.Z) .. ")"
                .. (opened and "  [mở rồi]" or "")
        btn.TextColor3 = opened 
            and Color3.fromRGB(90, 90, 90) 
            or Color3.fromRGB(200, 220, 255)
        btn.TextSize = 11
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = i
        btn.Parent = scrollFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

        if not opened then
            btn.MouseButton1Click:Connect(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(
                        part.Position + Vector3.new(0, 5, 0)
                    )
                    setStatus("Teleport → Chest #" .. i, Color3.fromRGB(255, 220, 80))
                    addLog("→ Teleport Chest #" .. i)
                end
            end)
        end
    end

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #parts * 29 + 6)
    countLabel.Text = "Chests: " .. #parts .. " total | " .. remaining .. " còn lại"
end

-- ===================== FARM LOGIC =====================
local function farmAll()
    if isFarming then
        isFarming = false
        farmBtn.Text = "▶  Farm All Chests"
        farmBtn.BackgroundColor3 = Color3.fromRGB(34, 140, 60)
        setStatus("Stopped", Color3.fromRGB(255, 120, 80))
        addLog("⏹ Stopped")
        return
    end

    isFarming = true
    farmBtn.Text = "⏹  Stop"
    farmBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)

    task.spawn(function()
        local parts = CollectionService:GetTagged("BonusChestPart")
        local total = #parts
        local opened = 0
        local skipped = 0

        addLog("▶ Bắt đầu farm " .. total .. " chest")

        for i, part in parts do
            if not isFarming then break end

            local char = player.Character
            if not char then 
                task.wait(1)
                char = player.Character 
            end
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                addLog("✗ Không tìm thấy character")
                break
            end

            local prompt = getPrompt(part)

            if not prompt then
                skipped += 1
                addLog("skip #" .. i .. " (đã mở)")
                rebuildList()
                task.wait(0.1)
                continue
            end

            setStatus(
                "Đến chest " .. i .. "/" .. total, 
                Color3.fromRGB(255, 220, 50)
            )
            char.HumanoidRootPart.CFrame = CFrame.new(
                part.Position + Vector3.new(0, 4, 0)
            )
            task.wait(0.25)

            prompt = getPrompt(part)
            if not prompt then
                skipped += 1
                addLog("skip #" .. i .. " (đã mở sau tp)")
                rebuildList()
                task.wait(0.1)
                continue
            end

            setStatus(
                "Mở chest " .. i .. "/" .. total .. " 🎁", 
                Color3.fromRGB(80, 220, 160)
            )
            addLog("→ Mở Chest #" .. i)

            local ok = pcall(function()
                fireproximityprompt(prompt)
            end)

            if not ok then
                pcall(function()
                    local vim = game:GetService("VirtualInputManager")
                    vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait((prompt.HoldDuration or 0) + 0.15)
                    vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end)
            end

            opened += 1
            task.wait(1.2)
            rebuildList()
            addLog("✓ #" .. i .. " done | " .. opened .. " mở / " .. skipped .. " skip")
        end

        if isFarming then
            setStatus(
                "✅ Done! " .. opened .. " mở, " .. skipped .. " đã skip", 
                Color3.fromRGB(80, 255, 120)
            )
            addLog("✅ Farm xong!")
        end

        isFarming = false
        farmBtn.Text = "▶  Farm All Chests"
        farmBtn.BackgroundColor3 = Color3.fromRGB(34, 140, 60)
        rebuildList()
    end)
end

farmBtn.MouseButton1Click:Connect(farmAll)

-- ===================== AUTO REFRESH =====================
CollectionService:GetInstanceAddedSignal("BonusChestPart"):Connect(function()
    task.wait(0.3)
    rebuildList()
end)

CollectionService:GetInstanceRemovedSignal("BonusChestPart"):Connect(function()
    task.wait(0.1)
    rebuildList()
end)

task.wait(2)
rebuildList()
setStatus("Sẵn sàng", Color3.fromRGB(150, 255, 180))
addLog("Loaded. " .. #CollectionService:GetTagged("BonusChestPart") .. " chests found")

task.spawn(function()
    while true do
        task.wait(5)
        if not isFarming then
            rebuildList()
        end
    end
end)
