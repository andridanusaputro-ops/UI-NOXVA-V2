-- ==========================================
-- NOXVA HUB | RECORD WALK - 100% PURE OVERLAY (PIGGYBACK SYSTEM)
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- 1. LOAD UI UTAMA LU DULU (Biar FPS, Logo, dan Sistem Close bawaan lu nyala)
local NoxvaLib = _G.NoxvaLib or loadstring(game:HttpGet("https://raw.githubusercontent.com/andridanusaputro-ops/UI-NOXVA-V2/main/uiNoxvaV2.lua"))()
local Window = NoxvaLib:CreateWindow("NOXVA", Color3.fromRGB(0, 120, 255))

local successHui, hui = pcall(function() return gethui() end)
local targetParent = hui or CoreGui or (Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui"))
local NoxvaUI = targetParent:WaitForChild("NoxvaHub_Pure", 5)

if not NoxvaUI then
    warn("❌ [NOXVA ERROR] ScreenGui NoxvaHub_Pure tidak ditemukan!")
    return
end

-- ==========================================
-- HACKING UI UTAMA: SEMBUNYIKAN TAB GEDE, TAPI BIARKAN LOGO & FPS HIDUP
-- ==========================================
local MainFrame, OpenLogo, ConfirmOverlay

for _, child in ipairs(NoxvaUI:GetChildren()) do
    if child:IsA("Frame") then
        if child.Size == UDim2.new(0, 480, 0, 310) then
            MainFrame = child
        elseif child.Size == UDim2.new(0, 50, 0, 50) then
            OpenLogo = child
        elseif child.Size == UDim2.new(1, 0, 1, 0) and child.BackgroundTransparency == 1 then
            ConfirmOverlay = child
        end
    end
end

-- Sembunyikan jendela besar bawaan UI lu secara permanen
if MainFrame then
    MainFrame.Visible = false
end

-- ==========================================
-- GLOBAL EXPORT UNTUK LOGIC
-- ==========================================
_G.NoxvaWalkUI = _G.NoxvaWalkUI or {}
-- Tracker status panel supaya pas di-restore dari logo, posisinya tetep bener
_G.NoxvaWalkUI.State = { VIP = true, Ctrl = true }

-- ==========================================
-- FUNGSI DRAGGABLE
-- ==========================================
local function MakeDraggable(Frame, DragArea)
    local dragToggle, dragInput, dragStart, startPos
    local target = DragArea or Frame
    
    target.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true; dragStart = input.Position; startPos = Frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
        end
    end)
    target.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ==========================================
-- TEMPLATE BUILDER FLOATING PANEL (100% CLONE)
-- ==========================================
local function CreatePanel(Name, TitleText, Pos, SizeX, isCenterPanel)
    local Panel = Instance.new("Frame", NoxvaUI) -- NUMPANG DI UI UTAMA LU
    Panel.Name = Name
    Panel.Size = UDim2.new(0, SizeX, 0, 0)
    Panel.Position = Pos
    Panel.AutomaticSize = Enum.AutomaticSize.Y
    Panel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Panel.BackgroundTransparency = 0.2
    Panel.Visible = false 
    
    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", Panel)
    Stroke.Color = Color3.fromRGB(150, 255, 100)
    Stroke.Thickness = 1.5

    local TopBar = Instance.new("Frame", Panel)
    TopBar.Size = UDim2.new(1, 0, 0, 25)
    TopBar.BackgroundTransparency = 1
    MakeDraggable(Panel, TopBar)

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = TitleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Tombol Close X (Standar)
    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(1, -25, 0.5, -10)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.Font = Enum.Font.GothamBold

    local MinBtn = nil
    if isCenterPanel then
        -- Tombol Minimize (-) khusus Panel Tengah
        MinBtn = Instance.new("TextButton", TopBar)
        MinBtn.Size = UDim2.new(0, 20, 0, 20)
        MinBtn.Position = UDim2.new(1, -45, 0.5, -10)
        MinBtn.BackgroundTransparency = 1
        MinBtn.Text = "-"
        MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        MinBtn.Font = Enum.Font.GothamBold
        MinBtn.TextSize = 20
    end

    local Line = Instance.new("Frame", Panel)
    Line.Size = UDim2.new(0.9, 0, 0, 1)
    Line.Position = UDim2.new(0.05, 0, 0, 25)
    Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Line.BackgroundTransparency = 0.8

    local Content = Instance.new("Frame", Panel)
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.Position = UDim2.new(0, 0, 0, 30)
    Content.AutomaticSize = Enum.AutomaticSize.Y
    Content.BackgroundTransparency = 1

    local Layout = Instance.new("UIListLayout", Content)
    Layout.FillDirection = Enum.FillDirection.Vertical
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local Pad = Instance.new("UIPadding", Content)
    Pad.PaddingTop = UDim.new(0, 5); Pad.PaddingBottom = UDim.new(0, 12)

    if not isCenterPanel then
        CloseBtn.MouseButton1Click:Connect(function() Panel.Visible = false end)
    end

    return Panel, Content, CloseBtn, MinBtn
