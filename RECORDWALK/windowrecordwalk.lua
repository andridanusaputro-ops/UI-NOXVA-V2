-- ==========================================
-- NOXVA HUB | RECORD WALK - WINDOW UI
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================

local NoxvaLib = _G.NoxvaLib or loadstring(game:HttpGet("https://raw.githubusercontent.com/andridanusaputro-ops/UI-NOXVA-V2/main/uiNoxvaV2.lua"))()
local Window = NoxvaLib:CreateWindow("NOXVA WALK RECORD", Color3.fromRGB(0, 120, 255))

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local successHui, hui = pcall(function() return gethui() end)
local targetParent = hui or CoreGui or (Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui"))
local NoxvaUI = targetParent:WaitForChild("NoxvaHub_Pure", 5)

if not NoxvaUI then
    warn("❌ [NOXVA ERROR] ScreenGui utama tidak ditemukan!")
    return
end

-- ==========================================
-- GLOBAL EXPORT (AMAN DARI BUG RE-EXECUTE)
-- ==========================================
_G.NoxvaWalkUI = _G.NoxvaWalkUI or {}

-- ==========================================
-- FUNGSI DRAGGABLE UI
-- ==========================================
local function MakeDraggable(Frame, TopBar)
    local dragToggle, dragInput, dragStart, startPos
    local dragTarget = TopBar or Frame
    
    dragTarget.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true; dragStart = input.Position; startPos = Frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
        end
    end)
    dragTarget.InputChanged:Connect(function(input)
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
-- PEMBUATAN WIDGET FRAME (STYLE STUDIOWALK)
-- ==========================================
local function CreateWidget(Name, DefaultPos, TitleText)
    local Widget = Instance.new("Frame", NoxvaUI)
    Widget.Name = Name
    Widget.Size = UDim2.new(0, 220, 0, 0) -- Tinggi auto menyesuaikan
    Widget.AutomaticSize = Enum.AutomaticSize.Y 
    Widget.Position = DefaultPos
    Widget.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Widget.Visible = false
    Instance.new("UICorner", Widget).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Widget)
    Stroke.Color = Color3.fromRGB(50, 150, 255); Stroke.Thickness = 1.5

    -- TOP BAR (Buat drag)
    local TopBar = Instance.new("Frame", Widget)
    TopBar.Size = UDim2.new(1, 0, 0, 25)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
    
    -- Fix ujung bawah TopBar biar nyatu sama body
    local FixCorner = Instance.new("Frame", TopBar)
    FixCorner.Size = UDim2.new(1, 0, 0, 5)
    FixCorner.Position = UDim2.new(0, 0, 1, -5)
    FixCorner.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    FixCorner.BorderSizePixel = 0
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, -25, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = TitleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(1, -25, 0.5, -10)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.MouseButton1Click:Connect(function() Widget.Visible = false end)

    MakeDraggable(Widget, TopBar)

    -- CONTAINER ISI
    local Content = Instance.new("Frame", Widget)
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.Position = UDim2.new(0, 0, 0, 30)
    Content.AutomaticSize = Enum.AutomaticSize.Y
    Content.BackgroundTransparency = 1

    local Layout = Instance.new("UIListLayout", Content)
    Layout.FillDirection = Enum.FillDirection.Vertical
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 6)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local Pad = Instance.new("UIPadding", Content)
    Pad.PaddingTop = UDim.new(0, 5); Pad.PaddingBottom = UDim.new(0, 10)
    Pad.PaddingLeft = UDim.new(0, 10); Pad.PaddingRight = UDim.new(0, 10)

    return Widget, Content
end

-- Fungsi bikin baris horizontal buat nyusun tombol
local function CreateRow(Parent)
    local Row = Instance.new("Frame", Parent)
    Row.Size = UDim2.new(1, 0, 0, 28)
    Row.BackgroundTransparency = 1
    
    local Layout = Instance.new("UIListLayout", Row)
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 5)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    return Row
end

