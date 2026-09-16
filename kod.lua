-- Umieść ten skrypt w StarterGui jako LocalScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Tworzenie głównego ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoordDisplayGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Tworzenie głównej ramki (tło czarne z czerwoną ramką)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 90)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Ciemnoszary / Czarny
mainFrame.BorderColor3 = Color3.fromRGB(220, 20, 20) -- Czerwona ramka
mainFrame.BorderSizePixel = 2
mainFrame.Parent = screenGui

-- Nagłówek GUI
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(180, 10, 10) -- Czerwone tło nagłówka
titleLabel.BorderSizePixel = 0
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "POZYCJA GRACZA"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

-- Tekst wyświetlający współrzędne
local coordLabel = Instance.new("TextLabel")
coordLabel.Size = UDim2.new(1, -10, 0, 50)
coordLabel.Position = UDim2.new(0, 5, 0, 35)
coordLabel.BackgroundTransparency = 1
coordLabel.Font = Enum.Font.Code
coordLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
coordLabel.TextSize = 14
coordLabel.TextXAlignment = Enum.TextXAlignment.Left
coordLabel.TextYAlignment = Enum.TextYAlignment.Center
coordLabel.TextWrapped = true
coordLabel.Parent = mainFrame

-- Aktualizacja współrzędnych w czasie rzeczywistym
RunService.RenderStepped:Connect(function()
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local pos = character.HumanoidRootPart.Position
		coordLabel.Text = string.format("X: %.1f\nY: %.1f\nZ: %.1f", pos.X, pos.Y, pos.Z)
	else
		coordLabel.Text = "Brak postaci..."
	end
end)
