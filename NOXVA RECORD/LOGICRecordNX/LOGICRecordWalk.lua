-- ==========================================
-- NOXVA HUB | PURE LOGIC RECORD WALK (V6 ENGINE FIX REALTIME MODIFIER)
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
    Conns = {},
    CoilSettings = {
        NormalWS = 0, NormalJP = 0,
        Coil1Name = "Speed Coil", Coil1WS = 0, Coil1JP = 0,
        Coil2Name = "Gravity Coil", Coil2WS = 0, Coil2JP = 0
    }
}
local Data = _G.NoxvaWalkData

local ConfigFolder = "NoxvaHub/WalkRecords/" .. tostring(game.PlaceId)
if makefolder then pcall(function() makefolder("NoxvaHub") makefolder("NoxvaHub/WalkRecords") makefolder(ConfigFolder) end) end

local lastJumpTime = 0
local stuckTimer = 0
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
-- REALTIME SPEED ENFORCER (BUAT TESTING SEBELUM RECORD!)
-- ==========================================
-- Loop ini bakal maksa nerapin Speed yang lu masukin di UI secara Real-Time!
if Data.Conns.RealtimeSpeed then Data.Conns.RealtimeSpeed:Disconnect() end
Data.Conns.RealtimeSpeed = RunService.Heartbeat:Connect(function()
    -- Jangan nimpa kalo lagi bot PlayRecord (Karena pas PlayRecord pake logicnya sendiri)
    if Data.IsPlaying then return end 
    
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if not hum then return end

    local tool = char:FindFirstChildOfClass("Tool")
    local toolName = tool and tool.Name or "None"

    local targetWS = 0
    local targetJP = 0

    if toolName == Data.CoilSettings.Coil1Name then
        targetWS = Data.CoilSettings.Coil1WS
        targetJP = Data.CoilSettings.Coil1JP
    elseif toolName == Data.CoilSettings.Coil2Name then
        targetWS = Data.CoilSettings.Coil2WS
        targetJP = Data.CoilSettings.Coil2JP
    else
        targetWS = Data.CoilSettings.NormalWS
        targetJP = Data.CoilSettings.NormalJP
    end

    -- Kalo di UI diisi angka lebih dari 0, paksa speed karakternya saat itu juga!
    if targetWS > 0 then hum.WalkSpeed = targetWS end
    if targetJP > 0 then hum.JumpPower = targetJP end
end)

-- ==========================================
-- DETEKSI TOOL (COIL) SAAT RECORD
-- ==========================================
local function GetEquippedTool()
    local char = player.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then return tool.Name end
    end
    return "None"
end

local function AddNode(pos, isJump)
    table.insert(Data.Path, {
        Position = pos, 
        IsJumpPoint = isJump,
        Tool = GetEquippedTool()
    })
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
-- 2. ABSOLUTE SPEED ENGINE (BACA SETTING UI LU)
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
        
        -- ⚡ CEK SETTING UI LU BERDASARKAN TOOL SAAT ITU
        local targetWS = Data.CoilSettings.NormalWS > 0 and Data.CoilSettings.NormalWS or 16
        local targetJP = Data.CoilSettings.NormalJP > 0 and Data.CoilSettings.NormalJP or 50
        
        if step.Tool == Data.CoilSettings.Coil1Name then
            targetWS = Data.CoilSettings.Coil1WS > 0 and Data.CoilSettings.Coil1WS or 32
            targetJP = Data.CoilSettings.Coil1JP > 0 and Data.CoilSettings.Coil1JP or 50
        elseif step.Tool == Data.CoilSettings.Coil2Name then
            targetWS = Data.CoilSettings.Coil2WS > 0 and Data.CoilSettings.Coil2WS or 16
            targetJP = Data.CoilSettings.Coil2JP > 0 and Data.CoilSettings.Coil2JP or 100
        end
        
        humanoid.WalkSpeed = targetWS
        humanoid.JumpPower = targetJP

        local targetPos = step.Position
        local myPos = hrp.Position
        
        local walkDir = (Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos)
        local dist2D = walkDir.Magnitude
        local dir = (dist2D > 0.1) and walkDir.Unit or Vector3.zero
        
        local state = humanoid:GetState()
        local isMidAir = (state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall)
        local yDiff = targetPos.Y - myPos.Y

        if dir ~= Vector3.zero then
            humanoid:Move(dir, false)
            local targetVelY = hrp.Velocity.Y

            if isMidAir then
                hrp.Velocity = Vector3.new(dir.X * targetWS, targetVelY, dir.Z * targetWS)
            else
                if yDiff > 1.2 then
                    if not isMidAir then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
                    targetVelY = math.max(targetVelY, 15) 
                elseif yDiff < -5 and dist2D < 4 then
                    targetVelY = -60 
                end
                hrp.Velocity = Vector3.new(dir.X * targetWS, targetVelY, dir.Z * targetWS)
            end
            
            if dist2D > 0.5 then 
                local freshPos = hrp.Position
                hrp.CFrame = CFrame.lookAt(freshPos, Vector3.new(targetPos.X, freshPos.Y, targetPos.Z)) 
            end
        end

        local tolerance = (step.IsJumpPoint) and 2.5 or 2.0
        
        if step.IsJumpPoint and dist2D < (tolerance + 1.0) then 
            if not isMidAir and (tick() - lastJumpTime > 0.5) then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                lastJumpTime = tick()
                hrp.Velocity = Vector3.new(dir.X * (targetWS * 1.2), hrp.Velocity.Y, dir.Z * (targetWS * 1.2))
            end
        end

        if dist2D < tolerance then
            Data.CurrentNode = Data.CurrentNode + 1
            stuckTimer = 0
        end

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
            for _, step in ipairs(Data.Path) do 
                table.insert(savablePath, {
                    x = step.Position.X, y = step.Position.Y, z = step.Position.Z, 
                    IsJumpPoint = step.IsJumpPoint,
                    Tool = step.Tool
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
                        IsJumpPoint = step.IsJumpPoint,
                        Tool = step.Tool or "None"
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
            s = s..string.format("    {Vector3.new(%.2f, %.2f, %.2f), %s, \"%s\"},\n", v.Position.X, v.Position.Y, v.Position.Z, tostring(v.IsJumpPoint), v.Tool or "None") 
        end
        s = s.."}\nreturn Route"
        if writefile then writefile(ConfigFolder.."/NOXVA_Script_Export.lua", s); SendNotif("✅ EXPORT", "Script berhasil di-export murni!")
        else SendNotif("❌ ERROR", "Executor lu gak support writefile!") end
    end)
end

_G.NoxvaWalkAPI = { StopRecord = StopRecording, StartRecord = StartRecording, Play = PlayRecord }
