--[[ 
    Galactic Hub | WindUI
    Made by RealYoGalactic
    Key System: 1234
]]--

local WindUI

-- Load WindUI
do
    local ok, result = pcall(function()
        return require("./src/Init") -- Local load
    end)

    if ok then
        WindUI = result
    else
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
    end
end

-- Create Window
local Window = WindUI:CreateWindow({
    Title = "Galactic Hub",
    Author = "RealYoGalactic",
    Folder = "galactichub",
    Icon = "sfsymbols:appleLogo",
    NewElements = true,

    OpenButton = {
        Title = "Open Galactic Hub",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(Color3.fromHex("#30FF6A"), Color3.fromHex("#e7ff2f"))
    },

    KeySystem = {
        Title = "Key System",
        Note = "Enter the key to access the hub (Key: 1234)",
        KeyValidator = function(key)
            return key == "1234"
        end
    }
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ===== Main Tab =====
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "game-controller"
})

-- ESP toggles
local ESPEnabled = false
local BoxESP = true
local NameESP = true
local TracerESP = true
local ESPColor = Color3.fromRGB(255,0,0)

MainTab:Toggle({
    Title = "Enable ESP",
    Callback = function(state)
        ESPEnabled = state
    end
})

MainTab:Toggle({
    Title = "Box ESP",
    Default = true,
    Callback = function(state)
        BoxESP = state
    end
})

MainTab:Toggle({
    Title = "Name ESP",
    Default = true,
    Callback = function(state)
        NameESP = state
    end
})

MainTab:Toggle({
    Title = "Tracer ESP",
    Default = true,
    Callback = function(state)
        TracerESP = state
    end
})

MainTab:Colorpicker({
    Title = "ESP Color",
    Default = ESPColor,
    Callback = function(color)
        ESPColor = color
    end
})

-- ===== Visuals Tab =====
local VisualTab = Window:Tab({
    Title = "Visuals",
    Icon = "eye"
})

VisualTab:Colorpicker({
    Title = "ESP Color",
    Default = ESPColor,
    Callback = function(color)
        ESPColor = color
    end
})

-- ===== Movement Tab =====
local MovementTab = Window:Tab({
    Title = "Movement",
    Icon = "figure.walk"
})

-- Variables
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local InfiniteJumpEnabled = false
local SpeedValue = 16 -- Default walk speed

-- Walk Speed Slider
MovementTab:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 25, Default = 16 },
    Step = 1,
    Callback = function(value)
        SpeedValue = value
        if Humanoid then
            Humanoid.WalkSpeed = SpeedValue
        end
    end
})

-- Infinite Jump Toggle
MovementTab:Toggle({
    Title = "Infinite Jump",
    Callback = function(state)
        InfiniteJumpEnabled = state
    end
})

-- Apply Humanoid properties
Humanoid.WalkSpeed = SpeedValue

-- Infinite Jump Logic
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ===== Config Tab =====
local ConfigTab = Window:Tab({
    Title = "Config",
    Icon = "folder"
})

local ConfigManager = Window.ConfigManager
local ConfigName = "default"

ConfigTab:Input({
    Title = "Config Name",
    Icon = "file-cog",
    Callback = function(value)
        ConfigName = value
    end
})

ConfigTab:Button({
    Title = "Save Config",
    Callback = function()
        local cfg = ConfigManager:CreateConfig(ConfigName)
        if cfg:Save() then
            WindUI:Notify({
                Title = "Config Saved",
                Desc = "Config '"..ConfigName.."' saved!",
                Icon = "check"
            })
        end
    end
})

ConfigTab:Button({
    Title = "Load Config",
    Callback = function()
        local cfg = ConfigManager:CreateConfig(ConfigName)
        if cfg:Load() then
            WindUI:Notify({
                Title = "Config Loaded",
                Desc = "Config '"..ConfigName.."' loaded!",
                Icon = "refresh-cw"
            })
        end
    end
})

-- ===== Updates Tab =====
local UpdatesTab = Window:Tab({
    Title = "Updates",
    Icon = "sparkles"
})

UpdatesTab:Section({
    Title = "Latest Update",
    TextSize = 20
})

UpdatesTab:Paragraph({
    Title = "GALACTIC HUB RELEASE",
    Desc = "Includes ESP, Infinite Jump, Walk Speed up to 25, and more coming soon!",
})

-- ===== About Tab =====
local AboutTab = Window:Tab({
    Title = "About",
    Icon = "info"
})

AboutTab:Section({
    Title = "About Galactic Hub",
    TextSize = 18
})

AboutTab:Paragraph({
    Title = "Galactic Hub",
    Desc = [[Galactic Hub is a Roblox GUI hub built with WindUI.
Developed by RealYoGalactic.
Includes: Main tools (ESP, Highlights), Visual customization, Movement (Speed & Infinite Jump), Config management, and Updates tab.]],
})

-- ===== ESP Logic =====
local function createESP(plr)
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = plr.Character.HumanoidRootPart

    -- Remove old ESP
    if root:FindFirstChild("ESPFolder") then
        root.ESPFolder:Destroy()
    end

    local folder = Instance.new("Folder")
    folder.Name = "ESPFolder"
    folder.Parent = root

    if BoxESP then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "BoxESP"
        box.Adornee = root
        box.Size = Vector3.new(2,5,1)
        box.Color3 = ESPColor
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Parent = folder
    end

    if NameESP then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "NameESP"
        billboard.Size = UDim2.new(0,100,0,50)
        billboard.Adornee = root
        billboard.AlwaysOnTop = true

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextColor3 = ESPColor
        label.Text = plr.Name
        label.Font = Enum.Font.SourceSansBold
        label.TextScaled = true
        label.Parent = billboard

        billboard.Parent = folder
    end

    if TracerESP then
        local tracer = Instance.new("LineHandleAdornment")
        tracer.Name = "TracerESP"
        tracer.Adornee = root
        tracer.Color3 = ESPColor
        tracer.AlwaysOnTop = true
        tracer.Length = (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        tracer.Thickness = 0.05
        tracer.Parent = folder
    end
end

RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                createESP(plr)
            end
        end
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local root = plr.Character.HumanoidRootPart
                if root:FindFirstChild("ESPFolder") then
                    root.ESPFolder:Destroy()
                end
            end
        end
    end
end)