local function C_Btn(Parent, Text, SizeX, Color)
    local b = Instance.new("TextButton", Parent)
    b.Size = UDim2.new(0, SizeX, 0, 28)
    b.BackgroundColor3 = Color; b.Text = Text; b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold; b.TextSize = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end

-- ==========================================
-- 1. PANEL STATUS & VIP REWIND (KIRI)
-- ==========================================
local W_Status, C_Status = CreateWidget("W_Status", UDim2.new(0.2, 0, 0.2, 0), "NOXVA VIP STATUS")

local StatusLbl = Instance.new("TextLabel", C_Status)
StatusLbl.Size = UDim2.new(1, 0, 0, 20); StatusLbl.BackgroundTransparency = 1; 
StatusLbl.Text = "Status: IDLE"
StatusLbl.TextColor3 = Color3.fromRGB(200, 200, 200); StatusLbl.Font = Enum.Font.GothamBold; StatusLbl.TextSize = 11

local InfoLbl = Instance.new("TextLabel", C_Status)
InfoLbl.Size = UDim2.new(1, 0, 0, 20); InfoLbl.BackgroundTransparency = 1; 
InfoLbl.Text = "Node: 0 | Waktu: 00:00"
InfoLbl.TextColor3 = Color3.fromRGB(150, 200, 255); InfoLbl.Font = Enum.Font.GothamBold; InfoLbl.TextSize = 11

local RowRewind = CreateRow(C_Status)
_G.NoxvaWalkUI.BtnRewind = C_Btn(RowRewind, "⏪ REWIND (3s)", 150, Color3.fromRGB(180, 120, 30))

_G.NoxvaWalkUI.StatusLabel = StatusLbl
_G.NoxvaWalkUI.InfoLabel = InfoLbl

-- ==========================================
-- 2. PANEL CONTROLS UTAMA (KANAN)
-- ==========================================
local W_Controls, C_Controls = CreateWidget("W_Controls", UDim2.new(0.6, 0, 0.2, 0), "NOXVA CONTROLS")

-- Baris 1: Play, Record, Stop
local Row1 = CreateRow(C_Controls)
_G.NoxvaWalkUI.BtnRecord = C_Btn(Row1, "⏺ REC", 60, Color3.fromRGB(200, 50, 50))
_G.NoxvaWalkUI.BtnPlay   = C_Btn(Row1, "▶ PLAY", 60, Color3.fromRGB(40, 200, 90))
_G.NoxvaWalkUI.BtnStop   = C_Btn(Row1, "⏹ STOP", 60, Color3.fromRGB(180, 40, 40))

-- Baris 2: Loop & Speed
local Row2 = CreateRow(C_Controls)
_G.NoxvaWalkUI.BtnLoop   = C_Btn(Row2, "🔄 LOOP OFF", 95, Color3.fromRGB(60, 120, 200))
_G.NoxvaWalkUI.BtnSpeed  = C_Btn(Row2, "⚡ SPEED 1x", 95, Color3.fromRGB(200, 150, 40))

-- Baris 3: Save, Load, Clear
local Row3 = CreateRow(C_Controls)
_G.NoxvaWalkUI.BtnSave   = C_Btn(Row3, "💾 SAVE", 60, Color3.fromRGB(60, 60, 150))
_G.NoxvaWalkUI.BtnLoad   = C_Btn(Row3, "📂 LOAD", 60, Color3.fromRGB(60, 120, 150))
_G.NoxvaWalkUI.BtnClear  = C_Btn(Row3, "🗑 CLEAR", 60, Color3.fromRGB(150, 50, 50))


-- ==========================================
-- TAB UI UTAMA (DI WINDOW NOXVA)
-- ==========================================
local WalkTab = Window:MakeTab("🏃 VIP Walk")

WalkTab:AddSection("WIDGET MANAGER")
WalkTab:AddDoubleButton("Tampilkan Status VIP", function() W_Status.Visible = true end, "Tampilkan Controls", function() W_Controls.Visible = true end)

Window:MakeConfigTab()

