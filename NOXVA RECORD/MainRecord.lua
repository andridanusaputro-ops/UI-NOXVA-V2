-- ==========================================
-- NOXVA HUB - MAIN WALK RECORD EXECUTOR
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================

local BaseURL = "https://raw.githubusercontent.com/andridanusaputro-ops/UI-NOXVA-V2/main/"

-- Fungsi Penarik File
local function PullNoxvaFile(Path)
    local targetURL = BaseURL .. Path
    local success, result = pcall(function() return loadstring(game:HttpGet(targetURL))() end)
    if not success then
        warn("Noxva Error: Gagal menarik file -> " .. Path)
        return nil
    end
    return result
end

print("Memulai Injeksi Noxva Walk Record System...")

-- 1. Panggil Window UI-nya dulu (Biar _G.NoxvaWalkUI kebentuk)
print("Memuat Pure Window UI...")
PullNoxvaFile("NOXVA RECORD/NOXVA WINDOW.lua")

-- Pastikan Window berhasil dimuat sebelum lanjut narik Logic
if not _G.NoxvaWalkUI then
    warn("Injeksi Dibatalkan: UI Window gagal memuat Global Table!")
    return
end

-- 2. Panggil 3 Mesin Logic-nya secara berurutan
print("Memuat Logic Record Walk...")
PullNoxvaFile("NOXVA RECORD/LOGICRecordNX/LOGICRecordWalk.lua")

print("Memuat Logic Timeline...")
PullNoxvaFile("NOXVA RECORD/LOGICRecordNX/LOGICTimeline.lua")

print("Memuat Logic Walk Control...")
PullNoxvaFile("NOXVA RECORD/LOGICRecordNX/LOGICWALKControl.lua")

print("✅ Noxva Walk Record Berhasil Diaktifkan!")

