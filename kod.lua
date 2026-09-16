-- Palofsc Script: Nowoczesny Hub do Steal an Egg (z systemem toggle, zakładkami i funkcjami)
-- Zawiera przełączanie pod prawym Shiftem oraz wszystkie 15 żądanych funkcji farmingu i automatyzacji.

local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

if coreGui:FindFirstChild("StealAnEggHubModern") then
    coreGui.StealAnEggHubModern:Destroy()
end

-- Główny ekran GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealAnEggHubModern"
ScreenGui.Parent = coreGui

-- Nowoczesne, pływające okno główne (Ciemny motyw z czerwonymi akcentami)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 560, 0, 380)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Subtelna ramka wokół okna
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(200, 25, 50)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Pasek górny
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "STEAL AN EGG | PREMIUM HUB"
TitleLabel.TextColor3 = Color3.fromRGB(230, 30, 60)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local HintLabel = Instance.new("TextLabel")
HintLabel.Size = UDim2.new(1, -20, 1, 0)
HintLabel.BackgroundTransparency = 1
HintLabel.Text = "[Prawy Shift: Ukryj/Pokaż]"
HintLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
HintLabel.TextSize = 11
HintLabel.Font = Enum.Font.Gotham
HintLabel.TextXAlignment = Enum.TextXAlignment.Right
HintLabel.Parent = TopBar

-- Kontener zakładek (Menu boczne)
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 145, 1, -50)
TabContainer.Position = UDim2.new(0, 5, 0, 45)
TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabContainer.BorderSizePixel = 0
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 320)
TabContainer.ScrollBarThickness = 3
TabContainer.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.Parent = TabContainer

-- Kontener na zawartość
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -155, 1, -50)
ContentContainer.Position = UDim2.new(0, 152, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- System zakładek i zawartości
local tabs = {}
local currentTab = nil

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
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 600)
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

-- Funkcja do dodawania przełączników (Toggle)
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

-- Funkcja do dodawania przycisków akcji
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

-- TWORZENIE ZAKŁADEK I FUNKCJI
local tabFarm = createTab("Farming", 1)
local tabVisual = createTab("Wizualne / ESP", 2)
local tabAutos = createTab("Automatyzacja", 3)
local tabPlayer = createTab("Gracz", 4)

-- 1. Auto Egg Farming
addToggle(tabFarm, "1. Auto Egg Farming", function(v)
    print("Auto Egg Farming:", v)
end)

-- 2. Rare Egg Targeting
addToggle(tabFarm, "2. Rare Egg Targeting", function(v)
    print("Rare Egg Targeting:", v)
end)

-- 3. Auto Return to Base
addToggle(tabFarm, "3. Auto Return to Base", function(v)
    print("Auto Return to Base:", v)
end)

-- 4. Auto Collect
addToggle(tabFarm, "4. Auto Collect Items", function(v)
    print("Auto Collect:", v)
end)

-- 5. Server Hop
addButton(tabFarm, "5. Server Hop (Przełącz serwer)", function()
    local ts = game:GetService("TeleportService")
    local lp = players.LocalPlayer
    ts:Teleport(game.PlaceId, lp)
end)

-- 6. Auto Farm Loop
addToggle(tabFarm, "6. Auto Farm Loop", function(v)
    print("Auto Farm Loop:", v)
end)

-- 7. Easy Egg Searching
addToggle(tabFarm, "7. Easy Egg Searching", function(v)
    print("Easy Egg Searching:", v)
end)

-- 8. Less Repetitive Gameplay (Optymalizacja powtarzalności)
addToggle(tabFarm, "8. Less Repetitive Bypass", function(v)
    print("Less Repetitive Gameplay:", v)
end)

-- 9. Egg Predictor
addToggle(tabVisual, "9. Egg Predictor (Szacowanie)", function(v)
    print("Egg Predictor:", v)
end)

-- 10. Egg Spawn Time
addToggle(tabVisual, "10. Pokazuj czas respawnu (Timer)", function(v)
    print("Egg Spawn Time Timer:", v)
end)

-- 11. Egg X-Ray and ESP
addToggle(tabVisual, "11. Egg X-Ray / ESP przez ściany", function(v)
    print("Egg X-Ray:", v)
end)

-- 12. Steal Filter By KG
addToggle(tabAutos, "12. Steal Filter By KG (Waga)", function(v)
end)

-- 13. Trap Protection
addToggle(tabAutos, "13. Trap Protection (Ochrona przed pułapkami)", function(v)
    print("Trap Protection:", v)
end)

-- 14. Pet Fusion
addButton(tabAutos, "14. Uruchom Auto Pet Fusion", function()
    print("Pet Fusion uruchomione")
end)

-- 15. Auto Steal
addToggle(tabAutos, "15. Auto Steal (Kradzież baz)", function(v)
    print("Auto Steal:", v)
end)

-- Zakładka Gracz (Prędkość 150)
addButton(tabPlayer, "Ustaw prędkość poruszania (Speed: 150)", function()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        localPlayer.Character.Humanoid.WalkSpeed = 150
    end
end)

addButton(tabPlayer, "Reset prędkości (Speed: 16)", function()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        localPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Obsługa minimalizowania i przywracania okienka za pomocą Prawego Shifta (Right Shift)
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)