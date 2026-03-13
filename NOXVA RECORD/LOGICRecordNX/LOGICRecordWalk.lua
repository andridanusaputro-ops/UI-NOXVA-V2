-- ==========================================
-- NOXVA HUB - LOGIC RECORD WALK (PURE LOGIC)
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================

local UI = _G.NoxvaWalkUI
if not UI then
    warn("Noxva Error: UI Widget belum dimuat! Logic Record dibatalkan.")
    return
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Bikin Brankas Data Global (Biar file Timeline & Control bisa ikutan akses)
_G.NoxvaWalkData = {
    Path = {},
    IsRecording = false,
    IsPlaying = false,
    IsPaused = false,
    IsLooping = false,
    CurrentNode = 1
}
local Data = _G.NoxvaWalkData

-- Bikin Folder Config di Executor
local ConfigFolder = "NoxvaHub/WalkRecords/" .. tostring(game.PlaceId)
if makefolder then
    pcall(function() makefolder("NoxvaHub") makefolder("NoxvaHub/WalkRecords") makefolder(ConfigFolder) end)
end

local function SendNotif(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = text, Duration = 3})
end

-- ==========================================
-- LOGIC 1: RECORDING (⏺ RECORD)
-- ==========================================
UI.BtnRecord.MouseButton1Click:Connect(function()
    Data.IsRecording = not Data.IsRecording
    if Data.IsRecording then
        Data.Path = {} -- Reset jalur lama pas mulai rekam baru
        UI.BtnRecord.Text = "⏹ STOP REC"
        SendNotif("NOXVA RECORD", "Mulai merekam jejak... Silakan berjalan!")
        
        task.spawn(function()
            while Data.IsRecording do
                task.wait(0.1) -- Catat koordinat tiap 0.1 detik
                if not Data.IsPaused then
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        -- Cuma catet kalau jarak berubah > 1.5 stud biar hemat memori
                        if #Data.Path == 0 or (Data.Path[#Data.Path] - hrp.Position).Magnitude > 1.5 then
                            table.insert(Data.Path, hrp.Position)
                        end
                    end
                end
            end
        end)
    else
        UI.BtnRecord.Text = "⏺ RECORD"
        SendNotif("NOXVA RECORD", "Rekaman Selesai! Total Titik: " .. #Data.Path)
    end
end)

-- ==========================================
-- LOGIC 2: PLAYING (▶ PLAY)
-- ==========================================
UI.BtnPlay.MouseButton1Click:Connect(function()
    if #Data.Path == 0 then SendNotif("NOXVA ERROR", "Data kosong! Rekam jejak dulu Cok!") return end
    if Data.IsPlaying then SendNotif("NOXVA ERROR", "Bot sudah berjalan!") return end
    
    Data.IsPlaying = true
    Data.CurrentNode = 1
    SendNotif("NOXVA PLAY", "Bot mulai berjalan mengikuti jejak!")
    
    task.spawn(function()
        while Data.IsPlaying and Data.CurrentNode <= #Data.Path do
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChild("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then break end

            -- Kalau di-pause dari menu Control
            if Data.IsPaused then
                hum:MoveTo(hrp.Position) -- Ngerem mendadak
                repeat task.wait(0.1) until not Data.IsPaused or not Data.IsPlaying
            end
            
            if not Data.IsPlaying then break end

            local TargetPos = Data.Path[Data.CurrentNode]
            hum:MoveTo(TargetPos)

            -- Tunggu sampai sampai di titik tujuan (atau timeout kalau nyangkut)
            local Timeout = tick()
            repeat
                task.wait()
            until not Data.IsPlaying or Data.IsPaused or (hrp.Position - TargetPos).Magnitude < 3 or tick() - Timeout > 2

            if not Data.IsPaused and Data.IsPlaying then
                Data.CurrentNode = Data.CurrentNode + 1
            end
        end

        -- Kalau sudah sampai titik terakhir
        if Data.IsPlaying then
            if Data.IsLooping then
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = CFrame.new(Data.Path[1]) end -- Teleport ke awal
                task.wait(0.5)
                Data.IsPlaying = false
                UI.BtnPlay.MouseButton1Click:Fire() -- Auto klik play lagi (Looping)
            else
                Data.IsPlaying = false
                SendNotif("NOXVA DONE", "Bot sampai di tujuan akhir!")
            end
        end
    end)
end)

-- ==========================================
-- LOGIC 3: SAVE & LOAD
-- ==========================================
UI.BtnSave.MouseButton1Click:Connect(function()
    if #Data.Path == 0 then SendNotif("NOXVA ERROR", "Tidak ada jejak untuk disave!") return end
    local saveTable = {}
    for _, v in ipairs(Data.Path) do table.insert(saveTable, {v.X, v.Y, v.Z}) end
    if writefile then
        writefile(ConfigFolder.."/SavedPath.json", HttpService:JSONEncode(saveTable))
        SendNotif("NOXVA SAVE", "Jejak berhasil diamankan ke folder Executor!")
    else
        SendNotif("NOXVA ERROR", "Executor lu gak support writefile!")
    end
end)

UI.BtnLoad.MouseButton1Click:Connect(function()
    if isfile and isfile(ConfigFolder.."/SavedPath.json") then
        local readData = HttpService:JSONDecode(readfile(ConfigFolder.."/SavedPath.json"))
        Data.Path = {}
        for _, v in ipairs(readData) do table.insert(Data.Path, Vector3.new(v[1], v[2], v[3])) end
        SendNotif("NOXVA LOAD", "Jejak berhasil dimuat! Total: " .. #Data.Path .. " Titik")
    else
        SendNotif("NOXVA ERROR", "Belum ada file save jejak di game ini!")
    end
end)

print("Logic Record Walk berhasil dimuat!")

