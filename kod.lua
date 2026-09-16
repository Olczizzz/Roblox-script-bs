-- Palofsc Script: AvalonHub dla Blox Strike (Modern Minimalist Red/Black GUI)
-- Skrypt zawiera nowoczesny, minimalistyczny interfejs z zakładkami Wallhack, Aimbot oraz suwakiem skuteczności trafień.

local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

if coreGui:FindFirstChild("AvalonHubBloxStrike") then
    coreGui.AvalonHubBloxStrike:Destroy()
end

getgenv().AvalonConfig = {
    Wallhack = false,
    Aimbot = false,
    HitChance = 100 -- Procent skuteczności trafień
}

-- Główny kontener GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AvalonHubBloxStrike"
ScreenGui.Parent = coreGui

-- Okno główne (Nowoczesny minimalizm, czerń i czerwień)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(200, 20, 40)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Pasek górny
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 6)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "AvalonHub"
TitleLabel.TextColor3 = Color3.fromRGB(220, 30, 50)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local HintLabel = Instance.new("TextLabel")
HintLabel.Size = UDim2.new(1, -20, 1, 0)
HintLabel.BackgroundTransparency = 1
HintLabel.Text = "[Right Shift: Ukryj]"
HintLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
HintLabel.TextSize = 10
HintLabel.Font = Enum.Font.Gotham
HintLabel.TextXAlignment = Enum.TextXAlignment.Right
HintLabel.Parent = TopBar

-- Pasek boczny z zakładkami
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 130, 1, -45)
TabContainer.Position = UDim2.new(0, 5, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabContainer

-- Kontener na zawartość zakładek
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -145, 1, -45)
ContentContainer.Position = UDim2.new(0, 140, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local tabs = {}

local function createTab(name, order)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 32)
    tabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tabBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
    tabBtn.Text = name
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.LayoutOrder = order
    tabBtn.Parent = TabContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = tabBtn
    
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = ContentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = tabContent
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.content.Visible = false
            t.button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            t.button.TextColor3 = Color3.fromRGB(170, 170, 170)
        end
        tabContent.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(200, 20, 40)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    if #tabs == 0 then
        tabContent.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(200, 20, 40)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    table.insert(tabs, {button = tabBtn, content = tabContent})
    return tabContent
end

local function addToggle(tab, title, callback)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, -5, 0, 35)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    toggleBtn.TextColor3 = Color3.fromRGB(210, 210, 210)
    toggleBtn.Text = "  " .. title .. ": [OFF]"
    toggleBtn.TextSize = 11
    toggleBtn.Font = Enum.Font.Gotham
    toggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    toggleBtn.Parent = tab
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = toggleBtn
    
    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            toggleBtn.Text = "  " .. title .. ": [ON]"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 40)
        else
            toggleBtn.Text = "  " .. title .. ": [OFF]"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        end
        pcall(function() callback(state) end)
    end)
end

local function addSlider(tab, title, min, max, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -5, 0, 50)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = tab
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = title .. ": " .. getgenv().AvalonConfig.HitChance .. "%"
    label.TextColor3 = Color3.fromRGB(210, 210, 210)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local sliderBar = Instance.new("TextButton")
    sliderBar.Size = UDim2.new(1, -20, 0, 8)
    sliderBar.Position = UDim2.new(0, 10, 0, 30)
    sliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    sliderBar.Text = ""
    sliderBar.AutoButtonColor = false
    sliderBar.Parent = sliderFrame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = sliderBar
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(getgenv().AvalonConfig.HitChance / max, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(200, 20, 40)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill
    
    local dragging = false
    sliderBar.MouseButton1Down:Connect(function() dragging = true end)
    userInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    userInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = userInputService:GetMouseLocation()
            local absPos = sliderBar.AbsolutePosition
            local absSize = sliderBar.AbsoluteSize
            local percent = math.clamp((pos.X - absPos.X) / absSize.X, 0, 1)
            local val = math.floor(min + (max - min) * percent)
            
            fill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = title .. ": " .. val .. "%"
            getgenv().AvalonConfig.HitChance = val
            pcall(function() callback(val) end)
        end
    end)
end

-- Tworzenie zakładek
local tabWallhack = createTab("Wallhack", 1)
local tabAimbot = createTab("Aimbot", 2)

-- Zakładka Wallhack (Włącz / Wyłącz)
addToggle(tabWallhack, "Wallhack (ESP)", function(state)
    getgenv().AvalonConfig.Wallhack = state
    task.spawn(function()
        while getgenv().AvalonConfig.Wallhack do
            task.wait(1)
            pcall(function()
                for _, p in ipairs(players:GetPlayers()) do
                    if p ~= localPlayer and p.Character then
                        local highlight = p.Character:FindFirstChild("AvalonHighlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "AvalonHighlight"
                            highlight.FillColor = Color3.fromRGB(200, 20, 40)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.Parent = p.Character
                        end
                        highlight.Enabled = getgenv().AvalonConfig.Wallhack
                    end
                end
            end)
        end
        if not getgenv().AvalonConfig.Wallhack then
            pcall(function()
                for _, p in ipairs(players:GetPlayers()) do
                    if p.Character then
                        local h = p.Character:FindFirstChild("AvalonHighlight")
                        if h then h:Destroy() end
                    end
                end
            end)
        end
    end)
end)

-- Zakładka Aimbot (Włącz / Wyłącz oraz suwak skuteczności)
addToggle(tabAimbot, "Aimbot", function(state)
    getgenv().AvalonConfig.Aimbot = state
    task.spawn(function()
        while getgenv().AvalonConfig.Aimbot do
            task.wait()
            pcall(function()
                local closestTarget = nil
                local shortestDist = math.huge
                
                for _, p in ipairs(players:GetPlayers()) do
                    if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                        if p.Character.Humanoid.Health > 0 then
                            local pos, onScreen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                            if onScreen then
                                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                                if dist < shortestDist then
                                    shortestDist = dist
                                    closestTarget = p.Character.HumanoidRootPart
                                end
                            end
                        end
                    end
                end
                
                if closestTarget and math.random(1, 100) <= getgenv().AvalonConfig.HitChance then
                    camera.CFrame = CFrame.new(camera.CFrame.Position, closestTarget.Position)
                end
            end)
        end
    end)
end)

addSlider(tabAimbot, "Skuteczność trafień", 1, 100, function(val)
    getgenv().AvalonConfig.HitChance = val
end)

-- Ukrywanie / pokazywanie okna pod prawym Shiftem
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
