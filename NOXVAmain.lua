-- ==========================================
-- NOXVA HUB - MAIN UNIVERSAL LOADER
-- ==========================================
local BaseURL = "https://raw.githubusercontent.com/andridanusaputro-ops/UI-NOXVA-V2/main/"

-- 1. Fungsi pinter buat manggil file
local function GetFile(path)
    local url = BaseURL .. path
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Noxva Error: Gagal narik file -> " .. path)
        return nil
    end
    return result
end

-- 2. Panggil Core UI Engine Lu
_G.NoxvaLib = GetFile("uiNoxvaV2.lua")

-- 3. Deteksi Game Otomatis pake PlaceId
local PlaceId = game.PlaceId

-- [ UPDATE: Masukin ID Game Lu Di Sini ]
if PlaceId == 81008840993724 then
    print("Noxva Hub: Game Terdeteksi! Memuat modul Realpse...")
    
    -- A. Tarik semua mesin
    _G.LogicFarming = GetFile("NoxvaLogic/MainNX/MAINRealpse.lua")
    _G.LogicTeleport = GetFile("NoxvaLogic/TeleportNX/TPRealpse.lua")
    _G.LogicSetting = GetFile("NoxvaLogic/SettingNX/SETTINGRealpse.lua")
    
    -- B. Panggil Window/Tampilannya
    GetFile("NoxvaWindow/WINDOWNXRealpse.lua")

else
    -- 4. Kalau ID game gak cocok, keluarin UI Kosong
    if _G.NoxvaLib then
        local Window = _G.NoxvaLib:CreateWindow()
        local TabInfo = Window:MakeTab("ℹ️ Info")
        TabInfo:AddLabel("Game ID (" .. PlaceId .. ") belum didukung oleh NOXVA HUB.")
        TabInfo:AddButton("Copy Game ID", function()
            setclipboard(tostring(PlaceId))
        end)
    end
end

