
--==================================================
-- SENA HUB X NHAT KHANH
-- MINI GUI + AUTO VIETNAMESE TRANSLATOR
--==================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local GUI_NAME = "SenaHubXNhatKhanh"

--==================================================
-- 1. TRANSLATION SETTINGS
--==================================================

local language = "vi"
local originals = setmetatable({}, {__mode = "k"})
local lastApplied = setmetatable({}, {__mode = "k"})
local cache = {}
local pending = {}
local queue = {}
local MAX_LENGTH = 450

-- Dictionary fallback
local translations = {
    ["Sena Exclusive"] = "Sena Độc Quyền",
    ["Donate"] = "Ủng hộ",
    ["Home"] = "Trang chủ",
    ["Steal"] = "Cướp",
    ["Eggs"] = "Trứng",
    ["Pets"] = "Thú cưng",
    ["Events"] = "Sự kiện",
    ["Farm"] = "Nông trại",
    ["Task Order"] = "Thứ tự nhiệm vụ",
    ["Auto Steal"] = "Tự động cướp",
    ["Auto Sell"] = "Tự động bán",
    ["Auto Hatch"] = "Tự động mở trứng",
    ["Auto Fishing"] = "Tự động câu cá",
    ["Auto Mobs"] = "Tự động đánh quái",
    ["Shooting Star"] = "Sao băng",
    ["Search"] = "Tìm kiếm",
    ["Settings"] = "Cài đặt",
    ["Reset"] = "Đặt lại",
    ["Close"] = "Đóng",
    ["Open"] = "Mở",
    ["Save"] = "Lưu",
    ["Cancel"] = "Hủy",
    ["Enabled"] = "Đã bật",
    ["Disabled"] = "Đã tắt",
    ["English"] = "Tiếng Anh",
    ["Waiting for reset wall"] = "Đang chờ tường đặt lại",
    ["No star right now"] = "Hiện không có sao",
    ["Auto Steal (Normal)"] = "Tự động cướp (Thường)",
    ["Auto Steal (Halloween)"] = "Tự động cướp (Halloween)",
    ["High-Value Zone First (Halloween)"] =
        "Ưu tiên khu vực giá trị cao (Halloween)",
    ["Carry Speed (Halloween)"] =
        "Tốc độ mang trứng (Halloween)",
    ["Steals normal-world eggs that match your filters and brings them home."] =
        "Tự động cướp trứng phù hợp bộ lọc và mang về nhà.",
    ["Auto-farms Halloween eggs into Candy Corn. Runs on its own and keeps going after a rejoin."] =
        "Tự động farm trứng Halloween để nhận Candy Corn và tiếp tục sau khi vào lại.",
}

--==================================================
-- 2. ACCESSIBLE GUI ROOTS
--==================================================

local function getRoots()
    local roots = {playerGui, CoreGui}

    pcall(function()
        if type(gethui) == "function" then
            table.insert(roots, gethui())
        end
    end)

    return roots
end

--==================================================
-- 3. ONLINE TRANSLATION
--==================================================

local function translateOnline(text)
    if translations[text] then
        return translations[text]
    end

    if cache[text] then
        return cache[text]
    end

    local url =
        "https://translate.googleapis.com/translate_a/single"
        .. "?client=gtx&sl=auto&tl=vi&dt=t&q="
        .. HttpService:UrlEncode(text)

    local body

    local requestFunc
    if type(request) == "function" then
        requestFunc = request
    elseif type(http_request) == "function" then
        requestFunc = http_request
    end

    if requestFunc then
        local response = requestFunc({
            Url = url,
            Method = "GET"
        })

        assert(response, "No HTTP response")

        local status = response.StatusCode
            or response.Status
        assert(status == 200, "Translation HTTP error")

        body = response.Body
    else
        body = game:HttpGet(url)
    end

    local data = HttpService:JSONDecode(body)
    local parts = {}

    if type(data) == "table"
        and type(data[1]) == "table" then

        for _, segment in ipairs(data[1]) do
            if type(segment) == "table"
                and type(segment[1]) == "string" then
                table.insert(parts, segment[1])
            end
        end
    end

    local result = table.concat(parts)
    assert(result ~= "", "Empty translation result")

    cache[text] = result
    return result
