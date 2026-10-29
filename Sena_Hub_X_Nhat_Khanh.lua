
--========================================
-- Sena Hub X Nhat Khanh
-- Draggable Language GUI
--========================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Translation dictionary
local translations = {
    ["Sena Exclusive"] = "Sena Độc Quyền",
    ["Donate"] = "Ủng hộ",
    ["Home"] = "Trang chủ",
    ["Steal"] = "Cướp",
    ["Eggs &..."] = "Trứng &...",
    ["Pets"] = "Thú cưng",
    ["Events"] = "Sự kiện",
    ["Task Order"] = "Thứ tự nhiệm vụ",
    ["Auto Steal"] = "Tự động cướp",
    ["Shooting Star"] = "Sao băng",
    ["Auto Mobs"] = "Tự động đánh quái",
    ["Auto Fishing"] = "Tự động câu cá",
    ["Auto Sell"] = "Tự động bán",
    ["Auto Hatch"] = "Tự động mở trứng",
    ["Reset"] = "Đặt lại",
    ["Search"] = "Tìm kiếm",
    ["Settings"] = "Cài đặt",
    ["Inventory"] = "Túi đồ",
    ["Eggs"] = "Trứng",
    ["Close"] = "Đóng",
    ["Open"] = "Mở",
    ["Save"] = "Lưu",
    ["Cancel"] = "Hủy",
    ["Enabled"] = "Đã bật",
    ["Disabled"] = "Đã tắt",
    ["Waiting for reset wall"] = "Đang chờ tường đặt lại",
    ["No star right now"] = "Hiện không có sao",
    ["0 stolen"] = "Đã cướp: 0",
    ["Search"] = "Tìm kiếm",
    ["Task Order"] = "Thứ tự nhiệm vụ",
    ["English"] = "Tiếng Anh",
    ["Language"] = "Ngôn ngữ",
    ["Main"] = "Chính",
    ["Misc"] = "Khác",
    ["Teleport"] = "Dịch chuyển",
    ["Filter"] = "Bộ lọc",
    ["Rarity"] = "Độ hiếm",
}

local originalText = setmetatable({}, {__mode = "k"})
local lastTranslated = setmetatable({}, {__mode = "k"})
local language = "vi"

-- Get accessible GUI roots
local function getRoots()
    local roots = {playerGui}

    pcall(function()
        table.insert(roots, CoreGui)
    end)

    pcall(function()
        if type(gethui) == "function" then
            table.insert(roots, gethui())
        end
    end)

    return roots
end

-- Translate exact matches
local function translate(text)
    return translations[text] or text
end

-- Scan accessible text objects
local function scanGui()
    for _, root in ipairs(getRoots()) do
        pcall(function()
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("TextLabel")
                    or obj:IsA("TextButton")
                    or obj:IsA("TextBox") then

                    if not obj:FindFirstAncestor("SenaHubXNhatKhanh") then
                        if originalText[obj] == nil then
                            originalText[obj] = obj.Text
                        elseif obj.Text ~= lastTranslated[obj] then
                            originalText[obj] = obj.Text
                        end

                        local result = originalText[obj]

                        if language == "vi" then
                            result = translate(result)
                        end

                        obj.Text = result
                        lastTranslated[obj] = result
                    end
                end
            end
        end)
    end
end

-- Remove previous GUI
for _, root in ipairs(getRoots()) do
    pcall(function()
        local old = root:FindFirstChild("SenaHubXNhatKhanh")
        if old then old:Destroy() end
    end)
end

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SenaHubXNhatKhanh"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "LanguagePanel"
frame.Size = UDim2.fromOffset(280, 100)

-- Near top-center, close to FPS panel
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Position = UDim2.new(0.5, 180, 0, 8)

frame.BackgroundColor3 = Color3.fromRGB(24, 25, 38)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius =
    UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(220, 100, 190)
stroke.Thickness = 1.5
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -10, 0, 35)
title.Position = UDim2.fromOffset(5, 2)
title.BackgroundTransparency = 1
title.Text = "Sena Hub X Nhat Khanh"
title.TextColor3 = Color3.fromRGB(255, 150, 220)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function makeButton(name, text, x)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.fromOffset(128, 42)
    b.Position = UDim2.fromOffset(x, 48)
    b.BackgroundColor3 = Color3.fromRGB(55, 58, 78)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = frame

    Instance.new("UICorner", b).CornerRadius =
        UDim.new(0, 8)

    return b
end

local activeColor = Color3.fromRGB(75, 95, 210)
local inactiveColor = Color3.fromRGB(55, 58, 78)

local viButton = makeButton(
    "VietnameseButton", "🇻🇳 TIẾNG VIỆT", 7
)

local enButton = makeButton(
    "EnglishButton", "🌐 ENGLISH", 145
)

local function setLanguage(lang)
    language = lang

    viButton.BackgroundColor3 =
        lang == "vi" and activeColor or inactiveColor

    enButton.BackgroundColor3 =
        lang == "en" and activeColor or inactiveColor

    scanGui()
end

viButton.Activated:Connect(function()
    setLanguage("vi")
end)

enButton.Activated:Connect(function()
    setLanguage("en")
end)

-- Drag by title bar, supports touch
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

UserInputService.InputChanged:Connect(function(input)
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

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Periodically scan new GUI elements
task.spawn(function()
    task.wait(2)

    while gui.Parent do
        scanGui()
        task.wait(1)
    end
end)

print("Sena Hub X Nhat Khanh loaded")
