-- Palofsc Script: Nowoczesne czerwono-czarne GUI z cieniem i przyciskiem współrzędnych XYZ
-- Skrypt tworzy nowoczesny interfejs z cieniami, obsługą przełączania pod prawym Shiftem oraz przyciskiem włączającym/wyłączającym wyświetlanie pozycji XYZ w prawym górnym rogu.

local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

if coreGui:FindFirstChild("ModernXYZHub") then
    coreGui.ModernXYZHub:Destroy()
end

-- Główny kontener GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernXYZHub"
ScreenGui.Parent = coreGui

-- Okno główne (Czerwono-czarny motyw z nowoczesnymi proporcjami)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Nowoczesne zaokrąglenie rogów
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Cienie wokół okna (efekt głębi)
local DropShadow = Instance.new("UIStroke")
DropShadow.Color = Color3.fromRGB(220, 20, 60)
DropShadow.Thickness = 2
DropShadow.Parent = MainFrame

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
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "MODERN HUB | XYZ COORDS"
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

-- Kontener na zawartość
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 42)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Widget wyświetlający pozycję w prawym górnym rogu ekranu (domyślnie ukryty)
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

-- Przycisk XYZ w głównym menu
local XYZButton = Instance.new("TextButton")
XYZButton.Size = UDim2.new(1, 0, 0, 45)
XYZButton.Position = UDim2.new(0, 0, 0, 10)
XYZButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
XYZButton.TextColor3 = Color3.fromRGB(255, 255, 255)
XYZButton.Text = "Pokaż / Ukryj Pozycję XYZ (Prawy Górny Róg): [OFF]"
XYZButton.TextSize = 12
XYZButton.Font = Enum.Font.GothamMedium
XYZButton.Parent = ContentFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = XYZButton

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(220, 20, 60)
BtnStroke.Thickness = 1
BtnStroke.Parent = XYZButton

-- Logika włączania/wyłączania wyświetlania koordynatów XYZ
local xyzActive = false
XYZButton.MouseButton1Click:Connect(function()
    xyzActive = not xyzActive
    CoordsDisplay.Visible = xyzActive
    if xyzActive then
        XYZButton.Text = "Pokaż / Ukryj Pozycję XYZ (Prawy Górny Róg): [ON]"
        XYZButton.BackgroundColor3 = Color3.fromRGB(180, 20, 50)
    else
        XYZButton.Text = "Pokaż / Ukryj Pozycję XYZ (Prawy Górny Róg): [OFF]"
        XYZButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)

-- Aktualizacja pozycji gracza w czasie rzeczywistym
runService.RenderStepped:Connect(function()
    if xyzActive then
        pcall(function()
            local char = localPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                CoordsDisplay.Text = string.format("X: %.1f | Y: %.1f | Z: %.1f", pos.X, pos.Y, pos.Z)
            end
        end)
    end
end)

-- Obsługa minimalizowania i przywracania okna za pomocą Prawego Shifta
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
