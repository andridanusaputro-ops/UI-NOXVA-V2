-- ==========================================
-- NOXVA HUB | PURE LOGIC RECORD WALK (V6 ENGINE CLEAN + FIX SHORT JUMP)
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================
local UI = _G.NoxvaWalkUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- BRANKAS DATA GLOBAL (BERSIH DARI COIL SETTINGS)
_G.NoxvaWalkData = _G.NoxvaWalkData or {}
_G.NoxvaWalkData.Path = _G.NoxvaWalkData.Path or {}
_G.NoxvaWalkData.Conns = _G.NoxvaWalkData.Conns or {}
_G.NoxvaWalkData.IsRecording = _G.NoxvaWalkData.IsRecording or false
_G.NoxvaWalkData.IsPlaying = _G.NoxvaWalkData.IsPlaying or false
_G.NoxvaWalkData.CurrentNode = _G.NoxvaWalkData.CurrentNode or 1
_G.NoxvaWalkData.TotalRecordTime = _G.NoxvaWalkData.TotalRecordTime or 0

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
-- 1. FUNGSI RECORDING (MURNI NATIVE)
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
-- 2. FUNGSI PLAYBACK (FIX JUMP PANIC & SHORT DISTANCE)
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
        
        -- MURNI PAKE SPEED BAWAAN ROBLOX SAAT INI (Entah lu lagi pake coil atau gak, dia ngikut otomatis)
        local currentWS = humanoid.WalkSpeed

        local targetPos = step.Position
        local myPos = hrp.Position
        
        local walkDir = (Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos)
        local dist2D = walkDir.Magnitude
        local dir = (dist2D > 0.05) and walkDir.Unit or Vector3.zero
        
        local state = humanoid:GetState()
        local isMidAir = (state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall)
        local yDiff = targetPos.Y - myPos.Y

        if dir ~= Vector3.zero then
            humanoid:Move(dir, false)
            
            if not isMidAir then
                local targetVelY = hrp.Velocity.Y
                if yDiff > 1.2 then
                    targetVelY = math.max(targetVelY, 15) 
                elseif yDiff < -5 and dist2D < 4 then
                    targetVelY = -60 
                end
                hrp.Velocity = Vector3.new(dir.X * currentWS, targetVelY, dir.Z * currentWS)
            else
                hrp.Velocity = Vector3.new(dir.X * currentWS, hrp.Velocity.Y, dir.Z * currentWS)
            end
            
            if dist2D > 0.5 then 
                local freshPos = hrp.Position
                hrp.CFrame = CFrame.lookAt(freshPos, Vector3.new(targetPos.X, freshPos.Y, targetPos.Z)) 
            end
        end

        local tolerance = math.max(2.5, currentWS * 0.05)
        
        -- ========================================================
        -- FIX BUG PANIK LOMPAT DEKET TANGGA:
        -- Gak usah ngecek `isMidAir` lagi. Pokoknya lu nemu titik lompat -> PAKSA LOMPAT!
        -- ========================================================
        if step.IsJumpPoint and dist2D < (tolerance + 2.0) then 
            if (tick() - lastJumpTime > 0.3) then
                humanoid.Jump = true -- Ini yang bikin dia gak pernah gagal lompat
                
                -- Kalo tangganya agak tinggi, suntik Y Velocity dikit biar gak nyangkut nembus
                if yDiff > 0.5 then
                    hrp.Velocity = Vector3.new(hrp.Velocity.X, math.max(hrp.Velocity.Y, humanoid.JumpPower * 0.8), hrp.Velocity.Z)
                end
                
                lastJumpTime = tick()
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
if UI and UI.BtnRecord then
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
