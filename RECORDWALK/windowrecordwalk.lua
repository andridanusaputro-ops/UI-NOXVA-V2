-- ==========================================
-- NOXVA HUB | RECORD WALK - PURE OVERLAY (RGB & SAKLAR VIP)
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- 1. LOAD UI UTAMA LU DULU
local NoxvaLib = _G.NoxvaLib or loadstring(game:HttpGet("https://raw.githubusercontent.com/andridanusaputro-ops/UI-NOXVA-V2/main/uiNoxvaV2.lua"))()

local successHui, hui = pcall(function() return gethui() end)
local targetParent = hui or CoreGui or (Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui"))
local NoxvaUI = targetParent:WaitForChild("NoxvaHub_Pure", 5)

if not NoxvaUI then
    warn("❌ [NOXVA ERROR] ScreenGui NoxvaHub_Pure tidak ditemukan!")
    return
end

-- ==========================================
-- HACKING UI UTAMA: HIDE MAIN TAB, KEEP FPS & LOGO
-- ==========================================
local MainFrame, OpenLogo, ConfirmOverlay, NotifContainer

for _, child in ipairs(NoxvaUI:GetChildren()) do
    if child:IsA("Frame") then
        if child.Size == UDim2.new(0, 480, 0, 310) then MainFrame = child
        elseif child.Size == UDim2.new(0, 50, 0, 50) then OpenLogo = child
        elseif child.Size == UDim2.new(1, 0, 1, 0) and child.BackgroundTransparency == 1 then ConfirmOverlay = child
        elseif child.Name == "NotifContainer" then NotifContainer = child end
    end
end

if MainFrame then MainFrame.Visible = false end

-- ==========================================
-- GLOBAL EXPORT & STATE TRACKER
-- ==========================================
_G.NoxvaWalkUI = _G.NoxvaWalkUI or {}
_G.NoxvaWalkUI.State = { VIP = true, Ctrl = false, File = false }
local RGBStrokes = {} -- Buat nampung garis yang mau diwarnain pelangi

-- ==========================================
-- FUNGSI NOTIFIKASI ALA NOXVA
-- ==========================================
local function SendNoxvaNotif(Title, Text)
    if not NotifContainer then return end
    local NotifFrame = Instance.new("Frame", NotifContainer)
    NotifFrame.Size = UDim2.new(1, 0, 0, 60); NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); NotifFrame.BackgroundTransparency = 0.1
    NotifFrame.Position = UDim2.new(1, 300, 0, 0)
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 5)
    local NStroke = Instance.new("UIStroke", NotifFrame); NStroke.Thickness = 1.5
    table.insert(RGBStrokes, NStroke) -- Masukin ke efek pelangi

    local NotifTitle = Instance.new("TextLabel", NotifFrame)
    NotifTitle.Size = UDim2.new(1, -20, 0, 20); NotifTitle.Position = UDim2.new(0, 10, 0, 5); NotifTitle.BackgroundTransparency = 1; NotifTitle.Text = Title
    NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255); NotifTitle.Font = Enum.Font.GothamBold; NotifTitle.TextSize = 13; NotifTitle.TextXAlignment = Enum.TextXAlignment.Left

    local NotifDesc = Instance.new("TextLabel", NotifFrame)
    NotifDesc.Size = UDim2.new(1, -20, 0, 30); NotifDesc.Position = UDim2.new(0, 10, 0, 25); NotifDesc.BackgroundTransparency = 1; NotifDesc.Text = Text
    NotifDesc.TextColor3 = Color3.fromRGB(200, 200, 200); NotifDesc.Font = Enum.Font.GothamSemibold; NotifDesc.TextSize = 12; NotifDesc.TextXAlignment = Enum.TextXAlignment.Left; NotifDesc.TextWrapped = true

    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.delay(3, function()
        local fadeOut = TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 0, 0)})
        fadeOut:Play()
        fadeOut.Completed:Connect(function() NotifFrame:Destroy() end)
    end)
end

-- ==========================================
-- FUNGSI DRAGGABLE
-- ==========================================
local function MakeDraggable(Frame, DragArea)
    local dragging, dragInput, dragStart, startPos
    DragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = Frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    DragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ==========================================
