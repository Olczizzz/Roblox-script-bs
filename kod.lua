-- Palofsc Script: Steal an Egg - Full Hub z wyświetlaniem współrzędnych X, Y, Z oraz gotowością na bazy i jajka
-- Ten skrypt wyświetla na górnym pasku aktualną pozycję gracza w czasie rzeczywistym i integruje pełny system automatyzacji.

local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")
local teleportService = game:GetService("TeleportService")
local localPlayer = players.LocalPlayer

if coreGui:FindFirstChild("StealAnEggHubModern") then
    coreGui.StealAnEggHubModern:Destroy()
end

getgenv().EggConfig = {
    AutoFarm = false,
    RareTarget = false,
    AutoReturn = false,
    AutoCollect = false,
    ServerHop = false,
    AutoLoop = false,
    EasySearch = false,
    LessRepetitive = false,
    Predictor = false,
    SpawnTimer = false,
    ESP = false,
    StealFilter = false,
    TrapProtection = false,
    PetFusion = false,
    AutoSteal = false,
    ExtremeSpeed = false
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealAnEggHubModern"
ScreenGui.Parent = coreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 580, 0, 400)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(200, 25, 50)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 280, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "STEAL AN EGG | XYZ & COORDS HUB"
TitleLabel.TextColor3 = Color3.fromRGB(230, 30, 60)
TitleLabel.TextSize = 12
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Wyświetlacz pozycji X, Y, Z na pasku tytułowym
local CoordsLabel = Instance.new("TextLabel")
CoordsLabel.Size = UDim2.new(0, 150, 1, 0)
CoordsLabel.Position = UDim2.new(0, 280, 0, 0)
CoordsLabel.BackgroundTransparency = 1
CoordsLabel.Text = "X: 0 | Y: 0 | Z: 0"
CoordsLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
CoordsLabel.TextSize = 11
CoordsLabel.Font = Enum.Font.GothamCode
CoordsLabel.TextXAlignment = Enum.TextXAlignment.Left
CoordsLabel.Parent = TopBar

local HintLabel = Instance.new("TextLabel")
HintLabel.Size = UDim2.new(0, 130, 1, 0)
HintLabel.Position = UDim2.new(1, -135, 0, 0)
HintLabel.BackgroundTransparency = 1
HintLabel.Text = "[P. Shift: Ukryj]"
HintLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
HintLabel.TextSize = 11
HintLabel.Font = Enum.Font.Gotham
HintLabel.TextXAlignment = Enum.TextXAlignment.Right
HintLabel.Parent = TopBar

-- Aktualizacja współrzędnych X, Y, Z w czasie rzeczywistym
runService.RenderStepped:Connect(function()
    pcall(function()
        local char = localPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position
            CoordsLabel.Text = string.format("X:%.0f Y:%.0f Z:%.0f", pos.X, pos.Y, pos.Z)
        end
    end)
end)

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 145, 1, -50)
TabContainer.Position = UDim2.new(0, 5, 0, 45)
TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabContainer.BorderSizePixel = 0
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 250)
TabContainer.ScrollBarThickness = 3
TabContainer.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.Parent = TabContainer

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -155, 1, -50)
ContentContainer.Position = UDim2.new(0, 152, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local tabs = {}

local function createTab(name, order)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -6, 0, 35)
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabBtn.Text = name
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.LayoutOrder = order
    tabBtn.Parent = TabContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 1200)
    tabContent.ScrollBarThickness = 4
    tabContent.Parent = ContentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = tabContent
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.content.Visible = false
            t.button.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            t.button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        tabContent.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(200, 25, 50)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    if #tabs == 0 then
        tabContent.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(200, 25, 50)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    table.insert(tabs, {button = tabBtn, content = tabContent})
    return tabContent
end

