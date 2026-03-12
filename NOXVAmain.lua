-- ==========================================
-- NOXVA HUB 
-- DEVELOPED BY DANZY 
-- ==========================================
local BaseURL = "https://raw.githubusercontent.com/andridanusaputro-ops/UI-NOXVA-V2/main/"

-- 1. Fungsi penarik file sakti
local function GetFile(path)
    local url = BaseURL .. path
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not success then warn("Noxva Error: Gagal narik file -> " .. path) return nil end
    return result
end

-- 2. Panggil Logic Key System
local LogicMainMenu = GetFile("MAINMENU/LOGICMAINmenu.lua")
if not LogicMainMenu then warn("Noxva Error: Logic Main Menu gagal dimuat!") return end

local PlaceId = game.PlaceId
local IsSupported, GameName = LogicMainMenu:CheckSupport(PlaceId)

-- ==========================================
-- FUNGSI LOAD HUB UTAMA (Jalan Kalau Sukses)
-- ==========================================
local function LoadNoxvaHub()
    -- Panggil Core UI Engine Lu 
    _G.NoxvaLib = GetFile("uiNoxvaV2.lua")
    
    if PlaceId == 81008840993724 then -- ID Game Fisch Lu
        print("Noxva Hub: Memuat modul Realpse...")
        _G.LogicFarming = GetFile("NoxvaLogic/MainNX/MAINRealpse.lua")
        _G.LogicTeleport = GetFile("NoxvaLogic/TeleportNX/TPRealpse.lua")
        _G.LogicSetting = GetFile("NoxvaLogic/SettingNX/SETTINGRealpse.lua")
        GetFile("NoxvaWindow/WINDOWNXRealpse.lua")
    end
end

-- ==========================================
-- TAMPILAN PREMIUM KEY SYSTEM UI (ULTRA CLEAN)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local successHui, hui = pcall(function() return gethui() end)
local targetParent = hui or CoreGui or (LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui"))
if not targetParent then return end

local KeyUI = Instance.new("ScreenGui")
KeyUI.Name = "NoxvaPremiumKey_Clean"
KeyUI.ResetOnSpawn = false
KeyUI.Parent = targetParent

-- Parent MainKeyFrame langsung ke KeyUI (Melayang murni tanpa background gelap)
local MainKeyFrame = Instance.new("Frame", KeyUI)
MainKeyFrame.Size = UDim2.new(0, 0, 0, 0) -- Animasi dari 0
MainKeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainKeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainKeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) 
MainKeyFrame.BackgroundTransparency = 0.02 
MainKeyFrame.ClipsDescendants = true
Instance.new("UICorner", MainKeyFrame).CornerRadius = UDim.new(0, 10)

-- Logo Kotak Lu (Pake rbxassetid biar pasti muncul)
local LogoImage = Instance.new("ImageLabel", MainKeyFrame)
LogoImage.Size = UDim2.new(0, 55, 0, 55)
LogoImage.Position = UDim2.new(0.5, -27.5, 0, 20)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "rbxassetid://125602638236059" 
LogoImage.ScaleType = Enum.ScaleType.Fit
Instance.new("UICorner", LogoImage).CornerRadius = UDim.new(0, 10)

-- Title
local Title = Instance.new("TextLabel", MainKeyFrame)
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Position = UDim2.new(0, 0, 0, 85)
Title.BackgroundTransparency = 1
Title.Text = "NOXVA HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16

-- Subtitle (Status Game)
local SubTitle = Instance.new("TextLabel", MainKeyFrame)
SubTitle.Size = UDim2.new(1, 0, 0, 15)
SubTitle.Position = UDim2.new(0, 0, 0, 108)
SubTitle.BackgroundTransparency = 1
SubTitle.TextColor3 = IsSupported and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 80, 80)
SubTitle.Text = IsSupported and ("Game: " .. GameName) or "GAME NOT SUPPORTED"
SubTitle.Font = Enum.Font.GothamSemibold
SubTitle.TextSize = 12

-- Animasi Hover Tombol
local function AddHover(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play() end)
end

