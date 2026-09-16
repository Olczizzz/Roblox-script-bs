-- Usunięcie starego GUI, jeśli już jakieś istniało
local coreGui = game:GetService("CoreGui")
if coreGui:FindFirstChild("StealAnEggHub") then
    coreGui.StealAnEggHub:Destroy()
end

-- Główny kontener GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealAnEggHub"
ScreenGui.Parent = coreGui

-- Główne okno interfejsu
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Pasek górny
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Steal an Egg - Premium Hub"
TitleLabel.TextColor3 = Color3.fromRGB(220, 20, 60)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Menu boczne (zakładki)
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 130, 1, -35)
TabContainer.Position = UDim2.new(0, 0, 0, 35)
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

-- Kontener na zawartość zakładek
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -130, 1, -35)
ContentContainer.Position = UDim2.new(0, 130, 0, 35)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Funkcja pomocnicza do tworzenia przycisków zakładek
local function createTabButton(name, positionIndex)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, 10 + (positionIndex - 1) * 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Text = name
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSans
    btn.Parent = TabContainer
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = btn
    
    return btn
end

local Tab1Btn = createTabButton("Główna", 1)
local Tab2Btn = createTabButton("Gracz", 2)

-- Ramki poszczególnych zakładek
local Tab1Content = Instance.new("ScrollingFrame")
Tab1Content.Size = UDim2.new(1, 0, 1, 0)
Tab1Content.BackgroundTransparency = 1
Tab1Content.Visible = true
Tab1Content.Parent = ContentContainer

local Tab2Content = Instance.new("ScrollingFrame")
Tab2Content.Size = UDim2.new(1, 0, 1, 0)
Tab2Content.BackgroundTransparency = 1
Tab2Content.Visible = false
Tab2Content.Parent = ContentContainer

-- Przełączanie widoczności zakładek
Tab1Btn.MouseButton1Click:Connect(function()
    Tab1Content.Visible = true
    Tab2Content.Visible = false
end)

Tab2Btn.MouseButton1Click:Connect(function()
    Tab1Content.Visible = false
    Tab2Content.Visible = true
end)

-- Treść zakładki "Główna"
local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Size = UDim2.new(0.9, 0, 0, 50)
WelcomeLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text = "Witaj w skrypcie do Steal an Egg!\nWybierz zakładkę po lewej stronie."
WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeLabel.TextSize = 13
WelcomeLabel.Font = Enum.Font.SourceSans
WelcomeLabel.Parent = Tab1Content

-- Treść zakładki "Gracz" – Przycisk ustawiający prędkość na 150
local SpeedButton = Instance.new("TextButton")
SpeedButton.Size = UDim2.new(0.9, 0, 0, 35)
SpeedButton.Position = UDim2.new(0.05, 0, 0.05, 0)
SpeedButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.Text = "Ustaw prędkość (Speed: 150)"
SpeedButton.TextSize = 13
SpeedButton.Font = Enum.Font.SourceSansBold
SpeedButton.Parent = Tab2Content

local speedEnabled = false
SpeedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    local player = game:GetService("Players").LocalPlayer
    
    -- Zabezpieczenie sprawdzające, czypostać i Humanoid istnieją
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        if speedEnabled then
            humanoid.WalkSpeed = 150
            SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Zmiana koloru na zielony (aktywny)
        else
            humanoid.WalkSpeed = 16 -- Domyślna prędkość w Roblox
            SpeedButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0) -- Powrót do czerwonego
        end
    end
end)