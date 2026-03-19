-- Chạy từ executor

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer

-- ===================== CHỐNG CHẠY 2 LẦN =====================
if _G.ChestFarmLoaded then return end
_G.ChestFarmLoaded = true

-- ===================== KEEP ALIVE =====================
local queueteleport = queue_on_teleport
    or (syn and syn.queue_on_teleport)
    or (fluxus and fluxus.queue_on_teleport)

local TeleportCheck = false
Players.LocalPlayer.OnTeleport:Connect(function(State)
    if not TeleportCheck and queueteleport then
        TeleportCheck = true
        _G.ChestFarmLoaded = nil
        queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/abc4215412/chest-farmer/refs/heads/main/chestfarm.lua'))()")
    end
end)

-- ===================== GUI PARENT =====================
local COREGUI = game:GetService("CoreGui")
local MAX_DISPLAY_ORDER = 2147483647
local PARENT = nil

local function randomString()
    local length = math.random(10, 20)
    local array = {}
    for i = 1, length do
        array[i] = string.char(math.random(32, 126))
    end
    return table.concat(array)
end

if get_hidden_gui or gethui then
    local Main = Instance.new("ScreenGui")
    Main.Name = randomString()
    Main.ResetOnSpawn = false
    Main.DisplayOrder = MAX_DISPLAY_ORDER
    Main.Parent = (get_hidden_gui or gethui)()
    PARENT = Main
elseif syn and syn.protect_gui then
    local Main = Instance.new("ScreenGui")
    Main.Name = randomString()
    Main.ResetOnSpawn = false
    Main.DisplayOrder = MAX_DISPLAY_ORDER
    syn.protect_gui(Main)
    Main.Parent = COREGUI
    PARENT = Main
elseif COREGUI:FindFirstChild("RobloxGui") then
    PARENT = COREGUI.RobloxGui
else
    local Main = Instance.new("ScreenGui")
    Main.Name = randomString()
    Main.ResetOnSpawn = false
    Main.DisplayOrder = MAX_DISPLAY_ORDER
    Main.Parent = COREGUI
    PARENT = Main
end

-- ===================== GUI =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChestFarmGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = MAX_DISPLAY_ORDER
screenGui.Parent = PARENT

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 270, 0, 370)
mainFrame.Position = UDim2.new(0, 16, 0.5, -185)
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
titleText.Text = "Chest Farmer — Auto"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 15
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -16, 0, 24)
statusLabel.Position = UDim2.new(0, 8, 0, 44)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Đang chờ..."
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
logLabel.Text = ""
logLabel.TextColor3 = Color3.fromRGB(140, 200, 140)
logLabel.TextSize = 11
logLabel.Font = Enum.Font.Code
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.TextYAlignment = Enum.TextYAlignment.Top
logLabel.TextWrapped = true
logLabel.Parent = mainFrame
Instance.new("UICorner", logLabel).CornerRadius = UDim.new(0, 6)

-- ===================== HELPERS =====================
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
        local opened = getPrompt(part) == nil
        if not opened then remaining += 1 end
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -6, 0, 26)
        btn.BackgroundColor3 = opened
            and Color3.fromRGB(24, 24, 34)
            or Color3.fromRGB(40, 50, 80)
        btn.BorderSizePixel = 0
        btn.Text = (opened and "✓ " or "📦 ") .. "Chest #" .. i
            .. " (" .. math.floor(part.Position.X) .. ", "
            .. math.floor(part.Position.Z) .. ")"
            .. (opened and "  [mở rồi]" or "")
        btn.TextColor3 = opened
            and Color3.fromRGB(80, 80, 80)
            or Color3.fromRGB(200, 220, 255)
        btn.TextSize = 11
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = i
        btn.Parent = scrollFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #parts * 29 + 6)
    countLabel.Text = "Chests: " .. #parts .. " total | " .. remaining .. " còn lại"
    return remaining
end

