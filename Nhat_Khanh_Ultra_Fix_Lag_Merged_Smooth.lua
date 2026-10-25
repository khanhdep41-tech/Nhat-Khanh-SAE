-- Utra FixLag / Nhat Khanh Hub - Giao dien tieng Viet + bang mini theo doi hieu nang
-- GUI appears immediately. On startup it runs the full extracted v390 startup optimization; Super Fix Lag runs the original v391 chain plus extra optimization.
-- No restore/toggle-off is provided for FPS Boost; original helper behavior hides/deletes other players' local visual models and map details.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Stats = game:GetService("Stats")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

pcall(function()
    local old = playerGui:FindFirstChild("NhatKhanhUtraFixLag_GUI")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "NhatKhanhUtraFixLag_GUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = parent
    return c
end
local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(75, 190, 255)
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.15
    s.Parent = parent
    return s
end
local function label(parent, text, size, pos, fontSize, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.Size = size
    l.Position = pos
    l.Font = font or Enum.Font.GothamMedium
    l.TextSize = fontSize or 13
    l.TextColor3 = color or Color3.fromRGB(240, 247, 255)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end
local function button(parent, text, size, pos, color)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = color or Color3.fromRGB(34, 54, 82)
    b.BorderSizePixel = 0
    b.AutoButtonColor = true
    b.Text = text
    b.TextColor3 = Color3.fromRGB(245, 250, 255)
    b.TextSize = 12
    b.Font = Enum.Font.GothamSemibold
    b.Parent = parent
    corner(b, 10)
    return b
end

-- Main panel
local main = Instance.new("Frame")
main.Name = "MainPanel"
main.Size = UDim2.fromOffset(285, 345)
main.Position = UDim2.new(0.5, -142, 0.5, -172)
main.BackgroundColor3 = Color3.fromRGB(14, 20, 34)
main.BorderSizePixel = 0
main.Active = true
main.Visible = true -- Vao game hien menu day du ngay
main.Parent = gui
corner(main, 16)
stroke(main, Color3.fromRGB(0, 220, 255), 1.4, 0.08)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(17, 38, 67)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 14, 29))
})
gradient.Rotation = 90
gradient.Parent = main

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, -14, 0, 48)
header.Position = UDim2.fromOffset(7, 7)
header.BackgroundColor3 = Color3.fromRGB(25, 44, 72)
header.BorderSizePixel = 0
header.Active = true
header.Parent = main
corner(header, 12)

local logo = label(header, "N", UDim2.fromOffset(30, 32), UDim2.fromOffset(10, 7), 22, Color3.fromRGB(83, 220, 255), Enum.Font.GothamBlack)
local title = label(header, "Utra FixLag / Nhat Khanh Hub", UDim2.new(1, -90, 0, 20), UDim2.fromOffset(43, 6), 14, Color3.fromRGB(245, 250, 255), Enum.Font.GothamBold)
local subtitle = label(header, "GIÁM SÁT HIỆU NĂNG TRỰC TIẾP", UDim2.new(1, -55, 0, 14), UDim2.fromOffset(43, 25), 8, Color3.fromRGB(145, 188, 220), Enum.Font.Gotham)
local hideBtn = button(header, "—", UDim2.fromOffset(28, 28), UDim2.new(1, -35, 0, 10), Color3.fromRGB(48, 70, 101))
hideBtn.TextSize = 18

label(main, "CHỨC NĂNG", UDim2.new(1, -28, 0, 18), UDim2.fromOffset(14, 64), 10, Color3.fromRGB(125, 170, 205), Enum.Font.GothamBold)

local fixBtn = button(main, "⚡  GIẢM GIẬT LAG", UDim2.new(1, -28, 0, 37), UDim2.fromOffset(14, 87), Color3.fromRGB(29, 87, 133))
local superBtn = button(main, "🚀  SIÊU GIẢM GIẬT LAG", UDim2.new(1, -28, 0, 37), UDim2.fromOffset(14, 132), Color3.fromRGB(78, 58, 135))
local capBtn = button(main, "🎯  BỎ GIỚI HẠN KHUNG HÌNH: TẮT", UDim2.new(1, -28, 0, 37), UDim2.fromOffset(14, 177), Color3.fromRGB(105, 83, 39))
local muteBtn = button(main, "🔇  TẮT ÂM THANH: TẮT", UDim2.new(1, -28, 0, 37), UDim2.fromOffset(14, 222), Color3.fromRGB(29, 105, 91))
local shaderBtn = button(main, "🎵  MỞ TRÌNH PHÁT NHẠC", UDim2.new(1, -28, 0, 37), UDim2.fromOffset(14, 267), Color3.fromRGB(111, 61, 135))
local status = label(main, "Trạng thái: menu sẵn sàng", UDim2.new(1, -28, 0, 18), UDim2.fromOffset(14, 311), 10, Color3.fromRGB(145, 188, 220), Enum.Font.Gotham)

-- Trình phát nhạc mini: thay thế hoàn toàn bảng Shader.
local musicPanel = Instance.new("Frame")
musicPanel.Name = "MusicPanel"
musicPanel.Size = UDim2.fromOffset(252, 565)
musicPanel.Position = UDim2.new(0.5, 150, 0.5, -282)
musicPanel.BackgroundColor3 = Color3.fromRGB(15, 21, 36)
musicPanel.BorderSizePixel = 0
musicPanel.Visible = false
musicPanel.Active = true
musicPanel.Parent = gui
corner(musicPanel, 15)
stroke(musicPanel, Color3.fromRGB(0, 220, 255), 1.3, 0.08)
local musicHead = Instance.new("Frame")
musicHead.Size = UDim2.new(1, -12, 0, 42)
musicHead.Position = UDim2.fromOffset(6, 6)
musicHead.BackgroundColor3 = Color3.fromRGB(24, 48, 70)
musicHead.BorderSizePixel = 0
musicHead.Active = true
musicHead.Parent = musicPanel
corner(musicHead, 10)
label(musicHead, "🎵  TRÌNH PHÁT NHẠC", UDim2.new(1, -48, 1, 0), UDim2.fromOffset(10, 0), 13, Color3.fromRGB(230, 250, 255), Enum.Font.GothamBold)
local musicHide = button(musicHead, "×", UDim2.fromOffset(26, 26), UDim2.new(1, -32, 0, 8), Color3.fromRGB(43, 82, 105))
musicHide.TextSize = 18
local currentTrackLabel = label(musicPanel, "Chưa phát bài nào", UDim2.new(1, -20, 0, 28), UDim2.fromOffset(10, 52), 10, Color3.fromRGB(120, 235, 255), Enum.Font.GothamBold)
currentTrackLabel.TextWrapped = true

