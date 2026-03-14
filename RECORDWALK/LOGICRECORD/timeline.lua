-- ==========================================
-- LOGIC: TIMELINE / REWIND VIP
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================
local Data = _G.NoxvaWalkData
local UI = _G.NoxvaWalkUI

if UI.BtnRewind then
    UI.BtnRewind.MouseButton1Click:Connect(function()
        if not Data.IsRecording or #Data.Path == 0 then return end
        
        local targetTime = Data.TotalTime - 3 -- Potong memori mundur 3 detik
        while #Data.Path > 0 and Data.Path[#Data.Path].Time > targetTime do
            table.remove(Data.Path)
        end
        
        Data.TotalTime = math.max(0, targetTime)
        if _G.NoxvaUpdateUI then _G.NoxvaUpdateUI() end
        
        if UI.StatusLabel then UI.StatusLabel.Text = "REWIND" end
        _G.SendNoxvaNotifLogic("NOXVA REWIND", "Bot mundur 3 detik! Sisa Titik: " .. #Data.Path)
    end)
end

