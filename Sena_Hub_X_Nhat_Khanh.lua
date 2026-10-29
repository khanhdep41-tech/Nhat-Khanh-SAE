-- Sena Hub X Nhat Khanh
-- 1) Goi loader Sena Hub
-- 2) Khoi tao GUI chon ngon ngu va thu dich cac chu co trong tu dien

local SENA_LOADER_URL = "https://senahub.xyz/senaexclusive"

local loaderOk, loaderErr = pcall(function()
    local source = game:HttpGet(SENA_LOADER_URL)
    assert(type(source) == "string" and #source > 0, "Sena loader khong tra ve source")
    local chunk, compileErr = loadstring(source)
    assert(chunk, compileErr or "Khong the nap Sena loader")
    chunk()
end)

if not loaderOk then
    warn("[Sena Hub X Nhat Khanh] Loi khi goi Sena loader: " .. tostring(loaderErr))
end

-- Cho Sena Hub co thoi gian tao giao dien truoc khi bat dau quet
task.wait(5)

-- Sena Hub X Nhat Khanh | Auto Translate GUI
-- GUI rieng: 2 nut chon ngon ngu, co the keo di chuyen.
-- Luu y: chi dich cac chu khop voi bang translations va cac GUI ma script truy cap duoc.

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local parent = (gethui and gethui()) or CoreGui

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
}

local originals = setmetatable({}, { __mode = "k" })
local currentLanguage = "vi"
local scanning = false

local function getRoots()
    local roots = { parent }
    if player then
        local playerGui = player:FindFirstChildOfClass("PlayerGui")
        if playerGui then
            table.insert(roots, playerGui)
        end
    end
    return roots
end

local function scanGui()
    if scanning then return end
    scanning = true

    for _, root in ipairs(getRoots()) do
        pcall(function()
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("TextLabel")
                    or obj:IsA("TextButton")
                    or obj:IsA("TextBox") then

                    if originals[obj] == nil then
                        originals[obj] = obj.Text
                    end

                    if currentLanguage == "vi" then
                        local original = originals[obj]
                        obj.Text = translations[original] or original
                    else
                        obj.Text = originals[obj]
                    end
                end
            end
        end)
    end

    scanning = false
end

pcall(function()
    local old = parent:FindFirstChild("SenaHubXNhatKhanh")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "SenaHubXNhatKhanh"
gui.ResetOnSpawn = false

local ok = pcall(function()
    gui.Parent = parent
end)
if not ok or not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

local frame = Instance.new("Frame")
frame.Name = "LanguagePanel"
frame.Size = UDim2.fromOffset(270, 95)
frame.Position = UDim2.new(1, -285, 0, 80)
frame.BackgroundColor3 = Color3.fromRGB(24, 25, 38)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(220, 100, 190)
stroke.Thickness = 1.5
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -10, 0, 34)
title.Position = UDim2.fromOffset(5, 2)
title.BackgroundTransparency = 1
title.Text = "Sena Hub X Nhat Khanh"
title.TextColor3 = Color3.fromRGB(255, 150, 220)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function makeButton(name, text, x, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.fromOffset(124, 40)
    button.Position = UDim2.fromOffset(x, 43)
    button.BackgroundColor3 = color
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 13
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = true
    button.Parent = frame
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    return button
end

local activeColor = Color3.fromRGB(75, 95, 210)
local inactiveColor = Color3.fromRGB(55, 58, 78)
local vi = makeButton("VietnameseButton", "🇻🇳 TIẾNG VIỆT", 7, activeColor)
local en = makeButton("EnglishButton", "🌐 ENGLISH", 139, inactiveColor)

local function setLanguage(lang)
    currentLanguage = lang
    scanGui()

    vi.BackgroundColor3 = lang == "vi" and activeColor or inactiveColor
    en.BackgroundColor3 = lang == "en" and activeColor or inactiveColor
end

vi.Activated:Connect(function()
    setLanguage("vi")
end)

en.Activated:Connect(function()
    setLanguage("en")
end)

-- Keo bang chuot/cam ung (keo tu thanh tieu de)
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
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Doi Hub load, sau do quet lai dinh ky de bat GUI moi
task.spawn(function()
    task.wait(3)
    while gui.Parent do
        scanGui()
        task.wait(2)
    end
end)

print("Sena Hub X Nhat Khanh Translator loaded")
