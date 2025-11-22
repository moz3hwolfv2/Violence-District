local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua"))()

local Window = Luna:CreateWindow({
    Name = "Violence District",
    Subtitle = "v1.1",
    LogoID = "82795327169782",
    LoadingEnabled = true,
    LoadingTitle = "Violence District",
    LoadingSubtitle = "Loading",
    ConfigSettings = {
        ConfigFolder = "District Folder"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Violence District",
        Subtitle = "Key System",
        SaveKey = true,
        Key = {"VDSCRIPT17O3N6"},
        SecondAction = {
            Enabled = true,
            Type = "Link",
            Parameter = "https://direct-link.net/1337281/TUa4hgYBUxWQ"
        }
    }
})

Window:CreateHomeTab({
    SupportedExecutors = {
        "Krnl",
        "Fluxus",
        "JJSploit",
        "WEAREDEVS",
        "Wave",
        "CODex",
        "Delta",
        "ArceusX"
    },
    DiscordInvite = "No Available Link",
    Icon = 1
})

local Visuals = Window:CreateTab({
    Name = "Visuals",
    Icon = "visibility",
    ImageSource = "Material",
    ShowTitle = true
})

local PlayerTab = Window:CreateTab({
    Name = "Player",
    Icon = "person",
    ImageSource = "Material",
    ShowTitle = true
})

local Misc = Window:CreateTab({
    Name = "Misc",
    Icon = "settings",
    ImageSource = "Material",
    ShowTitle = true
})

local ThemeTab = Window:CreateTab({
    Name = "Theme",
    Icon = "palette"
})
ThemeTab:BuildThemeSection()

local ConfigTab = Window:CreateTab({
    Name = "Config",
    Icon = "settings"
})
ConfigTab:BuildConfigSection()

local function getKillerModel()
    for _, plr in pairs(Players:GetPlayers()) do
        if tostring(plr.Team) == "Killer" and plr.Character then
            return plr.Character
        end
    end
end

Visuals:CreateSection("Killer Highlights")
Visuals:CreateToggle({
    Name = "Killer Chams",
    CurrentValue = false,
    Callback = function(state) _G.killers = state end
})

local killerHighlight = nil

RunService.Heartbeat:Connect(function()
    local lpChar = LocalPlayer.Character
    if not lpChar or not lpChar:FindFirstChild("HumanoidRootPart") then return end

    local killer = getKillerModel()
    if killer and killer:FindFirstChild("HumanoidRootPart") then
        if _G.killers then
            if not killerHighlight or not killerHighlight.Parent then
                if killerHighlight then killerHighlight:Destroy() end
                killerHighlight = Instance.new("Highlight")
                killerHighlight.Name = "NXP_Highlight"
                killerHighlight.FillColor = Color3.fromRGB(255,0,0)
                killerHighlight.OutlineColor = Color3.fromRGB(0,0,0)
                killerHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                killerHighlight.Parent = killer
            end
        else
            if killerHighlight then
                killerHighlight:Destroy()
                killerHighlight = nil
            end
        end
    else
        if killerHighlight then
            killerHighlight:Destroy()
            killerHighlight = nil
        end
    end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if not checkcaller() then
        if _G.antiFail and tostring(self) == "SkillCheckResultEvent" then return end
        if _G.antiHealFail and tostring(self) == "HealingSkillCheckResultEvent" then return end
    end
    return oldNamecall(self, ...)
end)

PlayerTab:CreateSection("Anti Fail")
PlayerTab:CreateToggle({
    Name = "Anti Generator Fail",
    CurrentValue = false,
    Callback = function(state) _G.antiFail = state end
})
PlayerTab:CreateToggle({
    Name = "Anti Heal Fail",
    CurrentValue = false,
    Callback = function(state) _G.antiHealFail = state end
})

local SpeedValue = 13.4
local sliderObj, inputObj

sliderObj = PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {1, 20},
    Increment = 0.1,
    CurrentValue = SpeedValue,
    Callback = function(val)
        SpeedValue = math.clamp(val, 1, 20)
        if inputObj and inputObj.Set then
            pcall(function() inputObj:Set(tostring(SpeedValue)) end)
        end
        if _G.speed then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = SpeedValue end
        end
    end
})

inputObj = PlayerTab:CreateInput({
    Name = "Set Speed",
    PlaceholderText = "Enter speed (1-20) and press Enter",
    Numeric = true,
    CurrentValue = tostring(SpeedValue),
    Enter = true,
    Callback = function(txt)
        local num = tonumber(txt)
        if num then
            num = math.clamp(num, 1, 20)
            SpeedValue = num
            if sliderObj and sliderObj.Set then
                pcall(function() sliderObj:Set(SpeedValue) end)
            end
            if _G.speed then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then hum.WalkSpeed = SpeedValue end
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Speed Toggle",
    CurrentValue = false,
    Callback = function(state)
        _G.speed = state
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            if state then
                humanoid.WalkSpeed = SpeedValue
            else
                humanoid.WalkSpeed = 16
            end
        end
    end
})

_G.allowJump = false
local originalJumpPower = 50
Misc:CreateToggle({
    Name = "Allow Jump",
    CurrentValue = _G.allowJump,
    Callback = function(state)
        _G.allowJump = state
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = (_G.allowJump and 50 or 0)
        end
    end
})

Misc:CreateSection("")
Misc:CreateButton({ Name = "No Fog", Callback = function()
    for _,v in pairs(game.Lighting:GetDescendants()) do if v:IsA("Atmosphere") then v:Destroy() end end
    game.Lighting.FogEnd = 999999
end})

Misc:CreateSection("Reset")
Misc:CreateButton({
    Name = "Self Sacrifice",
    Callback = function()
        if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
    end
})

Misc:CreateSection("")
Misc:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})