-- TEMPLATE BUILDER FLOATING PANEL
-- ==========================================
local function CreatePanel(Name, TitleText, Pos, SizeX, isMasterPanel)
    local Panel = Instance.new("Frame", NoxvaUI) 
    Panel.Name = Name; Panel.Size = UDim2.new(0, SizeX, 0, 0); Panel.Position = Pos; Panel.AutomaticSize = Enum.AutomaticSize.Y
    Panel.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Panel.BackgroundTransparency = 0.2; Panel.Visible = false 
    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 10)
    
    local Stroke = Instance.new("UIStroke", Panel); Stroke.Thickness = 1.5
    table.insert(RGBStrokes, Stroke) -- Bikin frame ini RGB kelap-kelip

    local TopBar = Instance.new("Frame", Panel); TopBar.Size = UDim2.new(1, 0, 0, 25); TopBar.BackgroundTransparency = 1
    MakeDraggable(Panel, TopBar)

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, -50, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0); Title.BackgroundTransparency = 1; Title.Text = TitleText; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20); CloseBtn.Position = UDim2.new(1, -25, 0.5, -10); CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80); CloseBtn.Font = Enum.Font.GothamBold
    
    local MinBtn = nil
    if isMasterPanel then
        MinBtn = Instance.new("TextButton", TopBar)
        MinBtn.Size = UDim2.new(0, 20, 0, 20); MinBtn.Position = UDim2.new(1, -45, 0.5, -10); MinBtn.BackgroundTransparency = 1; MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 20
    else
        CloseBtn.MouseButton1Click:Connect(function() Panel.Visible = false end)
    end

    local Line = Instance.new("Frame", Panel); Line.Size = UDim2.new(0.9, 0, 0, 1); Line.Position = UDim2.new(0.05, 0, 0, 25); Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Line.BackgroundTransparency = 0.8
    local Content = Instance.new("Frame", Panel); Content.Size = UDim2.new(1, 0, 0, 0); Content.Position = UDim2.new(0, 0, 0, 30); Content.AutomaticSize = Enum.AutomaticSize.Y; Content.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Content); Layout.FillDirection = Enum.FillDirection.Vertical; Layout.SortOrder = Enum.SortOrder.LayoutOrder; Layout.Padding = UDim.new(0, 8); Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local Pad = Instance.new("UIPadding", Content); Pad.PaddingTop = UDim.new(0, 5); Pad.PaddingBottom = UDim.new(0, 12)

    return Panel, Content, CloseBtn, MinBtn
end

local function C_Btn(Parent, Text, SizeX, Color)
    local b = Instance.new("TextButton", Parent); b.Size = UDim2.new(0, SizeX, 0, 30); b.BackgroundColor3 = Color; b.Text = Text; b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.GothamBold; b.TextSize = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", b); Stroke.Color = Color3.fromRGB(255, 255, 255); Stroke.Transparency = 0.8; Stroke.Thickness = 1
    return b
end

local function CreateRow(Parent)
    local Row = Instance.new("Frame", Parent); Row.Size = UDim2.new(1, 0, 0, 30); Row.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Row); Layout.FillDirection = Enum.FillDirection.Horizontal; Layout.SortOrder = Enum.SortOrder.LayoutOrder; Layout.Padding = UDim.new(0, 8); Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return Row
end

-- UI DROPDOWN KHUSUS FILE MANAGER
local function CreateDropdown(Parent, DefaultText)
    local Frame = Instance.new("Frame", Parent); Frame.Size = UDim2.new(0, 150, 0, 30); Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Frame.ClipsDescendants = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 5)
    local Stroke = Instance.new("UIStroke", Frame); Stroke.Color = Color3.fromRGB(100, 100, 100)
    
    local MainBtn = Instance.new("TextButton", Frame); MainBtn.Size = UDim2.new(1, 0, 0, 30); MainBtn.BackgroundTransparency = 1; MainBtn.Text = DefaultText .. " ▼"; MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MainBtn.Font = Enum.Font.Gotham; MainBtn.TextSize = 11
    
    local Scroll = Instance.new("ScrollingFrame", Frame); Scroll.Size = UDim2.new(1, 0, 1, -30); Scroll.Position = UDim2.new(0, 0, 0, 30); Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 2
    local Layout = Instance.new("UIListLayout", Scroll); Layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local isOpen = false
    MainBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        MainBtn.Text = DefaultText .. (isOpen and " ▲" or " ▼")
        Frame.Size = isOpen and UDim2.new(0, 150, 0, 120) or UDim2.new(0, 150, 0, 30)
    end)
    
    local API = {Container = Scroll, Btn = MainBtn, MainFrame = Frame}
    return API