-- Nhạc MP3 từ GitHub: Delta cần hỗ trợ HttpGet, writefile và getcustomasset.
local musicTracks = {
    {name="Tag Khỉ - Yung Ni99", artist="Yung Ni99", duration="MP3", url="https://raw.githubusercontent.com/ChilliHub-V5/chuyen-sv/refs/heads/main/Yung%20Ni99%20-%20Tag%20Khi%CC%89%20%5BOfficial%20Video%5D.mp3", file="utra_tag_khi.mp3"},
    {name="Người Dưng - Duzme Remix", artist="JACK - J97", duration="MP3", url="https://raw.githubusercontent.com/ChilliHub-V5/chuyen-sv/refs/heads/main/Ngu%CC%9Bo%CC%9B%CC%80i%20Du%CC%9Bng%20-%20JACK%20-%20J97%20(Duzme%20Remix)%20_%20Audio%20Lyrics.mp3", file="utra_nguoi_dung.mp3"},
    {name="Lưu Niên - Duzme Remix", artist="JACK - J97", duration="MP3", url="https://raw.githubusercontent.com/ChilliHub-V5/chuyen-sv/refs/heads/main/Lu%CC%9Bu%20Nie%CC%82n%20-%20JACK%20-%20J97%20(Duzme%20Remix)%20_%20Audio%20Lyrics.mp3", file="utra_luu_nien.mp3"},
    {name="Kiếp Sau Vẫn Muốn Cùng Em...", artist="Đinh Kiến Phương / Diễn Viên Akai", duration="MP3", url="https://raw.githubusercontent.com/ChilliHub-V5/chuyen-sv/refs/heads/main/Kie%CC%82%CC%81p%20sau%20va%CC%82%CC%83n%20muo%CC%82%CC%81n%20cu%CC%80ng%20em%20la%CC%A3%CC%82p%20gia%20%C4%91i%CC%80nh%20ke%CC%82%CC%81t%20ho%CC%82n-%C4%90inh%20Kie%CC%82%CC%81n%20Phu%CC%9Bo%CC%9Bng%20va%CC%80%20Die%CC%82%CC%83n%20Vie%CC%82n%20Akai%20To%CC%82%CC%89ng%20Ta%CC%80i%20OFFICIAL.mp3", file="utra_kiep_sau.mp3"},
    {name="Trăng Hoa Mây Mưa - Remix", artist="Bình Gold / Duzme", duration="MP3", url="https://raw.githubusercontent.com/ChilliHub-V5/chuyen-sv/refs/heads/main/Tra%CC%86ng%20Hoa%20Ma%CC%82y%20Mu%CC%9Ba%20-%20Bi%CC%80nh%20Gold%20(Duzme%20Remix)%20_%20Audio%20Lyrics.mp3", file="utra_trang_hoa_may_mua.mp3"},
    {name="Biển, Đảo Và Em - Remix", artist="LKN x ZANG", duration="MP3", url="https://raw.githubusercontent.com/ChilliHub-V5/chuyen-sv/refs/heads/main/Bie%CC%82%CC%89n,%20%C4%90a%CC%89o%20Va%CC%80%20Em%20-%20LKN%20X%20ZANG%20REMIX%20%20%7C%20%E9%A9%AC%E4%B9%9F_Crabbit%20-%20%E6%B5%B7%E5%B1%BF%E4%BD%A0.mp3", file="utra_bien_dao_va_em.mp3"},
    {name="Giáp Ất Bính Đinh - DJ Remix", artist="李佳薇", duration="MP3", url="https://raw.githubusercontent.com/ChilliHub-V5/chuyen-sv/refs/heads/main/Gia%CC%81p%20A%CC%82%CC%81t%20Bi%CC%81nh%20%C4%90inh%20%E6%9D%8E%E4%BD%B3%E8%96%87%20-%20%E7%94%B2%E4%B9%99%E4%B8%99%E4%B8%81%20-%20DJ%20Remix.%20Nha%CC%A3c%20Ne%CC%82%CC%80n%20Hot%20TikTok%20_%20Douyin%202026..mp3", file="utra_giap_at_binh_dinh.mp3"},
    {name="Vườn Hoa Con Cá - Remix", artist="O.lew / Anh Khoa ft. Naw Phi", duration="MP3", url="https://raw.githubusercontent.com/ChilliHub-V5/chuyen-sv/refs/heads/main/Vu%CC%9Bo%CC%9B%CC%80n%20Hoa%20Con%20Ca%CC%81%20(Anh%20Khoa%20ft.%20Naw%20Phi%20Remix)%20-%20O.lew%20%7C%20Hot%20TikTok%202024%20-%20Audio%20Lyrics%20Video.mp3", file="utra_vuon_hoa_con_ca.mp3"},
    {name="Buông Bỏ Sự Phụ Thuộc Nơi Anh", artist="Quinvy Remix", duration="MP3", url="https://raw.githubusercontent.com/ChilliHub-V5/chuyen-sv/refs/heads/main/%E7%A6%BB%E5%BC%80%E6%88%91%E7%9A%84%E4%BE%9D%E8%B5%96DJ%202026%20(%E7%8E%8B%E8%89%B3%E8%96%87)%20%7C%20Buo%CC%82ng%20Bo%CC%89%20Su%CC%9B%CC%A3%20Phu%CC%A3%20Thuo%CC%A3%CC%82c%20No%CC%9Bi%20Anh%20Remix%20-%20Quinvy%20Remix%20%7C%20Hot%20TikTok%202026.mp3", file="utra_buong_bo_phu_thuoc.mp3"},
    {name="Ex’s Hate Me (Part 2) - Drill Mix", artist="AMEE x B RAY x Prod. Neyun", duration="MP3", url="https://raw.githubusercontent.com/ChilliHub-V5/chuyen-sv/refs/heads/main/Ex%E2%80%99s%20Hate%20Me%20(Part%202)%20(Jerk%20Drill%20Mix)%20-%20AMEE%20x%20B%20RAY%20x%20Prod.%20Neyun%20%7C%20All%20My%20Ex%E2%80%99s%20Hate%20Me%20Drill.mp3", file="utra_exs_hate_me_part2.mp3"},
}
local musicSound = Instance.new("Sound")
musicSound.Name = "UtraFixLagMusicPlayer"
musicSound.Volume = 0.45
musicSound.Looped = false
musicSound.Parent = SoundService
local currentTrackIndex = 1
local musicTrackButtons = {}
local pauseMusicBtn
local playTrack
local function updateMusicTrackButtons()
    for i, b in ipairs(musicTrackButtons) do
        b.BackgroundColor3 = (i == currentTrackIndex) and Color3.fromRGB(18, 117, 137) or Color3.fromRGB(30, 43, 64)
        b.Text = (i == currentTrackIndex and "▶  " or "♪  ") .. musicTracks[i].name
    end
end
local function getLocalAsset(track)
    if type(writefile) ~= "function" or type(getcustomasset) ~= "function" then
        error("Delta cần hỗ trợ writefile và getcustomasset để phát MP3 từ GitHub")
    end
    local exists = false
    pcall(function() exists = isfile(track.file) end)
    if not exists then
        currentTrackLabel.Text = "Đang tải nhạc: " .. track.name
        local response = game:HttpGet(track.url)
        if type(response) ~= "string" or #response < 1024 then error("Tải MP3 thất bại hoặc file quá nhỏ") end
        writefile(track.file, response)
    end
    return getcustomasset(track.file)
