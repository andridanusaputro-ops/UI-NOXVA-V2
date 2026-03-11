local MAINRealpse = {}

MAINRealpse.IsFishing = false
MAINRealpse.Multiplier = 100
MAINRealpse.TargetFish = "Ancient Lochness Monster"

-- Fungsi ganti target ikan dari Dropdown Window
function MAINRealpse:SetTarget(namaIkan)
    self.TargetFish = namaIkan
end

-- Fungsi utama mancing dari Toggle Window
function MAINRealpse:ToggleFishing(state)
    self.IsFishing = state
    if state then
        task.spawn(function()
            while self.IsFishing do
                local RS = game:GetService("ReplicatedStorage"):FindFirstChild("FishingSystem")
                if RS then
                    -- Lempar Pancingan
                    RS.CastReplication:FireServer(Vector3.new(-112, -7, -1029), Vector3.new(-2, 5, -24), "Basic Rod", 94)
                    task.wait(2.2)
                    
                    -- Tarik Ikan
                    for i = 1, self.Multiplier do
                        if not self.IsFishing then break end
                        RS.FishGiver:FireServer({
                            ["hookPosition"] = Vector3.new(-108, -19, -1037), 
                            ["name"] = self.TargetFish, 
                            ["rarity"] = "Unknown", -- Rarity bisa diubah otomatis kalau butuh
                            ["weight"] = math.random(1500, 3500)
                        })
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end

return MAINRealpse
