-- ==========================================
-- NOXVA HUB | PURE LOGIC RECORD WALK (THE PERFECT ENGINE - NATIVE MOVETO)
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================
local UI = _G.NoxvaWalkUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- BRANKAS DATA GLOBAL
_G.NoxvaWalkData = _G.NoxvaWalkData or {}
_G.NoxvaWalkData.Path = _G.NoxvaWalkData.Path or {}
_G.NoxvaWalkData.Conns = _G.NoxvaWalkData.Conns or {}
_G.NoxvaWalkData.IsRecording = _G.NoxvaWalkData.IsRecording or false
_G.NoxvaWalkData.IsPlaying = _G.NoxvaWalkData.IsPlaying or false
_G.NoxvaWalkData.CurrentNode = _G.NoxvaWalkData.CurrentNode or 1
_G.NoxvaWalkData.TotalRecordTime = _G.NoxvaWalkData.TotalRecordTime or 0
_G.NoxvaWalkData.PlayThread = _G.NoxvaWalkData.PlayThread or nil

-- Simpen Speed Asli Bawaan Game Biar Bisa Ngerem
_G.NoxvaWalkData.BaseWS = _G.NoxvaWalkData.BaseWS or 16
_G.NoxvaWalkData.BaseJP = _G.NoxvaWalkData.BaseJP or 50
_G.NoxvaWalkData.BaseCaptured = _G.NoxvaWalkData.BaseCaptured or false

local Data = _G.NoxvaWalkData

local ConfigFolder = "NoxvaHub/WalkRecords/" .. tostring(game.PlaceId)
if makefolder then pcall(function() makefolder("NoxvaHub") makefolder("NoxvaHub/WalkRecords") makefolder(ConfigFolder) end) end

local lastJumpTime = 0
local lastUITick = 0 

local function SendNotif(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = text, Duration = 3})
end

local function UpdateInfoUI()
    if UI and UI.InfoLabel then
        local mins = math.floor(Data.TotalRecordTime / 60)
        local secs = math.floor(Data.TotalRecordTime % 60)
        UI.InfoLabel.Text = string.format("Total: %d | %02d:%02d", #Data.Path, mins, secs)
    end
end

-- ==========================================
-- ⚡ MESIN SPEED REALTIME (SCANNER 24 JAM MUTLAK!) ⚡
-- ==========================================
if Data.Conns.RealtimeSpeed then Data.Conns.RealtimeSpeed:Disconnect() end
Data.Conns.RealtimeSpeed = RunService.Heartbeat:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if not hum then return end

    -- Capture speed asli pas baru inject
    if not Data.BaseCaptured and hum.WalkSpeed > 0 then
        Data.BaseWS = hum.WalkSpeed
        Data.BaseJP = hum.JumpPower
        Data.BaseCaptured = true
    end

    local tool = char:FindFirstChildOfClass("Tool")
    local toolName = tool and tool.Name or "None"

    -- Ambil dari UI, kalo kosong (0) balik ke setting game asli
    local defaultWS = Data.CoilSettings.NormalWS > 0 and Data.CoilSettings.NormalWS or Data.BaseWS
    local defaultJP = Data.CoilSettings.NormalJP > 0 and Data.CoilSettings.NormalJP or Data.BaseJP

    local targetWS = defaultWS
    local targetJP = defaultJP

    -- Cocokin sama Tool yang lagi dipegang SAAT INI (Bukan dari Record)
    if toolName == Data.CoilSettings.Coil1Name then
        targetWS = Data.CoilSettings.Coil1WS > 0 and Data.CoilSettings.Coil1WS or defaultWS
        targetJP = Data.CoilSettings.Coil1JP > 0 and Data.CoilSettings.Coil1JP or defaultJP
    elseif toolName == Data.CoilSettings.Coil2Name then
        targetWS = Data.CoilSettings.Coil2WS > 0 and Data.CoilSettings.Coil2WS or defaultWS
        targetJP = Data.CoilSettings.Coil2JP > 0 and Data.CoilSettings.Coil2JP or defaultJP
    end

    -- Terapkan speed paksa tiap detik
    hum.WalkSpeed = targetWS
    hum.UseJumpPower = true 
    hum.JumpPower = targetJP
end)

-- ==========================================
-- 1. FUNGSI RECORDING (MURNI TITIK)
-- ==========================================
local function AddNode(pos, isJump)
    table.insert(Data.Path, {
        Position = pos, 
        IsJumpPoint = isJump
    })
end

