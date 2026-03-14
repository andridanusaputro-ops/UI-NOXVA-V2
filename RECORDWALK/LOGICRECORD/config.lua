-- ==========================================
-- LOGIC: CONFIG & DATA BRANKAS
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================
local UI = _G.NoxvaWalkUI

_G.NoxvaWalkData = _G.NoxvaWalkData or {
    Path = {},
    Conns = {},
    IsRecording = false,
    IsPlaying = false,
    CurrentNode = 1,
    TotalTime = 0,
    IsLooping = false,
    SpeedMult = 1,
    Folder = "NoxvaHub/WalkRecords/" .. tostring(game.PlaceId)
}

local Data = _G.NoxvaWalkData

-- Buat Folder Otomatis
if makefolder then
    pcall(function()
        makefolder("NoxvaHub")
        makefolder("NoxvaHub/WalkRecords")
        makefolder(Data.Folder)
    end)
end

-- Fungsi Global Update Info
_G.NoxvaUpdateUI = function()
    if UI.InfoLabel then
        local mins = math.floor(Data.TotalTime / 60)
        local secs = math.floor(Data.TotalTime % 60)
        UI.InfoLabel.Text = string.format("Nodes: %d | %02d:%02d", #Data.Path, mins, secs)
    end
end

-- Fungsi Global Notifikasi (Fallback Roblox StarterGui)
_G.SendNoxvaNotifLogic = function(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = text, Duration = 3})
    end)
end

