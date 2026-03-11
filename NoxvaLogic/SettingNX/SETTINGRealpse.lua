local SETTINGRealpse = {}
local HttpService = game:GetService("HttpService")
local FolderName = "NoxvaConfigs"

-- ==========================================
-- 1. LOGIC ANTI-ADMIN
-- ==========================================
SETTINGRealpse.AntiAdminActive = false

function SETTINGRealpse:ToggleAntiAdmin(state)
    self.AntiAdminActive = state
    if state then
        task.spawn(function()
            while self.AntiAdminActive do
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game:GetService("Players").LocalPlayer then
                        if player:GetRankInGroup(0) > 1 or player.Name:lower():find("admin") then
                            game:GetService("Players").LocalPlayer:Kick("Admin Detected: " .. player.Name)
                        end
                    end
                end
                task.wait(2)
            end
        end)
    end
end

-- ==========================================
-- 2. LOGIC CONFIG MANAGER
-- ==========================================
function SETTINGRealpse:Init()
    if makefolder and not isfolder(FolderName) then makefolder(FolderName) end
end

function SETTINGRealpse:GetConfigList()
    self:Init()
    local list = {}
    if listfiles then
        for _, file in pairs(listfiles(FolderName)) do
            if file:match("%.json$") then
                local name = file:match("([^/\\]+)%.json$")
                if name then table.insert(list, name) end
            end
        end
    end
    if #list == 0 then table.insert(list, "Belum Ada Config") end
    return list
end

function SETTINGRealpse:SaveConfig(ConfigName, FlagsData)
    if not writefile then return false, "Executor lu gak support writefile!" end
    if ConfigName == "" then return false, "Nama config gak boleh kosong!" end
    
    self:Init()
    local dataToSave = {}
    for flagName, data in pairs(FlagsData) do 
        if typeof(data.Value) == "Color3" then
            dataToSave[flagName] = {R = data.Value.R, G = data.Value.G, B = data.Value.B, IsColor = true}
        else
            dataToSave[flagName] = data.Value 
        end
    end
    
    local success, json = pcall(function() return HttpService:JSONEncode(dataToSave) end)
    if success then
        writefile(FolderName .. "/" .. ConfigName .. ".json", json)
        return true, "Config '" .. ConfigName .. "' berhasil disave!"
    end
    return false, "Gagal encode JSON."
end

function SETTINGRealpse:LoadConfig(ConfigName, FlagsData)
    if not readfile then return false, "Executor lu gak support readfile!" end
    if ConfigName == "Belum Ada Config" then return false, "Gak ada config yang bisa diload." end
    
    local path = FolderName .. "/" .. ConfigName .. ".json"
    if isfile(path) then
        local success, json = pcall(function() return readfile(path) end)
        if success then
            local data = HttpService:JSONDecode(json)
            for flagName, value in pairs(data) do
                if FlagsData[flagName] then
                    if type(value) == "table" and value.IsColor then
                        FlagsData[flagName].Value = Color3.new(value.R, value.G, value.B)
                        if FlagsData[flagName].Func then FlagsData[flagName].Func(Color3.new(value.R, value.G, value.B)) end
                    else
                        FlagsData[flagName].Value = value
                        if FlagsData[flagName].Func then FlagsData[flagName].Func(value) end
                    end
                end
            end
            return true, "Config '" .. ConfigName .. "' berhasil diload!"
        end
    end
    return false, "File config tidak ditemukan."
end

return SETTINGRealpse