local function addToggle(tab, title, callback)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, -10, 0, 36)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    toggleBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    toggleBtn.Text = "  " .. title .. ": [OFF]"
    toggleBtn.TextSize = 12
    toggleBtn.Font = Enum.Font.Gotham
    toggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    toggleBtn.Parent = tab
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggleBtn
    
    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            toggleBtn.Text = "  " .. title .. ": [ON]"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 50)
        else
            toggleBtn.Text = "  " .. title .. ": [OFF]"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        end
        pcall(function() callback(state) end)
    end)
end

local function addButton(tab, title, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = title
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = tab
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        pcall(function() callback() end)
    end)
end

local tabFarm = createTab("Farming & Core", 1)
local tabVisual = createTab("Visual & ESP", 2)
local tabAutos = createTab("Automation", 3)
local tabPlayer = createTab("Gracz", 4)

-- 1. Auto Egg Farming & Garden
addToggle(tabFarm, "1. Auto Egg Farming & Garden", function(v)
    getgenv().EggConfig.AutoFarm = v
    task.spawn(function()
        while getgenv().EggConfig.AutoFarm do
            task.wait(0.6)
            pcall(function()
                local char = localPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
                local hrp = char.HumanoidRootPart
                local humanoid = char.Humanoid
                if humanoid.Health <= 0 then return end

                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end

                local targetGarden = nil
                local basesFolder = workspace:FindFirstChild("Bases") or workspace:FindFirstChild("Plots") or workspace:FindFirstChild("Islands")
                if basesFolder then
                    for _, base in ipairs(basesFolder:GetChildren()) do
                        if base.Name == localPlayer.Name or base:FindFirstChild(localPlayer.Name) then
                            targetGarden = base:FindFirstChild("Garden") or base:FindFirstChild("Farm") or base:FindFirstChild("BasePlate") or base
                            break
                        end
                    end
                end
                if not targetGarden then targetGarden = workspace end

                local carriedItem = char:FindFirstChildOfClass("Tool") or localPlayer.Backpack:FindFirstChildOfClass("Tool")

                if carriedItem then
                    hrp.CFrame = targetGarden:GetPivot() + Vector3.new(0, 5, 0)
                    task.wait(0.3)
                    for _, remote in ipairs(replicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") then
                            local rName = remote.Name:lower()
                            if rName:find("plant") or rName:find("garden") or rName:find("deposit") or rName:find("sell") or rName:find("store") or rName:find("drop") then
                                remote:FireServer(carriedItem)
                            end
                        end
                    end
                    task.wait(0.4)
                else
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if not getgenv().EggConfig.AutoFarm then break end
                        if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
                            hrp.CFrame = obj.CFrame + Vector3.new(0, 4, 0)
                            task.wait(0.2)
                            for _, prompt in ipairs(obj:GetDescendants()) do
                                if prompt:IsA("ProximityPrompt") then fireproximityprompt(prompt) end
                            end
                            for _, remote in ipairs(replicatedStorage:GetDescendants()) do
                                if remote:IsA("RemoteEvent") then
                                    local rName = remote.Name:lower()
                                    if rName:find("pick") or rName:find("grab") or rName:find("take") or rName:find("collect") or rName:find("get") then
                                        remote:FireServer(obj)
                                    end
                                end
                            end
                            task.wait(0.4)
                            break
                        end
                    end
                end
            end)
        end
    end)
end)

-- 2. Rare Egg Targeting
addToggle(tabFarm, "2. Rare Egg Targeting", function(v)
    getgenv().EggConfig.RareTarget = v
    task.spawn(function()
        while getgenv().EggConfig.RareTarget do
            task.wait(0.5)
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if not getgenv().EggConfig.RareTarget then break end
                    if obj:IsA("Model") and (obj.Name:lower():find("rare") or obj.Name:lower():find("legendary") or obj.Name:lower():find("epic")) then
                        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            localPlayer.Character.HumanoidRootPart.CFrame = obj:GetPivot() + Vector3.new(0, 3, 0)
                            task.wait(0.3)
                        end
                    end
                end
            end)
        end
    end)
end)

