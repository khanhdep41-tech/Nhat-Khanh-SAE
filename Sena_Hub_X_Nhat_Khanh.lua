
-- NHAT KHANH VIET HOA - STEAL AN EGG
-- Tu dien Viet hoa giao dien game

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
if not player then return end

local GUI_NAME = "NhatKhanhVietHoa"
local language = "vi"
local originals = setmetatable({}, {__mode = "k"})
local busy = false
local gui

local translations = {
    ["Settings"]="Cài đặt", ["Setting"]="Cài đặt",
    ["Home"]="Trang chủ", ["Main"]="Chính", ["Donate"]="Ủng hộ",
    ["Donator"]="Người ủng hộ", ["Steal"]="Cướp",
    ["Eggs &..."]="Trứng và...", ["Pets"]="Thú cưng",
    ["Events"]="Sự kiện", ["Farm"]="Nông trại",
    ["Tools"]="Công cụ", ["Search"]="Tìm kiếm",
    ["Reset"]="Đặt lại", ["Task Order"]="Thứ tự nhiệm vụ",
    ["Auto Steal"]="Tự động cướp",
    ["Auto Steal (Normal)"]="Tự động cướp (Thế giới thường)",
    ["Auto Steal (Halloween)"]="Tự động cướp (Halloween)",
    ["Shooting Star"]="Sao băng",
    ["Waiting for reset wall"]="Đang chờ tường đặt lại",
    ["No star right now"]="Hiện không có sao băng",
    ["Auto Mobs"]="Tự động đánh quái",
    ["Auto Fishing"]="Tự động câu cá",
    ["Egg Automation"]="Tự động hóa trứng",
    ["Placed Eggs"]="Trứng đã đặt",
    ["Your placed eggs"]="Trứng bạn đã đặt",
    ["Egg Selling"]="Bán trứng",
    ["Pet Selling"]="Bán thú cưng",
    ["Equip & Collect"]="Trang bị và thu thập",
    ["Auto Sell Pet"]="Tự động bán thú cưng",
    ["Keep Mutated Pets"]="Giữ thú cưng đột biến",
    ["Pet Name Filter"]="Lọc theo tên thú cưng",
    ["Pet Rarity Filter"]="Lọc theo độ hiếm thú cưng",
    ["Auto Favorite"]="Tự động yêu thích",
    ["Favorite Rule"]="Quy tắc yêu thích",
    ["Rarities to Keep"]="Độ hiếm cần giữ",
    ["Species to Keep"]="Loài cần giữ",
    ["Auto Fuse"]="Tự động hợp nhất",
    ["Fusion Rule"]="Quy tắc hợp nhất",
    ["Rarities to Fuse"]="Độ hiếm cần hợp nhất",
    ["Species to Fuse"]="Loài cần hợp nhất",
    ["Only when Rule = Rarity"]="Chỉ khi quy tắc là Độ hiếm",
    ["Only when Rule = Species"]="Chỉ khi quy tắc là Loài",
    ["Only when Rule = Selected Species"]="Chỉ với loài đã chọn",
    ["Any Species"]="Mọi loài", ["Rarity"]="Độ hiếm",
    ["Species"]="Loài", ["None"]="Không có",
    ["All"]="Tất cả", ["Common"]="Phổ biến",
    ["Uncommon"]="Ít phổ biến", ["Rare"]="Hiếm",
    ["Epic"]="Sử thi", ["Legendary"]="Huyền thoại",
    ["Mythic"]="Thần thoại", ["Secret"]="Bí mật",
    ["Eternal"]="Vĩnh hằng", ["Divine"]="Thần thánh",
    ["Silver"]="Bạc", ["Golden"]="Vàng",
    ["Rainbow"]="Cầu vồng", ["Scrambled"]="Xáo trộn",
    ["Enchanted"]="Phù phép", ["Not mutated"]="Chưa đột biến",
    ["Ready to hatch"]="Sẵn sàng nở", ["Find"]="Tìm",
    ["Placed"]="Đã đặt", ["Loading..."]="Đang tải...",
    ["Close"]="Đóng", ["Open"]="Mở", ["Save"]="Lưu",
    ["Cancel"]="Hủy", ["Confirm"]="Xác nhận",
    ["Enabled"]="Đã bật", ["Disabled"]="Đã tắt",
    ["Enable"]="Bật", ["Disable"]="Tắt",
    ["On"]="Bật", ["Off"]="Tắt",
    ["Free"]="Miễn phí", ["Locked"]="Đã khóa",
    ["Unlocked"]="Đã mở khóa", ["Buy"]="Mua",
    ["Sell"]="Bán", ["Sell All"]="Bán tất cả",
    ["Collect"]="Thu thập", ["Collect All"]="Thu thập tất cả",
    ["Equip"]="Trang bị", ["Unequip"]="Tháo trang bị",
    ["Upgrade"]="Nâng cấp", ["Back"]="Quay lại",
    ["Claim"]="Nhận", ["Claim All"]="Nhận tất cả",
    ["Success"]="Thành công", ["Failed"]="Thất bại",
    ["Error"]="Lỗi", ["Warning"]="Cảnh báo",
    ["Please wait"]="Vui lòng chờ",
    ["Try Again"]="Thử lại", ["Rejoin"]="Vào lại máy chủ",
    ["Server"]="Máy chủ", ["Server Full"]="Máy chủ đã đầy",
    ["Leaderboard"]="Bảng xếp hạng",
    ["Time Left"]="Thời gian còn lại",
    ["Halloween Status"]="Trạng thái Halloween",
    ["Idle."]="Đang chờ.", ["Halloween"]="Halloween",
    ["Candy Corn"]="Kẹo ngô",
    ["Normal World"]="Thế giới thường",
    ["Halloween World"]="Thế giới Halloween",
    ["Dimension Shop"]="Cửa hàng không gian",
    ["Safe Zone"]="Khu vực an toàn",
    ["Nearby Zones"]="Khu vực lân cận",
    ["Priority"]="Ưu tiên", ["Normal"]="Thường",
    ["Low Speed"]="Tốc độ thấp",
    ["High Speed"]="Tốc độ cao",
    ["Boost for Mode Low Speed"]="Tăng cường chế độ tốc độ thấp",
    ["High-Value Zone First (Halloween)"]="Ưu tiên khu vực giá trị cao (Halloween)",
    ["Carry Speed (Halloween)"]="Tốc độ mang trứng (Halloween)",
    ["Auto Buy Egg (Halloween)"]="Tự động mua trứng (Halloween)",
    ["Cross-World Priority (Halloween)"]="Ưu tiên giữa các thế giới (Halloween)",
    ["Open Hop UI"]="Mở giao diện chuyển máy chủ",
    ["Help Friend"]="Giúp bạn bè",
    ["Aura Bat"]="Gậy Aura",
    ["Steal Other Script"]="Cướp trứng từ script khác",
    ["Auto Sell"]="Tự động bán",
    ["Auto Hatch"]="Tự động ấp",
    ["Auto Farm"]="Tự động cày",
    ["Auto Buy"]="Tự động mua",
    ["Pet"]="Thú cưng", ["Egg"]="Trứng",
    ["Eggs"]="Trứng", ["Mutation"]="Đột biến",
    ["Mutated"]="Đột biến", ["Speed"]="Tốc độ",
    ["Walk Speed"]="Tốc độ di chuyển",
    ["Money"]="Tiền", ["Cash"]="Tiền mặt",
    ["Coins"]="Xu", ["Level"]="Cấp độ",
    ["Max"]="Tối đa", ["Capacity"]="Sức chứa",
    ["Full"]="Đầy", ["Empty"]="Trống",
    ["Chance"]="Tỷ lệ", ["Luck"]="May mắn",
    ["Rewards"]="Phần thưởng", ["Reward"]="Phần thưởng",
    ["Update"]="Cập nhật", ["New"]="Mới",
    ["Coming Soon"]="Sắp ra mắt",
    ["Are you sure?"]="Bạn có chắc không?",
    ["Not Enough Money"]="Không đủ tiền",
    ["Inventory Full"]="Túi đồ đã đầy",
    ["Purchase Successful"]="Mua thành công",
    ["Rare Egg"]="Trứng hiếm",
    ["Egg Spawn"]="Trứng xuất hiện",
    ["Pet Storage"]="Kho thú cưng",
    ["Pet Capacity"]="Sức chứa thú cưng",
    ["Equip Pet"]="Trang bị thú cưng",
    ["Best Pet"]="Thú cưng tốt nhất",
    ["Treadmill"]="Máy chạy bộ",
    ["Training"]="Đang luyện tập",
    ["Multiplier"]="Hệ số nhân",
    ["Boost"]="Tăng cường",
    ["Upgrade Speed"]="Nâng cấp tốc độ",
    ["Chicken Egg"]="Trứng Gà",
    ["Swan Egg"]="Trứng Thiên Nga",
    ["Scorpion Egg"]="Trứng Bọ Cạp",
    ["Tiger Egg"]="Trứng Hổ",
    ["Yeti Egg"]="Trứng Yeti",
    ["Hellhound Egg"]="Trứng Chó Địa Ngục",
    ["Dragon Egg"]="Trứng Rồng",
    ["T-Rex Egg"]="Trứng T-Rex",
    ["Eternal Phoenix Egg"]="Trứng Phượng Hoàng Vĩnh Hằng",
    ["Cherry Blossom Egg"]="Trứng Hoa Anh Đào",
    ["Halloween Egg"]="Trứng Halloween",
    ["Extinction Egg"]="Trứng Tuyệt Chủng",
    ["Luminous Egg"]="Trứng Phát Sáng",
    ["Chicken"]="Gà", ["Bird"]="Chim", ["Owl"]="Cú",
    ["Raccoon"]="Gấu mèo", ["Frog"]="Ếch",
    ["Swan"]="Thiên nga", ["Scorpion"]="Bọ cạp",
    ["Tiger"]="Hổ", ["Phoenix"]="Phượng hoàng",
    ["Snow Owl"]="Cú tuyết", ["Red Panda"]="Gấu trúc đỏ",
    ["Unicorn"]="Kỳ lân", ["Gorilla King"]="Vua khỉ đột",
    ["King Mammoth"]="Voi ma mút vua",
}

