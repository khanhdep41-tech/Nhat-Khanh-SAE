--[[
    NHAT KHANH HUB - QUICK STEAL
    Compact draggable GUI, positioned on the RIGHT side of the screen.
    Background image is downloaded from GitHub and cached locally when supported.

    Buttons:
      1) Quick Auto Steal
      2) Quick Steal Other Script

    Note: The buttons require the Sena runtime globals used below to exist.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local env = (getgenv and getgenv()) or _G

local IMAGE_URL = "https://raw.githubusercontent.com/khanhdep41-tech/Nhat-Khanh-SAE/refs/heads/main/9a80e037e033b4fd9a6d5a48e8eb3ef4.jpg"
local FOLDER = "NhatKhanhHub"
local IMAGE_PATH = FOLDER .. "/background.jpg"

-- Remove previous copy
pcall(function()
    if CoreGui:FindFirstChild("NhatKhanhHub") then
        CoreGui.NhatKhanhHub:Destroy()
    end
    local pg = player:FindFirstChildOfClass("PlayerGui")
    if pg and pg:FindFirstChild("NhatKhanhHub") then
        pg.NhatKhanhHub:Destroy()
    end
end)

local function getLocalImageAsset()
    if type(writefile) ~= "function" then
        warn("[Nhat Khanh Hub] Executor does not support writefile.")
        return nil
    end

    if type(getcustomasset) ~= "function" and type(getsynasset) ~= "function" then
        warn("[Nhat Khanh Hub] Executor does not support getcustomasset/getsynasset.")
        return nil
    end

    if type(makefolder) == "function" and type(isfolder) == "function" then
        pcall(function()
            if not isfolder(FOLDER) then
                makefolder(FOLDER)
            end
        end)
    elseif type(makefolder) == "function" then
        pcall(makefolder, FOLDER)
    end

    local imageData
    local downloaded = false

    -- Use cached image when available; otherwise fetch it from GitHub.
    if type(isfile) == "function" and isfile(IMAGE_PATH) and type(readfile) == "function" then
        local okRead, result = pcall(readfile, IMAGE_PATH)
        if okRead and type(result) == "string" and #result > 0 then
            imageData = result
        end
    end

    if not imageData then
        local okHttp, result = pcall(function()
            if type(game.HttpGet) == "function" then
                return game:HttpGet(IMAGE_URL)
            end
            error("HttpGet unavailable")
        end)

        if not okHttp or type(result) ~= "string" or #result == 0 then
            warn("[Nhat Khanh Hub] Could not download background image.")
            return nil
        end

        imageData = result
        downloaded = true
    end

    if downloaded then
        local okWrite, err = pcall(writefile, IMAGE_PATH, imageData)
        if not okWrite then
            warn("[Nhat Khanh Hub] Could not save image locally: " .. tostring(err))
        end
    end

    local assetFn = getcustomasset or getsynasset
    local okAsset, asset = pcall(assetFn, IMAGE_PATH)
    if okAsset and type(asset) == "string" then
        return asset
    end

    warn("[Nhat Khanh Hub] Local image asset could not be loaded.")
    return nil
end

local function new(className, properties, parent)
    local obj = Instance.new(className)
    for key, value in pairs(properties) do
        obj[key] = value
    end
    obj.Parent = parent
    return obj
end

local gui = Instance.new("ScreenGui")
gui.Name = "NhatKhanhHub"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parentOK = pcall(function()
    gui.Parent = CoreGui
end)
if not parentOK or not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

-- Small panel anchored to the right side, near the middle of the screen.
local panel = new("Frame", {
    Name = "MainPanel",
    Size = UDim2.fromOffset(280, 164),
    Position = UDim2.new(1, -292, 0.48, -82),
    BackgroundColor3 = Color3.fromRGB(20, 13, 29),
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Active = true,
    ZIndex = 1,
}, gui)

new("UICorner", { CornerRadius = UDim.new(0, 12) }, panel)
new("UIStroke", {
    Color = Color3.fromRGB(105, 72, 132),
    Thickness = 1.5,
    Transparency = 0.12,
}, panel)

-- Background image, if local-file APIs are supported by the executor.
local imageAsset = getLocalImageAsset()
if imageAsset then
    new("ImageLabel", {
        Name = "BackgroundImage",
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0, 0),
        BackgroundTransparency = 1,
        Image = imageAsset,
        ImageTransparency = 0.38,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 1,
    }, panel)
end

-- Dark overlay keeps text readable over the background.
new("Frame", {
    Name = "ImageShade",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(16, 10, 24),
    BackgroundTransparency = imageAsset and 0.24 or 0.02,
    BorderSizePixel = 0,
    ZIndex = 2,
}, panel)

local header = new("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundColor3 = Color3.fromRGB(15, 10, 22),
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0,
    Active = true,
    ZIndex = 3,
}, panel)
new("UICorner", { CornerRadius = UDim.new(0, 10) }, header)