-- ==========================================
-- PEMBAGIAN UI (SUPPORTED vs NOT SUPPORTED)
-- ==========================================
if IsSupported then
    -- TAMPILAN JIKA GAME DI-SUPPORT
    local KeyBox = Instance.new("TextBox", MainKeyFrame)
    KeyBox.Size = UDim2.new(1, -50, 0, 40)
    KeyBox.Position = UDim2.new(0, 25, 0, 135)
    KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    KeyBox.PlaceholderText = "Enter Premium Key..."
    KeyBox.Text = ""
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.Font = Enum.Font.GothamSemibold
    KeyBox.TextSize = 12
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)

    local VerifyBtn = Instance.new("TextButton", MainKeyFrame)
    VerifyBtn.Size = UDim2.new(0.5, -30, 0, 35)
    VerifyBtn.Position = UDim2.new(0, 25, 0, 185)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    VerifyBtn.Text = "Verify Key"
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.TextSize = 12
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 6)

    local GetKeyBtn = Instance.new("TextButton", MainKeyFrame)
    GetKeyBtn.Size = UDim2.new(0.5, -30, 0, 35)
    GetKeyBtn.Position = UDim2.new(0.5, 5, 0, 185)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    GetKeyBtn.Text = "Get Key"
    GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.TextSize = 12
    Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 6)

    AddHover(VerifyBtn, Color3.fromRGB(0, 120, 255), Color3.fromRGB(0, 150, 255))
    AddHover(GetKeyBtn, Color3.fromRGB(35, 35, 35), Color3.fromRGB(50, 50, 50))

    -- LOGIC TOMBOL GET KEY (PANGGIL DARI FILE LOGIC)
    GetKeyBtn.MouseButton1Click:Connect(function()
        local pesan = LogicMainMenu:OpenDiscord()
        GetKeyBtn.Text = pesan
        task.wait(2)
        GetKeyBtn.Text = "Get Key"
    end)

    -- LOGIC TOMBOL VERIFY
    VerifyBtn.MouseButton1Click:Connect(function()
        local isSukses, pesan = LogicMainMenu:VerifyKey(KeyBox.Text)
        if isSukses then
            VerifyBtn.Text = pesan
            VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            local closeTween = TweenService:Create(MainKeyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
            closeTween:Play()
            closeTween.Completed:Connect(function()
                KeyUI:Destroy()
                LoadNoxvaHub()
            end)
        else
            VerifyBtn.Text = pesan
            VerifyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            task.wait(1.5)
            VerifyBtn.Text = "Verify Key"
            VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        end
    end)
    
    -- Play Animasi Muncul
    TweenService:Create(MainKeyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 320, 0, 245)}):Play()

else
    -- TAMPILAN JIKA GAME GAK DI-SUPPORT
    local ErrorDesc = Instance.new("TextLabel", MainKeyFrame)
    ErrorDesc.Size = UDim2.new(1, -40, 0, 30)
    ErrorDesc.Position = UDim2.new(0, 20, 0, 125)
    ErrorDesc.BackgroundTransparency = 1
    ErrorDesc.Text = "Game ID: " .. tostring(PlaceId) .. "\nBelum ditambahkan ke dalam database."
    ErrorDesc.TextColor3 = Color3.fromRGB(150, 150, 150)
    ErrorDesc.Font = Enum.Font.Gotham
    ErrorDesc.TextSize = 11

    local CopyIdBtn = Instance.new("TextButton", MainKeyFrame)
    CopyIdBtn.Size = UDim2.new(0.5, -30, 0, 35)
    CopyIdBtn.Position = UDim2.new(0, 25, 0, 165)
    CopyIdBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    CopyIdBtn.Text = "Copy Game ID"
    CopyIdBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    CopyIdBtn.Font = Enum.Font.GothamBold
    CopyIdBtn.TextSize = 11
    Instance.new("UICorner", CopyIdBtn).CornerRadius = UDim.new(0, 6)

    local ExitBtn = Instance.new("TextButton", MainKeyFrame)
    ExitBtn.Size = UDim2.new(0.5, -30, 0, 35)
    ExitBtn.Position = UDim2.new(0.5, 5, 0, 165)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ExitBtn.Text = "Close"
    ExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.TextSize = 11
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0, 6)

    AddHover(CopyIdBtn, Color3.fromRGB(35, 35, 35), Color3.fromRGB(50, 50, 50))
    AddHover(ExitBtn, Color3.fromRGB(200, 50, 50), Color3.fromRGB(220, 70, 70))

    CopyIdBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(tostring(PlaceId))
            CopyIdBtn.Text = "ID Copied!"
            task.wait(2)
            CopyIdBtn.Text = "Copy Game ID"
        end
    end)

    ExitBtn.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(MainKeyFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        closeTween:Play()
        closeTween.Completed:Connect(function() KeyUI:Destroy() end)
    end)

    -- Play Animasi Muncul 
    TweenService:Create(MainKeyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 320, 0, 220)}):Play()
end
