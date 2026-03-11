local SettingFisch = {}
SettingFisch.AntiAdminActive = false

function SettingFisch:ToggleAntiAdmin(state)
    self.AntiAdminActive = state
    if state then
        task.spawn(function()
            while self.AntiAdminActive do
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game:GetService("Players").LocalPlayer then
                        if player:GetRankInGroup(0) > 1 or player.Name:lower():find("admin") then
                            game:GetService("Players").LocalPlayer:Kick("Admin Detected: " .. player.Name)
                        end
                    end
                end
                task.wait(2)
            end
        end)
    end
end

return SettingFisch
