local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local highlightColor = Color3.fromRGB(255, 0, 0) -- Highlight color
local highlights = {} -- Store active highlights
local highlightingEnabled = false -- Toggle state

-- Function to create notification text
local function createNotification(text)
    local screenGui = Instance.new("ScreenGui")
    local label = Instance.new("TextLabel")

    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false

    label.Parent = screenGui
    label.Size = UDim2.new(0, 200, 0, 50)
    label.Position = UDim2.new(0.5, -100, 0.5, -25)
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.BackgroundTransparency = 0.5
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = text
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans

    local tween = TweenService:Create(label, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1, TextTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

-- Function to highlight a player
local function highlightPlayer(player)
    if player.Character and not highlights[player] then
        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character
        highlight.FillColor = highlightColor
        highlight.OutlineColor = highlightColor
        highlights[player] = highlight
    end
end

-- Function to remove highlight from a player
local function removeHighlight(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

-- Toggle highlighting with the "Z" key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Z then
        highlightingEnabled = not highlightingEnabled
        if not highlightingEnabled then
            for _, highlight in pairs(highlights) do
                highlight:Destroy()
            end
            highlights = {}
            createNotification("Highlighting Disabled")
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    highlightPlayer(player)
                end
            end
            createNotification("Highlighting Enabled")
        end
    end
end)

-- Highlight players when they join
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if highlightingEnabled then
            highlightPlayer(player)
        end
    end)
end)

-- Remove highlight when players leave
Players.PlayerRemoving:Connect(function(player)
    removeHighlight(player)
end)