end

local function C_Btn(Parent, Text, SizeX, Color)
    local b = Instance.new("TextButton", Parent)
    b.Size = UDim2.new(0, SizeX, 0, 30)
    b.BackgroundColor3 = Color
    b.Text = Text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local Stroke = Instance.new("UIStroke", b)
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Transparency = 0.8
    Stroke.Thickness = 1
    return b
end

local function CreateRow(Parent)
    local Row = Instance.new("Frame", Parent)
    Row.Size = UDim2.new(1, 0, 0, 30)
    Row.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Row)
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return Row
end

-- ==========================================
-- 1. PANEL VIP (KIRI)
-- ==========================================
local P_VIP, C_VIP = CreatePanel("Widget_VIP", "STUDIOWALK VIP", UDim2.new(0.05, 0, 0.3, 0), 200, false)
local StatusTxt = Instance.new("TextLabel", C_VIP)
StatusTxt.Size = UDim2.new(1, 0, 0, 30); StatusTxt.BackgroundTransparency = 1; StatusTxt.Text = "CP 0"; StatusTxt.TextColor3 = Color3.fromRGB(100, 200, 255); StatusTxt.Font = Enum.Font.GothamBlack; StatusTxt.TextSize = 22
_G.NoxvaWalkUI.StatusLabel = StatusTxt

local RowV1 = CreateRow(C_VIP)
_G.NoxvaWalkUI.BtnSet   = C_Btn(RowV1, "⏺ SET", 85, Color3.fromRGB(180, 40, 40))
_G.NoxvaWalkUI.BtnClear = C_Btn(RowV1, "🗑 CLEAR", 85, Color3.fromRGB(40, 100, 180))

local RowV2 = CreateRow(C_VIP)
_G.NoxvaWalkUI.BtnRewind = C_Btn(RowV2, "⏪ REWIND", 85, Color3.fromRGB(40, 140, 180))
_G.NoxvaWalkUI.BtnPass   = C_Btn(RowV2, "⏭ PASS", 85, Color3.fromRGB(40, 180, 80))

P_VIP:GetPropertyChangedSignal("Visible"):Connect(function() _G.NoxvaWalkUI.State.VIP = P_VIP.Visible end)

-- ==========================================
-- 2. PANEL CONTROLS (KANAN)
-- ==========================================
local P_Ctrl, C_Ctrl = CreatePanel("Widget_Ctrl", "STUDIOWALK CONTROLS", UDim2.new(0.75, 0, 0.3, 0), 200, false)
local RowC1 = CreateRow(C_Ctrl)
_G.NoxvaWalkUI.BtnPlay = C_Btn(RowC1, "▶ PLAY", 85, Color3.fromRGB(40, 180, 80))
_G.NoxvaWalkUI.BtnLoop = C_Btn(RowC1, "🔄 LOOP", 85, Color3.fromRGB(40, 180, 80))

local RowC2 = CreateRow(C_Ctrl)
_G.NoxvaWalkUI.BtnSpeed = C_Btn(RowC2, "⚡ SPEED 1x", 175, Color3.fromRGB(60, 60, 60))

local InfoTxt = Instance.new("TextLabel", C_Ctrl)
InfoTxt.Size = UDim2.new(1, 0, 0, 20); InfoTxt.BackgroundTransparency = 1; InfoTxt.Text = "Nodes: 0 | 00:00"; InfoTxt.TextColor3 = Color3.fromRGB(200, 200, 200); InfoTxt.Font = Enum.Font.Gotham; InfoTxt.TextSize = 11
_G.NoxvaWalkUI.InfoLabel = InfoTxt

