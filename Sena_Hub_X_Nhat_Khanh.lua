
--========================================
-- Sena Hub X Nhat Khanh
-- Language GUI + Sena Loader
--========================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- GUI parent
local parent
pcall(function()
    if type(gethui) == "function" then
        parent = gethui()
    end
end)

if not parent then
    parent = player:WaitForChild("PlayerGui")
end

-- Remove old GUI
pcall(function()
    local old = parent:FindFirstChild("SenaHubXNhatKhanh")
    if old then
        old:Destroy()
    end
end)

-- Translation dictionary
local translations = {
    ["Settings"] = "Cài đặt",
    ["Setting"] = "Cài đặt",
    ["Auto Farm"] = "Tự động farm",
    ["Main"] = "Chính",
    ["Misc"] = "Khác",
    ["Visual"] = "Hiển thị",
    ["Teleport"] = "Dịch chuyển",
    ["Player"] = "Người chơi",
    ["Shop"] = "Cửa hàng",
    ["Close"] = "Đóng",
    ["Open"] = "Mở",
    ["Save"] = "Lưu",
    ["Cancel"] = "Hủy",
    ["Search"] = "Tìm kiếm",
    ["Enabled"] = "Đã bật",
    ["Disabled"] = "Đã tắt",
    ["Language"] = "Ngôn ngữ",
    ["Anti-AFK"] = "Chống treo",
    ["Filter"] = "Bộ lọc",
    ["Rarity"] = "Độ hiếm",
    ["CONFIG SETTING AUTO FARM"] = "CÀI ĐẶT AUTO FARM",
    ["Inventory"] = "Túi đồ",
    ["Upgrade"] = "Nâng cấp",
    ["Teleport to Spawn"] = "Dịch chuyển về điểm hồi sinh",
    ["Speed"] = "Tốc độ",
    ["Jump Power"] = "Lực nhảy",
    ["Reset"] = "Đặt lại",
}

local originals = setmetatable({}, {__mode = "k"})
local currentLanguage = "vi"

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SenaHubXNhatKhanh"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parent

local frame = Instance.new("Frame")
frame.Name = "LanguagePanel"
frame.Size = UDim2.fromOffset(280, 100)
frame.Position = UDim2.new(1, -295, 0, 80)
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
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.fromOffset(128, 42)
    button.Position = UDim2.fromOffset(x, 48)
    button.BackgroundColor3 = Color3.fromRGB(55, 58, 78)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 13
    button.Font = Enum.Font.GothamBold
    button.Parent = frame

    Instance.new("UICorner", button).CornerRadius =
        UDim.new(0, 8)

    return button
end

local viButton = makeButton(
    "VietnameseButton", "🇻🇳 TIẾNG VIỆT", 7
)
local enButton = makeButton(
    "EnglishButton", "🌐 ENGLISH", 145
)

local activeColor = Color3.fromRGB(75, 95, 210)
local inactiveColor = Color3.fromRGB(55, 58, 78)

-- Scan accessible GUI text
local function scanGui()
    local roots = {parent}

    pcall(function()
        table.insert(roots, player:FindFirstChildOfClass("PlayerGui"))
    end)

    for _, root in ipairs(roots) do
        if root then
            pcall(function()
                for _, obj in ipairs(root:GetDescendants()) do
                    if obj ~= gui and (
                        obj:IsA("TextLabel")
                        or obj:IsA("TextButton")
                        or obj:IsA("TextBox")
                    ) then
                        if originals[obj] == nil then
                            originals[obj] = obj.Text
                        end

                        if currentLanguage == "vi" then
                            local original = originals[obj]
                            obj.Text = translations[original]
                                or original
                        else
                            obj.Text = originals[obj]
                        end
                    end
                end
            end)
        end
    end
end

local function setLanguage(language)
    currentLanguage = language

    viButton.BackgroundColor3 =
        language == "vi" and activeColor or inactiveColor
    enButton.BackgroundColor3 =
        language == "en" and activeColor or inactiveColor

    scanGui()
end

viButton.Activated:Connect(function()
    setLanguage("vi")
end)

enButton.Activated:Connect(function()
    setLanguage("en")
end)

-- Drag GUI by its title
local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Call Sena loader separately
task.spawn(function()
    local ok, err = pcall(function()
        local source = game:HttpGet(
            "https://senahub.xyz/senaexclusive"
        )

        assert(type(source) == "string" and #source > 0,
            "Sena loader returned empty source")

        local chunk, compileError = loadstring(source)
        assert(chunk, compileError or "Cannot compile Sena loader")
        chunk()
    end)

    if not ok then
        warn("[Sena Hub X Nhat Khanh] Sena loader error: "
            .. tostring(err))
    end
end)

-- Keep checking for newly created text
task.spawn(function()
    task.wait(3)

    while gui.Parent do
        scanGui()
        task.wait(2)
    end
end)

print("Sena Hub X Nhat Khanh loaded")
