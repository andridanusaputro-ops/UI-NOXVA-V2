-- ==========================================
-- LOGIC: CONTROLS (SPEED, LOOP, CLEAR)
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================
local Data = _G.NoxvaWalkData
local UI = _G.NoxvaWalkUI

if UI.BtnClear then
    UI.BtnClear.MouseButton1Click:Connect(function()
        if Data.IsRecording or Data.IsPlaying then 
            _G.SendNoxvaNotifLogic("⚠️ GAGAL", "Stop dulu Record/Play sebelum Clear!")
            return 
        end
        Data.Path = {}
        Data.TotalTime = 0
        if _G.NoxvaUpdateUI then _G.NoxvaUpdateUI() end
        if UI.StatusLabel then UI.StatusLabel.Text = "CLEAR" end
    end)
end

if UI.BtnLoop then
    UI.BtnLoop.MouseButton1Click:Connect(function()
        Data.IsLooping = not Data.IsLooping
        UI.BtnLoop.Text = Data.IsLooping and "🔄 LOOP ON" or "🔄 LOOP"
        UI.BtnLoop.BackgroundColor3 = Data.IsLooping and Color3.fromRGB(40, 100, 180) or Color3.fromRGB(40, 180, 80)
    end)
end

if UI.BtnSpeed then
    UI.BtnSpeed.MouseButton1Click:Connect(function()
        if Data.SpeedMult == 1 then
            Data.SpeedMult = 1.5
            UI.BtnSpeed.Text = "⚡ SPEED 1.5x"
            UI.BtnSpeed.BackgroundColor3 = Color3.fromRGB(180, 120, 30)
        elseif Data.SpeedMult == 1.5 then
            Data.SpeedMult = 2
            UI.BtnSpeed.Text = "⚡ SPEED 2x"
            UI.BtnSpeed.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        else
            Data.SpeedMult = 1
            UI.BtnSpeed.Text = "⚡ SPEED 1x"
            UI.BtnSpeed.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end)
end

