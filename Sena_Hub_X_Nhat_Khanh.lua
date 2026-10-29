
--[[
    NHAT KHANH VIET HOA
    Universal GUI Translator
    - Online translation + built-in dictionary
    - Auto scan new GUI text
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
local originals = setmetatable({}, {__mode = "k"})
local cache = {}
local queued = {}
local queue = {}
local scanning = false

-- Tu dien co san: uu tien dich nhanh, khong can Internet
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

-- Tim noi nhan HTTP phu hop voi executor
local function getRequestFunction()
    if type(request) == "function" then
        return request
    end

    if type(http_request) == "function" then
        return http_request
    end

    if type(syn) == "table" and type(syn.request) == "function" then
        return syn.request
    end

    return nil
end

-- Dich truc tuyen qua Google Translate
local function translateOnline(text)
    if type(text) ~= "string" or text == "" then
        return nil
    end

    if translations[text] then
        return translations[text]
    end

    if cache[text] then
        return cache[text]
    end

    -- Bo qua chu chi co ky tu dac biet hoac so
    if not text:find("%a") or #text > 450 then
        return nil
    end

    local url =
        "https://translate.googleapis.com/translate_a/single"
        .. "?client=gtx&sl=auto&tl=vi&dt=t&q="
        .. HttpService:UrlEncode(text)

    local body

    local requestFunction = getRequestFunction()
    if requestFunction then
        local ok, response = pcall(function()
            return requestFunction({
                Url = url,
                Method = "GET",
                Headers = {
                    ["Accept"] = "application/json"
                }
            })
        end)

        if ok and type(response) == "table" then
            body = response.Body or response.body
        end
    end

    -- Phuong an du phong neu game:HttpGet duoc executor ho tro
    if type(body) ~= "string" then
        local ok, result = pcall(function()
            return game:HttpGet(url)
        end)

        if ok and type(result) == "string" then
            body = result
        end
    end

    if type(body) ~= "string" then
        return nil
    end

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
    if result ~= "" then
        cache[text] = result
        return result
    end

    return nil
end

-- Tim cac noi co the truy cap
local function getRoots()
    local roots = {}
    local seen = {}

    local function add(root)
        if root and not seen[root] then
            seen[root] = true
            table.insert(roots, root)
        end
    end

    local ok, hui = pcall(function()
        if type(gethui) == "function" then
            return gethui()
        end
    end)
    if ok then add(hui) end

    local ok2, playerGui = pcall(function()
        return player:FindFirstChildOfClass("PlayerGui")
    end)
    if ok2 then add(playerGui) end

    return roots
end

-- Hang doi dich tu tu de giam nguy co bi gioi han request
local function enqueue(text)
    if queued[text] or cache[text] or translations[text] then
        return
    end

    queued[text] = true
    table.insert(queue, text)
end

task.spawn(function()
    while true do
        local text = table.remove(queue, 1)

        if text then
            local translated = translateOnline(text)
            if translated then
                cache[text] = translated
            end

            queued[text] = nil

            -- Cap nhat cac GUI dang hien thi sau khi co ban dich
            if translated and currentLanguage == "vi" then
                for obj, original in pairs(originals) do
                    if obj and obj.Parent and original == text then
                        pcall(function()
                            obj.Text = translated
                        end)
                    end
                end
            end

            task.wait(0.12)
        else
            task.wait(0.15)
        end
    end
end)

local function translateText(original)
    if translations[original] then
        return translations[original]
    end

    if cache[original] then
        return cache[original]
    end

    enqueue(original)
    return original
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

                    local original = originals[obj]

                    if currentLanguage == "vi" then
                        obj.Text = translateText(original)
                    else
                        obj.Text = original
                    end
                end
            end
        end)
    end

    scanning = false
end

-- Xoa GUI cu neu script duoc chay lai
for _, root in ipairs(getRoots()) do
    pcall(function()
        local old = root:FindFirstChild(GUI_NAME)
        if old then old:Destroy() end
    end)
end

-- Tao GUI
local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.DisplayOrder = 9999

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

local vi = makeButton(
    "VietnameseButton",
    "🇻🇳 TIẾNG VIỆT",
    7,
    activeColor
)

local en = makeButton(
    "EnglishButton",
    "🌐 ENGLISH",
    139,
    inactiveColor
)

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

-- Keo GUI bang chuot hoac cam ung
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

-- Quet ngay va quet lai de tim GUI moi
task.spawn(function()
    task.wait(1)
    scanGui()

    while gui.Parent do
        task.wait(2)
        scanGui()
    end
end)

print("[Nhat Khanh Viet Hoa] Translator da khoi dong")
