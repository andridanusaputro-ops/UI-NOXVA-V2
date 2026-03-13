-- ==========================================
-- NOXVA HUB | PURE LOGIC RECORD WALK (V6 ENGINE)
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================
local UI = _G.NoxvaWalkUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- BRANKAS DATA GLOBAL
_G.NoxvaWalkData = _G.NoxvaWalkData or {
    Path = {},
    IsRecording = false,
    IsPlaying = false,
    CurrentNode = 1,
    EditIndex = 0,
    TotalRecordTime = 0,
    Conns = {} -- Tempat nyimpen koneksi biar gak bocor (Bug Fix)
}
local Data = _G.NoxvaWalkData

local ConfigFolder = "NoxvaHub/WalkRecords/" .. tostring(game.PlaceId)
if makefolder then pcall(function() makefolder("NoxvaHub") makefolder("NoxvaHub/WalkRecords") makefolder(ConfigFolder) end) end

local lastJumpTime = 0
local stuckTimer = 0

local function SendNotif(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = text, Duration = 3})
end

-- ==========================================
-- 1. FUNGSI RECORDING
-- ==========================================
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
        table.clear(Data.Path)
        Data.TotalRecordTime = 0
        SendNotif("🔴 RECORD", "Recording Dimulai!") 
    else 
        SendNotif("🔴 RECORD", "Resume Recording!") 
    end
    
    Data.IsRecording = true
    local lastPos = hrp.Position
    
    -- Anti Bug: Bersihin koneksi lama sebelum bikin baru
    StopRecording()
    Data.IsRecording = true 
    
    Data.Conns.Death = humanoid.Died:Connect(function()
        if Data.IsRecording then StopRecording(); SendNotif("⏸️ RECORD", "Mati! Recording Pause.") end
    end)
    
    Data.Conns.Jump = UserInputService.JumpRequest:Connect(function()
        if Data.IsRecording and (tick() - lastJumpTime) > 0.5 then 
            lastJumpTime = tick()
            table.insert(Data.Path, {Position = hrp.Position, IsJumpPoint = true})
            lastPos = hrp.Position
        end
    end)
    
    Data.Conns.State = humanoid.StateChanged:Connect(function(oldState, newState)
        if Data.IsRecording and newState == Enum.HumanoidStateType.Landed then
            table.insert(Data.Path, {Position = hrp.Position, IsJumpPoint = false})
            lastPos = hrp.Position
        end
    end)
    
    Data.Conns.Rec = RunService.Stepped:Connect(function(time, dt)
        if not Data.IsRecording then return end
        Data.TotalRecordTime = Data.TotalRecordTime + dt
        
        local state = humanoid:GetState()
        local distLimit = (state == Enum.HumanoidStateType.Climbing) and 1.2 or 3.5
        
        if (hrp.Position - lastPos).Magnitude > distLimit then
            table.insert(Data.Path, {Position = hrp.Position, IsJumpPoint = false})
            lastPos = hrp.Position
        end
    end)
end

