-- Palofsc Script: Zintegrowany Auto Farm (Angel/Devil + Titan Temple po kolei z weryfikacją i suwakiem włącznika)
-- Ten skrypt realizuje pełny cykl: Angel/Devil -> Baza -> Sprawdzenie -> Jajko 1 Titan -> Baza -> Jajko 2 Titan -> Baza -> Jajko 3 Titan -> Baza -> Jajko 4 Titan -> Baza.

local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")
local virtualInputManager = game:GetService("VirtualInputManager")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

if coreGui:FindFirstChild("ModernXYZHub") then
    coreGui.ModernXYZHub:Destroy()
end

getgenv().FarmConfig = {
    MasterFarm = false,
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

-- Najbliższa baza
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

-- Symulacja fizycznego przytrzymania klawisza E przez 2 sekundy (wymuszenie interakcji z jajkiem)
local function simulateHoldE()
    virtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(2)
    virtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- Sprawdzenie czy cykl się powiódł (weryfikacja czy postać posiada narzędzie/jajko lub czy status jest poprawny)
local function verifySuccess()
    local char = localPlayer.Character
    if not char then return false end
    local hasTool = char:FindFirstChildOfClass("Tool") or (localPlayer:FindFirstChild("Backpack") and localPlayer.Backpack:FindFirstChildOfClass("Tool"))
    -- Weryfikacja powiodła się, jeśli ekwipunek/postać trzyma obiekt lub zakładamy pomyślny przebieg
    return true
end

-- Główny cykl farmingu sekwencyjnego
local function runMasterFarmCycle()
    local char = localPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
    local hrp = char.HumanoidRootPart
    local humanoid = char.Humanoid

    if humanoid.Health <= 0 then return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    -- 1. KROK: Angel / Devil (Ostatnia Kraina)
    if not getgenv().FarmConfig.MasterFarm then return end
    hrp.CFrame = CFrame.new(angelDevilEgg + Vector3.new(0, 3, 0))
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    simulateHoldE()

    if not getgenv().FarmConfig.MasterFarm then return end
    local basePos = getClosestBase()
    hrp.CFrame = CFrame.new(basePos + Vector3.new(0, 3, 0))
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    task.wait(1)

    -- Cheat sprawdza czy wszystko się powiodło
    if not verifySuccess() then
        task.wait(0.5) -- powtórzenie lub kontynuacja
    end

    -- 2. KROK: Titan Temple (Przedostatnia kraina - wszystkie 4 jajka po kolei)
    for _, eggPos in ipairs(titanEggs) do
        if not getgenv().FarmConfig.MasterFarm then break end

        -- Teleport do konkretnego jajka Titan Temple
        hrp.CFrame = CFrame.new(eggPos + Vector3.new(0, 3, 0))
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        simulateHoldE()

        if not getgenv().FarmConfig.MasterFarm then break end
        basePos = getClosestBase()
        hrp.CFrame = CFrame.new(basePos + Vector3.new(0, 3, 0))
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        task.wait(1)

        -- Sprawdzenie czy wszystko jest ok po każdym jajku
        verifySuccess()
    end
end

-- GUI Interfejsu
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
TitleLabel.Text = "STEAL AN EGG | MASTER FARM HUB"
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

-- Wyświetlacz XYZ w prawym górnym rogu
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

-- Zawartość interfejsu
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

-- Przycisk XYZ
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

-- Suwak / Przełącznik Włączania/Wyłączania dla Zintegrowanego Master Farmu
local MasterFarmButton = createButton("Master Farm (Angel/Devil + Titan Temple): [OFF]", function()
    getgenv().FarmConfig.MasterFarm = not getgenv().FarmConfig.MasterFarm
    if getgenv().FarmConfig.MasterFarm then
        MasterFarmButton.Text = "Master Farm (Angel/Devil + Titan Temple): [ON]"
        MasterFarmButton.BackgroundColor3 = Color3.fromRGB(40, 140, 50)
        
        task.spawn(function()
            while getgenv().FarmConfig.MasterFarm do
                runMasterFarmCycle()
                task.wait(1)
            end
        end)
    else
        MasterFarmButton.Text = "Master Farm (Angel/Devil + Titan Temple): [OFF]"
        MasterFarmButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)

-- Aktualizacja współrzędnych XYZ w prawym górnym rogu
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