end
playTrack = function(index)
    currentTrackIndex = ((index - 1) % #musicTracks) + 1
    local track = musicTracks[currentTrackIndex]
    musicSound:Stop()
    currentTrackLabel.Text = "Đang tải: " .. track.name
    updateMusicTrackButtons()
    task.spawn(function()
        local ok, assetOrError = pcall(getLocalAsset, track)
        if not ok then
            currentTrackLabel.Text = "Không tải/phát được: " .. track.name
            status.Text = tostring(assetOrError):sub(1, 80)
            return
        end
        musicSound.SoundId = assetOrError
        musicSound.TimePosition = 0
        local playOk, playError = pcall(function() musicSound:Play() end)
        if not playOk then
            currentTrackLabel.Text = "Không phát được: " .. track.name
            status.Text = tostring(playError):sub(1, 80)
        else
            currentTrackLabel.Text = "Đang phát: " .. track.name
            status.Text = "Đang phát nhạc: " .. track.name
            pauseMusicBtn.Text = "⏸ TẠM DỪNG"
        end
    end)
end
-- Danh sách bài hát và các nút điều khiển cùng nằm trong vùng cuộn dọc.
local musicList = Instance.new("ScrollingFrame")
musicList.Name = "MusicTrackList"
musicList.Size = UDim2.new(1, -20, 0, 440)
musicList.Position = UDim2.fromOffset(10, 84)
musicList.BackgroundTransparency = 1
musicList.BorderSizePixel = 0
musicList.Active = true
musicList.ScrollingEnabled = true
musicList.ScrollingDirection = Enum.ScrollingDirection.Y
musicList.ScrollBarThickness = 5
musicList.ScrollBarImageColor3 = Color3.fromRGB(66, 210, 245)
musicList.CanvasSize = UDim2.new(0, 0, 0, 0)
musicList.AutomaticCanvasSize = Enum.AutomaticSize.Y
musicList.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
musicList.Parent = musicPanel
local musicListLayout = Instance.new("UIListLayout")
musicListLayout.Padding = UDim.new(0, 6)
musicListLayout.SortOrder = Enum.SortOrder.LayoutOrder
musicListLayout.Parent = musicList
for i, track in ipairs(musicTracks) do
    local b = button(musicList, "♪  " .. track.name .. "  •  " .. track.duration,
        UDim2.new(1, -8, 0, 42), UDim2.new(), Color3.fromRGB(30, 43, 64))
    b.Name = "MusicTrack_" .. i
    b.LayoutOrder = i
    b.TextSize = 10
    musicTrackButtons[i] = b
    b.Activated:Connect(function() playTrack(i) end)
end
-- Các nút điều khiển được đặt SAU danh sách trong cùng vùng cuộn.
-- Người dùng vuốt xuống cuối danh sách để thấy nút lặp và điều khiển.
local controlsRow = Instance.new("Frame")
controlsRow.Name = "MusicControlsRow"
controlsRow.Size = UDim2.new(1, -8, 0, 30)
controlsRow.BackgroundTransparency = 1
controlsRow.LayoutOrder = 11
controlsRow.Parent = musicList
local prevMusicBtn = button(controlsRow, "⏮ BÀI TRƯỚC", UDim2.new(0.5, -3, 1, 0), UDim2.fromOffset(0, 0), Color3.fromRGB(31, 81, 109))
local nextMusicBtn = button(controlsRow, "BÀI TIẾP ⏭", UDim2.new(0.5, -3, 1, 0), UDim2.new(0.5, 6, 0, 0), Color3.fromRGB(31, 81, 109))
local transportRow = Instance.new("Frame")
transportRow.Name = "MusicTransportRow"
transportRow.Size = UDim2.new(1, -8, 0, 30)
transportRow.BackgroundTransparency = 1
transportRow.LayoutOrder = 12
transportRow.Parent = musicList
pauseMusicBtn = button(transportRow, "⏸ TẠM DỪNG", UDim2.new(0.5, -3, 1, 0), UDim2.fromOffset(0, 0), Color3.fromRGB(74, 69, 111))
local stopMusicBtn = button(transportRow, "⏹ DỪNG NHẠC", UDim2.new(0.5, -3, 1, 0), UDim2.new(0.5, 6, 0, 0), Color3.fromRGB(104, 53, 70))
local loopMode = 0 -- 0=tắt lặp, 1=lặp bài, 2=lặp danh sách
local loopBtn = button(musicList, "🔁 LẶP: TẮT", UDim2.new(1, -8, 0, 30), UDim2.new(), Color3.fromRGB(39, 91, 105))
loopBtn.LayoutOrder = 13
loopBtn.Activated:Connect(function()
    loopMode = (loopMode + 1) % 3
    loopBtn.Text = ({[0]="🔁 LẶP: TẮT", [1]="🔂 LẶP: MỘT BÀI", [2]="🔁 LẶP: TẤT CẢ"})[loopMode]
end)
prevMusicBtn.Activated:Connect(function() playTrack(currentTrackIndex - 1) end)
nextMusicBtn.Activated:Connect(function() playTrack(currentTrackIndex + 1) end)
pauseMusicBtn.Activated:Connect(function()
    if musicSound.IsPlaying then
        musicSound:Pause()
        pauseMusicBtn.Text = "▶ TIẾP TỤC"
        currentTrackLabel.Text = "Đã tạm dừng: " .. musicTracks[currentTrackIndex].name
    elseif musicSound.SoundId ~= "" then
        musicSound:Resume()
        pauseMusicBtn.Text = "⏸ TẠM DỪNG"
        currentTrackLabel.Text = "Đang phát: " .. musicTracks[currentTrackIndex].name
    else
        playTrack(currentTrackIndex)
        pauseMusicBtn.Text = "⏸ TẠM DỪNG"
    end
end)
stopMusicBtn.Activated:Connect(function()
    musicSound:Stop()
    pauseMusicBtn.Text = "⏸ TẠM DỪNG"
    currentTrackLabel.Text = "Đã dừng nhạc"
    status.Text = "Đã dừng trình phát nhạc"
end)
musicSound.Ended:Connect(function()
    if not musicPanel.Parent then return end
    if loopMode == 1 then
        playTrack(currentTrackIndex)
    elseif loopMode == 2 then
        playTrack(currentTrackIndex + 1)
    elseif currentTrackIndex < #musicTracks then
        playTrack(currentTrackIndex + 1)
    else
        currentTrackLabel.Text = "Đã phát hết danh sách"
    end
end)
updateMusicTrackButtons()

-- Floating Tech Mini: only live FPS and ping; tap to reopen the full menu.
local float = button(gui, "", UDim2.fromOffset(230, 118), UDim2.new(0, 14, 0.55, 0), Color3.fromRGB(7, 15, 30))
float.Name = "UtraFixLagTechMini"
float.Text = ""
float.Visible = false -- Full menu opens on startup; mini appears when menu is minimized.
float.ZIndex = 4
corner(float, 15)
local floatStroke = stroke(float, Color3.fromRGB(0, 220, 255), 1.5, 0.02)
local floatGradient = Instance.new("UIGradient")
floatGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 43, 76)),
    ColorSequenceKeypoint.new(0.52, Color3.fromRGB(10, 24, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 13, 28))
})
floatGradient.Rotation = 25
floatGradient.Parent = float
local miniHeader = label(float, "UTRA FIXLAG / NHAT KHANH HUB", UDim2.new(1, -12, 0, 20), UDim2.fromOffset(6, 4), 7, Color3.fromRGB(105, 220, 255), Enum.Font.GothamBold)
miniHeader.ZIndex = 6
local miniDivider = Instance.new("Frame")
miniDivider.Name = "MiniDivider"
miniDivider.Size = UDim2.new(1, -18, 0, 1)
miniDivider.Position = UDim2.fromOffset(9, 21)
miniDivider.BackgroundColor3 = Color3.fromRGB(45, 112, 155)
miniDivider.BackgroundTransparency = 0.25
miniDivider.BorderSizePixel = 0
miniDivider.ZIndex = 6
miniDivider.Parent = float
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "LiveFPSPing"
fpsLabel.Position = UDim2.fromOffset(10, 25)
fpsLabel.Size = UDim2.new(1, -20, 0, 32)
fpsLabel.BackgroundTransparency = 1
fpsLabel.BorderSizePixel = 0
fpsLabel.Text = "FPS: --     PING: -- ms"
fpsLabel.TextWrapped = true
fpsLabel.TextYAlignment = Enum.TextYAlignment.Center
fpsLabel.TextColor3 = Color3.fromRGB(96, 255, 207)
fpsLabel.TextSize = 10
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.ZIndex = 6
fpsLabel.Parent = float
local miniSongLabel = label(float, "♪ Chưa phát bài nào", UDim2.new(1, -20, 0, 20), UDim2.fromOffset(10, 59), 9, Color3.fromRGB(120, 235, 255), Enum.Font.GothamBold)
miniSongLabel.Name = "MiniCurrentSong"
miniSongLabel.TextTruncate = Enum.TextTruncate.AtEnd
miniSongLabel.ZIndex = 6
local miniTimeLabel = label(float, "00:00 / 00:00", UDim2.new(1, -20, 0, 14), UDim2.fromOffset(10, 80), 8, Color3.fromRGB(210, 230, 245), Enum.Font.Gotham)
miniTimeLabel.Name = "MiniMusicTime"
miniTimeLabel.ZIndex = 6
local miniProgressBack = Instance.new("Frame")
miniProgressBack.Name = "MiniMusicProgressBack"
miniProgressBack.Size = UDim2.new(1, -20, 0, 4)
miniProgressBack.Position = UDim2.fromOffset(10, 101)
miniProgressBack.BackgroundColor3 = Color3.fromRGB(40, 67, 87)
miniProgressBack.BorderSizePixel = 0
miniProgressBack.ZIndex = 6
miniProgressBack.Parent = float
corner(miniProgressBack, 3)
local miniProgress = Instance.new("Frame")
miniProgress.Name = "MiniMusicProgress"
miniProgress.Size = UDim2.new(0, 0, 1, 0)
miniProgress.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
miniProgress.BorderSizePixel = 0
miniProgress.ZIndex = 7
miniProgress.Parent = miniProgressBack
corner(miniProgress, 3)

