-- ==========================================
-- LOGIC: RECORDER (SET TOGGLE)
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local Data = _G.NoxvaWalkData
local UI = _G.NoxvaWalkUI
local lastJumpTime = 0
local lastPos = Vector3.zero

local function AddNode(pos, isJump, speed)
    table.insert(Data.Path, {
        Position = pos,
        IsJumpPoint = isJump,
        Speed = speed or 16,
        Time = Data.TotalTime
    })
    if _G.NoxvaUpdateUI then _G.NoxvaUpdateUI() end
end

local function StopRecord()
    Data.IsRecording = false
    if Data.Conns.Rec then Data.Conns.Rec:Disconnect() end
    if Data.Conns.JumpRec then Data.Conns.JumpRec:Disconnect() end
    
    if UI.BtnSet then
        UI.BtnSet.Text = "⏺ SET"
        UI.BtnSet.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
    if UI.StatusLabel then UI.StatusLabel.Text = "IDLE" end
    _G.SendNoxvaNotifLogic("NOXVA RECORD", "Recording Selesai! Total Node: " .. #Data.Path)
end

local function StartRecord()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")
    
    Data.Path = {}
    Data.TotalTime = 0
    Data.IsRecording = true
    lastPos = hrp.Position
    if _G.NoxvaUpdateUI then _G.NoxvaUpdateUI() end
    
    if UI.BtnSet then
        UI.BtnSet.Text = "⏹ STOP REC"
        UI.BtnSet.BackgroundColor3 = Color3.fromRGB(180, 120, 30)
    end
    if UI.StatusLabel then UI.StatusLabel.Text = "RECORDING" end
    _G.SendNoxvaNotifLogic("NOXVA RECORD", "Mulai Merekam Rute...")
    
    Data.Conns.JumpRec = UserInputService.JumpRequest:Connect(function()
        if Data.IsRecording and (tick() - lastJumpTime) > 0.3 then
            lastJumpTime = tick()
            AddNode(hrp.Position, true, humanoid.WalkSpeed)
            lastPos = hrp.Position
        end
    end)
    
    Data.Conns.Rec = RunService.Stepped:Connect(function(_, dt)
        if not Data.IsRecording then return end
        Data.TotalTime = Data.TotalTime + dt
        
        local recordGap = math.max(3.5, humanoid.WalkSpeed * 0.1)
        if (hrp.Position - lastPos).Magnitude > recordGap then
            AddNode(hrp.Position, false, humanoid.WalkSpeed)
            lastPos = hrp.Position
        end
    end)
end

if UI.BtnSet then
    UI.BtnSet.MouseButton1Click:Connect(function()
        if Data.IsPlaying then return end
        if Data.IsRecording then
            StopRecord()
        else
            StartRecord()
        end
    end)
end

