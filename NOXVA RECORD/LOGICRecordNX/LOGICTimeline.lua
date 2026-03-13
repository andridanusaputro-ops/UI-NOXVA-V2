-- ==========================================
-- NOXVA HUB - LOGIC TIMELINE CUT & CP (PURE LOGIC)
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================

local UI = _G.NoxvaWalkUI
local Data = _G.NoxvaWalkData

if not UI or not Data then
    warn("Noxva Error: UI atau Data Global belum siap! Logic Timeline dibatalkan.")
    return
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variabel buat mode "Preview" / Editing
local PreviewIndex = 1

local function SendNotif(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = text, Duration = 3})
end

-- Fungsi buat teleport karakter ke titik yang lagi di-preview
local function TeleportToPreview()
    if Data.Path[PreviewIndex] then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(Data.Path[PreviewIndex] + Vector3.new(0, 3, 0)) -- Ditambah 3 Y biar gak nyangkut di tanah
            SendNotif("TIMELINE", "Melihat Titik ke-" .. PreviewIndex .. " dari " .. #Data.Path)
        end
    end
end

-- ==========================================
-- LOGIC 1: NEXT & PREV (Maju Mundur Titik)
-- ==========================================
UI.BtnNext.MouseButton1Click:Connect(function()
    if #Data.Path == 0 then SendNotif("ERROR", "Data kosong!") return end
    if PreviewIndex < #Data.Path then
        PreviewIndex = PreviewIndex + 1
        TeleportToPreview()
    else
        SendNotif("TIMELINE", "Ini sudah titik paling ujung!")
    end
end)

UI.BtnPrev.MouseButton1Click:Connect(function()
    if #Data.Path == 0 then SendNotif("ERROR", "Data kosong!") return end
    if PreviewIndex > 1 then
        PreviewIndex = PreviewIndex - 1
        TeleportToPreview()
    else
        SendNotif("TIMELINE", "Ini sudah titik paling awal!")
    end
end)

-- ==========================================
-- LOGIC 2: DONE / CUT (Potong Jejak)
-- ==========================================
-- Fungsi ini bakal memotong/menghapus semua titik SETELAH titik yang lu liat sekarang.
UI.BtnDone.MouseButton1Click:Connect(function()
    if #Data.Path == 0 then return end
    
    local oldTotal = #Data.Path
    local newPath = {}
    
    -- Ambil data dari titik 1 sampai titik yang lu preview
    for i = 1, PreviewIndex do
        table.insert(newPath, Data.Path[i])
    end
    
    Data.Path = newPath -- Timpa data lama
    SendNotif("TIMELINE CUT", "Jejak dipotong! Dari " .. oldTotal .. " menjadi " .. #Data.Path .. " titik.")
end)

-- ==========================================
-- LOGIC 3: DROPDOWN CHECKPOINT (CP)
-- ==========================================
-- Kita bikin sistem: Tiap 20 Titik (Nodes) bakal dianggep 1 Checkpoint.
local function RefreshDropdownCP()
    if not UI.CPDropdown then return end
    
    local CPList = {}
    local totalCP = math.floor(#Data.Path / 20)
    
    if totalCP < 1 then
        table.insert(CPList, "CP belum terbentuk (Jejak kurang panjang)")
    else
        for i = 1, totalCP do
            table.insert(CPList, "Checkpoint " .. i)
        end
    end
    
    -- Inject data ke UI Custom Dropdown lu
    UI.CPDropdown:UpdateList(CPList, function(CPTerpilih)
        -- Logic saat lu nge-klik CP di dropdown
        if string.find(CPTerpilih, "Checkpoint") then
            -- Ambil angka CP-nya (Contoh: "Checkpoint 2" -> diambil angka 2-nya)
            local cpNum = tonumber(string.match(CPTerpilih, "%d+"))
            if cpNum then
                PreviewIndex = cpNum * 20 -- Lompat ke index titiknya
                TeleportToPreview()
                SendNotif("TELEPORT CP", "Berhasil melompat ke " .. CPTerpilih)
            end
        end
    end)
end

-- Refresh Dropdown CP otomatis setiap kali lu nge-klik UI Timeline
-- Biar datanya selalu update kalau lu abis ngerekam jejak baru.
UI.BtnNext.MouseButton1Click:Connect(RefreshDropdownCP)
UI.BtnPrev.MouseButton1Click:Connect(RefreshDropdownCP)

print("Logic Timeline & CP berhasil dimuat!")

