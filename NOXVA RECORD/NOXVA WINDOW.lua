-- ==========================================
-- NOXVA HUB - PURE WINDOW WALK RECORD (CLEAN UI - NO COIL BLOAT)
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
    warn("Noxva Error: ScreenGui utama tidak ditemukan!")
    return
end

-- ==========================================
-- GLOBAL EXPORT (CLEAN)
-- ==========================================
_G.NoxvaWalkUI = {}
_G.NoxvaWalkData = _G.NoxvaWalkData or {}

-- ==========================================
-- FUNGSI DRAGGABLE UI
-- ==========================================
local function MakeDraggable(Frame)
    local dragToggle, dragInput, dragStart, startPos
    Frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true; dragStart = input.Position; startPos = Frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
        end
    end)
    Frame.InputChanged:Connect(function(input)
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
-- PEMBUATAN WIDGET FRAME
-- ==========================================
local function CreateWidget(Name, DefaultPos)
    local Widget = Instance.new("Frame", NoxvaUI)
    Widget.Name = Name
    Widget.Size = UDim2.new(0, 0, 0, 45) 
    Widget.AutomaticSize = Enum.AutomaticSize.X 
    Widget.Position = DefaultPos
    Widget.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Widget.Visible = false
    Instance.new("UICorner", Widget).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Widget)
    Stroke.Color = Color3.fromRGB(50, 50, 50); Stroke.Thickness = 1
    MakeDraggable(Widget)

    local Layout = Instance.new("UIListLayout", Widget)
    Layout.FillDirection = Enum.FillDirection.Horizontal; Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 6); Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    
    local Pad = Instance.new("UIPadding", Widget)
    Pad.PaddingLeft = UDim.new(0, 10); Pad.PaddingRight = UDim.new(0, 10)
    return Widget
end

local function C_Btn(Parent, Text, SizeX, Color)
    local b = Instance.new("TextButton", Parent)
    b.Size = UDim2.new(0, SizeX, 0, 28)
    b.BackgroundColor3 = Color; b.Text = Text; b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold; b.TextSize = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end

local function AddCloseBtn(Parent)
    local b = C_Btn(Parent, "X", 25, Color3.fromRGB(200, 50, 50))
    b.MouseButton1Click:Connect(function() Parent.Visible = false end)
end

local function CreateCPDropdown(Parent)
    local DropContainer = Instance.new("Frame", Parent)
    DropContainer.Size = UDim2.new(0, 90, 0, 28)
    DropContainer.BackgroundTransparency = 1
    
    local MainBtn = Instance.new("TextButton", DropContainer)
    MainBtn.Size = UDim2.new(1, 0, 1, 0)
    MainBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainBtn.Text = "CP: None ▼"
    MainBtn.TextColor3 = Color3.fromRGB(240, 200, 50)
    MainBtn.Font = Enum.Font.GothamBold
    MainBtn.TextSize = 10
    Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(0, 5)
    
    local ListContainer = Instance.new("ScrollingFrame", DropContainer)
    ListContainer.Size = UDim2.new(1, 0, 0, 100)
    ListContainer.Position = UDim2.new(0, 0, 1, 2)
    ListContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ListContainer.Visible = false
    ListContainer.ZIndex = 10 
    ListContainer.ScrollBarThickness = 2
    Instance.new("UICorner", ListContainer).CornerRadius = UDim.new(0, 5)
    
    local ListLayout = Instance.new("UIListLayout", ListContainer)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    MainBtn.MouseButton1Click:Connect(function()
        ListContainer.Visible = not ListContainer.Visible
        local currentText = MainBtn.Text:gsub(" ▼", ""):gsub(" ▲", "")
        MainBtn.Text = currentText .. (ListContainer.Visible and " ▲" or " ▼")
    end)
    
    local DropdownAPI = {}
    function DropdownAPI:UpdateList(CP_Table, CallbackAction)
        for _, v in pairs(ListContainer:GetChildren()) do
            if v:IsA("TextButton") then v:Destroy() end
        end
        local ySize = 0
        for _, cpName in ipairs(CP_Table) do
            local opt = Instance.new("TextButton", ListContainer)
            opt.Size = UDim2.new(1, 0, 0, 25); opt.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            opt.BackgroundTransparency = 0.5; opt.Text = cpName; opt.TextColor3 = Color3.fromRGB(200, 200, 200)
            opt.Font = Enum.Font.GothamBold; opt.TextSize = 10; opt.ZIndex = 11; opt.BorderSizePixel = 0
            
            opt.MouseButton1Click:Connect(function()
                MainBtn.Text = cpName .. " ▼"
                ListContainer.Visible = false
                if CallbackAction then CallbackAction(cpName) end
            end)
            ySize = ySize + 25
        end
        ListContainer.CanvasSize = UDim2.new(0, 0, 0, ySize)
    end
    return DropdownAPI