-- ===================== WAIT FOR READY =====================
-- Dùng attribute "Ready" trên player — server set khi map load xong
-- Khi Ready = false hoặc bị xóa thì map đang reset (giữa các round)
local function waitForReady()
    setStatus("Chờ intro / map load...", Color3.fromRGB(255, 200, 60))
    addLog("⏳ Chờ Ready attribute...")

    -- Chờ Ready = true
    while player:GetAttribute("Ready") ~= true do
        task.wait(0.3)
    end

    -- Thêm buffer nhỏ để chest được tag đầy đủ
    task.wait(0.5)

    -- Đảm bảo có ít nhất 1 chest
    local waited = 0
    while #CollectionService:GetTagged("BonusChestPart") == 0 do
        task.wait(0.3)
        waited += 0.3
        if waited > 10 then
            -- Timeout: Ready = true nhưng không có chest (map không có chest)
            addLog("⚠ Không có chest trên map này")
            return false
        end
    end

    addLog("✅ Ready! " .. #CollectionService:GetTagged("BonusChestPart") .. " chest")
    return true
end

-- ===================== FARM 1 ROUND =====================
local function farmOneRound()
    local parts = CollectionService:GetTagged("BonusChestPart")
    local opened = 0
    local skipped = 0

    rebuildList()
    addLog("▶ Farm " .. #parts .. " chest")

    for i, part in parts do
        -- Nếu Ready bị tắt giữa chừng (map đổi) thì dừng ngay
        if player:GetAttribute("Ready") ~= true then
            addLog("⚠ Map reset giữa chừng, dừng")
            break
        end

        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            task.wait(1)
            char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                addLog("✗ Mất character")
                break
            end
        end

        local prompt = getPrompt(part)
        if not prompt then
            skipped += 1
            continue
        end

        setStatus("Chest " .. i .. "/" .. #parts, Color3.fromRGB(255, 220, 50))
        char.HumanoidRootPart.CFrame = CFrame.new(part.Position + Vector3.new(0, 4, 0))
        task.wait(0.2)

        prompt = getPrompt(part)
        if not prompt then
            skipped += 1
            continue
        end

        local ok = pcall(fireproximityprompt, prompt)
        if not ok then
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait((prompt.HoldDuration or 0) + 0.1)
                vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)
        end

        opened += 1
        task.wait(0.8)
        rebuildList()
        addLog("✓ #" .. i .. " | " .. opened .. " mở")
    end

    return opened, skipped
end

-- ===================== MAIN LOOP =====================
task.spawn(function()
    while true do
        -- Bước 1: chờ map sẵn sàng (qua intro, qua loading)
        local ok = waitForReady()

        if ok then
            -- Bước 2: farm hết chest
            local opened, skipped = farmOneRound()
            local remaining = rebuildList()

            -- Bước 3: nếu còn sót thì retry 1 lần
            if remaining > 0 and player:GetAttribute("Ready") == true then
                addLog("⚠ Còn " .. remaining .. " chest, retry...")
                task.wait(2)
                farmOneRound()
                rebuildList()
            end

            setStatus("✅ Xong! Chờ round mới...", Color3.fromRGB(80, 255, 120))
            addLog("✅ Xong! Chờ map tiếp...")
        end

        -- Bước 4: chờ Ready tắt đi (server reset map / round mới bắt đầu)
        -- Khi Ready = false server đang clear chest cũ (theo decompiled code)
        while player:GetAttribute("Ready") == true do
            task.wait(0.5)
        end

        addLog("🔄 Map reset, chờ round mới...")
        setStatus("Chờ round mới...", Color3.fromRGB(180, 180, 255))

        -- Reset UI
        for _, c in scrollFrame:GetChildren() do
            if c:IsA("TextButton") then c:Destroy() end
        end
        countLabel.Text = "Chests: 0 total | 0 còn lại"

        -- Vòng lặp tiếp tục → waitForReady() sẽ chờ Ready = true lần nữa
    end
end)