end

--==================================================
-- 4. TRANSLATION QUEUE
--==================================================

local function enqueue(obj, original)
    if not original or original == ""
        or #original > MAX_LENGTH then
        return
    end

    if translations[original] then
        obj.Text = translations[original]
        lastApplied[obj] = obj.Text
        return
    end

    if cache[original] then
        obj.Text = cache[original]
        lastApplied[obj] = obj.Text
        return
    end

    if pending[original] then
        return
    end

    pending[original] = true
    table.insert(queue, {
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
                for obj, original in pairs(originals) do
                    if obj.Parent
                        and original == item.text
                        and language == "vi" then

                        pcall(function()
                            obj.Text = result
                            lastApplied[obj] = result
                        end)
                    end
                end
            else
                warn(
                    "[Sena Translator] Translation failed:",
                    tostring(result)
                )

                -- Retry failed requests after a delay
                task.delay(5, function()
                    if language == "vi" and not pending[item.text] then
                        pending[item.text] = true
                        table.insert(queue, {
                            text = item.text
                        })
                    end
                end)
            end

            task.wait(0.3)
        else
            task.wait(0.1)
        end
    end
end)

--==================================================
-- 5. SCAN ALL ACCESSIBLE TEXT
--==================================================

local function scan()
    for _, root in ipairs(getRoots()) do
        pcall(function()
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("TextLabel")
                    or obj:IsA("TextButton")
                    or obj:IsA("TextBox") then

                    if obj:FindFirstAncestor(GUI_NAME) then
                        continue
                    end

                    local current = obj.Text

                    if originals[obj] == nil then
                        originals[obj] = current
                    elseif current ~= lastApplied[obj] then
                        -- Capture text updated by the game
                        originals[obj] = current
                    end

                    local original = originals[obj]

                    if language == "vi" then
                        if translations[original] then
                            obj.Text = translations[original]
                            lastApplied[obj] = obj.Text
                        elseif cache[original] then
                            obj.Text = cache[original]
                            lastApplied[obj] = obj.Text
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

--==================================================
-- 6. REMOVE OLD GUI
--==================================================

for _, root in ipairs(getRoots()) do
    pcall(function()
        local old = root:FindFirstChild(GUI_NAME)
        if old then
            old:Destroy()
        end
    end)
end

--==================================================
-- 7. CREATE COMPACT LANGUAGE GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "LanguagePanel"
frame.Size = UDim2.fromOffset(220, 64)
frame.Position = UDim2.new(0.5, 120, 0, 8)
frame.BackgroundColor3 = Color3.fromRGB(24, 25, 38)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius =
    UDim.new(0, 10)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(220, 100, 190)
stroke.Thickness = 1.3
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -8, 0, 23)
title.Position = UDim2.fromOffset(4, 0)
title.BackgroundTransparency = 1
title.Text = "Sena Hub X Nhat Khanh"
title.TextColor3 = Color3.fromRGB(255, 150, 220)
title.TextSize = 11
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function createButton(name, text, x)
    local b = Instance.new("TextButton")
    b.Name = name
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

local viButton = createButton(
    "VietnameseButton", "🇻🇳 TIẾNG VIỆT", 5
)

local enButton = createButton(
    "EnglishButton", "🌐 ENGLISH", 113
)

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

--==================================================
-- 8. DRAG GUI
--==================================================

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

--==================================================
-- 9. START IN VIETNAMESE + CONTINUOUS SCANNING
--==================================================

task.spawn(function()
    task.wait(2)
    setLanguage("vi")

    while gui.Parent do
        if language == "vi" then
            local ok, err = pcall(scan)

            if not ok then
                warn("[Sena Translator] Scan error:", err)
            end
        end

        task.wait(1)
    end
end)

print("[Sena Hub X Nhat Khanh] Translator started")
