-- Palofsc Script: Steal an Egg - Custom Farming & Teleports (Angel/Devil & Titan Temple)
-- Skrypt dodaje dedykowane przyciski i funkcje automatycznego farmingu dla ostatnich krain oraz baz w oparciu o dostarczone koordynaty.

local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

if coreGui:FindFirstChild("ModernXYZHub") then
    coreGui.ModernXYZHub:Destroy()
end

getgenv().FarmConfig = {
    AngelDevilFarm = false,
    TitanTempleFarm = false,
    XYZVisible = false
}

-- Koordynaty baz
local basesCoords = {
    Vector3.new(531.8, 70.6, -243.8),
    Vector3.new(463.8, 70.6, -244.5),
    Vector3.new(468.6, 70.6, -298.1),
    Vector3.new(444.1, 70.6, -359.1),
    Vector3.new(451.5, 70.6, -421.5),
    Vector3.new(460.3, 70.6, -476.1),
    Vector3.new(510.9, 70.6, -474.5)
}

-- Koordynaty jajek
local angelDevilEgg = Vector3.new(5636, 70.6, -334.3)
local titanEggs = {
    Vector3.new(4798.9, 70.6, -331.3),
    Vector3.new(4804.6, 70.6, -328.4),
    Vector3.new(4801.1, 70.6, -326.8),
    Vector3.new(4788.3, 70.6, -328.2)
}

-- Funkcja zwracająca najbliższą bazę
local function getClosestBase()
    local char = localPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return basesCoords[1] end
    local hrpPos = char.HumanoidRootPart.Position
    local closest = basesCoords[1]
    local minDist = math.huge
    for _, pos in ipairs(basesCoords) do
        local dist = (hrpPos - pos).Magnitude
        if dist < minDist then
            minDist = dist
            closest = pos
        end
    end
    return closest
end

-- Symulacja przytrzymania przycisku E / zbierania (2 sekundy)
local function simulateEggCollection()
    task.wait(2)
end

-- Główny kontener GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernXYZHub"
ScreenGui.Parent = coreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 380)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local DropShadow = Instance.new("UIStroke")
DropShadow.Color = Color3.fromRGB(220, 20, 60)
DropShadow.Thickness = 2
DropShadow.Parent = MainFrame

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
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "STEAL AN EGG | CUSTOM FARM & XYZ"
TitleLabel.TextColor3 = Color3.fromRGB(230, 30, 60)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local HintLabel = Instance.new("TextLabel")
HintLabel.Size = UDim2.new(1, -20, 1, 0)
HintLabel.BackgroundTransparency = 1
HintLabel.Text = "[Prawy Shift: Ukryj]"
HintLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
HintLabel.TextSize = 11
HintLabel.Font = Enum.Font.Gotham
HintLabel.TextXAlignment = Enum.TextXAlignment.Right
HintLabel.Parent = TopBar

-- Widget XYZ w prawym górnym rogu
local CoordsDisplay = Instance.new("TextLabel")
CoordsDisplay.Size = UDim2.new(0, 220, 0, 35)
CoordsDisplay.Position = UDim2.new(1, -230, 0, 15)
CoordsDisplay.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
CoordsDisplay.TextColor3 = Color3.fromRGB(0, 255, 120)
CoordsDisplay.TextSize = 13
CoordsDisplay.Font = Enum.Font.GothamBold
CoordsDisplay.Text = "X: 0 | Y: 0 | Z: 0"
CoordsDisplay.Visible = false
CoordsDisplay.Parent = ScreenGui

local CoordsCorner = Instance.new("UICorner")
CoordsCorner.CornerRadius = UDim.new(0, 6)
CoordsCorner.Parent = CoordsDisplay

local CoordsStroke = Instance.new("UIStroke")
CoordsStroke.Color = Color3.fromRGB(220, 20, 60)
CoordsStroke.Thickness = 1.5
CoordsStroke.Parent = CoordsDisplay

-- Zawartość interfejsu (przyciski)
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 42)
ContentFrame.BackgroundTransparency = 1
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 250)
ContentFrame.ScrollBarThickness = 4
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ContentFrame

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = ContentFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(220, 20, 60)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 1. Przycisk XYZ
local XYZButton = createButton("Pokaż / Ukryj Pozycję XYZ: [OFF]", function()
    getgenv().FarmConfig.XYZVisible = not getgenv().FarmConfig.XYZVisible
    CoordsDisplay.Visible = getgenv().FarmConfig.XYZVisible
    if getgenv().FarmConfig.XYZVisible then
        XYZButton.Text = "Pokaż / Ukryj Pozycję XYZ: [ON]"
        XYZButton.BackgroundColor3 = Color3.fromRGB(180, 20, 50)
    else
        XYZButton.Text = "Pokaż / Ukryj Pozycję XYZ: [OFF]"
        XYZButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)

-- 2. Angel/Devil Farm Toggle
createButton("Angel/Devil Farm (Ostatnia Kraina -> Baza)", function()
    getgenv().FarmConfig.AngelDevilFarm = not getgenv().FarmConfig.AngelDevilFarm
    task.spawn(function()
        while getgenv().FarmConfig.AngelDevilFarm do
            task.wait(0.5)
            pcall(function()
                local char = localPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart

                -- Teleport do jajka Angel/Devil
                hrp.CFrame = CFrame.new(angelDevilEgg)
                simulateEggCollection()

                -- Teleport do bazy
                local targetBase = getClosestBase()
                hrp.CFrame = CFrame.new(targetBase)
                task.wait(1)
            end)
        end
    end)
end)

-- 3. Titan Temple Farm Toggle (Przedostatnia kraina)
createButton("Titan Temple Farm (Przedostatnia Kraina -> Baza)", function()
    getgenv().FarmConfig.TitanTempleFarm = not getgenv().FarmConfig.TitanTempleFarm
    task.spawn(function()
        while getgenv().FarmConfig.TitanTempleFarm do
            task.wait(0.5)
            pcall(function()
                local char = localPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart

                -- Pętla po wszystkich jajkach Titan Temple
                for _, eggPos in ipairs(titanEggs) do
                    if not getgenv().FarmConfig.TitanTempleFarm then break end
                    hrp.CFrame = CFrame.new(eggPos)
                    simulateEggCollection()

                    local targetBase = getClosestBase()
                    hrp.CFrame = CFrame.new(targetBase)
                    task.wait(1)
                end
            end)
        end
    end)
end)

-- Aktualizacja koordynatów XYZ w prawym górnym rogu
runService.RenderStepped:Connect(function()
    if getgenv().FarmConfig.XYZVisible then
        pcall(function()
            local char = localPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                CoordsDisplay.Text = string.format("X: %.1f | Y: %.1f | Z: %.1f", pos.X, pos.Y, pos.Z)
            end
        end)
    end
end)

-- Obsługa prawego Shifta do ukrywania/pokazywania okna
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
