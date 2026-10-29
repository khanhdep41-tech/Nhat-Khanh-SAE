
--========================================
-- NHAT KHANH VIET HOA
-- NEON PURPLE CYBER UI
--========================================

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "NeonPanel"
frame.Size = UDim2.fromOffset(190, 56)
frame.Position = UDim2.new(0.5, 120, 0, 8)
frame.BackgroundColor3 = Color3.fromRGB(13, 8, 28)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 11)
corner.Parent = frame

-- Neon purple border
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(190, 65, 255)
stroke.Thickness = 1.8
stroke.Transparency = 0.05
stroke.Parent = frame

-- Subtle purple gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(
        0, Color3.fromRGB(30, 12, 65)
    ),
    ColorSequenceKeypoint.new(
        0.5, Color3.fromRGB(15, 10, 38)
    ),
    ColorSequenceKeypoint.new(
        1, Color3.fromRGB(42, 8, 60)
    )
})
gradient.Rotation = 20
gradient.Parent = frame

-- Header
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -8, 0, 21)
title.Position = UDim2.fromOffset(4, 0)
title.BackgroundTransparency = 1
title.Text = "✦ NHAT KHANH VIET HOA"
title.TextColor3 = Color3.fromRGB(226, 170, 255)
title.TextSize = 10
title.Font = Enum.Font.GothamBold
title.TextStrokeTransparency = 0.8
title.Parent = frame

-- Language buttons
local function makeButton(name, text, x)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.fromOffset(87, 27)
    button.Position = UDim2.fromOffset(x, 25)
    button.BackgroundColor3 = Color3.fromRGB(35, 17, 65)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(240, 220, 255)
    button.TextSize = 9
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = true
    button.Parent = frame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 7)
    buttonCorner.Parent = button

    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(145, 60, 220)
    buttonStroke.Thickness = 1
    buttonStroke.Transparency = 0.2
    buttonStroke.Parent = button

    return button, buttonStroke
end

local viButton, viStroke =
    makeButton("VietnameseButton", "🇻🇳 TIẾNG VIỆT", 5)

local enButton, enStroke =
    makeButton("EnglishButton", "ENGLISH", 98)

local neonPurple = Color3.fromRGB(130, 45, 230)
local darkPurple = Color3.fromRGB(35, 17, 65)

local function setLanguage(lang)
    language = lang

    viButton.BackgroundColor3 =
        lang == "vi" and neonPurple or darkPurple

    enButton.BackgroundColor3 =
        lang == "en" and neonPurple or darkPurple

    viStroke.Color =
        lang == "vi"
        and Color3.fromRGB(225, 170, 255)
        or Color3.fromRGB(145, 60, 220)

    enStroke.Color =
        lang == "en"
        and Color3.fromRGB(225, 170, 255)
        or Color3.fromRGB(145, 60, 220)

    scan()
end

viButton.Activated:Connect(function()
    setLanguage("vi")
end)

enButton.Activated:Connect(function()
    setLanguage("en")
end)

-- Drag panel on touch and mouse
local UIS = game:GetService("UserInputService")
local dragging = false
local dragStart
local startPosition

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = frame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Auto-enable Vietnamese
task.defer(function()
    task.wait(1)
    setLanguage("vi")
end)
