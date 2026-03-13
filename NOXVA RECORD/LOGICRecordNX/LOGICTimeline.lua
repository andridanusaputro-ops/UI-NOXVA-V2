-- ==========================================
-- NOXVA HUB | PURE LOGIC TIMELINE EDITOR
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================
local UI = _G.NoxvaWalkUI
local Data = _G.NoxvaWalkData
local API = _G.NoxvaWalkAPI
local Players = game:GetService("Players")
local player = Players.LocalPlayer

if not UI or not Data then return warn("Noxva Error: UI/Data Timeline gagal!") end

local function SendNotif(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = text, Duration = 2})
end

-- ==========================================
-- 1. FUNGSI EDITOR TIMELINE
-- ==========================================
local function UpdateEditPos()
    if #Data.Path == 0 or Data.EditIndex == 0 then return end
    
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    local pos = Data.Path[Data.EditIndex].Position
    local nextPos = pos
    if Data.EditIndex < #Data.Path then nextPos = Data.Path[Data.EditIndex + 1].Position end
    
    local lookPos = Vector3.new(nextPos.X, pos.Y, nextPos.Z)
    if (lookPos - pos).Magnitude < 0.1 then lookPos = pos + Vector3.new(0, 0, 1) end
    
    hrp.Velocity = Vector3.zero
    hrp.Anchored = true -- BUG FIX: Cegah jatuh pas ngedit
    hrp.CFrame = CFrame.lookAt(pos + Vector3.new(0, 1.5, 0), lookPos)
    
    SendNotif("🛠️ TIMELINE", "Frame: " .. Data.EditIndex .. " / " .. #Data.Path)
end

local function StepBack() 
    if Data.EditIndex > 1 then 
        Data.EditIndex = Data.EditIndex - 1; UpdateEditPos() 
    end 
end

local function StepForward() 
    if Data.EditIndex < #Data.Path then 
        Data.EditIndex = Data.EditIndex + 1; UpdateEditPos() 
    end 
end

local function TrimAndResume()
    if #Data.Path == 0 or Data.EditIndex == 0 then return end
    
    local newPath = {} 
    for i = 1, Data.EditIndex do 
        table.insert(newPath, Data.Path[i]) 
    end
    Data.Path = newPath
    
    -- BUG FIX: Lepasin Anchored sebelum lanjut jalan
    local char = player.Character 
    if char and char:FindFirstChild("HumanoidRootPart") then 
        char.HumanoidRootPart.Anchored = false 
    end
    
    SendNotif("✂️ TRIM", "Rute dipotong sampai frame " .. Data.EditIndex)
    if API and API.StartRecord then API.StartRecord(true) end -- Lanjut record
end

-- ==========================================
-- 2. BINDING TOMBOL EDITOR
-- ==========================================
if UI then
    UI.BtnPrev.MouseButton1Click:Connect(StepBack)
    UI.BtnNext.MouseButton1Click:Connect(StepForward)
    
    UI.BtnDone.MouseButton1Click:Connect(function()
        TrimAndResume()
        -- Kalau lu mau nambahin UI EditPanel.Visible = false, masukin di file Window nanti.
    end)
    
    -- Opsional: Kalau lu mau buka mode Edit pas klik Dropdown CP
    if UI.CPDropdown then
        UI.CPDropdown:UpdateList({"Masuk Mode Edit"}, function()
            if Data.IsPlaying then
                Data.IsPlaying = false
                if Data.Conns.Play then Data.Conns.Play:Disconnect() end
                UI.BtnPlay.Text = "▶ PLAY"
            end
            if API and API.StopRecord then API.StopRecord() end
            Data.EditIndex = #Data.Path
            UpdateEditPos()
        end)
    end
end

print("Logic Timeline (V6 Editor) berhasil dimuat!")