-- Live monitor: FPS from rendered frames and ping from Stats if exposed.
local function readPingMs()
    local ok, value = pcall(function()
        local network = Stats:FindFirstChild("Network")
        local serverStats = network and network:FindFirstChild("ServerStatsItem")
        local dataPing = serverStats and serverStats:FindFirstChild("Data Ping")
        if not dataPing then return nil end
        local raw = dataPing:GetValue()
        if type(raw) == "number" then return math.floor(raw + 0.5) end
        local textValue = dataPing:GetValueString()
        local number = tonumber(string.match(textValue, "[%d%.]+"))
        return number and math.floor(number + 0.5) or nil
    end)
    if ok then return value end
    return nil
end

local function readBatteryPercent()
    local candidates = {}
    pcall(function()
        if type(getdevicebattery) == "function" then table.insert(candidates, getdevicebattery) end
    end)
    pcall(function()
        if type(getbattery) == "function" then table.insert(candidates, getbattery) end
    end)
    for _, fn in ipairs(candidates) do
        local ok, value = pcall(fn)
        if ok and type(value) == "number" then
            if value <= 1 then value = value * 100 end
            if value >= 0 and value <= 100 then return math.floor(value + 0.5) end
        end
    end
    local ok, value = pcall(function()
        return UserInputService:GetDeviceBatteryLevel()
    end)
    if ok and type(value) == "number" and value >= 0 and value <= 1 then
        return math.floor(value * 100 + 0.5)
    end
    return nil
end

local fpsFrames, fpsElapsed = 0, 0
local fpsConnection = RunService.RenderStepped:Connect(function(dt)
    fpsFrames = fpsFrames + 1
    fpsElapsed = fpsElapsed + dt
    if fpsElapsed >= 0.5 then
        local fps = math.floor((fpsFrames / math.max(fpsElapsed, 0.001)) + 0.5)
        local ping = readPingMs()
        local pingText = ping and (tostring(ping) .. " ms") or "Chưa có"
        fpsLabel.Text = "FPS: " .. tostring(fps) .. "     PING: " .. pingText
        if fps < 25 then
            fpsLabel.TextColor3 = Color3.fromRGB(255, 105, 125)
            floatStroke.Color = Color3.fromRGB(255, 82, 115)
        elseif fps < 45 then
            fpsLabel.TextColor3 = Color3.fromRGB(255, 205, 90)
            floatStroke.Color = Color3.fromRGB(255, 180, 70)
        else
            fpsLabel.TextColor3 = Color3.fromRGB(130, 255, 200)
            floatStroke.Color = Color3.fromRGB(66, 224, 255)
        end
        fpsFrames, fpsElapsed = 0, 0
    end
end)

-- Mini player status: title + elapsed/total time; no next/previous/pause controls here.
local function formatMusicTime(seconds)
    seconds = math.max(0, math.floor(tonumber(seconds) or 0))
    return string.format("%02d:%02d", math.floor(seconds / 60), seconds % 60)
end
local miniMusicElapsed = 0
local miniMusicConnection = RunService.Heartbeat:Connect(function(dt)
    miniMusicElapsed += dt
    if miniMusicElapsed < 0.25 then return end
    miniMusicElapsed = 0
    local track = musicTracks[currentTrackIndex]
    if track and musicSound.SoundId ~= "" then
        miniSongLabel.Text = (musicSound.IsPlaying and "♪ " or "Ⅱ ") .. track.name
        local current = musicSound.TimePosition
        local total = musicSound.TimeLength
        if total and total > 0 then
            miniTimeLabel.Text = formatMusicTime(current) .. " / " .. formatMusicTime(total)
            miniProgress.Size = UDim2.new(math.clamp(current / total, 0, 1), 0, 1, 0)
        else
            miniTimeLabel.Text = formatMusicTime(current) .. " / --:--"
            miniProgress.Size = UDim2.new(0, 0, 1, 0)
        end
    else
        miniSongLabel.Text = "♪ Chưa phát bài nào"
        miniTimeLabel.Text = "00:00 / 00:00"
        miniProgress.Size = UDim2.new(0, 0, 1, 0)
    end
end)

local function setMainVisible(visible)
    main.Visible = visible
    if not visible then
        musicPanel.Visible = false
        float.Visible = true
    else
        float.Visible = false
    end
end
hideBtn.Activated:Connect(function() setMainVisible(false) end)
float.Activated:Connect(function() setMainVisible(true) end)
shaderBtn.Activated:Connect(function()
    musicPanel.Visible = not musicPanel.Visible
end)
musicHide.Activated:Connect(function() musicPanel.Visible = false end)

-- Standalone functions: only client-side visual/audio settings; no egg-hub dependency.
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local optimizationLevel = 0 -- 0=normal, 1=Fix Lag, 2=Super Fix Lag
local savedProps = setmetatable({}, {__mode = "k"})
local savedLighting = {}
local savedTerrain = {}
local soundSaved = setmetatable({}, {__mode = "k"})
local muted = false
local soundAddedConnection
local shaderObjects = {}

local function saveProperty(obj, prop)
    if not obj then return end
    savedProps[obj] = savedProps[obj] or {}
    if savedProps[obj][prop] == nil then
        local ok, value = pcall(function() return obj[prop] end)
        if ok then savedProps[obj][prop] = value end
    end
end
local function setSaved(obj, prop, value)
    saveProperty(obj, prop)
    pcall(function() obj[prop] = value end)
end
local function saveLightingProp(prop)
    if savedLighting[prop] == nil then
        local ok, value = pcall(function() return Lighting[prop] end)
        if ok then savedLighting[prop] = value end
    end
end
local function optimizeVisuals(level, updateButtonState, skipWorkspaceScan)
    if level == 0 then
        -- Trung hòa modifier FPSBoost của LightingController nếu game hỗ trợ.
        pcall(function()
            local controller = require(game:GetService("ReplicatedStorage").Client.LightingsController)
            controller:SetModifier("FPSBoost", function(original) return original end, 100, 0)
        end)
        for obj, props in pairs(savedProps) do
            if obj and obj.Parent then
                for prop, value in pairs(props) do pcall(function() obj[prop] = value end) end
            end
        end
        table.clear(savedProps)
        for prop, value in pairs(savedLighting) do
            if prop == "__quality" then pcall(function() settings().Rendering.QualityLevel = value end)
            elseif prop == "__physics" then pcall(function() settings().Physics.PhysicsEnvironmentalThrottle = value end)
            elseif prop == "__savedQuality" then pcall(function() UserSettings():GetService("UserGameSettings").SavedQualityLevel = value end)
            else pcall(function() Lighting[prop] = value end) end
        end
        table.clear(savedLighting)
        for prop, value in pairs(savedTerrain) do if Terrain then pcall(function() Terrain[prop] = value end) end end
        table.clear(savedTerrain)
        optimizationLevel = 0
        return
    end
    saveLightingProp("GlobalShadows")
    saveLightingProp("FogEnd")
    saveLightingProp("Brightness")
    saveLightingProp("Technology")
    saveLightingProp("Ambient")
    saveLightingProp("OutdoorAmbient")
    pcall(function()
        if savedLighting.__quality == nil then savedLighting.__quality = settings().Rendering.QualityLevel end
        if savedLighting.__physics == nil then savedLighting.__physics = settings().Physics.PhysicsEnvironmentalThrottle end
        if savedLighting.__savedQuality == nil then savedLighting.__savedQuality = UserSettings():GetService("UserGameSettings").SavedQualityLevel end
    end)
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function() settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Always end)
    pcall(function() UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1 end)
    pcall(function() Lighting.Technology = Enum.Technology.Compatibility end)
    pcall(function() Lighting.GlobalShadows = false end)
    pcall(function() Lighting.FogEnd = 100000 end)
    if level >= 2 then pcall(function() Lighting.Brightness = math.max(Lighting.Brightness, 2) end) end
    if Terrain then
        for _, prop in ipairs({"WaterWaveSize", "WaterWaveSpeed", "WaterReflectance", "WaterTransparency", "Decoration"}) do
            if savedTerrain[prop] == nil then pcall(function() savedTerrain[prop] = Terrain[prop] end) end
        end
        pcall(function() Terrain.WaterWaveSize = 0 end)
        pcall(function() Terrain.WaterWaveSpeed = 0 end)
        pcall(function() Terrain.WaterReflectance = 0 end)
        pcall(function() Terrain.WaterTransparency = 1 end)
        if level >= 2 then pcall(function() Terrain.Decoration = false end) end
    end
    for _, obj in ipairs(Lighting:GetDescendants()) do
        if obj:IsA("PostEffect") then setSaved(obj, "Enabled", false) end
    end
    -- Khi v391 da quet toan bo Workspace, bo qua vong quet trung lap nay.
    if not skipWorkspaceScan then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                setSaved(obj, "Enabled", false)
            elseif level >= 2 and (obj:IsA("Decal") or obj:IsA("Texture")) then
                setSaved(obj, "Transparency", 1)
            elseif level >= 2 and obj:IsA("BasePart") then
                setSaved(obj, "CastShadow", false)
                if obj.Material ~= Enum.Material.Plastic and obj.Material ~= Enum.Material.SmoothPlastic then
                    setSaved(obj, "Material", Enum.Material.Plastic)
                end
            end
        end
    end
    if updateButtonState ~= false then optimizationLevel = level end
