-- Palofsc Script: Nowoczesne czerwono-czarne GUI z koordynatami XYZ i dedykowanymi teleportami (1, 2, 3)

local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

if coreGui:FindFirstChild("CleanTeleportHub") then
    coreGui.CleanTeleportHub:Destroy()
end

getgenv().HubConfig = {
    XYZVisible = false
}

-- Koordynaty docelowe
local posAngelDevil = Vector3.new(5636, 70.6, -334.3)
local posTitanEgg = Vector3.new(4798.9, 70.6, -331.3)
local posBase = Vector3.new(531.8, 70.6, -243.8)

-- Funkcja bezpiecznego teleportu
local function teleportTo(targetPos)
    pcall(function()
        local char = localPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end)
end

-- Główny kontener GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CleanTeleportHub"
ScreenGui.Parent = coreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
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
TitleLabel.Text = "CLEAN TELEPORT HUB | KEYBINDS"
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

-- Wyświetlacz pozycji XYZ w prawym górnym rogu
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

-- 1. Przycisk XYZ
local XYZButton = createButton("Pokaż / Ukryj Pozycję XYZ: [OFF]", function()
    getgenv().HubConfig.XYZVisible = not getgenv().HubConfig.XYZVisible
    CoordsDisplay.Visible = getgenv().HubConfig.XYZVisible
    if getgenv().HubConfig.XYZVisible then
        XYZButton.Text = "Pokaż / Ukryj Pozycję XYZ: [ON]"
        XYZButton.BackgroundColor3 = Color3.fromRGB(180, 20, 50)
    else
        XYZButton.Text = "Pokaż / Ukryj Pozycję XYZ: [OFF]"
        XYZButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)

-- 2. Guzik Angel / Devil [Keybind: 1]
createButton("Teleport to Angel/Devil [Key: 1]", function()
    teleportTo(posAngelDevil)
end)

-- 3. Guzik Titan Egg [Keybind: 2]
createButton("Teleport to Titan Egg [Key: 2]", function()
    teleportTo(posTitanEgg)
end)

-- 4. Guzik Baza [Keybind: 3]
createButton("Teleport to Base [Key: 3]", function()
    teleportTo(posBase)
end)

-- Obsługa klawiszy (Keybindy 1, 2, 3 oraz prawy Shift)
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    elseif input.KeyCode == Enum.KeyCode.One then
        teleportTo(posAngelDevil)
    elseif input.KeyCode == Enum.KeyCode.Two then
        teleportTo(posTitanEgg)
    elseif input.KeyCode == Enum.KeyCode.Three then
        teleportTo(posBase)
    end
end)

-- Aktualizacja pozycji XYZ w prawym górnym rogu
runService.RenderStepped:Connect(function()
    if getgenv().HubConfig.XYZVisible then
        pcall(function()
            local char = localPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                CoordsDisplay.Text = string.format("X: %.1f | Y: %.1f | Z: %.1f", pos.X, pos.Y, pos.Z)
            end
        end)
    end
end)