local phrases = {
    ["Steals normal-world eggs that match your filters and brings them home."] =
        "Tự động cướp trứng ở thế giới thường phù hợp với bộ lọc và mang chúng về nhà.",
    ["Auto-farms Halloween eggs into Candy Corn. Runs on its own and keeps going after a rejoin."] =
        "Tự động cày trứng Halloween để nhận Kẹo ngô. Tiếp tục chạy sau khi vào lại máy chủ.",
    ["Buys a Halloween egg from the dimension shop each time Candy Corn reaches 2250."] =
        "Mua trứng Halloween từ cửa hàng không gian mỗi khi Kẹo ngô đạt 2250.",
    ["Never sells a pet that has any mutation, even if it matches the filters below."] =
        "Không bán thú cưng có đột biến, kể cả khi phù hợp với bộ lọc bên dưới.",
    ["Match pets by rarity or by species."] =
        "Chọn thú cưng theo độ hiếm hoặc theo loài.",
    ["Pets of these rarities get favorited."] =
        "Thú cưng thuộc độ hiếm này sẽ được đánh dấu yêu thích.",
    ["Pets of these species get favorited."] =
        "Thú cưng thuộc các loài này sẽ được đánh dấu yêu thích.",
    ["Only fuse pets of these rarities. Leave empty for any rarity."] =
        "Chỉ hợp nhất thú cưng thuộc các độ hiếm này. Để trống để áp dụng mọi độ hiếm.",
    ["Only these species go into the machine."] =
        "Chỉ những loài này được đưa vào máy.",
}

