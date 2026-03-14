-- ==========================================
-- LOGIC: PLAYBACK (PLAY, PAUSE, RESUME, LOOP)
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local Data = _G.NoxvaWalkData
local UI = _G.NoxvaWalkUI
local lastJumpTime = 0
local stuckTimer = 0

-- FUNGSI 1: PAUSE (Berhenti tapi memori jalan tetap disimpan)
local function PausePlay()
    Data.IsPlaying = false
    if Data.Conns.Play then Data.Conns.Play:Disconnect() end
    
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid:Move(Vector3.zero, false) -- Ngerem botnya biar ga nyelonong
    end
    
    -- Ubah tampilan tombol jadi Resume
    if UI.BtnPlay then 
        UI.BtnPlay.Text = "▶ RESUME"
        UI.BtnPlay.BackgroundColor3 = Color3.fromRGB(40, 180, 80) 
    end
    if UI.StatusLabel then UI.StatusLabel.Text = "PAUSED" end
end

-- FUNGSI 2: STOP (Berhenti total & Reset ke node 1)
local function StopPlay()
    Data.IsPlaying = false
    Data.CurrentNode = 1 -- Reset ke awal rute
    if Data.Conns.Play then Data.Conns.Play:Disconnect() end
    
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid:Move(Vector3.zero, false)
    end
    
    -- Balikin tombol ke bentuk semula
    if UI.BtnPlay then 
        UI.BtnPlay.Text = "▶ PLAY"
        UI.BtnPlay.BackgroundColor3 = Color3.fromRGB(40, 180, 80) 
    end
    if UI.StatusLabel then UI.StatusLabel.Text = "IDLE" end
    if _G.NoxvaUpdateUI then _G.NoxvaUpdateUI() end
end

-- FUNGSI 3: START / RESUME
local function StartPlay()
    if not Data.Path or #Data.Path == 0 then return end
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")
    
    -- Kalo Data.CurrentNode kosong atau kelewatan batas, mulai dari awal
    if not Data.CurrentNode or Data.CurrentNode > #Data.Path then
        Data.CurrentNode = 1
    end
    
    stuckTimer = 0
    Data.IsPlaying = true
    
    -- Ubah tampilan tombol jadi Pause (Warna Oren/Kuning)
    if UI.BtnPlay then 
        UI.BtnPlay.Text = "⏸ PAUSE"
        UI.BtnPlay.BackgroundColor3 = Color3.fromRGB(180, 120, 30) 
    end
    if UI.StatusLabel then UI.StatusLabel.Text = "PLAYING" end

    -- Bersihin koneksi lama biar ga double speed
    if Data.Conns.Play then Data.Conns.Play:Disconnect() end
    
    Data.Conns.Play = RunService.Stepped:Connect(function(_, dt)
        if not Data.IsPlaying or humanoid.Health <= 0 then PausePlay() return end
        
        -- Kalo rute udah mentok sampai ujung
        if Data.CurrentNode > #Data.Path then
            if Data.IsLooping then
                Data.CurrentNode = 1 -- Ngulang rute kalo Loop nyala
                hrp.CFrame = CFrame.new(Data.Path[1].Position + Vector3.new(0, 3, 0))
            else
                StopPlay() -- Matiin bot kalo Loop mati
            end
            return
        end

        local step = Data.Path[Data.CurrentNode]
        local targetSpeed = (step.Speed and step.Speed > 16) and step.Speed or 16
        humanoid.WalkSpeed = targetSpeed * (Data.SpeedMult or 1)
        
        local myPos = hrp.Position
        local targetPos = step.Position
        local dist2D = (Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos).Magnitude
        
        local tolerance = math.max(4.0, humanoid.WalkSpeed * 0.1)
        if humanoid:GetState() == Enum.HumanoidStateType.Freefall then tolerance = tolerance * 1.5 end

        -- Kalo bot udah nyentuh titik koordinat, lanjut ke titik berikutnya
        if dist2D < tolerance then
            Data.CurrentNode = Data.CurrentNode + 1
            stuckTimer = 0
            -- Update UI Info biar ketauan udah jalan sampe mana
            if UI.InfoLabel then UI.InfoLabel.Text = string.format("Nodes: %d / %d", Data.CurrentNode - 1, #Data.Path) end
            return
        end

        -- Logic Jalan Bawaan Roblox (Aman & Mulus)
        local walkDir = (Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos)
        if walkDir.Magnitude > 0.1 then
            humanoid:Move(walkDir.Unit, false)
        end

        -- Logic Lompat
        if step.IsJumpPoint and dist2D < (tolerance + 3.0) and (tick() - lastJumpTime > 0.25) then
            humanoid.Jump = true
            lastJumpTime = tick()
        end

        -- Anti Nyangkut (Kalo diem di tempat selama 2.5 detik, ditarik paksa ke depan)
        stuckTimer = stuckTimer + dt
        if stuckTimer > 2.5 then
            hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
            Data.CurrentNode = Data.CurrentNode + 1
            stuckTimer = 0
        end
    end)
end

-- ==========================================
-- SAKLAR TOMBOL PLAY / PAUSE
-- ==========================================
if UI.BtnPlay then
    UI.BtnPlay.MouseButton1Click:Connect(function()
        if Data.IsRecording then return end -- Cegah tombol dipencet pas lagi nge-record
        
        if Data.IsPlaying then
            PausePlay() -- Kalo lagi lari, dipause
        else
            StartPlay() -- Kalo lagi diem, dilanjutin (Play/Resume)
        end
    end)
end