new("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -48, 1, 0),
    Position = UDim2.fromOffset(12, 0),
    BackgroundTransparency = 1,
    Text = "NHAT KHANH | QUICK STEAL",
    TextColor3 = Color3.fromRGB(220, 153, 255),
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
}, header)

local close = new("TextButton", {
    Name = "Close",
    Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(1, -32, 0, 8),
    BackgroundColor3 = Color3.fromRGB(48, 37, 56),
    Text = "×",
    TextColor3 = Color3.fromRGB(245, 245, 245),
    TextSize = 19,
    Font = Enum.Font.Gotham,
    BorderSizePixel = 0,
    ZIndex = 4,
}, header)
new("UICorner", { CornerRadius = UDim.new(0, 6) }, close)

local status = new("TextLabel", {
    Name = "Status",
    Size = UDim2.new(1, -20, 0, 15),
    Position = UDim2.fromOffset(10, 43),
    BackgroundTransparency = 1,
    Text = "Ready",
    TextColor3 = Color3.fromRGB(205, 205, 210),
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
}, panel)

local function createToggle(label, y)
    local row = new("Frame", {
        Name = "ToggleRow",
        Size = UDim2.new(1, -20, 0, 42),
        Position = UDim2.fromOffset(10, y),
        BackgroundColor3 = Color3.fromRGB(72, 43, 95),
        BackgroundTransparency = 0.10,
        BorderSizePixel = 0,
        ZIndex = 3,
    }, panel)
    new("UICorner", { CornerRadius = UDim.new(0, 9) }, row)

    new("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -75, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Color3.fromRGB(250, 247, 252),
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
    }, row)

    local switch = new("TextButton", {
        Name = "Switch",
        Size = UDim2.fromOffset(49, 25),
        Position = UDim2.new(1, -59, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(70, 70, 76),
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = true,
        ZIndex = 4,
    }, row)
    new("UICorner", { CornerRadius = UDim.new(1, 0) }, switch)

    local knob = new("Frame", {
        Name = "Knob",
        Size = UDim2.fromOffset(19, 19),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = Color3.fromRGB(250, 250, 250),
        BorderSizePixel = 0,
        ZIndex = 5,
    }, switch)
    new("UICorner", { CornerRadius = UDim.new(1, 0) }, knob)

    local function render(enabled)
        switch.BackgroundColor3 = enabled
            and Color3.fromRGB(35, 220, 105)
            or Color3.fromRGB(70, 70, 76)
        knob.Position = enabled
            and UDim2.new(1, -22, 0, 3)
            or UDim2.fromOffset(3, 3)
    end

    return switch, render
end

local autoOn = false
local snipeOn = false
local autoBtn, renderAuto = createToggle("Quick Auto Steal", 62)
local snipeBtn, renderSnipe = createToggle("Quick Steal Other Script", 111)

local function getRuntime()
    return env.__SenaV4EggRuntime
end

autoBtn.Activated:Connect(function()
    local rt = getRuntime()
    if not rt or type(rt.setEnabled) ~= "function" then
        status.Text = "Sena runtime not found"
        warn("[Nhat Khanh Hub] Runtime missing or setEnabled unavailable.")
        return
    end

    local nextValue = not autoOn
    local success, err = pcall(function()
        rt:setEnabled(nextValue)
        if type(env.__SenaV4SetStealDeclutter) == "function" then
            env.__SenaV4SetStealDeclutter(nextValue)
        end
    end)

    if success then
        autoOn = nextValue
        renderAuto(autoOn)
        status.Text = "Auto Steal: " .. (autoOn and "ON" or "OFF")
    else
        status.Text = "Auto Steal error"
        warn("[Nhat Khanh Hub] " .. tostring(err))
    end
end)

snipeBtn.Activated:Connect(function()
    local rt = getRuntime()
    if not rt then
        status.Text = "Sena runtime not found"
        warn("[Nhat Khanh Hub] Runtime missing.")
        return
    end

    local nextValue = not snipeOn
    local success, err = pcall(function()
        if type(rt._reconcileRunningState) == "function" then
            rt:_reconcileRunningState()
        end

        if nextValue then
            assert(type(rt._installSnipeHook) == "function",
                "Missing _installSnipeHook")
            rt:_installSnipeHook()
        else
            assert(type(rt._removeSnipeHook) == "function",
                "Missing _removeSnipeHook")
            rt:_removeSnipeHook()
        end
    end)

    if success then
        snipeOn = nextValue
        renderSnipe(snipeOn)
        status.Text = "Other Script: " .. (snipeOn and "ON" or "OFF")
    else
        status.Text = "Other Script hook error"
        warn("[Nhat Khanh Hub] " .. tostring(err))
    end
end)

-- Drag by the header; supports mouse and touchscreen.
local dragging = false
local dragInput
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = panel.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput
        or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

close.Activated:Connect(function()
    gui:Destroy()
end)

print("[Nhat Khanh Hub] GUI loaded; positioned on the right side.")
