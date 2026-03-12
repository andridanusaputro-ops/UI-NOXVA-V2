-- ==========================================
-- NOXVA HUB - MAIN ROUTER & UNIVERSAL LOADER
-- DEVELOPED BY DANZY
-- ==========================================
local BaseURL = "https://raw.githubusercontent.com/andridanusaputro-ops/UI-NOXVA-V2/main/"

-- Fungsi penarik file sakti (Kita globalin biar bisa dipake di file lain)
_G.GetNoxvaFile = function(path)
    local url = BaseURL .. path
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if not success then warn("Noxva Error: Gagal narik file -> " .. path) return nil end
    return result
end

-- ==========================================
-- 🗂️ DATABASE GAME YANG DI-SUPPORT NOXVA HUB
-- ==========================================
_G.NoxvaSupportedGames = {
    
    -- [1] FISCH / REALPSE
    [81008840993724] = {
        Name = "Realpse Kesepian",
        Execute = function()
            print("Noxva Hub: Memuat modul Realpse...")
            _G.LogicFarming = _G.GetNoxvaFile("NoxvaLogic/MainNX/MAINRealpse.lua")
            _G.LogicTeleport = _G.GetNoxvaFile("NoxvaLogic/TeleportNX/TPRealpse.lua")
            _G.LogicSetting = _G.GetNoxvaFile("NoxvaLogic/SettingNX/SETTINGRealpse.lua")
            _G.GetNoxvaFile("NoxvaWindow/WINDOWNXRealpse.lua")
        end
    },

    -- [2] CONTOH GAME LAIN (BLOX FRUITS)
    -- Tinggal copas blok ini kalo mau nambah game baru cok!
    [2753915549] = {
        Name = "Blox Fruits",
        Execute = function()
            print("Noxva Hub: Memuat modul Blox Fruits...")
            -- _G.GetNoxvaFile("NoxvaWindow/WINDOWNXBloxFruits.lua")
        end
    }

}

-- ==========================================
-- PANGGIL TAMPILAN KEY SYSTEM (UI)
-- ==========================================
local success, err = pcall(function()
    _G.GetNoxvaFile("MAINMENU/WINDOWNOXVAKEY.lua")
end)

if not success then
    warn("Noxva Error: Gagal memuat UI Key System! " .. tostring(err))
end