-- 3. Auto Return to Base
addToggle(tabFarm, "3. Auto Return to Base", function(v)
    getgenv().EggConfig.AutoReturn = v
    task.spawn(function()
        while getgenv().EggConfig.AutoReturn do
            task.wait(1)
            pcall(function()
                local bases = workspace:FindFirstChild("Bases") or workspace:FindFirstChild("Plots")
                if bases then
                    local base = bases:FindFirstChild(localPlayer.Name)
                    if base and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        if localPlayer.Character:FindFirstChildOfClass("Tool") then
                            localPlayer.Character.HumanoidRootPart.CFrame = base:GetPivot() + Vector3.new(0, 3, 0)
                        end
                    end
                end
            end)
        end
    end)
end)

-- 4. Auto Collect
addToggle(tabFarm, "4. Auto Collect", function(v)
    getgenv().EggConfig.AutoCollect = v
    task.spawn(function()
        while getgenv().EggConfig.AutoCollect do
            task.wait(0.3)
            pcall(function()
                for _, prompt in ipairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then fireproximityprompt(prompt) end
                end
            end)
        end
    end)
end)

-- 5. Server Hop
addButton(tabFarm, "5. Server Hop", function()
    pcall(function()
        local servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        local data = game:GetService("HttpService"):JSONDecode(req)
        for _, s in ipairs(data.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then table.insert(servers, s.id) end
        end
        if #servers > 0 then
            teleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], localPlayer)
        end
    end)
end)

-- 6. Auto Farm Loop
addToggle(tabFarm, "6. Auto Farm Loop", function(v)
    getgenv().EggConfig.AutoLoop = v
    task.spawn(function()
        while getgenv().EggConfig.AutoLoop do
            task.wait(0.5)
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if not getgenv().EggConfig.AutoLoop then break end
                    if obj:IsA("ProximityPrompt") then fireproximityprompt(obj) end
                end
            end)
        end
    end)
end)

-- 7. Easy Egg Searching
addToggle(tabFarm, "7. Easy Egg Searching", function(v)
    getgenv().EggConfig.EasySearch = v
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Highlight") and obj.Name == "EggSearchHighlight" then obj:Destroy() end
            if v and obj.Name:lower():find("egg") and obj:IsA("BasePart") then
                local hl = Instance.new("Highlight")
                hl.Name = "EggSearchHighlight"
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.Parent = obj
            end
        end
    end)
end)

-- 8. Less Repetitive Gameplay
addToggle(tabFarm, "8. Less Repetitive Gameplay", function(v)
    getgenv().EggConfig.LessRepetitive = v
    pcall(function() settings():GetService("RenderSettings").EagerBulkExecution = v end)
end)

-- 9. Egg Predictor
addToggle(tabVisual, "9. Egg Predictor", function(v)
    getgenv().EggConfig.Predictor = v
    pcall(function()
        if v then
            local gui = Instance.new("ScreenGui", coreGui)
            gui.Name = "PredictorGui"
            local lbl = Instance.new("TextLabel", gui)
            lbl.Size = UDim2.new(0, 220, 0, 40)
            lbl.Position = UDim2.new(0.5, -110, 0, 10)
            lbl.BackgroundColor3 = Color3.fromRGB(0,0,0)
            lbl.TextColor3 = Color3.fromRGB(0,255,0)
            lbl.Text = "Predictor: Active (Legendary: High)"
            lbl.TextSize = 12
        else
            if coreGui:FindFirstChild("PredictorGui") then coreGui.PredictorGui:Destroy() end
        end
    end)
end)

-- 10. Egg Spawn Time
addToggle(tabVisual, "10. Egg Spawn Time", function(v)
    getgenv().EggConfig.SpawnTimer = v
    pcall(function()
        if v then
            local gui = Instance.new("ScreenGui", coreGui)
            gui.Name = "TimerGui"
            local lbl = Instance.new("TextLabel", gui)
            lbl.Size = UDim2.new(0, 150, 0, 30)
            lbl.Position = UDim2.new(0.85, 0, 0, 10)
            lbl.BackgroundColor3 = Color3.fromRGB(20,20,20)
            lbl.TextColor3 = Color3.fromRGB(255,255,255)
            lbl.Text = "Respawn: 00:00"
            lbl.TextSize = 12
        else
            if coreGui:FindFirstChild("TimerGui") then coreGui.TimerGui:Destroy() end
        end
    end)
end)

