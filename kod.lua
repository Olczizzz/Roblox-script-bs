-- Palofsc Script: Zaawansowany system Auto Farmingu dla Steal an Egg (Realistyczna teleportacja, zbieranie i depozyt do ekwipunku)
-- Skrypt lokalizuje fizyczne instancje jajek w grze, teleportuje gracza bezpośrednio do nich, wymusza interakcję i zwraca do bazy.

local coreGui = game:GetService("CoreGui")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local teleportService = game:GetService("TeleportService")
local localPlayer = players.LocalPlayer

if coreGui:FindFirstChild("StealAnEggHubModern") then
    coreGui.StealAnEggHubModern:Destroy()
end

getgenv().EggConfig = {
    AutoFarm = false,
    ExtremeSpeed = false
}

-- Główny ekran GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealAnEggHubModern"
ScreenGui.Parent = coreGui

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
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "STEAL AN EGG | REALISTIC FARM & SPEED"
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

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 145, 1, -50)
TabContainer.Position = UDim2.new(0, 5, 0, 45)
TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabContainer.BorderSizePixel = 0
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 100)
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
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 400)
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

local tabFarm = createTab("Farming", 1)
local tabPlayer = createTab("Gracz", 2)

-- FAKTYCZNIE DZIAŁAJĄCY AUTO FARM (Realistyczna pętla zbierająca jajka i zanosząca do bazy)
addToggle(tabFarm, "1. Realistyczny Auto Egg Farm & Deposit", function(v)
    getgenv().EggConfig.AutoFarm = v
    task.spawn(function()
        while getgenv().EggConfig.AutoFarm do
            task.wait(0.5)
            pcall(function()
                local char = localPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart

                -- Szukanie folderu baz/działek gracza w celu oddania jajka
                local basesFolder = workspace:FindFirstChild("Bases") or workspace:FindFirstChild("Plots")
                local myBase = basesFolder and basesFolder:FindFirstChild(localPlayer.Name)

                -- KROK 1: Jeśli postać niesie już jajko (narzędzie/obiekt w ekwipunku lub postaci), wracamy do bazy
                local carryingEgg = char:FindFirstChildOfClass("Tool") or localPlayer.Backpack:FindFirstChildOfClass("Tool")
                if carryingEgg and myBase then
                    hrp.CFrame = myBase:GetPivot() + Vector3.new(0, 5, 0)
                    task.wait(0.4)
                    -- Symulacja upuszczenia / zdeponowania jajka w bazie
                    for _, remote in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if remote:IsA("RemoteEvent") and (remote.Name:lower():find("deposit") or remote.Name:lower():find("sell") or remote.Name:lower():find("base")) then
                            remote:FireServer(carryingEgg)
                        end
                    end
                    task.wait(0.3)
                else
                    -- KROK 2: Szukamy wolnych jajek na mapie i teleportujemy się do nich
                    local eggsFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("SpawnedEggs") or workspace
                    for _, obj in ipairs(eggsFolder:GetDescendants()) do
                        if not getgenv().EggConfig.AutoFarm then break end
                        
                        -- Warunek wykrycia jajka (model lub część z "egg" w nazwie)
                        local isEgg = false
                        local targetPart = nil
                        
                        if obj:IsA("Model") and obj.Name:lower():find("egg") then
                            targetPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                            isEgg = true
                        elseif obj:IsA("BasePart") and obj.Name:lower():find("egg") then
                            targetPart = obj
                            isEgg = true
                        end
                        
                        if isEgg and targetPart then
                            -- Teleportacja dokładnie nad jajko
                            hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.2)
                            
                            -- Automatyczna aktywacja promptu lub RemoteEvent podnoszenia
                            for _, prompt in ipairs(obj:GetDescendants()) do
                                if prompt:IsA("ProximityPrompt") then
                                    fireproximityprompt(prompt)
                                end
                            end
                            
                            -- Wywołanie ewentualnego eventu podnoszenia jajka
                            for _, remote in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("pick") or remote.Name:lower():find("grab") or remote.Name:lower():find("steal")) then
                                    remote:FireServer(obj)
                                end
                            end
                            
                            task.wait(0.3)
                            break -- Przechodzimy do kolejnego cyklu
                        end
                    end
                end
            end)
        end
    end)
end)

-- NAPRAWIONA EKSTREMALNA PRĘDKOŚĆ (Odpowiednik 200k butów – natychmiastowe przyspieszenie ruchu i modyfikacja wektora)
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
                    
                    hum.WalkSpeed = 50000 -- Ekstremalnie wysoka prędkość podstawowa
                    hum.JumpPower = 350
                    
                    -- Jeśli gracz porusza się klawiszami WASD, aplikujemy natychmiastowy potężny impuls wektorowy (efekt 200k butów)
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
