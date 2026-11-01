
--[[
    NHAT KHANH HUB
    Giao diện nhỏ gọn, có thể kéo trên màn hình.
    Ảnh nền tải từ GitHub và lưu vào file executor nếu được hỗ trợ.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local env = (getgenv and getgenv()) or _G

local IMAGE_URL =
    "https://raw.githubusercontent.com/khanhdep41-tech/Nhat-Khanh-SAE/refs/heads/main/IMG_9880.jpeg"

local FOLDER = "NhatKhanhHub"
local IMAGE_PATH = FOLDER .. "/IMG_9880.jpeg"

-- Xóa GUI cũ
pcall(function()
    if CoreGui:FindFirstChild("NhatKhanhHub") then
        CoreGui.NhatKhanhHub:Destroy()
    end

    local pg = player:FindFirstChildOfClass("PlayerGui")
    if pg and pg:FindFirstChild("NhatKhanhHub") then
        pg.NhatKhanhHub:Destroy()
    end
end)

-- Tải ảnh và lưu cục bộ nếu executor hỗ trợ
local function getLocalImageAsset()
    if type(writefile) ~= "function" then
        warn("[NHAT KHANH] Executor không hỗ trợ writefile.")
        return nil
    end

    local assetFn = getcustomasset or getsynasset
    if type(assetFn) ~= "function" then
        warn("[NHAT KHANH] Executor không hỗ trợ nạp ảnh cục bộ.")
        return nil
    end

    if type(makefolder) == "function" then
        pcall(makefolder, FOLDER)
    end

    -- Đọc ảnh đã lưu nếu có
    local data
    if type(isfile) == "function"
        and type(readfile) == "function"
        and isfile(IMAGE_PATH) then

        local okRead, result = pcall(readfile, IMAGE_PATH)
        if okRead and type(result) == "string"
            and #result > 0 then
            data = result
        end
    end

    -- Nếu chưa có thì tải ảnh mới
    if not data then
        local okHttp, result = pcall(function()
            return game:HttpGet(IMAGE_URL)
        end)

        if not okHttp or type(result) ~= "string"
            or #result == 0 then
            warn("[NHAT KHANH] Không tải được ảnh nền.")
            return nil
        end

        data = result

        local okWrite, err = pcall(writefile, IMAGE_PATH, data)
        if not okWrite then
            warn("[NHAT KHANH] Không lưu được ảnh: " .. tostring(err))
        end
    end

    local okAsset, asset = pcall(assetFn, IMAGE_PATH)
    if okAsset and type(asset) == "string" then
        return asset
    end

    warn("[NHAT KHANH] Không nạp được ảnh cục bộ.")
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

-- Tạo GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NhatKhanhHub"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local okParent = pcall(function()
    gui.Parent = CoreGui
end)

if not okParent or not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

-- Khung nhỏ bên phải màn hình
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

new("UICorner", {
    CornerRadius = UDim.new(0, 12)
}, panel)

new("UIStroke", {
    Color = Color3.fromRGB(105, 72, 132),
    Thickness = 1,
    Transparency = 0.65,
}, panel)

-- Ảnh nền
local imageAsset = getLocalImageAsset()

if imageAsset then
    new("ImageLabel", {
        Name = "BackgroundImage",
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0, 0),
        BackgroundTransparency = 1,
        Image = imageAsset,
        ImageTransparency = 0.15,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 1,
    }, panel)
end

-- Lớp phủ nhẹ để chữ dễ đọc
new("Frame", {
    Name = "ImageShade",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(16, 10, 24),
    BackgroundTransparency = imageAsset and 0.55 or 0.02,
    BorderSizePixel = 0,
    ZIndex = 2,
}, panel)

-- Thanh tiêu đề
local header = new("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Active = true,
    ZIndex = 3,
}, panel)

new("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -48, 1, 0),
    Position = UDim2.fromOffset(12, 0),
    BackgroundTransparency = 1,
    Text = "NHAT KHANH",
    TextColor3 = Color3.fromRGB(230, 170, 255),
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
}, header)

