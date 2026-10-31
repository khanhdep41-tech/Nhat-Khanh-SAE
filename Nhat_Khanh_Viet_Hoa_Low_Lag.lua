--[[
    NHAT KHANH VIET HOA - LOW LAG
    Universal GUI Translator for Roblox executors (Delta-friendly)
    - Built-in dictionary + optional online translation
    - Processes GUI descendants in small batches
    - Watches newly added GUI objects
    - Vietnamese / English toggle
    - Draggable neon purple GUI
]]

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
    warn("[Nhat Khanh Viet Hoa] Khong tim thay LocalPlayer")
    return
end

local GUI_NAME = "NhatKhanhVietHoa"
local currentLanguage = "vi"

-- Tuning for lower lag
local BATCH_SIZE = 50
local BATCH_WAIT = 0.03
local SCAN_INTERVAL = 8
local TRANSLATION_WAIT = 0.35

local originals = setmetatable({}, { __mode = "k" })
local cache = {}
local queued = {}
local queue = {}
local knownObjects = setmetatable({}, { __mode = "k" })
local applyingTranslation = setmetatable({}, { __mode = "k" })
local watchedObjects = setmetatable({}, { __mode = "k" })
local scanBusy = false
local scanAgain = false

-- Built-in dictionary: fast, no internet needed
local translations = {
    ["Settings"] = "Cài đặt",
    ["Setting"] = "Cài đặt",
    ["Main"] = "Chính",
    ["Home"] = "Trang chủ",
    ["Main Menu"] = "Menu chính",
    ["Misc"] = "Khác",
    ["Miscellaneous"] = "Khác",
    ["Visual"] = "Hiển thị",
    ["Display"] = "Màn hình",
    ["Teleport"] = "Dịch chuyển",
    ["Player"] = "Người chơi",
    ["Players"] = "Người chơi",
    ["Shop"] = "Cửa hàng",
    ["Inventory"] = "Túi đồ",
    ["Pets"] = "Thú cưng",
    ["Eggs"] = "Trứng",
    ["Close"] = "Đóng",
    ["Open"] = "Mở",
    ["Save"] = "Lưu",
    ["Cancel"] = "Hủy",
    ["Confirm"] = "Xác nhận",
    ["Apply"] = "Áp dụng",
    ["Reset"] = "Đặt lại",
    ["Search"] = "Tìm kiếm",
    ["Enabled"] = "Đã bật",
    ["Disabled"] = "Đã tắt",
    ["Enable"] = "Bật",
    ["Disable"] = "Tắt",
    ["Language"] = "Ngôn ngữ",
    ["Anti-AFK"] = "Chống treo",
    ["Filter"] = "Bộ lọc",
    ["Rarity"] = "Độ hiếm",
    ["Common"] = "Thông thường",
    ["Uncommon"] = "Không phổ biến",
    ["Rare"] = "Hiếm",
    ["Epic"] = "Sử thi",
    ["Legendary"] = "Huyền thoại",
    ["Mythic"] = "Thần thoại",
    ["Auto Farm"] = "Tự động farm",
    ["Auto Sell"] = "Tự động bán",
    ["Auto Collect"] = "Tự động thu thập",
    ["Collect All"] = "Thu thập tất cả",
    ["Sell All"] = "Bán tất cả",
    ["Equip"] = "Trang bị",
    ["Unequip"] = "Tháo trang bị",
    ["Upgrade"] = "Nâng cấp",
    ["Buy"] = "Mua",
    ["Free"] = "Miễn phí",
    ["Loading..."] = "Đang tải...",
    ["Please wait"] = "Vui lòng chờ",
    ["Success"] = "Thành công",
    ["Failed"] = "Thất bại",
    ["Error"] = "Lỗi",
    ["Warning"] = "Cảnh báo",
    ["Information"] = "Thông tin",
    ["On"] = "Bật",
    ["Off"] = "Tắt",
    ["Yes"] = "Có",
    ["No"] = "Không",
    ["Back"] = "Quay lại",
    ["Next"] = "Tiếp theo",
    ["Previous"] = "Trước đó",
    ["Speed"] = "Tốc độ",
    ["Walk Speed"] = "Tốc độ chạy",
    ["Jump Power"] = "Lực nhảy",
    ["Infinite"] = "Vô hạn",
    ["ESP"] = "ESP",
    ["Player ESP"] = "ESP người chơi",
    ["Server"] = "Máy chủ",
    ["Rejoin"] = "Vào lại",
    ["Server Hop"] = "Chuyển máy chủ",
    ["Performance"] = "Hiệu suất",
    ["Graphics"] = "Đồ họa",
    ["Low Graphics"] = "Đồ họa thấp",
    ["Fix Lag"] = "Giảm giật lag",
    ["Music"] = "Nhạc",
    ["Sound"] = "Âm thanh",
    ["Volume"] = "Âm lượng",
    ["Start"] = "Bắt đầu",
    ["Stop"] = "Dừng",
    ["Pause"] = "Tạm dừng",
    ["Resume"] = "Tiếp tục",
    ["Refresh"] = "Làm mới",
    ["Re-execute"] = "Chạy lại",
    ["Execute"] = "Thực thi",
    ["Select"] = "Chọn",
    ["Selected"] = "Đã chọn",
    ["Unselected"] = "Chưa chọn",
    ["Amount"] = "Số lượng",
    ["Time"] = "Thời gian",
    ["Auto"] = "Tự động",
    ["Manual"] = "Thủ công",
    ["Settings Menu"] = "Menu cài đặt",
    ["CONFIG SETTING AUTO FARM"] = "CÀI ĐẶT AUTO FARM",
}

