-- Ambil semua mesin dari Main Loader
local NoxvaLib = _G.NoxvaLib
local LogicFarm = _G.LogicFarming
local LogicTP = _G.LogicTeleport
local LogicSet = _G.LogicSetting -- File Setting sekarang bawa AntiAdmin + Config

local Window = NoxvaLib:CreateWindow()

-- ==========================================
-- TAB 1: 🎣 AUTO FISHING
-- ==========================================
local TabFish = Window:MakeTab("🎣 Auto Fishing")
TabFish:AddSearchBar()

TabFish:AddButton("Teleport Ke Spot Mancing", function()
    if LogicTP then LogicTP:ToSpot() end
    Window:Notify("INFO", "Berhasil Teleport!", 2)
end)

local FishList = {
    "Ancient Lochness Monster", "Zombie Megalodon", "Kraken", "Megalodon",
    "Zombie Shark", "Frostborn Shark", "Queen Crab",
    "Wild Serpent", "Red Serpent", "Worm Fish", "KingJelly Strong", "BloodMoon Whale"
}

TabFish:AddDropdown("Target Ikan", FishList, function(Selected)
    if LogicFarm then LogicFarm:SetTarget(Selected) end
    Window:Notify("TARGET", "Ikan: " .. Selected, 3)
end, "target_ikan")

TabFish:AddDropdown("Multiplier", {"100", "10", "5"}, function(Selected)
    if LogicFarm then LogicFarm.Multiplier = tonumber(Selected) end
end, "multi_ikan")

TabFish:AddToggle("Mulai Auto Fishing", false, function(State)
    if LogicFarm then LogicFarm:ToggleFishing(State) end
end, "toggle_fish")


-- ==========================================
-- TAB 2: ⚙️ SETTINGS & SAFETY
-- ==========================================
local TabSetting = Window:MakeTab("⚙️ Settings & Safety")

-- [ BAGIAN SAFETY ]
TabSetting:AddLabel("🛡️ PROTEKSI AKUN")

TabSetting:AddToggle("Anti-Admin (Auto Kick)", false, function(State)
    if LogicSet then LogicSet:ToggleAntiAdmin(State) end
end, "toggle_admin")

TabSetting:AddButton("Aktifkan Anti-AFK (Bypass 20 Menit Kick)", function()
    Window:EnableAntiAFK()
end)

TabSetting:AddLabel("---------------------------------")

-- [ BAGIAN CONFIG MANAGER ]
TabSetting:AddLabel("💾 ADVANCED CONFIG MANAGER")
local FolderConfig = TabSetting:AddFolder("Save & Load Config")

local NamaSave = "CustomConfig1"
FolderConfig:AddTextbox("Nama Config Baru", "Ketik nama untuk disave...", function(Text)
    NamaSave = Text
end, "input_nama_config")

FolderConfig:AddButton("💾 Save Setingan Saat Ini", function()
    if LogicSet then
        -- Manggil Logic Save dari SETTINGRealpse
        local sukses, pesan = LogicSet:SaveConfig(NamaSave, NoxvaLib.Flags)
        Window:Notify(sukses and "SUKSES" or "ERROR", pesan, 3)
    else
        Window:Notify("ERROR", "Mesin Setting belum diload!", 3)
    end
end)

FolderConfig:AddLabel("---------------------------------")

local DaftarConfig = {"Belum Ada Config"}
if LogicSet then
    DaftarConfig = LogicSet:GetConfigList()
end
local ConfigPilihan = DaftarConfig[1]

FolderConfig:AddDropdown("Pilih Config Tersimpan", DaftarConfig, function(Pilihan)
    ConfigPilihan = Pilihan
end, "pilih_config_drop")

FolderConfig:AddButton("📂 Load Setingan", function()
    if LogicSet then
        -- Manggil Logic Load dari SETTINGRealpse
        local sukses, pesan = LogicSet:LoadConfig(ConfigPilihan, NoxvaLib.Flags)
        Window:Notify(sukses and "SUKSES" or "ERROR", pesan, 3)
    else
        Window:Notify("ERROR", "Mesin Setting belum diload!", 3)
    end
end)

FolderConfig:AddLabel("Info: Re-Execute script lu buat refresh daftar Config.")
