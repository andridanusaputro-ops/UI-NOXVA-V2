-- ==========================================
-- NOXVA HUB | PURE LOGIC WALK CONTROL
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================
local UI = _G.NoxvaWalkUI
local Data = _G.NoxvaWalkData
local API = _G.NoxvaWalkAPI
local Players = game:GetService("Players")

if not UI or not Data then return end

local function SendNotif(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = text, Duration = 2})
end

-- ==========================================
-- BINDING TOMBOL KONTROL
-- ==========================================
if UI then
    UI.BtnPause.MouseButton1Click:Connect(function()
        if API and API.StopRecord then 
            API.StopRecord() 
            UI.BtnRecord.Text = "⏺ RECORD"
            SendNotif("⏸️ PAUSE", "Aktivitas dibekukan!")
        end
    end)

    UI.BtnStop.MouseButton1Click:Connect(function()
        Data.IsPlaying = false
        if API and API.StopRecord then API.StopRecord() end
        if Data.Conns.Play then Data.Conns.Play:Disconnect() end
        
        UI.BtnRecord.Text = "⏺ RECORD"
        UI.BtnPlay.Text = "▶ PLAY"
        UI.BtnPlay.BackgroundColor3 = Color3.fromRGB(40, 200, 90)
        
        local char = Players.LocalPlayer.Character
        if char then
            if char:FindFirstChild("Humanoid") then 
                char.Humanoid:Move(Vector3.zero, false) 
                char.Humanoid.AutoRotate = true -- FIX Rotasi balikin normal
            end
            if char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.Anchored = false end
        end
        SendNotif("⏹️ STOP", "Semua sistem dimatikan!")
    end)
    
    if UI.BtnLoop then
        UI.BtnLoop.MouseButton1Click:Connect(function()
            Data.IsLooping = not Data.IsLooping
            UI.BtnLoop.Text = Data.IsLooping and "🔄 LOOP ON" or "🔄 LOOP OFF"
            UI.BtnLoop.BackgroundColor3 = Data.IsLooping and Color3.fromRGB(40, 200, 90) or Color3.fromRGB(40, 150, 240)
        end)
    end
end

print("Logic Walk Control berhasil dimuat!")