local function StopRecording()
    Data.IsRecording = false
    if Data.Conns.Rec then Data.Conns.Rec:Disconnect() end
    if Data.Conns.Jump then Data.Conns.Jump:Disconnect() end
    if Data.Conns.State then Data.Conns.State:Disconnect() end
    if Data.Conns.Death then Data.Conns.Death:Disconnect() end
end

local function StartRecording(isResume)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")
    hrp.Anchored = false 
    
    if not isResume then 
        Data.Path = {}
        Data.TotalRecordTime = 0
        UpdateInfoUI()
        SendNotif("🔴 RECORD", "Mulai merekam jejak!") 
    else 
        SendNotif("🔴 RECORD", "Resume Recording Aktif!") 
    end
    
    Data.IsRecording = true
    local lastPos = hrp.Position
    StopRecording()
    Data.IsRecording = true 
    
    Data.Conns.Death = humanoid.Died:Connect(function()
        if Data.IsRecording then StopRecording(); SendNotif("⏸️ RECORD", "Mati! Recording Pause.") end
    end)
    
    Data.Conns.Jump = UserInputService.JumpRequest:Connect(function()
        local state = humanoid:GetState()
        local isGrounded = (state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.RunningNoPhysics or state == Enum.HumanoidStateType.Landed)
        if Data.IsRecording and isGrounded and (tick() - lastJumpTime) > 0.5 then 
            lastJumpTime = tick()
            AddNode(hrp.Position, true)
            lastPos = hrp.Position
            UpdateInfoUI()
        end
    end)
    
    Data.Conns.State = humanoid.StateChanged:Connect(function(oldState, newState)
        if Data.IsRecording and newState == Enum.HumanoidStateType.Landed then
            AddNode(hrp.Position, false)
            lastPos = hrp.Position
            UpdateInfoUI()
        end
    end)
    
    Data.Conns.Rec = RunService.Stepped:Connect(function(time, dt)
        if not Data.IsRecording then return end
        Data.TotalRecordTime = Data.TotalRecordTime + dt
        
        if tick() - lastUITick > 1 then
            lastUITick = tick()
            UpdateInfoUI()
        end
        
        local state = humanoid:GetState()
        local distLimit = (state == Enum.HumanoidStateType.Climbing) and 1.2 or 3.5
        
        if (hrp.Position - lastPos).Magnitude > distLimit then
            AddNode(hrp.Position, false)
            lastPos = hrp.Position
        end
    end)
end

-- ==========================================
-- 2. FUNGSI PLAYBACK (NATIVE COROUTINE MOVETO - PERFECT LOGIC)
-- ==========================================
local function PlayRecord()
    if #Data.Path == 0 then SendNotif("⚠️ ERROR", "Rute Kosong!"); return end
    
    local char = player.Character
    if not char or not char.Parent or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then char = player.CharacterAdded:Wait() end
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")
    
    local distToBasecamp = (hrp.Position - Data.Path[1].Position).Magnitude
    if distToBasecamp < 25 then
        Data.CurrentNode = 1; SendNotif("🚀 WALK", "Mulai dari Basecamp")
    else
        local closestDist = math.huge
        for i, step in ipairs(Data.Path) do
            local dist = (hrp.Position - step.Position).Magnitude
            if dist < closestDist then closestDist = dist; Data.CurrentNode = i end
        end
        SendNotif("🚀 WALK", "Lanjut dari Titik " .. Data.CurrentNode)
    end
    
    Data.IsPlaying = true
    humanoid.AutoRotate = true 

    if UI and UI.BtnPlay then 
        UI.BtnPlay.Text = "⏹ STOP WALK"
        UI.BtnPlay.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end

    -- Hapus Thread lama kalo masih ada yang jalan
    if Data.PlayThread then task.cancel(Data.PlayThread) end

    -- Bikin Thread baru buat jalanin rute tanpa ngerusak FPS
    Data.PlayThread = task.spawn(function()
        for i = Data.CurrentNode, #Data.Path do
            if not Data.IsPlaying or humanoid.Health <= 0 then break end
            
            Data.CurrentNode = i
            local step = Data.Path[i]
            local targetPos = step.Position
            
            -- Pake Engine Bawaan Roblox! Mulus Parah Gak Akan Nyemplung
            humanoid:MoveTo(targetPos)
            
            if step.IsJumpPoint then
                humanoid.Jump = true
            end
            
            local stuckTimer = 0
            while Data.IsPlaying and humanoid.Health > 0 do
                local dt = RunService.Heartbeat:Wait()
                stuckTimer = stuckTimer + dt
                
                -- Hitung jarak ke titik (Pake 2D biar di tangga gak error)
                local currentPos = hrp.Position
                local dist2D = (Vector3.new(currentPos.X, targetPos.Y, currentPos.Z) - targetPos).Magnitude
                
                -- Toleransi fix, aman buat segala jenis speed
                if dist2D <= 3.5 then
                    break -- Titik tercapai! Lanjut ke node berikutnya
                end
                
                -- Kalau udah kelamaan (nyangkut), paksa teleport ke titik itu
                if stuckTimer > 1.5 then
                    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2.5, 0))
                    hrp.Velocity = Vector3.zero
                    break
                end
            end
        end
        
        -- Kalo udah nyampe akhir rute
        if Data.IsPlaying then
            Data.IsPlaying = false
            SendNotif("🏁 SELESAI", "Auto Walk Selesai!")
            if UI and UI.BtnPlay then 
                UI.BtnPlay.Text = "▶ PLAY"
                UI.BtnPlay.BackgroundColor3 = Color3.fromRGB(40, 200, 90) 
            end
            humanoid:MoveTo(hrp.Position) -- Stop jalan
        end
    end)