end

-- ==========================================
-- 1. PANEL UTAMA SAKLAR (NOXVAWALK VIP)
-- ==========================================
local P_VIP, C_VIP, VIP_CloseBtn, VIP_MinBtn = CreatePanel("Widget_VIP", "NOXVAWALK VIP", UDim2.new(0.05, 0, 0.3, 0), 200, true)

-- Teks Besar Berubah-ubah
local StatusTxt = Instance.new("TextLabel", C_VIP)
StatusTxt.Size = UDim2.new(1, 0, 0, 30); StatusTxt.BackgroundTransparency = 1; StatusTxt.Text = "CP 0"; StatusTxt.TextColor3 = Color3.fromRGB(100, 200, 255); StatusTxt.Font = Enum.Font.GothamBlack; StatusTxt.TextSize = 22
_G.NoxvaWalkUI.StatusLabel = StatusTxt

local function UpdateBigText(txt) StatusTxt.Text = txt end

local RowV1 = CreateRow(C_VIP)
_G.NoxvaWalkUI.BtnSet   = C_Btn(RowV1, "⏺ SET", 85, Color3.fromRGB(180, 40, 40))
_G.NoxvaWalkUI.BtnClear = C_Btn(RowV1, "🗑 CLEAR", 85, Color3.fromRGB(40, 100, 180))

local RowV2 = CreateRow(C_VIP)
_G.NoxvaWalkUI.BtnRewind = C_Btn(RowV2, "⏪ REWIND", 85, Color3.fromRGB(40, 140, 180))
_G.NoxvaWalkUI.BtnFile   = C_Btn(RowV2, "📁 FILE", 85, Color3.fromRGB(40, 180, 80))

-- ==========================================
-- 2. PANEL CONTROLS (NOXVAWALK CONTROL)
-- ==========================================
local P_Ctrl, C_Ctrl = CreatePanel("Widget_Ctrl", "NOXVAWALK CONTROL", UDim2.new(0.75, 0, 0.3, 0), 200, false)

local RowC1 = CreateRow(C_Ctrl)
_G.NoxvaWalkUI.BtnPlay = C_Btn(RowC1, "▶ PLAY", 85, Color3.fromRGB(40, 180, 80))
_G.NoxvaWalkUI.BtnLoop = C_Btn(RowC1, "🔄 LOOP", 85, Color3.fromRGB(40, 180, 80))

local RowC2 = CreateRow(C_Ctrl)
_G.NoxvaWalkUI.BtnSpeed = C_Btn(RowC2, "⚡ SPEED 1x", 175, Color3.fromRGB(60, 60, 60))

local InfoTxt = Instance.new("TextLabel", C_Ctrl)
InfoTxt.Size = UDim2.new(1, 0, 0, 20); InfoTxt.BackgroundTransparency = 1; InfoTxt.Text = "Nodes: 0 | 00:00"; InfoTxt.TextColor3 = Color3.fromRGB(200, 200, 200); InfoTxt.Font = Enum.Font.Gotham; InfoTxt.TextSize = 11
_G.NoxvaWalkUI.InfoLabel = InfoTxt

-- ==========================================
-- 3. PANEL FILE MANAGER
-- ==========================================
local P_File, C_File = CreatePanel("Widget_File", "FILE MANAGER", UDim2.new(0.4, 0, 0.4, 0), 180, false)

-- TextBox buat Save Baru
local FileNameInput = Instance.new("TextBox", C_File)
FileNameInput.Size = UDim2.new(0, 150, 0, 30); FileNameInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30); FileNameInput.Text = "Nama_Rute"; FileNameInput.TextColor3 = Color3.fromRGB(255, 255, 255); FileNameInput.Font = Enum.Font.Gotham; FileNameInput.TextSize = 12
Instance.new("UICorner", FileNameInput).CornerRadius = UDim.new(0, 5)
_G.NoxvaWalkUI.InputFileName = FileNameInput

local RowF1 = CreateRow(C_File)
_G.NoxvaWalkUI.BtnSave = C_Btn(RowF1, "💾 SAVE", 150, Color3.fromRGB(40, 180, 80))

-- Dropdown Daftar Save
local SavedFilesDropdown = CreateDropdown(C_File, "Pilih Rute Load...")
_G.NoxvaWalkUI.DropdownAPI = SavedFilesDropdown