local function getRequestFunction()
    if type(request) == "function" then return request end
    if type(http_request) == "function" then return http_request end
    if type(syn) == "table" and type(syn.request) == "function" then
        return syn.request
    end
    return nil
end

local function translateOnline(original)
    if type(original) ~= "string" or original == "" then return nil end
    if translations[original] then return translations[original] end
    if cache[original] then return cache[original] end
    if not original:find("%a") or #original > 350 then return nil end

    local url = "https://translate.googleapis.com/translate_a/single"
        .. "?client=gtx&sl=auto&tl=vi&dt=t&q="
        .. HttpService:UrlEncode(original)

    local body
    local requestFunction = getRequestFunction()

    if requestFunction then
        local ok, response = pcall(function()
            return requestFunction({
                Url = url,
                Method = "GET",
                Headers = { ["Accept"] = "application/json" }
            })
        end)

        if ok and type(response) == "table" then
            body = response.Body or response.body
        end
    end

    if type(body) ~= "string" then
        local ok, result = pcall(function()
            return game:HttpGet(url)
        end)
        if ok and type(result) == "string" then body = result end
    end

    if type(body) ~= "string" then return nil end

    local ok, data = pcall(function()
        return HttpService:JSONDecode(body)
    end)
    if not ok or type(data) ~= "table" or type(data[1]) ~= "table" then
        return nil
    end

    local pieces = {}
    for _, part in ipairs(data[1]) do
        if type(part) == "table" and type(part[1]) == "string" then
            table.insert(pieces, part[1])
        end
    end

    local result = table.concat(pieces)
    if result ~= "" and result ~= original then
        cache[original] = result
        return result
    end
    return nil
end

local function getRoots()
    local roots, seen = {}, {}

    local function add(root)
        if root and not seen[root] then
            seen[root] = true
            table.insert(roots, root)
        end
    end

    pcall(function()
        if type(gethui) == "function" then add(gethui()) end
    end)

    pcall(function()
        add(player:FindFirstChildOfClass("PlayerGui"))
    end)

    return roots
end

local function enqueue(original)
    if type(original) ~= "string" or original == "" then return end
    if translations[original] or cache[original] or queued[original] then return end
    if #original > 350 or not original:find("%a") then return end

    queued[original] = true
    table.insert(queue, original)
end

local function applyText(obj, value)
    if not obj or not obj.Parent or obj.Text == value then return end
    applyingTranslation[obj] = true
    pcall(function()
        obj.Text = value
    end)
    applyingTranslation[obj] = nil
end

