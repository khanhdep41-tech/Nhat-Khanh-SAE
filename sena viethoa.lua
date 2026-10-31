
-- Nhat Khanh Viet Hoa + Sena Hub
-- Viet hoa giao dien co the truy cap; quet theo dot de giam lag

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Chay loading Sena Hub goc
task.spawn(function()
    local ok, err = pcall(function()
        loadstring(game:HttpGet(
            "https://senahub.xyz/senaexclusive"
        ))()
    end)

    if not ok then
        warn("[Nhat Khanh] Sena Hub loi: " .. tostring(err))
    end
end)

-- 2. Bang dich
local translations = {
    ["Auto Steal"] = "Trom trung tu dong",
    ["Steal"] = "Trom",
    ["Egg"] = "Trung",
    ["Eggs"] = "Trung",
    ["Pets"] = "Thu cung",
    ["Pet"] = "Thu cung",
    ["Auto Sell"] = "Ban tu dong",
    ["Sell Pets"] = "Ban thu cung",
    ["Sell Eggs"] = "Ban trung",
    ["Auto Hatch"] = "No trung tu dong",
    ["Auto Place"] = "Dat tu dong",
    ["Auto Favorite"] = "Danh dau yeu thich tu dong",
    ["Auto Fuse"] = "Hop nhat tu dong",
    ["Equip Best"] = "Trang bi tot nhat",
    ["Movement"] = "Di chuyen",
    ["Fly"] = "Bay",
    ["Speed"] = "Toc do",
    ["Teleport"] = "Dich chuyen",
    ["Server Hop"] = "Doi may chu",
    ["Settings"] = "Cai dat",
    ["Visuals"] = "Hien thi",
    ["Performance"] = "Hieu nang",
    ["FPS Boost"] = "Tang FPS",
    ["General"] = "Chung",
    ["Misc"] = "Khac",
    ["Rarity"] = "Do hiem",
    ["Mutation"] = "Dot bien",
    ["Filter"] = "Bo loc",
    ["Search"] = "Tim kiem",
    ["Start"] = "Bat dau",
    ["Stop"] = "Dung",
    ["Enabled"] = "Da bat",
    ["Disabled"] = "Da tat",
    ["Close"] = "Dong",
    ["Open"] = "Mo",
    ["Save"] = "Luu",
    ["Load"] = "Tai",
    ["Cancel"] = "Huy",
    ["Confirm"] = "Xac nhan",
    ["Select"] = "Chon",
    ["Target"] = "Muc tieu",
    ["Collect"] = "Thu thap",
    ["Upgrade"] = "Nang cap",
    ["Rejoin"] = "Vao lai",
    ["Auto Rejoin"] = "Tu dong vao lai",
    ["Egg Filter"] = "Bo loc trung",
    ["Movement Mode"] = "Che do di chuyen",
    ["Fly Speed"] = "Toc do bay",
    ["Fly Height"] = "Do cao bay",
    ["Glide Speed"] = "Toc do luot",
    ["Hatch and Steal"] = "No trung va trom",
    ["Botting Mode"] = "Che do tu dong",
    ["Presets"] = "Cau hinh mau",
    ["Export"] = "Xuat",
    ["Import"] = "Nhap",
    ["Home"] = "Trang chu",
    ["Back"] = "Quay lai",
    ["Next"] = "Tiep",
}

-- Dich cac cum tu truoc, sau do moi dich tu don
local phrases = {}
for english, vietnamese in pairs(translations) do
    table.insert(phrases, english)
end
table.sort(phrases, function(a, b)
    return #a > #b
end)

local originals = setmetatable({}, {__mode = "k"})
local translatedCache = {}

local function translateText(source)
    if translatedCache[source] then
        return translatedCache[source]
    end

    local result = source

    for _, english in ipairs(phrases) do
        local vietnamese = translations[english]
        result = result:gsub(english, function()
            return vietnamese
        end)
    end

    translatedCache[source] = result
    return result
end

-- 3. Tao GUI dieu khien
local oldGui = playerGui:FindFirstChild("NhatKhanhVietHoa")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "NhatKhanhVietHoa"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(230, 125)
frame.Position = UDim2.new(0, 20, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 20, 48)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(180, 90, 255)
stroke.Thickness = 1.5
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -12, 0, 32)
title.Position = UDim2.fromOffset(6, 3)
title.BackgroundTransparency = 1
title.Text = "NHAT KHANH VIET HOA"
title.TextColor3 = Color3.fromRGB(220, 180, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

local function makeButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.5, -12, 0, 36)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(90, 45, 135)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.Parent = frame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = button

    button.Activated:Connect(callback)
    return button
end

local enabled = true

local function scanGui()
    local roots = {playerGui}

    -- Mot so executor cho phep truy cap GUI qua gethui()
    if type(gethui) == "function" then
        local ok, hiddenGui = pcall(gethui)
        if ok and hiddenGui then
            table.insert(roots, hiddenGui)
        end
    end

    for _, root in ipairs(roots) do
        local ok, descendants = pcall(function()
            return root:GetDescendants()
        end)

        if ok then
            for _, obj in ipairs(descendants) do
                if obj:IsA("TextLabel")
                    or obj:IsA("TextButton")
                    or obj:IsA("TextBox") then

                    if not obj:IsDescendantOf(gui) then
                        if originals[obj] == nil then
                            originals[obj] = obj.Text
                        end

                        if enabled then
                            local success, newText = pcall(
                                translateText,
                                originals[obj]
                            )
                            if success and obj.Parent then
                                pcall(function()
                                    obj.Text = newText
                                end)
                            end
                        else
                            pcall(function()
                                obj.Text = originals[obj]
                            end)
                        end
                    end
                end
            end
        end
    end
end

makeButton("🇻🇳 TIENG VIET",
    UDim2.new(0, 8, 0, 43),
    function()
        enabled = true
        scanGui()
    end
)

makeButton("🌐 ENGLISH",
    UDim2.new(0.5, 4, 0, 43),
    function()
        enabled = false
        scanGui()
    end
)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -12, 0, 24)
status.Position = UDim2.fromOffset(6, 88)
status.BackgroundTransparency = 1
status.Text = "San sang | Quet giao dien theo dot"
status.TextColor3 = Color3.fromRGB(205, 190, 220)
status.TextSize = 10
status.Font = Enum.Font.Gotham
status.Parent = frame

-- Quet ngay, sau do moi 5 giay quet lai
task.spawn(function()
    task.wait(3)
    while gui.Parent do
        scanGui()
        task.wait(5)
    end
end)
