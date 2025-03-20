-- Created by Jay/9lokk , @glocclover on ig
-- left ctrl to hide
-- 🌟 UI Library (Creates the GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

-- 📌 UI Frame (Draggable)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 180)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BackgroundTransparency = 0.5  -- Added transparency for cleaner look
Frame.BorderSizePixel = 2
Frame.Active = true
Frame.Draggable = false  -- Disable default draggable functionality

-- 🌟 UI Tweening
local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- 🏷️ Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Text = "RGB ESP by 9lokk"  -- Updated title
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- 🌟 Adding Rounded Corners to the Frame
local frameCorner = Instance.new("UICorner", Frame)
frameCorner.CornerRadius = UDim.new(0, 10)  -- Round the corners

-- 🟠 Close Button (X in Top-Right Corner)
local closeButton = Instance.new("TextButton", Frame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundTransparency = 1  -- No background for the close button
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.TextStrokeTransparency = 0

closeButton.MouseButton1Click:Connect(function()
    Frame.Visible = false  -- Hide the frame (effectively "closing" the GUI)
end)

-- 🌟 Adding Rounded Corners to the Close Button
local closeButtonCorner = Instance.new("UICorner", closeButton)
closeButtonCorner.CornerRadius = UDim.new(0, 5)  -- Round the corners of the button

-- 🌟 UI Toggle with Right Ctrl
local UIS = game:GetService("UserInputService")
local guiVisible = true

UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessed then
        guiVisible = not guiVisible
        local goal = { Position = guiVisible and UDim2.new(0, 10, 0, 10) or UDim2.new(0, -220, 0, 10) }
        local tween = TweenService:Create(Frame, tweenInfo, goal)
        tween:Play()
    end
end)

-- 🌟 ESP Toggle Variables
local ESPSettings = {
    NameESP = true,
    WeaponESP = true,
    BodyOutline = true
}

-- 🔥 Function to Create ESP Elements for a Character
local function applyESP(character, player)
    if not character:FindFirstChild("HumanoidRootPart") then return end

    -- 🏷️ Name ESP (BillboardGui)
    local billboard = Instance.new("BillboardGui", character)
    billboard.Name = "ESP_Name"
    billboard.Size = UDim2.new(4, 0, 1, 0)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = character:FindFirstChild("HumanoidRootPart")
    billboard.AlwaysOnTop = true
    billboard.Enabled = ESPSettings.NameESP

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextStrokeTransparency = 0
    label.TextColor3 = Color3.new(1, 1, 1)

    -- 🔫 Weapon ESP
    local weaponESP = Instance.new("BillboardGui", character)
    weaponESP.Name = "ESP_Weapon"
    weaponESP.Size = UDim2.new(3, 0, 0.5, 0)
    weaponESP.StudsOffset = Vector3.new(0, 2, 0)
    weaponESP.Adornee = character:FindFirstChild("HumanoidRootPart")
    weaponESP.AlwaysOnTop = true
    weaponESP.Enabled = ESPSettings.WeaponESP

    local weaponLabel = Instance.new("TextLabel", weaponESP)
    weaponLabel.Size = UDim2.new(1, 0, 1, 0)
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.Text = "No Weapon"
    weaponLabel.Font = Enum.Font.GothamBold
    weaponLabel.TextSize = 14
    weaponLabel.TextStrokeTransparency = 0
    weaponLabel.TextColor3 = Color3.new(1, 1, 1)

    -- 🔥 RGB Outline Effect
    local highlight = Instance.new("Highlight", character)
    highlight.Name = "ESP_Outline"
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.Enabled = ESPSettings.BodyOutline

    -- 🌈 RGB Animation
    task.spawn(function()
        while highlight.Parent do
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 1, 1)
            label.TextColor3 = color
            highlight.OutlineColor = color
            task.wait(0.1)
        end
    end)

    -- 🔄 Weapon Update Loop
    task.spawn(function()
        while weaponESP.Parent do
            local tool = character:FindFirstChildOfClass("Tool")
            weaponLabel.Text = tool and tool.Name or "No Weapon"
            task.wait(0.2)
        end
    end)
end

-- 🎯 Toggle Function
local function toggleESP(settingName)
    ESPSettings[settingName] = not ESPSettings[settingName]

    -- Toggle the ESP for the player
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local highlight = player.Character:FindFirstChild("ESP_Outline")
            local nameESP = player.Character:FindFirstChild("ESP_Name")
            local weaponESP = player.Character:FindFirstChild("ESP_Weapon")

            if settingName == "NameESP" and nameESP then
                nameESP.Enabled = ESPSettings.NameESP
            elseif settingName == "WeaponESP" and weaponESP then
                weaponESP.Enabled = ESPSettings.WeaponESP
            elseif settingName == "BodyOutline" and highlight then
                highlight.Enabled = ESPSettings.BodyOutline
            end
        end
    end

    return ESPSettings[settingName]  -- Return the updated state of the setting
end

-- 🔘 Create Buttons with Corrected Text Update and Spacing
local function createButton(name, pos, setting)
    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(1, 0, 0.2, 0)
    Button.Position = UDim2.new(0, 0, pos, 0)
    Button.Text = name .. " [ON]"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14

    -- 🌟 Rounded Corners for Buttons
    local buttonCorner = Instance.new("UICorner", Button)
    buttonCorner.CornerRadius = UDim.new(0, 10)  -- Round the corners of the buttons

    Button.MouseEnter:Connect(function()
        local tween = TweenService:Create(Button, tweenInfo, { BackgroundColor3 = Color3.fromRGB(60, 60, 60) })
        tween:Play()
    end)

    Button.MouseLeave:Connect(function()
        local tween = TweenService:Create(Button, tweenInfo, { BackgroundColor3 = Color3.fromRGB(50, 50, 50) })
        tween:Play()
    end)

    Button.MouseButton1Click:Connect(function()
        local enabled = toggleESP(setting)  -- Call toggleESP and store the new state
        Button.Text = name .. (enabled and " [ON]" or " [OFF]")  -- Update button text based on state
    end)
end

-- 🌟 Apply ESP to All Players
local function createESP(player)
    if player == game.Players.LocalPlayer then return end

    player.CharacterAdded:Connect(function(character)
        applyESP(character, player)
    end)

    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        applyESP(player.Character, player)
    end
end

for _, player in pairs(game.Players:GetPlayers()) do
    createESP(player)
end

game.Players.PlayerAdded:Connect(createESP)

-- 🌟 Add Buttons with smoother transitions and spaced out
createButton("Name ESP", 0.2, "NameESP")
createButton("Weapon ESP", 0.45, "WeaponESP")  -- Increased space between buttons
createButton("Body Outline", 0.7, "BodyOutline")  -- Increased space between buttons