-- ==========================================
-- 2. ABSOLUTE SPEED ENGINE (AUTO WALK V6)
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
    
    stuckTimer = 0
    Data.IsPlaying = true
    if Data.Conns.Play then Data.Conns.Play:Disconnect() end
    
    Data.Conns.Play = RunService.Stepped:Connect(function(time, dt)
        if not Data.IsPlaying or humanoid.Health <= 0 then
            Data.IsPlaying = false; if Data.Conns.Play then Data.Conns.Play:Disconnect() end; return
        end
        
        if Data.CurrentNode > #Data.Path then
            Data.IsPlaying = false; SendNotif("🏁 SELESAI", "Auto Walk Selesai!")
            if UI and UI.BtnPlay then UI.BtnPlay.Text = "▶ PLAY" end
            humanoid:Move(Vector3.zero, false)
            hrp.Velocity = Vector3.zero
            if Data.Conns.Play then Data.Conns.Play:Disconnect() end; return
        end

        local step = Data.Path[Data.CurrentNode]
        local targetPos = step.Position
        local myPos = hrp.Position
        
        local walkDir = (Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos)
        local dist2D = walkDir.Magnitude
        local dir = (dist2D > 0.1) and walkDir.Unit or Vector3.zero
        
        local state = humanoid:GetState()
        local yDiff = targetPos.Y - myPos.Y
        local currentSpeed = humanoid.WalkSpeed

        if dir ~= Vector3.zero then
            humanoid:Move(dir, false)
            local velX, velZ, velY = dir.X * currentSpeed, dir.Z * currentSpeed, hrp.Velocity.Y

            -- FIX V6: Nanjak (Tangga Melayang)
            if yDiff > 1.2 then
                if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall and state ~= Enum.HumanoidStateType.Climbing then humanoid.Jump = true end
                velY = math.max(velY, 15) 
            end

            -- FIX V6: Drop Anchor (Turun Curam)
            if yDiff < -5 and dist2D < 4 then
                velX, velZ, velY = dir.X * 5, dir.Z * 5, -60 
            end

            hrp.Velocity = Vector3.new(velX, velY, velZ)
            if dist2D > 0.5 then hrp.CFrame = CFrame.lookAt(myPos, Vector3.new(targetPos.X, myPos.Y, targetPos.Z)) end
        end

        local tolerance = (step.IsJumpPoint) and 2.5 or 2.0
        if dist2D < tolerance then
            if step.IsJumpPoint then humanoid.Jump = true end
            Data.CurrentNode = Data.CurrentNode + 1
            stuckTimer = 0
        end

        -- STUCK HANDLER
        stuckTimer = stuckTimer + dt
        if stuckTimer > 1.2 then 
            hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
            Data.CurrentNode = Data.CurrentNode + 1
            stuckTimer = 0
        end
    end)
end

-- ==========================================
-- 3. BINDING TOMBOL KE LOGIC
-- ==========================================
if UI then
    UI.BtnRecord.MouseButton1Click:Connect(function()
        if not Data.IsRecording then StartRecording(false); UI.BtnRecord.Text = "⏹ STOP REC" else StopRecording(); UI.BtnRecord.Text = "⏺ RECORD"; SendNotif("✅ SELESAI", "Record dihentikan!") end
    end)
    
    UI.BtnPlay.MouseButton1Click:Connect(function()
        if Data.IsRecording then StopRecording(); UI.BtnRecord.Text = "⏺ RECORD" end
        Data.IsPlaying = not Data.IsPlaying
        if Data.IsPlaying then UI.BtnPlay.Text = "⏹ STOP WALK"; PlayRecord()
        else UI.BtnPlay.Text = "▶ PLAY"; if Data.Conns.Play then Data.Conns.Play:Disconnect() end; local char = player.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid:Move(Vector3.zero, false) end end 
    end)

    UI.BtnSave.MouseButton1Click:Connect(function() 
        if writefile then 
            local savablePath = {}
            for _, step in ipairs(Data.Path) do table.insert(savablePath, {x = step.Position.X, y = step.Position.Y, z = step.Position.Z, IsJumpPoint = step.IsJumpPoint}) end
            writefile(ConfigFolder.."/NOXVA_Route.json", HttpService:JSONEncode(savablePath)) 
            SendNotif("💾 SAVE", "JSON TERSIMPAN di folder executor!") 
        end 
    end)

    UI.BtnLoad.MouseButton1Click:Connect(function() 
        if isfile and isfile(ConfigFolder.."/NOXVA_Route.json") then 
            local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(ConfigFolder.."/NOXVA_Route.json")) end)
            if success and type(decoded) == "table" then
                Data.Path = {}
                for _, step in ipairs(decoded) do table.insert(Data.Path, {Position = Vector3.new(step.x, step.y, step.z), IsJumpPoint = step.IsJumpPoint}) end
                Data.TotalRecordTime = #Data.Path * (1/60) 
                SendNotif("📂 LOAD", "JSON TER-LOAD! Total Rute: " .. #Data.Path) 
            end
        end 
    end)
end

-- Export fungsi biar bisa dipake file Control & Timeline
_G.NoxvaWalkAPI = { StopRecord = StopRecording, StartRecord = StartRecording, Play = PlayRecord }