end

-- Full startup optimization function v390() extracted from the supplied original hub source.
-- Includes its helper functions for visual effects, client-rendered assets, placed egg renders, and trap debris.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t15 = { effects = {}, parts = {}, decals = {}, snapshot = nil }
local t16 = {}
local u393 = false
local u421 = false
local v390

local function v396()
    local ClientRenderedAssets = workspace:FindFirstChild("ClientRenderedAssets")
    if not ClientRenderedAssets then return end
    for _, child in ipairs(ClientRenderedAssets:GetChildren()) do
        pcall(function() child.Parent = nil end)
    end
end

local function v400(p82)
    return string.sub(p82.Name, 1, #tostring(player.UserId) + 1) == tostring(player.UserId) .. "_"
end

local function v401()
    for _, child in ipairs(workspace:GetChildren()) do
        if child.Name == "PlacedEggRenders" then
            for _, child2 in ipairs(child:GetChildren()) do
                pcall(function()
                    if not child2:FindFirstChildOfClass("ProximityPrompt") and not v400(child2) then
                        child2.Parent = nil
                    end
                end)
            end
        end
    end
end

local function v406()
    for _, name in ipairs({"Transient", "__DEBRIS"}) do
        local folder = workspace:FindFirstChild(name)
        if folder then
            for _, child in ipairs(folder:GetChildren()) do
                if child.Name == "PlayerTrap" or child.Name:lower():find("trap") then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end
end

local function v416(descendant)
    pcall(function()
        if v412(descendant) then return end
        local removeNames = {
            PlusOne = true,
            SpeedGainPopup = true,
            SellPayout = true,
            SyncedIncomeCash = true,
        }
        local disableBillboards = {
            PlayerPlotSign = true,
            CanUpgrade = true,
            AlertGui = true,
            OfflineMoneyClaimBillboard = true,
        }
        if removeNames[descendant.Name] then
            descendant:Destroy()
            return
        end
        if descendant:IsA("BillboardGui") and disableBillboards[descendant.Name] then
            if descendant.Enabled then t15.effects[descendant] = true end
            descendant.Enabled = false
            return
        end
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam")
            or descendant:IsA("Sparkles") or descendant:IsA("Fire") or descendant:IsA("Smoke")
            or descendant:IsA("PostEffect") then
            if descendant.Enabled then t15.effects[descendant] = true end
            descendant.Enabled = false
        end
    end)
end

local function v417()
    if u393 then return end
    u393 = true
    table.insert(t16, game.DescendantAdded:Connect(v416))
    table.insert(t16, workspace.ChildAdded:Connect(function(child)
        if child.Name == "ClientRenderedAssets" then
            v396()
            table.insert(t16, child.ChildAdded:Connect(function(child2)
                pcall(function() child2.Parent = nil end)
            end))
        elseif child.Name == "PlacedEggRenders" then
            v401()
            table.insert(t16, child.ChildAdded:Connect(function(child2)
                pcall(function()
                    if not child2:FindFirstChildOfClass("ProximityPrompt") and not v400(child2) then
                        child2.Parent = nil
                    end
                end)
            end))
        elseif child.Name == "__DEBRIS" or child.Name == "Transient" then
            table.insert(t16, child.ChildAdded:Connect(function(child2)
                if child2.Name == "PlayerTrap" or child2.Name:lower():find("trap") then
                    pcall(function() child2:Destroy() end)
                end
            end))
        end
    end))
    local assets = workspace:FindFirstChild("ClientRenderedAssets")
    if assets then
        table.insert(t16, assets.ChildAdded:Connect(function(child)
            pcall(function() child.Parent = nil end)
        end))
    end
    for _, child in ipairs(workspace:GetChildren()) do
        if child.Name == "PlacedEggRenders" then
            table.insert(t16, child.ChildAdded:Connect(function(child2)
                pcall(function()
                    if not child2:FindFirstChildOfClass("ProximityPrompt") and not v400(child2) then
                        child2.Parent = nil
                    end
                end)
            end))
        end
    end
end

v390 = function()
    if u421 then return end
    u421 = true
    local Lighting = game:GetService("Lighting")

    if not t15.snapshot then
        local t19 = {}
        pcall(function()
            t19.quality = settings().Rendering.QualityLevel
            t19.throttle = settings().Physics.PhysicsEnvironmentalThrottle
            t19.technology = Lighting.Technology
            t19.shadows = Lighting.GlobalShadows
            t19.fogEnd = Lighting.FogEnd
            t19.brightness = Lighting.Brightness
            t19.ambient = Lighting.Ambient
            t19.outdoorAmbient = Lighting.OutdoorAmbient
        end)
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        if Terrain then
            pcall(function()
                t19.terrain = {
                    WaterWaveSize = Terrain.WaterWaveSize,
                    WaterWaveSpeed = Terrain.WaterWaveSpeed,
                    WaterReflectance = Terrain.WaterReflectance,
                    WaterTransparency = Terrain.WaterTransparency,
                    Decoration = Terrain.Decoration,
                }
            end)
            pcall(function()
                local Clouds = Terrain:FindFirstChildOfClass("Clouds")
                if Clouds then t19.cloudsEnabled = Clouds.Enabled end
            end)
        end
        pcall(function()
            local Shared = ReplicatedStorage:FindFirstChild("Shared")
            local Preferences = Shared and Shared:FindFirstChild("Preferences")
            if Preferences then
                local module = require(Preferences)
                t19.prefs = {
                    HideOtherPets = module.IsOn("HideOtherPets"),
                    DisableVideos = module.IsOn("DisableVideos"),
                }
            end
        end)
        if t19.quality == Enum.QualityLevel.Level01 then
            t19.quality = Enum.QualityLevel.Automatic
        end
        t15.snapshot = genv.__SenaV4DecomSnapshot or t19
        genv.__SenaV4DecomSnapshot = t15.snapshot
    end

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Always
        Lighting.Technology = Enum.Technology.Compatibility
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    end)

    local now = os.clock()
    for _, root in ipairs({workspace, Lighting}) do
        for _, descendant in ipairs(root:GetDescendants()) do
            if not v412(descendant) then
                if descendant:IsA("BasePart") then
                    pcall(function()
                        if not t15.parts[descendant] then
                            t15.parts[descendant] = {
                                descendant.Material,
                                descendant.CastShadow,
                                descendant:IsA("MeshPart") and descendant.RenderFidelity or nil,
                            }
                        end
                        descendant.Material = Enum.Material.SmoothPlastic
                        descendant.CastShadow = false
                        if descendant:IsA("MeshPart") then
                            descendant.RenderFidelity = Enum.RenderFidelity.Performance
                        end
                    end)
                elseif descendant:IsA("Decal") then
                    pcall(function()
                        if descendant.Texture ~= "" and not t15.decals[descendant] then
                            t15.decals[descendant] = descendant.Texture
                        end
                        descendant.Texture = ""
                    end)
                    if os.clock() - now > 0.004 then task.wait(); now = os.clock() end
                    continue
                elseif descendant:IsA("Texture") then
                    pcall(function()
                        if descendant.Texture ~= "" and not t15.decals[descendant] then
                            t15.decals[descendant] = descendant.Texture
                        end
                        descendant.Texture = ""
                    end)
                else
                    v416(descendant)
                end
                if os.clock() - now > 0.004 then task.wait(); now = os.clock() end
            end
        end
    end

    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        pcall(function()
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
            Terrain.Decoration = false
            local Clouds = Terrain:FindFirstChildOfClass("Clouds")
            if Clouds then Clouds.Enabled = false end
        end)
    end

    pcall(function()
        local Shared = ReplicatedStorage.Shared
        local Preferences = Shared:FindFirstChild("Preferences")
        if Preferences then
            local module = require(Preferences)
            module.Set("HideOtherPets", true)
            module.Set("DisableVideos", true)
        else
            local SettingsCmds = require(Shared.SettingsCmds)
            SettingsCmds.Write("HideOtherPets", true)
            SettingsCmds.Write("DisableVideos", true)
        end
    end)
    v396()
    v401()
    v406()
    v417()
    u421 = false
