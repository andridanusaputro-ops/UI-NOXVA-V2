-- ==========================================
-- NOXVA HUB | RECORD WALK - MAIN LOADER
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================

local githubRepo = "https://raw.githubusercontent.com/andridanusaputro-ops/UI-NOXVA-V2/main/RECORDWALK/"

-- Fungsi panggil script anti-error
local function LoadModule(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(githubRepo .. path))()
    end)
    
    if not success then
        warn("❌ [NOXVA ERROR] Gagal meload: " .. path)
        warn("Detail: " .. tostring(result))
    else
        print("✅ [NOXVA] Berhasil meload: " .. path)
    end
end

print("🔄 [NOXVA] Memulai inisialisasi Record Walk VIP...")

-- ==========================================
-- URUTAN LOAD SANGAT PENTING (JANGAN DIUBAH)
-- ==========================================

-- 1. Load Data/Brankas duluan
LoadModule("LOGICRECORD/config.lua")

-- 2. Load Window/UI (Biar _G.NoxvaWalkUI siap di-bind)
LoadModule("windowrecordwalk.lua")

-- 3. Load Otot Logic-nya
LoadModule("LOGICRECORD/recorder.lua")
LoadModule("LOGICRECORD/playback.lua")
LoadModule("LOGICRECORD/timeline.lua")
LoadModule("LOGICRECORD/filemanager.lua")
LoadModule("LOGICRECORD/controls.lua")

print("🚀 [NOXVA] Record Walk VIP Siap Digunakan!")