-- LOGIC UI DROPDOWN: Kalo dipilih, langsung buka NOXVAWALK CONTROL
function _G.NoxvaWalkUI.PopulateDropdown(fileList)
    for _, v in pairs(SavedFilesDropdown.Container:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    
    local ySize = 0
    for _, fileName in ipairs(fileList) do
        local btn = Instance.new("TextButton", SavedFilesDropdown.Container)
        btn.Size = UDim2.new(1, 0, 0, 25); btn.BackgroundTransparency = 1; btn.Text = fileName; btn.TextColor3 = Color3.fromRGB(200,200,200); btn.Font = Enum.Font.Gotham; btn.TextSize = 11
        
        btn.MouseButton1Click:Connect(function()
            SavedFilesDropdown.Btn.Text = fileName .. " ▼"
            SavedFilesDropdown.MainFrame.Size = UDim2.new(0, 150, 0, 30) -- Tutup dropdown
            -- Otomatis Buka Control Panel
            P_Ctrl.Visible = true
            SendNoxvaNotif("FILE MANAGER", "Rute " .. fileName .. " siap di-play!")
            
            -- Nanti di backend filemanager.lua, lu tambahin logic load data json-nya disini
            if _G.LoadRouteAction then _G.LoadRouteAction(fileName) end 
        end)
        ySize = ySize + 25
    end
    SavedFilesDropdown.Container.CanvasSize = UDim2.new(0, 0, 0, ySize)
end

-- Dummy data buat ngetes tampilan dropdown
_G.NoxvaWalkUI.PopulateDropdown({"Rute_Pvp", "SaveWalk1", "SaveWalk2"})


-- ==========================================
-- INTERAKSI TOMBOL SAKLAR DI NOXVAWALK VIP
-- ==========================================

_G.NoxvaWalkUI.BtnSet.MouseButton1Click:Connect(function()
    UpdateBigText("RECORDING")
    SendNoxvaNotif("NOXVA RECORD", "Memulai perekaman jalur...")
end)

_G.NoxvaWalkUI.BtnRewind.MouseButton1Click:Connect(function()
    UpdateBigText("REWIND")
    SendNoxvaNotif("NOXVA REWIND", "Mundur 3 detik!")
end)

_G.NoxvaWalkUI.BtnFile.MouseButton1Click:Connect(function()
    UpdateBigText("FILE")
    P_File.Visible = not P_File.Visible
end)

_G.NoxvaWalkUI.BtnClear.MouseButton1Click:Connect(function()
    UpdateBigText("CLEAR")
    -- Sembunyiin semua kecuali VIP
    P_File.Visible = false
    P_Ctrl.Visible = false
    SendNoxvaNotif("NOXVA CLEAR", "Tab disembunyikan & Memori di-reset!")
end)


-- ==========================================
-- LOGIC MINIMIZE (-) & CLOSE (X) DI NOXVAWALK VIP
-- ==========================================
VIP_MinBtn.MouseButton1Click:Connect(function()
    _G.NoxvaWalkUI.State.Ctrl = P_Ctrl.Visible
    _G.NoxvaWalkUI.State.File = P_File.Visible
    
    P_VIP.Visible = false
    P_Ctrl.Visible = false
    P_File.Visible = false
    
    if OpenLogo then OpenLogo.Visible = true end
end)

if MainFrame then
    MainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
        if MainFrame.Visible then
            MainFrame.Visible = false
            P_VIP.Visible = true
            P_Ctrl.Visible = _G.NoxvaWalkUI.State.Ctrl
            P_File.Visible = _G.NoxvaWalkUI.State.File
        end
    end)
end

VIP_CloseBtn.MouseButton1Click:Connect(function()
    P_VIP.Visible = false
    P_Ctrl.Visible = false
    P_File.Visible = false
    
    if ConfirmOverlay then
        ConfirmOverlay.Visible = true
        TweenService:Create(ConfirmOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
    else
        NoxvaUI:Destroy()
    end
end)

-- ==========================================
-- RGB CHROMA LOOP (UNTUK FRAME)
-- ==========================================
RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5
    local rgbColor = Color3.fromHSV(hue, 1, 1)
    for _, stroke in ipairs(RGBStrokes) do
        stroke.Color = rgbColor
    end
end)

-- TAMPILKAN OTOMATIS SAAT DILOAD
P_VIP.Visible = true