local function trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function translateText(text)
    if type(text) ~= "string" or text == "" then
        return text
    end

    local clean = trim(text)
    if translations[clean] then
        return translations[clean]
    end
    if phrases[clean] then
        return phrases[clean]
    end

    local result = text
    local keys = {}
    for key in pairs(translations) do
        if #key >= 4 then
            table.insert(keys, key)
        end
    end
    table.sort(keys, function(a, b)
        return #a > #b
    end)

    for _, key in ipairs(keys) do
        local pattern = key:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
        result = result:gsub(pattern, function()
            return translations[key]
        end)
    end

    return result
end

local function getRoots()
    local roots, seen = {}, {}
    local function add(obj)
        if obj and not seen[obj] then
            seen[obj] = true
            table.insert(roots, obj)
        end
    end

    pcall(function()
        if type(gethui) == "function" then
            add(gethui())
        end
    end)
    pcall(function()
        add(player:FindFirstChildOfClass("PlayerGui"))
    end)
    pcall(function()
        add(game:GetService("CoreGui"))
    end)
    return roots
end

local function scanGui()
    if busy then return end
    busy = true

    for _, root in ipairs(getRoots()) do
        pcall(function()
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("TextLabel")
                or obj:IsA("TextButton")
                or obj:IsA("TextBox") then
                    if not (gui and obj:IsDescendantOf(gui)) then
                        if originals[obj] == nil then
                            originals[obj] = obj.Text
                        end

                        local original = originals[obj]
                        if language == "vi" then
                            obj.Text = translateText(original)
                        else
                            obj.Text = original
                        end
                    end
                end
            end
        end)
    end

    busy = false
end

-- Xoa giao dien cu neu da ton tai
for _, root in ipairs(getRoots()) do
    pcall(function()
        local old = root:FindFirstChild(GUI_NAME)
        if old then old:Destroy() end
    end)
end

gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.DisplayOrder = 9999
gui.Parent = getRoots()[1] or player:WaitForChild("PlayerGui")

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
    button.Parent = frame
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    return button
end

local activeColor = Color3.fromRGB(100, 70, 210)
local inactiveColor = Color3.fromRGB(55, 58, 78)
local vi = makeButton("VietnameseButton", "🇻🇳 TIẾNG VIỆT", 7, activeColor)
local en = makeButton("EnglishButton", "🌐 ENGLISH", 139, inactiveColor)

local function setLanguage(lang)
    language = lang
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

-- Keo bang ngon tay hoac chuot
local dragging, dragStart, startPos = false, nil, nil
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

task.spawn(function()
    task.wait(1)
    scanGui()
    while gui.Parent do
        task.wait(1.5)
        scanGui()
    end
end)

print("[Nhat Khanh Viet Hoa] Da khoi dong tu dien Steal An Egg")
