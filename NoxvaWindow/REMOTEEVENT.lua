-- [[ 1. INIT UI LIBRARY LU DARI GITHUB ]]
local NoxvaLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/andridanusaputro-ops/UI-NOXVA-V2/refs/heads/main/uiNoxvaV2.lua"))()

-- [[ 2. CREATE WINDOW UTAMA ]]
local Window = NoxvaLib:CreateWindow()

-- Nyalain Anti-AFK bawaan UI lu biar aman pas lagi ngetes
Window:EnableAntiAFK()

-- [[ 3. BIKIN TAB KHUSUS AUDIT SERVER ]]
local AdminTab = Window:MakeTab("🛡️ Security Audit")
AdminTab:AddLabel("Tools khusus buat nyari celah RemoteEvent di server lu.")

-- ==========================================
-- FITUR TEST CELAH SERVER
-- ==========================================

-- A. Tombol buat nyari nama RemoteEvent
AdminTab:AddButton("🔎 SCAN SEMUA REMOTE EVENT", function()
    print("======================================")
    print("🔥 HASIL SCAN REMOTE EVENT DI SERVER 🔥")
    print("======================================")
    
    local count = 0
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            count = count + 1
            print("[" .. count .. "] NAMA: " .. obj.Name .. " | LOKASI: " .. obj:GetFullName())
        end
    end
    
    if count > 0 then
        Window:Notify("SCAN SELESAI", "Ketemu " .. count .. " event! Buka konsol (F9) buat liat list namanya.", 5)
    else
        Window:Notify("AMAN", "Gak ada RemoteEvent yang kebuka di server lu.", 4)
    end
end)

-- Variabel nyimpen inputan lu
local TargetRemoteName = ""
local TargetPlayerName = ""

-- B. Textbox buat masukin input
AdminTab:AddTextbox("Nama Remote Event", "Contoh: KickEvent / GiveMoney", function(Value)
    TargetRemoteName = Value
end, "InputRemoteBox")

AdminTab:AddTextbox("Target Player (Opsional)", "Ketik nama lu/orang lain...", function(Value)
    TargetPlayerName = Value
end, "InputTargetBox")

-- C. Tombol Eksekusi nembak celah
AdminTab:AddButton("🔫 TEST TEMBAK SERVER", function()
    if TargetRemoteName == "" then
        Window:Notify("ERROR", "Isi dulu nama Event-nya dongo!", 3)
        return
    end

    local remoteList = game:GetDescendants()
    local foundRemote = nil
    local target = game.Players:FindFirstChild(TargetPlayerName)

    -- Nyari RemoteEvent sesuai nama yang lu ketik
    for _, obj in pairs(remoteList) do
        if obj:IsA("RemoteEvent") and obj.Name == TargetRemoteName then
            foundRemote = obj
            break
        end
    end

    -- Eksekusi Tembak
    if foundRemote then
        if target then
            foundRemote:FireServer(target, "Test Celah Noxva")
            Window:Notify("SUKSES", "Sinyal ditembak ke " .. TargetRemoteName .. " dengan target " .. TargetPlayerName, 4)
        else
            foundRemote:FireServer("Test Celah Noxva")
            Window:Notify("SUKSES", "Sinyal ditembak ke " .. TargetRemoteName .. " (Tanpa player)", 4)
        end
        print("Berhasil nembak event: " .. TargetRemoteName)
    else
        Window:Notify("GAGAL", "Remote Event '" .. TargetRemoteName .. "' gak ketemu!", 4)
    end
end)

-- [[ 4. BIKIN TAB SETTINGS BAWAAN UI LU ]]
Window:MakeConfigTab()
