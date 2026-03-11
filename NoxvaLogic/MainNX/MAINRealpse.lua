local FarmingFisch = {}

-- Variabel bawaan disimpen di dalam table module ini
FarmingFisch.IsFishing = false
FarmingFisch.Multiplier = 100
FarmingFisch.TargetFish = "Ancient Lochness Monster"
FarmingFisch.TargetRarity = "Unknown"

-- Fungsi 1: Logic ngatur Rarity otomatis
function FarmingFisch:SetTarget(namaIkan)
    self.TargetFish = namaIkan
    local epics = {"Zombie Shark", "Frostborn Shark", "Queen Crab"}
    local legends = {"Wild Serpent", "Red Serpent", "Worm Fish", "KingJelly Strong", "BloodMoon Whale"}
    
    if table.find(epics, namaIkan) then
        self.TargetRarity = "Epic"
    elseif table.find(legends, namaIkan) then
        self.TargetRarity = "Legendary"
    else
        self.TargetRarity = "Unknown"
    end
end

-- Fungsi 2: Logic Mulai Mancing
function FarmingFisch:ToggleFishing(state)
    self.IsFishing = state
    if state then
        task.spawn(function()
            while self.IsFishing do
                local RS = game:GetService("ReplicatedStorage"):FindFirstChild("FishingSystem")
                if RS then
                    -- Lempar Pancingan
                    RS.CastReplication:FireServer(Vector3.new(-112, -7, -1029), Vector3.new(-2, 5, -24), "Basic Rod", 94)
                    task.wait(2.2)
                    
                    -- Nangkep ikan sesuai multiplier
                    for i = 1, self.Multiplier do
                        if not self.IsFishing then break end
                        RS.FishGiver:FireServer({
                            ["hookPosition"] = Vector3.new(-108, -19, -1037), 
                            ["name"] = self.TargetFish, 
                            ["rarity"] = self.TargetRarity, 
                            ["weight"] = math.random(1500, 3500)
                        })
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end

return FarmingFisch
