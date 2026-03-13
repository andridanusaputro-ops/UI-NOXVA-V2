-- ==========================================
-- NOXVA HUB | PURE LOGIC TIMELINE EDITOR (FIX FALL/CUT)
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
    hrp.Anchored = true 
    hrp.CFrame = CFrame.lookAt(pos + Vector3.new(0, 1.5, 0), lookPos)
    
    -- FIX LABEL UI
    if UI.EditLabel then
        UI.EditLabel.Text = "Frame: " .. Data.EditIndex .. "/" .. #Data.Path
    end
end

-- FIX BUG: Inisialisasi posisi ke UJUNG JALAN kalau lu baru mulai ngedit pas jatoh
local function InitEditIfNeeded()
    if #Data.Path > 0 and (Data.EditIndex == 0 or Data.EditIndex > #Data.Path) then
        Data.EditIndex = #Data.Path
        -- Matiin Record/Play kalo lagi jalan
        if Data.IsPlaying then Data.IsPlaying = false; if Data.Conns.Play then Data.Conns.Play:Disconnect() end end
        if API and API.StopRecord then API.StopRecord() end
    end
end

local function StepBack() 
    InitEditIfNeeded()
    if Data.EditIndex > 1 then 
        Data.EditIndex = Data.EditIndex - 1; UpdateEditPos() 
    else
        SendNotif("TIMELINE", "Mentok di titik awal!")
    end 
end

local function StepForward() 
    InitEditIfNeeded()
    if Data.EditIndex < #Data.Path then 
        Data.EditIndex = Data.EditIndex + 1; UpdateEditPos() 
    else
        SendNotif("TIMELINE", "Mentok di titik akhir!")
    end 
end

local function TrimAndResume()
    if #Data.Path == 0 or Data.EditIndex == 0 then return end
    
    local newPath = {} 
    for i = 1, Data.EditIndex do 
        table.insert(newPath, Data.Path[i]) 
    end
    Data.Path = newPath
    
    local char = player.Character 
    if char and char:FindFirstChild("HumanoidRootPart") then 
        char.HumanoidRootPart.Anchored = false 
    end
    
    SendNotif("✂️ TRIM", "Rute dipotong sampai frame " .. Data.EditIndex)
    if UI.EditLabel then UI.EditLabel.Text = "Frame: " .. Data.EditIndex .. "/" .. #Data.Path end
    
    -- Opsional: Langsung gas resume ngerekam lagi
    if API and API.StartRecord then 
        API.StartRecord(true)
        if UI.BtnRecord then UI.BtnRecord.Text = "⏹ STOP REC" end
    end 
end

-- ==========================================
-- 2. BINDING TOMBOL EDITOR
-- ==========================================
if UI then
    UI.BtnPrev.MouseButton1Click:Connect(StepBack)
    UI.BtnNext.MouseButton1Click:Connect(StepForward)
    UI.BtnDone.MouseButton1Click:Connect(TrimAndResume)
    
    if UI.CPDropdown then
        UI.CPDropdown:UpdateList({"Awal Rute", "Tengah Rute", "Ujung Rute"}, function(opt)
            InitEditIfNeeded()
            if opt == "Awal Rute" then Data.EditIndex = 1
            elseif opt == "Tengah Rute" then Data.EditIndex = math.floor(#Data.Path / 2)
            elseif opt == "Ujung Rute" then Data.EditIndex = #Data.Path end
            UpdateEditPos()
        end)
    end
end

print("Logic Timeline (V6 Editor) berhasil dimuat!")
