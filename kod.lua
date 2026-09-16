-- Palofsc Script: AvalonHub dla Blox Strike (Usunięty Aimbot + System Klucza i Discord)
-- Skrypt uruchamia najpierw okienko weryfikacji klucza z linkiem do Discorda, a po poprawnej weryfikacji otwiera główne menu.

local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

if coreGui:FindFirstChild("AvalonHubBloxStrike") then
    coreGui.AvalonHubBloxStrike:Destroy()
end

getgenv().AvalonConfig = {
    Wallhack = false,
    AntiAFK = false,
    CorrectKey = "AVALON2026" -- Twój wygenerowany klucz
}

-- Główny kontener GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AvalonHubBloxStrike"
ScreenGui.Parent = coreGui

-----------------------------------------------------------------
-- 1. OKNO SYSTEMU KLUCZY (KEY SYSTEM & DISCORD)
-----------------------------------------------------------------
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 400, 0, 240)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -120)
KeyFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 6)
KeyCorner.Parent = KeyFrame

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = Color3.fromRGB(200, 20, 40)
KeyStroke.Thickness = 1.5
KeyStroke.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "AVALON HUB - WERYFIKACJA KLUCZA"
KeyTitle.TextColor3 = Color3.fromRGB(220, 30, 50)
KeyTitle.TextSize = 13
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.85, 0, 0, 38)
KeyInput.Position = UDim2.new(0.075, 0, 0.3, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.PlaceholderText = "Wpisz swój klucz tutaj..."
KeyInput.Text = ""
KeyInput.TextSize = 12
KeyInput.Font = Enum.Font.Gotham
KeyInput.Parent = KeyFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 4)
InputCorner.Parent = KeyInput

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.85, 0, 0, 38)
SubmitBtn.Position = UDim2.new(0.075, 0, 0.53, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 40)
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Text = "ZATWIERDŹ KLUCZ"
SubmitBtn.TextSize = 12
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Parent = KeyFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 4)
BtnCorner.Parent = SubmitBtn

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0.85, 0, 0, 32)
DiscordBtn.Position = UDim2.new(0.075, 0, 0.76, 0)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
DiscordBtn.TextColor3 = Color3.fromRGB(150, 160, 255)
DiscordBtn.Text = "Discord: discord.gg/TwojLink"
DiscordBtn.TextSize = 11
DiscordBtn.Font = Enum.Font.GothamMedium
DiscordBtn.Parent = KeyFrame

local DiscCorner = Instance.new("UICorner")
DiscCorner.CornerRadius = UDim.new(0, 4)
DiscCorner.Parent = DiscordBtn

-----------------------------------------------------------------
-- 2. GŁÓWNE OKNO HUBA (UKRYTE DO MOMENTU POPRAWNEGO KLUCZA)
-----------------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 300)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false -- Ukryte na start
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(200, 20, 40)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

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

-- Obsługa weryfikacji klucza
SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == getgenv().AvalonConfig.CorrectKey then
        KeyFrame:Destroy() -- Usuwamy okno klucza
        MainFrame.Visible = true -- Pokazujemy główne menu AvalonHub
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Błędny klucz! Spróbuj ponownie."
    end
end)

-- Przycisk Discord (Kopiowanie linku do schowka, jeśli executor wspiera setclipboard)
DiscordBtn.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/TwojLink")
        DiscordBtn.Text = "Skopiowano link do schowka!"
        task.wait(2)
        DiscordBtn.Text = "Discord: discord.gg/TwojLink"
    end)
end)

-- Tworzenie zakładek w głównym menu (Wallhack oraz Misc/Anti-AFK)
local tabWallhack = createTab("Wallhack", 1)
local tabMisc = createTab("Misc / AFK", 2)

-- 1. Wallhack (ESP)
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

-- 2. Anti-AFK
addToggle(tabMisc, "Anti-AFK", function(state)
    getgenv().AvalonConfig.AntiAFK = state
    task.spawn(function()
        local virtualUser = game:GetService("VirtualUser")
        local connection
        if getgenv().AvalonConfig.AntiAFK then
            connection = localPlayer.Idled:Connect(function()
                if getgenv().AvalonConfig.AntiAFK then
                    virtualUser:Button2Down(Vector2.new(0,0), camera.CFrame)
                    task.wait(1)
                    virtualUser:Button2Up(Vector2.new(0,0), camera.CFrame)
                end
            end)
        end
        while getgenv().AvalonConfig.AntiAFK do
            task.wait(60)
            if not getgenv().AvalonConfig.AntiAFK and connection then
                connection:Disconnect()
                break
            end
        end
    end)
end)

-- Ukrywanie / pokazywanie głównego okna pod prawym Shiftem
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        if MainFrame.Visible then
            MainFrame.Visible = false
        else
            MainFrame.Visible = true
        end
    end
end)
