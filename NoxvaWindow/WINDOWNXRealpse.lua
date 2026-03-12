-- Ambil semua mesin dari Main Loader
local NoxvaLib = _G.NoxvaLib
local LogicFarm = _G.LogicFarming
local LogicTP = _G.LogicTeleport
local LogicSet = _G.LogicSetting -- File Setting sekarang bawa AntiAdmin + Config

local Window = NoxvaLib:CreateWindow("NOXVA PREMIUM")

-- ==========================================
-- TAB 1: 🎣 FISHING (Nama Tab Dipendekin)
-- ==========================================
local TabFish = Window:MakeTab("🎣 Fishing")
TabFish:AddSearchBar()

TabFish:AddSection("TELEPORTATION") -- Pake AddSection biar rapi, gantiin label "---"
TabFish:AddButton("Teleport Spot Mancing", function()
    if LogicTP then LogicTP:ToSpot() end
    Window:Notify("INFO", "Berhasil Teleport!", 2)
end)

TabFish:AddSection("AUTOMATION")
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

TabFish:AddToggle("Auto Fishing", false, function(State)
    if LogicFarm then LogicFarm:ToggleFishing(State) end
end, "toggle_fish")


-- ==========================================
-- TAB 2: ⚙️ SETTINGS (Nama Tab Dipendekin)
-- ==========================================
local TabSetting = Window:MakeTab("⚙️ Settings")

-- [ BAGIAN SAFETY ]
TabSetting:AddSection("ACCOUNT PROTECTION")

TabSetting:AddToggle("Anti-Admin", false, function(State) -- Teks dipendekin
    if LogicSet then LogicSet:ToggleAntiAdmin(State) end
end, "toggle_admin")

-- Info panjang ditaruh di AddLabel/AddParagraph, tombolnya dibikin simpel
TabSetting:AddLabel("Bypass sistem kick 20 menit dari Roblox.")
TabSetting:AddButton("Enable Anti-AFK", function()
    Window:EnableAntiAFK()
end)


-- [ BAGIAN CONFIG MANAGER ]
TabSetting:AddSection("CONFIG MANAGER")
local FolderConfig = TabSetting:AddFolder("Save & Load Config")

local NamaSave = "CustomConfig1"
FolderConfig:AddTextbox("Nama Config", "Ketik nama config...", function(Text)
    NamaSave = Text
end, "input_nama_config")

FolderConfig:AddButton("💾 Save Config", function()
    if LogicSet then
        -- Manggil Logic Save dari SETTINGRealpse
        local sukses, pesan = LogicSet:SaveConfig(NamaSave, NoxvaLib.Flags)
        Window:Notify(sukses and "SUKSES" or "ERROR", pesan, 3)
    else
        Window:Notify("ERROR", "Mesin Setting belum diload!", 3)
    end
end)

local DaftarConfig = {"Belum Ada Config"}
if LogicSet then
    DaftarConfig = LogicSet:GetConfigList()
end
local ConfigPilihan = DaftarConfig[1]

FolderConfig:AddDropdown("Pilih Config", DaftarConfig, function(Pilihan)
    ConfigPilihan = Pilihan
end, "pilih_config_drop")

FolderConfig:AddButton("📂 Load Config", function()
    if LogicSet then
        -- Manggil Logic Load dari SETTINGRealpse
        local sukses, pesan = LogicSet:LoadConfig(ConfigPilihan, NoxvaLib.Flags)
        Window:Notify(sukses and "SUKSES" or "ERROR", pesan, 3)
    else
        Window:Notify("ERROR", "Mesin Setting belum diload!", 3)
    end
end)

-- Pake AddParagraph di dalem folder buat naruh teks info yang kepanjangan
FolderConfig:AddParagraph("Info Sistem", "Silahkan Re-Execute script lu buat me-refresh daftar Config terbaru yang baru aja di-save.")