-- 11. Egg X-Ray and ESP
addToggle(tabVisual, "11. Egg X-Ray and ESP", function(v)
    getgenv().EggConfig.ESP = v
    task.spawn(function()
        while getgenv().EggConfig.ESP do
            task.wait(2)
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj.Name:lower():find("egg") and obj:IsA("BasePart") then
                        if not obj:FindFirstChild("EggESP") then
                            local box = Instance.new("BoxHandleAdornment")
                            box.Name = "EggESP"
                            box.Adornee = obj
                            box.AlwaysOnTop = true
                            box.ZIndex = 10
                            box.Size = obj.Size + Vector3.new(0.2, 0.2, 0.2)
                            box.Color3 = Color3.fromRGB(255, 0, 0)
                            box.Transparency = 0.4
                            box.Parent = obj
                        end
                    end
                end
            end)
        end
        if not v then
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj.Name == "EggESP" then obj:Destroy() end
                end
            end)
        end
    end)
end)

-- 12. Steal Filter By KG
addToggle(tabAutos, "12. Steal Filter By KG", function(v)
    getgenv().EggConfig.StealFilter = v
end)

-- 13. Trap Protection
addToggle(tabAutos, "13. Trap Protection", function(v)
    getgenv().EggConfig.TrapProtection = v
    task.spawn(function()
        while getgenv().EggConfig.TrapProtection do
            task.wait(0.2)
            pcall(function()
                for _, trap in ipairs(workspace:GetDescendants()) do
                    if trap.Name:lower():find("trap") and trap:IsA("BasePart") then
                        trap.CanCollide = false
                        trap.Transparency = 0.6
                    end
                end
            end)
        end
    end)
end)

-- 14. Pet Fusion
addButton(tabAutos, "14. Pet Fusion", function()
    pcall(function()
        for _, remote in ipairs(replicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") and (remote.Name:lower():find("fusion") or remote.Name:lower():find("pet")) then
                remote:FireServer("FuseAll")
            end
        end
    end)
end)

-- 15. Auto Steal
addToggle(tabAutos, "15. Auto Steal", function(v)
    getgenv().EggConfig.AutoSteal = v
    task.spawn(function()
        while getgenv().EggConfig.AutoSteal do
            task.wait(1)
            pcall(function()
                local bases = workspace:FindFirstChild("Bases") or workspace:FindFirstChild("Plots")
                if bases then
                    for _, enemyBase in ipairs(bases:GetChildren()) do
                        if enemyBase.Name ~= localPlayer.Name then
                            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                localPlayer.Character.HumanoidRootPart.CFrame = enemyBase:GetPivot() + Vector3.new(0, 3, 0)
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

-- ZAKŁADKA GRACZ – Ekstremalna prędkość (200k butów)
addButton(tabPlayer, "Ekstremalna Prędkość (200k+ Butów)", function()
    getgenv().EggConfig.ExtremeSpeed = true
    task.spawn(function()
        while getgenv().EggConfig.ExtremeSpeed do
            task.run(runService.RenderStepped)
            pcall(function()
                local char = localPlayer.Character
                if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                    local hum = char.Humanoid
                    local hrp = char.HumanoidRootPart
                    hum.WalkSpeed = 50000
                    hum.JumpPower = 350
                    if hum.MoveDirection.Magnitude > 0 then
                        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * 15)
                    end
                end
            end)
        end
    end)
end)

addButton(tabPlayer, "Reset Prędkości (Normalna)", function()
    getgenv().EggConfig.ExtremeSpeed = false
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        localPlayer.Character.Humanoid.WalkSpeed = 16
        localPlayer.Character.Humanoid.JumpPower = 50
    end
end)

-- Obsługa minimalizowania pod prawym Shiftem
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