P_Ctrl:GetPropertyChangedSignal("Visible"):Connect(function() _G.NoxvaWalkUI.State.Ctrl = P_Ctrl.Visible end)

-- ==========================================
-- 3. PANEL TENGAH (MASTER HUB & FILE) - SAKLAR UTAMA
-- ==========================================
local P_File, C_File, F_CloseBtn, F_MinBtn = CreatePanel("Widget_File", "MASTER HUB", UDim2.new(0.4, 0, 0.35, 0), 180, true)

-- SAKLAR ON/OFF BUAT MUNCULIN VIP & CONTROLS LAGI KALO DISILANG
local RowSaklar = CreateRow(C_File)
local BtnToggleVIP = C_Btn(RowSaklar, "👑 VIP", 70, Color3.fromRGB(40, 40, 40))
local BtnToggleCtrl = C_Btn(RowSaklar, "🎮 CTRL", 70, Color3.fromRGB(40, 40, 40))

BtnToggleVIP.MouseButton1Click:Connect(function() P_VIP.Visible = not P_VIP.Visible end)
BtnToggleCtrl.MouseButton1Click:Connect(function() P_Ctrl.Visible = not P_Ctrl.Visible end)

-- FILE MANAGER BAWAHNYA
local FileNameInput = Instance.new("TextBox", C_File)
FileNameInput.Size = UDim2.new(0, 150, 0, 30); FileNameInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30); FileNameInput.Text = "Rute_1"; FileNameInput.TextColor3 = Color3.fromRGB(255, 255, 255); FileNameInput.Font = Enum.Font.Gotham; FileNameInput.TextSize = 12
Instance.new("UICorner", FileNameInput).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", FileNameInput).Color = Color3.fromRGB(100, 100, 100)
_G.NoxvaWalkUI.InputFileName = FileNameInput

local RowF1 = CreateRow(C_File)
_G.NoxvaWalkUI.BtnSave = C_Btn(RowF1, "💾 SAVE", 70, Color3.fromRGB(40, 180, 80))
_G.NoxvaWalkUI.BtnLoad = C_Btn(RowF1, "📂 LOAD", 70, Color3.fromRGB(180, 120, 30))

-- ==========================================
-- LOGIC MINIMIZE (-) & CLOSE (X) PANEL TENGAH
-- ==========================================

-- Logic (-) Minimize
F_MinBtn.MouseButton1Click:Connect(function()
    -- Sembunyikan semua 3 panel
    P_VIP.Visible = false
    P_Ctrl.Visible = false
    P_File.Visible = false
    
    -- Panggil Logo Bawaan UI Lu!
    if OpenLogo then 
        OpenLogo.Visible = true 
    end
end)

-- Logic Nangkap Klik Logo Bawaan UI
if MainFrame then
    MainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
        -- Kalo logo diklik, UI bawaan lu bakal berusaha nampilin MainFrame
        if MainFrame.Visible then
            -- KITA BAJAK! Sembunyiin lagi MainFrame-nya
            MainFrame.Visible = false
            
            -- Munculin Panel Tengah & Kembalikan status panel samping
            P_File.Visible = true
            P_VIP.Visible = _G.NoxvaWalkUI.State.VIP
            P_Ctrl.Visible = _G.NoxvaWalkUI.State.Ctrl
        end
    end)
end

-- Logic (X) Close
F_CloseBtn.MouseButton1Click:Connect(function()
    -- Sembunyikan overlay StudioWalk biar layar bersih
    P_VIP.Visible = false
    P_Ctrl.Visible = false
    P_File.Visible = false
    
    -- Panggil Warning Dialog Peringatan Bawaan UI Lu!
    if ConfirmOverlay then
        ConfirmOverlay.Visible = true
        TweenService:Create(ConfirmOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
    else
        NoxvaUI:Destroy() -- Fallback kalau overlay ga nemu
    end
end)

-- ==========================================
-- TAMPILKAN OTOMATIS SAAT DILOAD
-- ==========================================
P_VIP.Visible = true
P_Ctrl.Visible = true
P_File.Visible = true