end

-- Source gốc thứ 3: v4720(p1045), đổi giới hạn FPS 240/60 nếu môi trường có helper.
local fpsCapEnabled = false
-- Original FPS Boost dependency scope extracted from the supplied hub source.
-- All required local variables/helpers are defined here rather than relying on the hub's outer scope.
local LocalPlayer = player
local genv = (type(getgenv) == "function" and getgenv()) or _G
local senaV4Config = {
    _fpsPlotsReady = false,
    _fpsTreadmillsReady = false,
    _fpsAreasReady = false,
    _fpsWorldReady = false,
    _fpsPetsReady = false,
    _fpsEggsReady = false,
    _fpsBoostApplying = nil,
}
local v391
local function v14()
    return Workspace:FindFirstChild("World") or Workspace:FindFirstChild("__OBJECTS")
end
local function v412(p83)
    if not p83:FindFirstAncestor("SenaVisualBack") and not p83:FindFirstAncestor("SenaVisualRemote") then
        local tool = p83:FindFirstAncestorWhichIsA("Tool")
        return tool ~= nil and tool:GetAttribute("NhatKhanhHub") ~= nil
    end
    return true
end

local u456 = false

local function v457(p84)
	if not p84 or not p84:IsA("Model") then
		return
	end

	local match = p84.Name:match("^(%d+)_")
	local v459 = match and tonumber(match)

	if not v459 or v459 == LocalPlayer.UserId then
		return
	end

	for _, descendant in ipairs(p84:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Transparency = 1
			descendant.CanCollide = false
		elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
			descendant.Transparency = 1
		elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
			descendant.Enabled = false
		elseif descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
			descendant.Enabled = false
		end
	end
end
local function v462()
	if senaV4Config._fpsEggsReady then
		return true
	end

	local u463 = false
	local ok, result = pcall(function()
		local v466 = require(game:GetService("ReplicatedStorage").Shared.Eggs.PlacedEggRenderer).GetRenderFolder()

		if not v466 then
			return
		end

		local children = v466:GetChildren()

		for _, child in ipairs(children) do
			v457(child)
		end

		v466.ChildAdded:Connect(function(child)
			task.defer(v457, child)
		end)
		u463 = true
	end)

	if not ok then
		warn("[FPSBoost] Gagal hide egg pemain lain:", result)

		return false
	end

	return u463
end
local function v470(p85)
	if not p85 then
		return
	end

	pcall(function()
		p85.Parent = nil
	end)
end
local function v471()
	if senaV4Config._fpsPetsReady then
		return true
	end

	local IsOn
	local ok, result = pcall(function()
		local Shared = game:GetService("ReplicatedStorage").Shared
		local Preferences = Shared:FindFirstChild("Preferences")

		if Preferences then
			local module = require(Preferences)

			module.Set("HideOtherPets", true)
			IsOn = module.IsOn
		else
			local SettingsCmds = require(Shared.SettingsCmds)

			SettingsCmds.Write("HideOtherPets", true)
			IsOn = SettingsCmds.Allows
		end
	end)
	local v479 = false

	if ok and IsOn then
		local ok2, result2 = pcall(IsOn, "HideOtherPets")

		v479 = ok2 and result2 == true
	end

	if ok then
		if v479 then
			local u482 = false
			local ok2, result2 = pcall(function()
				local ClientRenderedAssets = workspace:FindFirstChild("ClientRenderedAssets") or workspace:WaitForChild("ClientRenderedAssets", 10)

				if not ClientRenderedAssets then
					return
				end

				local children = ClientRenderedAssets:GetChildren()

				for _, child in ipairs(children) do
					v470(child)
				end

				ClientRenderedAssets.ChildAdded:Connect(function(child)
					task.defer(v470, child)
				end)
				u482 = true
			end)

			if not ok2 then
				warn("[FPSBoost] Gagal hide pet (manual):", result2)

				return false
			end

			return u482
		end
	end

	warn("[FPSBoost] Gagal set HideOtherPets bawaan game:", result or "setting belum aktif")

	return false
end
local function v489()
	if type(genv.__SenaV4SetCapFps) == "function" then
		pcall(genv.__SenaV4SetCapFps, 240)
	end

	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end)

	local function v490()
		UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
	end

	pcall(v490)
	pcall(function()
		require(game:GetService("ReplicatedStorage").Client.LightingsController):SetModifier("FPSBoost", function(p86)
			local v491 = table.clone(p86)

			v491.Bloom = nil
			v491.ColorCorrection = nil
			v491.SunRays = nil
			v491.DepthOfField = nil
			v491.Blur = nil
			v491.Clouds = nil
			v491.Atmosphere = nil
			v491.ShadowSoftness = 1

			return v491
		end, 100, 0)
	end)
	pcall(function()
		local Lighting = game:GetService("Lighting")

		Lighting.GlobalShadows = false
		Lighting.Technology = Enum.Technology.Compatibility
		Lighting.FogEnd = 9e9
		Lighting.Brightness = 2
	end)
	pcall(function()
		local Terrain = workspace:FindFirstChildOfClass("Terrain")

		if Terrain then
			Terrain.WaterWaveSize = 0
			Terrain.WaterWaveSpeed = 0
			Terrain.WaterReflectance = 0
			Terrain.WaterTransparency = 1
			Terrain.Decoration = false
		end
	end)
	pcall(function()
		local __DEBRIS = workspace:FindFirstChild("__DEBRIS")

		if __DEBRIS then
			for _, child in ipairs(__DEBRIS:GetChildren()) do
				if child.Name == "PlayerTrap" then
					pcall(function()
						child:Destroy()
					end)
				end
			end
		end
	end)
end

local color3 = Color3.fromRGB(120, 120, 120)

local function v498(p87)
	if not p87 or not p87:IsA("BasePart") then
		return
	end

	p87.Material = Enum.Material.SmoothPlastic
	p87.Color = color3
	p87.CastShadow = false
end
local function v499(p88)
	if p88:IsA("ParticleEmitter") then
		p88.Enabled = false
		p88.Rate = 0
		pcall(function()
			p88:Clear()
		end)
	elseif p88:IsA("Trail") or p88:IsA("Beam") or p88:IsA("Smoke") or p88:IsA("Fire") or p88:IsA("Sparkles") or p88:IsA("PostEffect") or p88:IsA("Light") or p88:IsA("Highlight") or p88:IsA("Clouds") then
		p88.Enabled = false
	elseif p88:IsA("Atmosphere") then
		p88.Density = 0
		p88.Haze = 0
		p88.Glare = 0
	elseif p88:IsA("Explosion") then
		pcall(function()
			p88.Visible = false
		end)
	end