local close = new("TextButton", {
    Name = "Close",
    Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(1, -32, 0, 8),
    BackgroundColor3 = Color3.fromRGB(35, 28, 42),
    BackgroundTransparency = 0.25,
    Text = "×",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 19,
    Font = Enum.Font.Gotham,
    BorderSizePixel = 0,
    ZIndex = 4,
}, header)

new("UICorner", {
    CornerRadius = UDim.new(0, 6)
}, close)

-- Trạng thái
local status = new("TextLabel", {
    Name = "Status",
    Size = UDim2.new(1, -20, 0, 15),
    Position = UDim2.fromOffset(10, 43),
    BackgroundTransparency = 1,
    Text = "Sẵn sàng",
    TextColor3 = Color3.fromRGB(230, 220, 235),
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
}, panel)

-- Tạo hàng công tắc
local function createToggle(label, y)
    local row = new("Frame", {
        Name = "ToggleRow",
        Size = UDim2.new(1, -20, 0, 42),
        Position = UDim2.fromOffset(10, y),
        BackgroundColor3 = Color3.fromRGB(72, 43, 95),
        BackgroundTransparency = 0.28,
        BorderSizePixel = 0,
        ZIndex = 3,
    }, panel)

    new("UICorner", {
        CornerRadius = UDim.new(0, 9)
    }, row)

    new("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -75, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Color3.fromRGB(255, 250, 255),
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

    new("UICorner", {
        CornerRadius = UDim.new(1, 0)
    }, switch)

    local knob = new("Frame", {
        Name = "Knob",
        Size = UDim2.fromOffset(19, 19),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = Color3.fromRGB(250, 250, 250),
        BorderSizePixel = 0,
        ZIndex = 5,
    }, switch)

    new("UICorner", {
        CornerRadius = UDim.new(1, 0)
    }, knob)

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

local autoBtn, renderAuto =
    createToggle("Tự động lấy trứng", 62)

local snipeBtn, renderSnipe =
    createToggle("Săn trứng từ script khác", 111)

-- Kết nối runtime Sena
local function getRuntime()
    return env.__SenaV4EggRuntime
end

autoBtn.Activated:Connect(function()
    local rt = getRuntime()

    if not rt or type(rt.setEnabled) ~= "function" then
        status.Text = "Không tìm thấy runtime Sena"
        warn("[NHAT KHANH] Không tìm thấy runtime Auto Steal.")
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
        status.Text = "Tự động lấy trứng: "
            .. (autoOn and "BẬT" or "TẮT")
    else
        status.Text = "Lỗi bật/tắt tự động"
        warn("[NHAT KHANH] " .. tostring(err))
    end
end)

snipeBtn.Activated:Connect(function()
    local rt = getRuntime()

    if not rt then
        status.Text = "Không tìm thấy runtime Sena"
        warn("[NHAT KHANH] Không tìm thấy runtime.")
        return
    end

    local nextValue = not snipeOn

    local success, err = pcall(function()
        if type(rt._reconcileRunningState) == "function" then
            rt:_reconcileRunningState()
        end

        if nextValue then
            assert(type(rt._installSnipeHook) == "function",
                "Thiếu _installSnipeHook")
            rt:_installSnipeHook()
        else
            assert(type(rt._removeSnipeHook) == "function",
                "Thiếu _removeSnipeHook")
            rt:_removeSnipeHook()
        end
    end)

    if success then
        snipeOn = nextValue
        renderSnipe(snipeOn)
        status.Text = "Săn trứng script khác: "
            .. (snipeOn and "BẬT" or "TẮT")
    else
        status.Text = "Lỗi hook săn trứng"
        warn("[NHAT KHANH] " .. tostring(err))
    end
end)

-- Kéo GUI bằng thanh tiêu đề, hỗ trợ cảm ứng
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
    if dragging and (
        input == dragInput
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
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

print("[NHAT KHANH] GUI đã tải; vị trí mặc định bên phải.")