local function processObject(obj)
    if not obj or not obj.Parent then return end
    if obj:IsA("ScreenGui") and obj.Name == GUI_NAME then return end
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
        return
    end

    if originals[obj] == nil then
        originals[obj] = obj.Text
    end

    local original = originals[obj]
    if type(original) ~= "string" or original == "" then return end

    if currentLanguage == "en" then
        applyText(obj, original)
        return
    end

    local translated = translations[original] or cache[original]
    if translated then
        applyText(obj, translated)
    else
        enqueue(original)
    end

    -- Watch changes made by the game's own UI after the object was discovered.
    if not watchedObjects[obj] then
        watchedObjects[obj] = true
        obj:GetPropertyChangedSignal("Text"):Connect(function()
            if applyingTranslation[obj] then return end
            if not obj.Parent then return end

            local newText = obj.Text
            if type(newText) ~= "string" or newText == "" then return end

            -- If the displayed text is our known translation, don't replace original.
            local oldOriginal = originals[obj]
            if oldOriginal and (translations[oldOriginal] == newText or cache[oldOriginal] == newText) then
                return
            end

            originals[obj] = newText
            if currentLanguage == "vi" then
                local result = translations[newText] or cache[newText]
                if result then
                    applyText(obj, result)
                else
                    enqueue(newText)
                end
            end
        end)
    end
end

-- Translate queue runs one request at a time to avoid flooding the network.
task.spawn(function()
    while true do
        local original = table.remove(queue, 1)
        if original then
            local translated
            local ok, result = pcall(translateOnline, original)
            if ok then translated = result end

            if translated then
                cache[original] = translated
                if currentLanguage == "vi" then
                    for obj, savedOriginal in pairs(originals) do
                        if obj and obj.Parent and savedOriginal == original then
                            applyText(obj, translated)
                        end
                    end
                end
            end

            queued[original] = nil
            task.wait(TRANSLATION_WAIT)
        else
            task.wait(0.2)
        end
    end
end)

local function scanGui()
    if scanBusy then
        scanAgain = true
        return
    end

    scanBusy = true
    task.spawn(function()
        repeat
            scanAgain = false
            local objects = {}

            for _, root in ipairs(getRoots()) do
                local ok, descendants = pcall(function()
                    return root:GetDescendants()
                end)

                if ok and descendants then
                    for _, obj in ipairs(descendants) do
                        if not (obj:IsA("ScreenGui") and obj.Name == GUI_NAME) then
                            if not knownObjects[obj] then
                                knownObjects[obj] = true
                                table.insert(objects, obj)
                            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                                -- Revisit text objects only when a manual/rescan is requested.
                                table.insert(objects, obj)
                            end
                        end
                    end
                end
            end

            for i = 1, #objects, BATCH_SIZE do
                local last = math.min(i + BATCH_SIZE - 1, #objects)
                for j = i, last do
                    pcall(processObject, objects[j])
                end
                task.wait(BATCH_WAIT)
            end
        until not scanAgain

        scanBusy = false
    end)
end

-- Remove previous translator panel so re-execution does not duplicate it.
for _, root in ipairs(getRoots()) do
    pcall(function()
        local old = root:FindFirstChild(GUI_NAME)
        if old then old:Destroy() end
    end)
end

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.DisplayOrder = 9999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parent
for _, root in ipairs(getRoots()) do
    parent = root
    break
end

if parent then
    gui.Parent = parent
else
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
title.Text = "✦ NHAT KHANH VIET HOA"
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

local activeColor = Color3.fromRGB(115, 70, 205)
local inactiveColor = Color3.fromRGB(55, 58, 78)

local vi = makeButton("VietnameseButton", "🇻🇳 TIẾNG VIỆT", 7, activeColor)
local en = makeButton("EnglishButton", "🌐 ENGLISH", 139, inactiveColor)

local function setLanguage(lang)
    currentLanguage = lang
    vi.BackgroundColor3 = lang == "vi" and activeColor or inactiveColor
    en.BackgroundColor3 = lang == "en" and activeColor or inactiveColor
    scanGui()
end

vi.Activated:Connect(function()
    setLanguage("vi")
end)

en.Activated:Connect(function()
    setLanguage("en")
end)

-- Drag panel with mouse or touch
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

-- Initial scan and low-frequency fallback scan for late-created UI.
task.spawn(function()
    task.wait(1)
    scanGui()
    while gui and gui.Parent do
        task.wait(SCAN_INTERVAL)
        scanGui()
    end
end)

-- Watch for new GUI objects as they are added; avoid rescanning everything.
for _, root in ipairs(getRoots()) do
    root.DescendantAdded:Connect(function(obj)
        task.defer(function()
            pcall(processObject, obj)
        end)
    end)
end

print("[Nhat Khanh Viet Hoa] Low-lag translator da khoi dong")
