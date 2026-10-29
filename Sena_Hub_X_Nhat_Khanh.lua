
--========================================
-- Sena Hub X Nhat Khanh
-- AUTO TRANSLATE + MINI LANGUAGE GUI
--========================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Call Sena loader separately
task.spawn(function()
    local ok, err = pcall(function()
        local source = game:HttpGet(
            "https://senahub.xyz/senaexclusive"
        )
        assert(#source > 0, "Sena source is empty")

        local fn, compileErr = loadstring(source)
        assert(fn, compileErr or "Load failed")
        fn()
    end)

    if not ok then
        warn("[Sena Hub X Nhat Khanh] Loader:", err)
    end
end)

-- 2. Remove previous GUI
local guiName = "SenaHubXNhatKhanh"

for _, root in ipairs({playerGui, CoreGui}) do
    pcall(function()
        local old = root:FindFirstChild(guiName)
        if old then old:Destroy() end
    end)
end

-- 3. Translation state
local language = "vi"
local originals = setmetatable({}, {__mode = "k"})
local lastApplied = setmetatable({}, {__mode = "k"})
local cache = {}
local pending = {}
local queue = {}
local seen = {}
local MAX_LENGTH = 450

local function getRoots()
    local roots = {playerGui, CoreGui}

    pcall(function()
        if type(gethui) == "function" then
            table.insert(roots, gethui())
        end
    end)

    return roots
end

-- 4. Google Translate endpoint
local function translateOnline(text)
    if cache[text] then
        return cache[text]
    end

    local url =
        "https://translate.googleapis.com/translate_a/single"
        .. "?client=gtx&sl=auto&tl=vi&dt=t&q="
        .. HttpService:UrlEncode(text)

    local response = game:HttpGet(url)
    local data = HttpService:JSONDecode(response)

    local parts = {}
    if type(data) == "table" and type(data[1]) == "table" then
        for _, segment in ipairs(data[1]) do
            if type(segment) == "table"
                and type(segment[1]) == "string" then
                table.insert(parts, segment[1])
            end
        end
    end

    local result = table.concat(parts)
    assert(result ~= "", "Empty translation")

    cache[text] = result
    return result
end

-- 5. Queue translations to avoid too many requests at once
local function enqueue(obj, original)
    if #original == 0 or #original > MAX_LENGTH then
        return
    end

    if cache[original] then
        if obj.Parent and language == "vi"
            and originals[obj] == original then
            obj.Text = cache[original]
            lastApplied[obj] = cache[original]
        end
        return
    end

    if pending[original] then
        return
    end

    pending[original] = true
    table.insert(queue, {
        object = obj,
        text = original
    })
end

task.spawn(function()
    while true do
        local item = table.remove(queue, 1)

        if item then
            local ok, result = pcall(
                translateOnline, item.text
            )

            pending[item.text] = nil

            if ok and type(result) == "string" then
                local translated = result

                -- Apply to every visible object with the same text
                for obj, original in pairs(originals) do
                    if original == item.text
                        and obj.Parent
                        and language == "vi" then

                        pcall(function()
                            obj.Text = translated
                            lastApplied[obj] = translated
                        end)
                    end
                end
            elseif not ok then
                warn("[Sena Translator] Translation failed:", result)
            end

            task.wait(0.25)
        else
            task.wait(0.1)
        end
    end
end)

-- 6. Scan accessible Roblox text
local function scan()
    for _, root in ipairs(getRoots()) do
        pcall(function()
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("TextLabel")
                    or obj:IsA("TextButton")
                    or obj:IsA("TextBox") then

                    if obj:FindFirstAncestor(guiName) then
                        continue
                    end

                    local current = obj.Text

                    if originals[obj] == nil then
                        originals[obj] = current
                    elseif current ~= lastApplied[obj] then
                        -- The game changed this text
                        originals[obj] = current
                    end

                    local original = originals[obj]

                    if language == "vi" then
                        if cache[original] then
                            obj.Text = cache[original]
                            lastApplied[obj] = cache[original]
                        elseif current == original then
                            enqueue(obj, original)
                        end
                    else
                        if current ~= original then
                            obj.Text = original
                        end
                        lastApplied[obj] = original
                    end
                end
            end
        end)
    end
end

-- 7. Compact GUI
local gui = Instance.new("ScreenGui")
gui.Name = guiName
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(220, 64)
frame.AnchorPoint = Vector2.new(0, 0)
frame.Position = UDim2.new(0.5, 120, 0, 8)
frame.BackgroundColor3 = Color3.fromRGB(24, 25, 38)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius =
    UDim.new(0, 10)

local outline = Instance.new("UIStroke")
outline.Color = Color3.fromRGB(220, 100, 190)
outline.Thickness = 1.3
outline.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -8, 0, 23)
title.Position = UDim2.fromOffset(4, 0)
title.BackgroundTransparency = 1
title.Text = "Sena Hub X Nhat Khanh"
title.TextColor3 = Color3.fromRGB(255, 150, 220)
title.TextSize = 11
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function makeButton(text, x)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(102, 28)
    b.Position = UDim2.fromOffset(x, 29)
    b.BackgroundColor3 = Color3.fromRGB(55, 58, 78)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 10
    b.Font = Enum.Font.GothamBold
    b.Parent = frame

    Instance.new("UICorner", b).CornerRadius =
        UDim.new(0, 7)

    return b
end

local viButton = makeButton("🇻🇳 VIỆT", 5)
local enButton = makeButton("🌐 ENGLISH", 113)

local activeColor = Color3.fromRGB(75, 95, 210)
local inactiveColor = Color3.fromRGB(55, 58, 78)

local function setLanguage(lang)
    language = lang

    viButton.BackgroundColor3 =
        lang == "vi" and activeColor or inactiveColor
    enButton.BackgroundColor3 =
        lang == "en" and activeColor or inactiveColor

    scan()
end

viButton.Activated:Connect(function()
    setLanguage("vi")
end)

enButton.Activated:Connect(function()
    setLanguage("en")
end)

-- 8. Drag by title bar (touch and mouse)
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

-- 9. Keep scanning new text
task.spawn(function()
    task.wait(3)

    while gui.Parent do
        scan()
        task.wait(1.5)
    end
end)

print("Sena Hub X Nhat Khanh: Auto Translate started")