end
local function v500()
	if senaV4Config._fpsWorldReady then
		return true
	end

	local u501 = false
	local t20 = {}
	local ok, result = pcall(function()
		local function v505(p89)
			if v412(p89) then
				return
			end

			v498(p89)
			v499(p89)
		end

		local t21 = {
			workspace,
			game:GetService("Lighting")
		}

		for _, v in ipairs(t21) do
			table.insert(t20, v.DescendantAdded:Connect(function(descendant)
				task.defer(v505, descendant)
			end))
		end

		local t22 = {}

		for _, v in ipairs(t21) do
			for _, child in ipairs(v:GetChildren()) do
				table.insert(t22, child)
			end
		end

		local n11 = 0

		while #t22 > 0 do
			local v515 = table.remove(t22)

			v505(v515)

			for _, child in ipairs(v515:GetChildren()) do
				table.insert(t22, child)
			end

			n11 += 1

			if n11 >= 250 and #t22 > 0 then
				n11 = 0
				RunService.Heartbeat:Wait()
			end
		end

		u501 = true
	end)

	if ok then
		return u501
	end

	for _, v in ipairs(t20) do
		v:Disconnect()
	end

	warn("[FPSBoost] Gagal flatten material workspace:", result)

	return false
end
local function v520()
	if senaV4Config._fpsAreasReady then
		return true
	end

	local v521 = v14()
	local Areas = v521 and v521:FindFirstChild("Areas")
	local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
	local Build = v521 and v521:FindFirstChild("Build")

	if not GuardAreas or not Build then
		return false
	end

	for _, child in ipairs(GuardAreas:GetChildren()) do
		local RequiredSpeedSign = child:FindFirstChild("RequiredSpeedSign")

		if RequiredSpeedSign then
			pcall(function()
				RequiredSpeedSign:Destroy()
			end)
		end
	end

	local MainMap = Build:FindFirstChild("MainMap")
	local Bases = MainMap and MainMap:FindFirstChild("Bases")

	local function v530(p90)
		if Bases and p90:IsDescendantOf(Bases) then
			return p90.Size.Y <= 5 and not string.find(string.upper(p90.Name), "WALL", 1, true)
		end

		local Parent = p90

		while true do
			if not Parent or Parent == Build then
				return false
			end

			if not string.find(string.upper(Parent.Name), "BOTTOM", 1, true) then
				Parent = Parent.Parent

				continue
			end

			break
		end

		return true
	end

	local t23 = {
		"ENCHANTED",
		"FUSEBIOME",
		"WISP",
		"BUTTERFLY",
		"MARKERS",
		"PORTAL",
		"TRIGGER"
	}

	local function v533(p91)
		if p91:FindFirstChildOfClass("TouchTransmitter") or p91:FindFirstChildWhichIsA("ProximityPrompt", true) then
			return true
		end

		local Parent = p91

		while true do
			if not Parent then
				return false
			end

			if Parent == Build then
				return false
			end

			local v535 = string.upper(Parent.Name)

			for _, v in ipairs(t23) do
				if string.find(v535, v, 1, true) then
					return true
				end
			end

			Parent = Parent.Parent
		end
	end
	local function v538(p92)
		if not p92:IsA("BasePart") then
			return
		end

		if v533(p92) then
			return
		end

		if v530(p92) then
			v498(p92)
		else
			pcall(function()
				p92:Destroy()
			end)
		end
	end

	local connection = Build.DescendantAdded:Connect(function(descendant)
		task.defer(v538, descendant)
	end)
	local n12 = 0
	local fpsAreaDeleted = 0

	for _, descendant in ipairs(Build:GetDescendants()) do
		local v544 = descendant.Parent ~= nil

		v538(descendant)

		if v544 and descendant.Parent == nil then
			fpsAreaDeleted += 1
		end

		n12 += 1

		if n12 >= 250 then
			n12 = 0
			RunService.Heartbeat:Wait()
		end
	end

	senaV4Config._fpsAreaListener = connection
	senaV4Config._fpsAreaDeleted = fpsAreaDeleted
	senaV4Config._fpsAreasReady = true

	return true
end
local function v545()
	if senaV4Config._fpsPlotsReady then
		return true
	end

	local u546 = false
	local ok, result = pcall(function()
		local PlotState2 = require(game:GetService("ReplicatedStorage").Client.PlotState)

		if PlotState2.GetMySlot() == nil then
			warn("[FPSBoost] Slot plot kita belum ke-resolve, skip delete plot dulu (biar aman).")

			return
		end

		local function v550(p93)
			local v551 = PlotState2.GetMySlot()

			return v551 ~= nil and p93.Name == tostring(v551)
		end

		local Plots = PlotState2.GetPlotsFolder() or workspace:WaitForChild("Plots", 10)

		if not Plots then
			warn("[FPSBoost] workspace.Plots gak ketemu sama sekali.")

			return
		end

		local children = Plots:GetChildren()
		local n13 = 0

		for _, child in ipairs(children) do
			if not v550(child) and pcall(function()
				child:Destroy()
			end) then
				n13 += 1
			end
		end

		Plots.ChildAdded:Connect(function(child)
			task.defer(function()
				if child.Parent then
					if not v550(child) then
						pcall(function()
							child:Destroy()
						end)
					end
				end
			end)
		end)
		u546 = true
	end)

	if ok then
		return u546
	end

	warn("[FPSBoost] Gagal delete plot pemain lain:", result)

	return false
end
local function v557()
	if senaV4Config._fpsTreadmillsReady then
		return true
	end

	local u558 = false
	local ok, result = pcall(function()
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local PlotState2 = require(ReplicatedStorage2.Client.PlotState)
		local v563
		local Modules = ReplicatedStorage2.Client:FindFirstChild("Modules") or ReplicatedStorage2.Client:WaitForChild("Modules", 10)
		local RuntimeInstanceRegistry = Modules and (Modules:FindFirstChild("RuntimeInstanceRegistry") or Modules:WaitForChild("RuntimeInstanceRegistry", 10))

		if RuntimeInstanceRegistry then
			local ok, result = pcall(require, RuntimeInstanceRegistry)

			if ok then
				v563 = result
			end
		end

		local __ClientTreadmillRenders = workspace:FindFirstChild("__ClientTreadmillRenders") or workspace:WaitForChild("__ClientTreadmillRenders", 10)

		if not __ClientTreadmillRenders then
			return
		end

		local function v569()
			local v570 = PlotState2.GetMySlot()

			if v570 == nil then
				return nil
			end

			local v571 = __ClientTreadmillRenders:FindFirstChild("TreadmillRender_" .. tostring(v570))

			if v571 then
				return v571
			end

			local Peek = v563 and (v563.Peek or v563.Get)

			if not Peek then
				return nil
			end

			local ok, result = pcall(Peek, "TreadmillPlotRender", tostring(v570))

			if ok then
				return result
			end

			return nil
		end
		local function v575(p94)
			local v576 = v569()

			if v576 and p94 == v576 then
				return true
			end

			local ok, result = pcall(function()
				return p94:GetPivot().Position
			end)

			if not ok then
				return true
			end

			local ok2, result2 = pcall(PlotState2.IsWorldPositionWithinLocalPlotBounds, result)
			local v581 = ok2 and result2

			return v581
		end

		local children = __ClientTreadmillRenders:GetChildren()
		local n14 = 0

		for _, child in ipairs(children) do
			if child:IsA("Model") and not v575(child) and pcall(function()
				child:Destroy()
			end) then
				n14 += 1
			end
		end

		__ClientTreadmillRenders.ChildAdded:Connect(function(child)
			task.defer(function()
				if child.Parent and child:IsA("Model") and not v575(child) then
					pcall(function()
						child:Destroy()
					end)
				end
			end)
		end)
		u558 = true
	end)

	if ok then
		return u558
	end

	warn("[FPSBoost] Gagal delete treadmill pemain lain:", result)

	return false
end

v391 = function()
	if u456 or senaV4Config._fpsBoostApplying then
		return
	end

	senaV4Config._fpsBoostApplying = true

	local ok, result = pcall(function()
		v489()
		senaV4Config._fpsPlotsReady = v545() == true
		senaV4Config._fpsTreadmillsReady = v557() == true
		senaV4Config._fpsAreasReady = v520() == true
		senaV4Config._fpsWorldReady = v500() == true
		senaV4Config._fpsPetsReady = v471() == true
		senaV4Config._fpsEggsReady = v462() == true
		u456 = senaV4Config._fpsEggsReady and senaV4Config._fpsPetsReady and senaV4Config._fpsWorldReady and senaV4Config._fpsPlotsReady and senaV4Config._fpsTreadmillsReady and senaV4Config._fpsAreasReady
	end)

	senaV4Config._fpsBoostApplying = nil

	if not ok then
		warn("[FPSBoost] Gagal menerapkan FPS Boost:", result)
	end
