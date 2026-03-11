-- Ambil variabel dari Main Loader
local NoxvaLib = _G.NoxvaLib
local LogicFarm = _G.LogicFarming
local LogicTP = _G.LogicTeleport
local LogicSet = _G.LogicSetting

local Window = NoxvaLib:CreateWindow()
Window:EnableAntiAFK()

-- TAB 1: FISHING
local TabFish = Window:MakeTab("🎣 Auto Fishing")
TabFish:AddSearchBar()

TabFish:AddButton("Teleport Ke Spot Mancing", function()
    LogicTP:ToSpot() -- Manggil dari TeleportFisch.lua
    Window:Notify("INFO", "Berhasil Teleport!", 2)
end)

local FishList = {
    "Ancient Lochness Monster", "Zombie Megalodon", "Kraken", "Megalodon",
    "Zombie Shark", "Frostborn Shark", "Queen Crab",
    "Wild Serpent", "Red Serpent", "Worm Fish", "KingJelly Strong", "BloodMoon Whale"
}

TabFish:AddDropdown("Target Ikan", FishList, function(Selected)
    LogicFarm:SetTarget(Selected) -- Manggil setting rarity dari FarmingFisch.lua
    Window:Notify("TARGET", "Ikan: " .. Selected .. "\nRarity: " .. LogicFarm.TargetRarity, 3)
end, "target_ikan")

TabFish:AddDropdown("Multiplier", {"100", "10", "5"}, function(Selected)
    LogicFarm.Multiplier = tonumber(Selected)
end, "multi_ikan")

TabFish:AddToggle("Mulai Auto Fishing", false, function(State)
    LogicFarm:ToggleFishing(State) -- Manggil loop mancing dari FarmingFisch.lua
end, "toggle_fish")


-- TAB 2: SAFETY
local TabSafety = Window:MakeTab("🛡️ Safety")
TabSafety:AddToggle("Anti-Admin (Auto Kick)", false, function(State)
    LogicSet:ToggleAntiAdmin(State) -- Manggil loop proteksi dari SettingFisch.lua
end, "toggle_admin")

Window:MakeConfigTab()

