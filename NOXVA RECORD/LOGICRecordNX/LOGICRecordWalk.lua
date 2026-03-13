-- ==========================================
-- NOXVA HUB | PURE LOGIC RECORD WALK (V6 ENGINE FIX JUMP & PHYSICS)
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
    Conns = {} 
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
-- UI UPDATER
-- ==========================================
local function UpdateInfoUI()
    if UI and UI.InfoLabel then
        local mins = math.floor(Data.TotalRecordTime / 60)
        local secs = math.floor(Data.TotalRecordTime % 60)
        UI.InfoLabel.Text = string.format("Total: %d | %02d:%02d", #Data.Path, mins, secs)
    end
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
        UpdateInfoUI()
        SendNotif("🔴 RECORD", "Recording Dimulai!") 
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
    
    -- FIX V6 ANTI DOUBLE JUMP SAAT RECORDING: Cuma catat lompat pas lagi di darat
    Data.Conns.Jump = UserInputService.JumpRequest:Connect(function()
        local state = humanoid:GetState()
        local isGrounded = (state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.RunningNoPhysics or state == Enum.HumanoidStateType.Landed)
        
        if Data.IsRecording and isGrounded and (tick() - lastJumpTime) > 0.5 then 
            lastJumpTime = tick()
            table.insert(Data.Path, {Position = hrp.Position, IsJumpPoint = true})
            lastPos = hrp.Position
            UpdateInfoUI()
        end
    end)
    
    Data.Conns.State = humanoid.StateChanged:Connect(function(oldState, newState)
        if Data.IsRecording and newState == Enum.HumanoidStateType.Landed then
            table.insert(Data.Path, {Position = hrp.Position, IsJumpPoint = false})
            lastPos = hrp.Position
            UpdateInfoUI()
        end
    end)
    
    Data.Conns.Rec = RunService.Stepped:Connect(function(time, dt)
        if not Data.IsRecording then return end
        Data.TotalRecordTime = Data.TotalRecordTime + dt
        UpdateInfoUI()
        
        local state = humanoid:GetState()
        local distLimit = (state == Enum.HumanoidStateType.Climbing) and 1.2 or 3.5
        
        if (hrp.Position - lastPos).Magnitude > distLimit then
            table.insert(Data.Path, {Position = hrp.Position, IsJumpPoint = false})
            lastPos = hrp.Position
            UpdateInfoUI()
        end
    end)
end

-- ==========================================
-- 2. ABSOLUTE SPEED ENGINE (FIX JUMP PHYSICS)
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
    humanoid.AutoRotate = false 

    if Data.Conns.Play then Data.Conns.Play:Disconnect() end
    
    Data.Conns.Play = RunService.Heartbeat:Connect(function(dt)
        if not Data.IsPlaying or humanoid.Health <= 0 then
            Data.IsPlaying = false
            humanoid.AutoRotate = true 
            if Data.Conns.Play then Data.Conns.Play:Disconnect() end; return
        end
        
        if Data.CurrentNode > #Data.Path then
            Data.IsPlaying = false; SendNotif("🏁 SELESAI", "Auto Walk Selesai!")
            if UI and UI.BtnPlay then UI.BtnPlay.Text = "▶ PLAY"; UI.BtnPlay.BackgroundColor3 = Color3.fromRGB(40, 200, 90) end
            humanoid:Move(Vector3.zero, false)
            hrp.Velocity = Vector3.zero
            humanoid.AutoRotate = true 
            if Data.Conns.Play then Data.Conns.Play:Disconnect() end; return
        end

        local step = Data.Path[Data.CurrentNode]
        local targetPos = step.Position
        local myPos = hrp.Position
        
        local walkDir = (Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos)
        local dist2D = walkDir.Magnitude
        local dir = (dist2D > 0.1) and walkDir.Unit or Vector3.zero
        
        local state = humanoid:GetState()
        local isMidAir = (state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall)
        local yDiff = targetPos.Y - myPos.Y
        local currentSpeed = humanoid.WalkSpeed

        if dir ~= Vector3.zero then
            humanoid:Move(dir, false)
            local targetVelY = hrp.Velocity.Y

            if isMidAir then
                -- Biarkan gravitasi kerja untuk Y, tapi dorong terus X dan Z biar nyampe tujuannya!
                hrp.Velocity = Vector3.new(dir.X * currentSpeed, targetVelY, dir.Z * currentSpeed)
            else
                if yDiff > 1.2 then
                    -- Nanjak otomatis kalau bukan titik lompat
                    if not isMidAir then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
                    targetVelY = math.max(targetVelY, 15) 
                elseif yDiff < -5 and dist2D < 4 then
                    targetVelY = -60 
                end
                hrp.Velocity = Vector3.new(dir.X * currentSpeed, targetVelY, dir.Z * currentSpeed)
            end
            
            if dist2D > 0.5 then 
                local freshPos = hrp.Position
                hrp.CFrame = CFrame.lookAt(freshPos, Vector3.new(targetPos.X, freshPos.Y, targetPos.Z)) 
            end
        end

        local tolerance = (step.IsJumpPoint) and 2.5 or 2.0
        
        -- FIX V6 ANTI DOUBLE JUMP + MOMENTUM BOOST
        if step.IsJumpPoint and dist2D < (tolerance + 1.0) then 
            if not isMidAir and (tick() - lastJumpTime > 0.5) then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                lastJumpTime = tick()
                -- Boost dorongan ke depan pas baru lepas landas biar lompatannya pasti nyampe
                hrp.Velocity = Vector3.new(dir.X * (currentSpeed * 1.2), hrp.Velocity.Y, dir.Z * (currentSpeed * 1.2))
            end
        end

        if dist2D < tolerance then
            Data.CurrentNode = Data.CurrentNode + 1
            stuckTimer = 0
        end

        -- FIX V6 STUCK HANDLER: Jangan narik/teleport bot kalau lagi melayang jatuh di udara!
        stuckTimer = stuckTimer + dt
        if stuckTimer > 1.5 then 
            if not isMidAir then 
                hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
            end
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
        if Data.IsPlaying then UI.BtnPlay.Text = "⏹ STOP WALK"; UI.BtnPlay.BackgroundColor3 = Color3.fromRGB(180, 40, 40); PlayRecord()
        else UI.BtnPlay.Text = "▶ PLAY"; UI.BtnPlay.BackgroundColor3 = Color3.fromRGB(40, 200, 90); if Data.Conns.Play then Data.Conns.Play:Disconnect() end; local char = player.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid:Move(Vector3.zero, false); char.Humanoid.AutoRotate = true end end 
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
                UpdateInfoUI() 
                SendNotif("📂 LOAD", "JSON TER-LOAD! Total Rute: " .. #Data.Path) 
            end
        end 
    end)
    
    UI.BtnExport.MouseButton1Click:Connect(function()
        if #Data.Path == 0 then SendNotif("⚠️ EXPORT", "Rute Kosong!") return end
        local s = "local Route = {\n"
        for _,v in ipairs(Data.Path) do s = s..string.format("    {Vector3.new(%.2f, %.2f, %.2f), %s},\n", v.Position.X, v.Position.Y, v.Position.Z, tostring(v.IsJumpPoint)) end
        s = s.."}\nreturn Route"
        if writefile then writefile(ConfigFolder.."/NOXVA_Script_Export.lua", s); SendNotif("✅ EXPORT", "Script berhasil di-export murni!")
        else SendNotif("❌ ERROR", "Executor lu gak support writefile!") end
    end)
end

_G.NoxvaWalkAPI = { StopRecord = StopRecording, StartRecord = StartRecording, Play = PlayRecord }