end

-- Siêu Fix Lag now calls the original v391() orchestration and its full helper chain.
-- Source gốc thứ 2: v391() gọi v489() cùng các helper phụ thuộc của hub.
local function sourceFPSBoost()
    if type(v391) ~= "function" then
        error("Không khởi tạo được chuỗi FPS Boost gốc v391")
    end
    v391()
    return senaV4Config._fpsEggsReady and senaV4Config._fpsPetsReady
        and senaV4Config._fpsWorldReady and senaV4Config._fpsPlotsReady
        and senaV4Config._fpsTreadmillsReady and senaV4Config._fpsAreasReady
end

local function setFpsCap(enabled)
    fpsCapEnabled = enabled == true
    local ok = false
    pcall(function()
        local env = (getgenv and getgenv()) or _G
        local cap = env.__SenaV4SetCapFps
        if type(cap) == "function" then
            cap(fpsCapEnabled and 240 or 60)
            ok = true
        end
    end)
    -- Delta/executor may expose its own FPS cap function instead of the hub helper.
    if not ok then
        pcall(function()
            if type(setfpscap) == "function" then
                setfpscap(fpsCapEnabled and 240 or 60)
                ok = true
            end
        end)
    end
    capBtn.Text = fpsCapEnabled and "🎯  BỎ GIỚI HẠN FPS: ON" or "🎯  BỎ GIỚI HẠN KHUNG HÌNH: TẮT"
    capBtn.BackgroundColor3 = fpsCapEnabled and Color3.fromRGB(153, 111, 43) or Color3.fromRGB(105, 83, 39)
    return ok
end

local function muteSound(sound)
    if not sound:IsA("Sound") then return end
    if soundSaved[sound] == nil then soundSaved[sound] = sound.Volume end
    pcall(function() sound.Volume = 0 end)
end
local function setMuted(on)
    muted = on
    if on then
        for _, obj in ipairs(game:GetDescendants()) do if obj:IsA("Sound") then muteSound(obj) end end
        if soundAddedConnection then soundAddedConnection:Disconnect() end
        soundAddedConnection = game.DescendantAdded:Connect(function(obj)
            if muted and obj:IsA("Sound") then task.defer(function() if muted and obj.Parent then muteSound(obj) end end) end
        end)
        muteBtn.Text = "🔇  TẮT ÂM THANH  :  ON"
        muteBtn.BackgroundColor3 = Color3.fromRGB(158, 58, 77)
        status.Text = "Đã tắt âm thanh local"
    else
        if soundAddedConnection then soundAddedConnection:Disconnect(); soundAddedConnection = nil end
        for sound, volume in pairs(soundSaved) do if sound and sound.Parent then pcall(function() sound.Volume = volume end) end end
        table.clear(soundSaved)
        muteBtn.Text = "🔇  TẮT ÂM THANH: TẮT"
        muteBtn.BackgroundColor3 = Color3.fromRGB(29, 105, 91)
        status.Text = "Đã khôi phục âm lượng"
    end
end

-- Shader đã được thay bằng trình phát nhạc; không còn hiệu ứng shader trong giao diện.
local function clearShader() end

-- Fix Lag: nút chỉ bật tối ưu đồ họa kiểu nhẹ; không có thao tác tắt/khôi phục.
fixBtn.Activated:Connect(function()
    if optimizationLevel >= 1 then
        status.Text = "Fix Lag đã được bật trước đó"
        return
    end
    local ok, err = pcall(function() optimizeVisuals(1) end)
    if not ok then
        status.Text = "Fix Lag lỗi: " .. tostring(err)
        return
    end
    optimizationLevel = 1
    fixBtn.Text = "⚡  FIX LAG: ON"
    status.Text = "Fix Lag đã bật • tối ưu đồ họa kiểu nhẹ"
end)

-- Siêu Fix Lag: chạy FPS Boost gốc v391() rồi áp dụng thêm tối ưu hình ảnh Utra FixLag.
-- Chỉ bật; không có chức năng khôi phục.
superBtn.Activated:Connect(function()
    if senaV4Config._fpsBoostApplying then
        status.Text = "Siêu Fix Lag đang chạy, vui lòng chờ"
        return
    end
    local ok, result = pcall(function()
        local originalReady = sourceFPSBoost()
        -- Lớp tối ưu bổ sung: hạ chi tiết vật thể, tắt hiệu ứng/texture và giảm tải hình ảnh.
        -- Không thay thế FPS Boost gốc; chạy tiếp sau chuỗi v391().
        -- v391 da xu ly phan lon Workspace; chi bo sung lighting/terrain, tranh quet lai toan bo map.
        optimizeVisuals(2, false, true)
        return originalReady
    end)
    if not ok then
        status.Text = "Siêu Fix Lag lỗi: " .. tostring(result)
        return
    end
    optimizationLevel = 2
    fixBtn.Text = "⚡  GIẢM GIẬT LAG"
    superBtn.Text = "🚀  SIÊU FIX LAG: ON"
    status.Text = result and "Siêu Fix Lag: FPS Boost gốc + tối ưu Utra đã bật" or "Siêu Fix Lag: đã áp dụng tối ưu bổ sung; FPS Boost gốc chỉ hoàn tất một phần"
end)

capBtn.Activated:Connect(function()
    local ok = setFpsCap(not fpsCapEnabled)
    status.Text = ok and (fpsCapEnabled and "Đã đặt FPS cap 240" or "Đã đặt FPS cap 60") or "Executor không hỗ trợ helper đặt FPS cap này"
end)

muteBtn.Activated:Connect(function() setMuted(not muted) end)



-- Drag support: header and floating button, mouse + touch
local function makeDraggable(handle, target, ignoreButton)
    local dragging = false
    local dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if ignoreButton and input.UserInputType == Enum.UserInputType.MouseButton1 then
                local p = input.Position
                if hideBtn.Visible and p.X >= hideBtn.AbsolutePosition.X and p.X <= hideBtn.AbsolutePosition.X + hideBtn.AbsoluteSize.X and p.Y >= hideBtn.AbsolutePosition.Y and p.Y <= hideBtn.AbsolutePosition.Y + hideBtn.AbsoluteSize.Y then return end
            end
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(header, main, true)
makeDraggable(musicHead, musicPanel, false)
makeDraggable(float, float, false)

-- Bảng nhạc có thể kéo bằng thanh tiêu đề; không còn xử lý shader.

-- Startup Boost: chay v390 mot lan; chi thu lai neu lan dau gap loi.
-- Tranh quet va thay doi toan bo map hai lan lien tiep gay khung luc moi vao game.
local startupBoostEnabled = true
task.spawn(function()
    task.wait(1.5)
    if not startupBoostEnabled or not gui.Parent then return end

    local ok, err = pcall(function() v390() end)
    if ok then
        status.Text = "Tăng tốc khởi động: tối ưu gốc đã chạy"
        return
    end

    status.Text = "Tối ưu khởi động lỗi, sẽ thử lại: " .. tostring(err):sub(1, 55)
    task.wait(4)
    if not startupBoostEnabled or not gui.Parent then return end
    local ok2, err2 = pcall(function() v390() end)
    if ok2 then
        status.Text = "Tăng tốc khởi động: chạy thành công sau lần thử lại"
    else
        status.Text = "Tối ưu khởi động lỗi: " .. tostring(err2):sub(1, 65)
    end
end)

-- Cleanup bộ đếm và trình phát nhạc khi GUI bị xóa.
gui.Destroying:Connect(function()
    if fpsConnection then fpsConnection:Disconnect() end
    if miniMusicConnection then miniMusicConnection:Disconnect() end
    pcall(function() musicSound:Stop(); musicSound:Destroy() end)
end)
