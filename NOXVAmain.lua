-- ==========================================
-- NOXVA HUB - MAIN UNIVERSAL LOADER + UI KEY SYSTEM
-- DEVELOPED BY DANZY
-- ==========================================
local BaseURL = "https://raw.githubusercontent.com/andridanusaputro-ops/UI-NOXVA-V2/main/"

-- 1. Fungsi pinter buat manggil file
local function GetFile(path)
    local url = BaseURL .. path
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not success then warn("Noxva Error: Gagal narik file -> " .. path) return nil end
    return result
end

-- 2. Panggil Otak Logic Key System dari folder MAINMENU
local LogicMainMenu = GetFile("MAINMENU/LOGICMAINmenu.lua")
if not LogicMainMenu then 
    warn("Noxva Error: Logic Main Menu gagal dimuat!")
    return 
end

-- ==========================================
-- FUNGSI UTAMA LOAD HUB (Jalan Kalo Key Bener)
-- ==========================================
local function LoadNoxvaHub()
    -- Panggil Core UI Engine Lu
    _G.NoxvaLib = GetFile("uiNoxvaV2.lua")
    local PlaceId = game.PlaceId

    if PlaceId == 81008840993724 then
        print("Noxva Hub: Game Terdeteksi! Memuat modul Realpse...")
        _G.LogicFarming = GetFile("NoxvaLogic/MainNX/MAINRealpse.lua")
        _G.LogicTeleport = GetFile("NoxvaLogic/TeleportNX/TPRealpse.lua")
        _G.LogicSetting = GetFile("NoxvaLogic/SettingNX/SETTINGRealpse.lua")
        GetFile("NoxvaWindow/WINDOWNXRealpse.lua")
    else
        if _G.NoxvaLib then
            local Window = _G.NoxvaLib:CreateWindow("NOXVA PREMIUM")
            local TabInfo = Window:MakeTab("ℹ️ Info")
            TabInfo:AddLabel("Game ID (" .. PlaceId .. ") belum didukung oleh NOXVA HUB.")
            TabInfo:AddButton("Copy Game ID", function() setclipboard(tostring(PlaceId)) end)
        end
    end
end

-- ==========================================
-- TAMPILAN MODERN KEY SYSTEM UI
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local successHui, hui = pcall(function() return gethui() end)
local targetParent = hui or CoreGui or (LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui"))
if not targetParent then return end

local KeyUI = Instance.new("ScreenGui")
KeyUI.Name = "NoxvaKeySystem"
KeyUI.ResetOnSpawn = false
KeyUI.Parent = targetParent

local MainKeyFrame = Instance.new("Frame", KeyUI)
MainKeyFrame.Size = UDim2.new(0, 350, 0, 200)
MainKeyFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
MainKeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainKeyFrame.BackgroundTransparency = 0.1
MainKeyFrame.ClipsDescendants = true
Instance.new("UICorner", MainKeyFrame).CornerRadius = UDim.new(0, 8)

local KeyStroke = Instance.new("UIStroke", MainKeyFrame)
KeyStroke.Color = Color3.fromRGB(0, 120, 255) 
KeyStroke.Thickness = 1.5

local Title = Instance.new("TextLabel", MainKeyFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "NOXVA HUB | KEY SYSTEM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

local KeyBox = Instance.new("TextBox", MainKeyFrame)
KeyBox.Size = UDim2.new(1, -40, 0, 40)
KeyBox.Position = UDim2.new(0, 20, 0, 60)
KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyBox.PlaceholderText = "Enter your key here..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.Font = Enum.Font.GothamSemibold
KeyBox.TextSize = 13
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 5)

local VerifyBtn = Instance.new("TextButton", MainKeyFrame)
VerifyBtn.Size = UDim2.new(0.5, -25, 0, 35)
VerifyBtn.Position = UDim2.new(0, 20, 0, 120)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
VerifyBtn.Text = "Verify Key"
VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 13
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 5)

local GetKeyBtn = Instance.new("TextButton", MainKeyFrame)
GetKeyBtn.Size = UDim2.new(0.5, -25, 0, 35)
GetKeyBtn.Position = UDim2.new(0.5, 5, 0, 120)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
GetKeyBtn.Text = "Get Key"
GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 13
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 5)

local function AddHover(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play() end)
end
AddHover(VerifyBtn, Color3.fromRGB(0, 120, 255), Color3.fromRGB(0, 150, 255))
AddHover(GetKeyBtn, Color3.fromRGB(35, 35, 35), Color3.fromRGB(50, 50, 50))

-- ==========================================
-- 4. PENGGUNAAN LOGIC DARI FILE TERPISAH
-- ==========================================

GetKeyBtn.MouseButton1Click:Connect(function()
    if LogicMainMenu:CopyDiscordLink() then
        GetKeyBtn.Text = "Copied to Clipboard!"
        task.wait(2)
        GetKeyBtn.Text = "Get Key"
    end
end)

VerifyBtn.MouseButton1Click:Connect(function()
    local isSukses, pesan = LogicMainMenu:VerifyKey(KeyBox.Text)
    
    if isSukses then
        VerifyBtn.Text = pesan
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        local closeTween = TweenService:Create(MainKeyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
        closeTween:Play()
        closeTween.Completed:Connect(function()
            KeyUI:Destroy()
            LoadNoxvaHub() -- MANGGIL SCRIPT UTAMA KALO BENER
        end)
    else
        VerifyBtn.Text = pesan
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(1.5)
        VerifyBtn.Text = "Verify Key"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end
end)

MainKeyFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainKeyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 350, 0, 200)}):Play()