end

-- ==========================================
-- 3. BINDING TOMBOL KE LOGIC & FIX JSON
-- ==========================================
if UI and UI.BtnRecord then
    UI.BtnRecord.MouseButton1Click:Connect(function()
        if not Data.IsRecording then StartRecording(false); UI.BtnRecord.Text = "⏹ STOP REC" else StopRecording(); UI.BtnRecord.Text = "⏺ RECORD"; SendNotif("✅ SELESAI", "Record dihentikan!") end
    end)
    
    UI.BtnPlay.MouseButton1Click:Connect(function()
        if Data.IsRecording then StopRecording(); UI.BtnRecord.Text = "⏺ RECORD" end
        if Data.IsPlaying then
            -- Kalau lagi Play terus distop manual
            Data.IsPlaying = false
            if Data.PlayThread then task.cancel(Data.PlayThread) end
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:MoveTo(char.HumanoidRootPart.Position)
            end
            UI.BtnPlay.Text = "▶ PLAY"
            UI.BtnPlay.BackgroundColor3 = Color3.fromRGB(40, 200, 90)
        else
            -- Mulai Play
            PlayRecord()
        end
    end)

    UI.BtnSave.MouseButton1Click:Connect(function() 
        if writefile then 
            local savablePath = {}
            for _, step in ipairs(Data.Path) do 
                table.insert(savablePath, {
                    x = step.Position.X, y = step.Position.Y, z = step.Position.Z, 
                    IsJumpPoint = step.IsJumpPoint
                }) 
            end
            writefile(ConfigFolder.."/NOXVA_Route.json", HttpService:JSONEncode(savablePath)) 
            SendNotif("💾 SAVE", "JSON TERSIMPAN di folder executor!") 
        end 
    end)

    UI.BtnLoad.MouseButton1Click:Connect(function() 
        if isfile and isfile(ConfigFolder.."/NOXVA_Route.json") then 
            local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(ConfigFolder.."/NOXVA_Route.json")) end)
            if success and type(decoded) == "table" then
                Data.Path = {}
                for _, step in ipairs(decoded) do 
                    table.insert(Data.Path, {
                        Position = Vector3.new(step.x, step.y, step.z), 
                        IsJumpPoint = step.IsJumpPoint
                    }) 
                end
                Data.TotalRecordTime = #Data.Path * (1/60) 
                UpdateInfoUI() 
                SendNotif("📂 LOAD", "JSON TER-LOAD! Total Rute: " .. #Data.Path) 
            end
        end 
    end)
    
    UI.BtnExport.MouseButton1Click:Connect(function()
        if #Data.Path == 0 then SendNotif("⚠️ EXPORT", "Rute Kosong!") return end
        local s = "local Route = {\n"
        for _,v in ipairs(Data.Path) do 
            s = s..string.format("    {Vector3.new(%.2f, %.2f, %.2f), %s},\n", v.Position.X, v.Position.Y, v.Position.Z, tostring(v.IsJumpPoint)) 
        end
        s = s.."}\nreturn Route"
        if writefile then writefile(ConfigFolder.."/NOXVA_Script_Export.lua", s); SendNotif("✅ EXPORT", "Script berhasil di-export murni!")
        else SendNotif("❌ ERROR", "Executor lu gak support writefile!") end
    end)
end

_G.NoxvaWalkAPI = { StopRecord = StopRecording, StartRecord = StartRecording, Play = PlayRecord }