end

-- ==========================================
-- 1. WIDGET TIMELINE
-- ==========================================
local W_Timeline = CreateWidget("W_Timeline", UDim2.new(0.3, 0, 0.2, 0))
local EditLbl = Instance.new("TextLabel", W_Timeline)
EditLbl.Size = UDim2.new(0, 75, 0, 28); EditLbl.BackgroundTransparency = 1; EditLbl.Text = "Frame: 0/0"; EditLbl.TextColor3 = Color3.fromRGB(255, 200, 50); EditLbl.Font = Enum.Font.GothamBold; EditLbl.TextSize = 10
_G.NoxvaWalkUI.EditLabel = EditLbl
_G.NoxvaWalkUI.BtnPrev = C_Btn(W_Timeline, "<<", 35, Color3.fromRGB(50, 50, 50))
_G.NoxvaWalkUI.BtnNext = C_Btn(W_Timeline, ">>", 35, Color3.fromRGB(50, 50, 50))
_G.NoxvaWalkUI.BtnDone = C_Btn(W_Timeline, "✂️ POTONG", 65, Color3.fromRGB(180, 40, 40))
_G.NoxvaWalkUI.CPDropdown = CreateCPDropdown(W_Timeline)
AddCloseBtn(W_Timeline)

-- ==========================================
-- 2. WIDGET RECORD & PLAY
-- ==========================================
local W_Record = CreateWidget("W_Record", UDim2.new(0.6, 0, 0.2, 0))
local InfoLbl = Instance.new("TextLabel", W_Record)
InfoLbl.Size = UDim2.new(0, 110, 0, 28); InfoLbl.BackgroundTransparency = 1; InfoLbl.Text = "Total: 0 | 00:00"; InfoLbl.TextColor3 = Color3.fromRGB(150, 200, 255); InfoLbl.Font = Enum.Font.GothamBold; InfoLbl.TextSize = 10
_G.NoxvaWalkUI.InfoLabel = InfoLbl
_G.NoxvaWalkUI.BtnRecord = C_Btn(W_Record, "⏺ RECORD", 65, Color3.fromRGB(200, 50, 50))
_G.NoxvaWalkUI.BtnPlay   = C_Btn(W_Record, "▶ PLAY", 50, Color3.fromRGB(40, 200, 90))
_G.NoxvaWalkUI.BtnSave   = C_Btn(W_Record, "💾 SAVE", 55, Color3.fromRGB(60, 60, 150))
_G.NoxvaWalkUI.BtnLoad   = C_Btn(W_Record, "📂 LOAD", 55, Color3.fromRGB(60, 120, 150))
_G.NoxvaWalkUI.BtnExport = C_Btn(W_Record, "📋 EXPORT", 65, Color3.fromRGB(150, 60, 150))
AddCloseBtn(W_Record)

-- ==========================================
-- 3. WIDGET CONTROLS
-- ==========================================
local W_Control = CreateWidget("W_Control", UDim2.new(0.6, 0, 0.3, 0))
_G.NoxvaWalkUI.BtnLoop  = C_Btn(W_Control, "🔄 LOOP OFF", 75, Color3.fromRGB(40, 150, 240))
_G.NoxvaWalkUI.BtnPause = C_Btn(W_Control, "⏸ PAUSE", 60, Color3.fromRGB(120, 120, 120))
_G.NoxvaWalkUI.BtnStop  = C_Btn(W_Control, "⏹ STOP", 50, Color3.fromRGB(40, 40, 40))
AddCloseBtn(W_Control)

-- ==========================================
-- TAB UI UTAMA
-- ==========================================
local WalkTab = Window:MakeTab("🏃 Walk Record")

WalkTab:AddSection("WIDGET MANAGER")
WalkTab:AddDoubleButton("Tampilkan Timeline", function() W_Timeline.Visible = true end, "Tampilkan Record", function() W_Record.Visible = true end)
WalkTab:AddButton("Tampilkan Control Panel", function() W_Control.Visible = true end)

Window:MakeConfigTab()
