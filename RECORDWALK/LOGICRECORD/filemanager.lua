-- ==========================================
-- LOGIC: FILE MANAGER (SAVE & REFRESH DROPDOWN)
-- DEVELOPED BY DANZY (WIB / KEBUMEN)
-- ==========================================
local HttpService = game:GetService("HttpService")
local Data = _G.NoxvaWalkData
local UI = _G.NoxvaWalkUI

-- Fungsi Refresh Isi Dropdown
local function RefreshDropdownList()
    if not UI.PopulateDropdown then return end
    local fileList = {}
    if listfiles then
        pcall(function()
            local files = listfiles(Data.Folder)
            for _, f in ipairs(files) do
                if f:sub(-5) == ".json" then
                    local cleanName = f:match("([^/]+)%.json$") or f:match("([^\\]+)%.json$")
                    if cleanName then table.insert(fileList, cleanName) end
                end
            end
        end)
    end
    if #fileList == 0 then table.insert(fileList, "Belum Ada Rute") end
    UI.PopulateDropdown(fileList)
end

-- Panggil refresh pertama kali pas script diload
RefreshDropdownList()

if UI.BtnSave then
    UI.BtnSave.MouseButton1Click:Connect(function()
        if not writefile then 
            _G.SendNoxvaNotifLogic("❌ ERROR", "Executor lu gak support writefile!")
            return 
        end
        
        local inputName = UI.InputFileName and UI.InputFileName.Text or ""
        local fileName = (inputName ~= "" and inputName:match("%S") ~= nil) and inputName or "Rute_Default"
        fileName = fileName:gsub("[\\/:*?\"<>|]", "")
        
        local fullPath = Data.Folder .. "/" .. fileName .. ".json"
        local savable = {}
        for _, step in ipairs(Data.Path) do 
            table.insert(savable, {
                x = step.Position.X, y = step.Position.Y, z = step.Position.Z, 
                IsJumpPoint = step.IsJumpPoint, Speed = step.Speed, Time = step.Time
            }) 
        end
        
        local success, encoded = pcall(function() return HttpService:JSONEncode(savable) end)
        if success then
            writefile(fullPath, encoded)
            _G.SendNoxvaNotifLogic("💾 SAVE SUCCESS", "Tersimpan sebagai: " .. fileName)
            RefreshDropdownList() -- Otomatis update list di Dropdown
        end
    end)
end

-- Fungsi Global yang bakal dipanggil sama tombol Dropdown di Window
_G.LoadRouteAction = function(fileName)
    if not isfile or not readfile then return end
    local fullPath = Data.Folder .. "/" .. fileName .. ".json"
    
    if isfile(fullPath) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(fullPath)) end)
        if success and type(decoded) == "table" then
            Data.Path = {}
            for _, step in ipairs(decoded) do 
                table.insert(Data.Path, {
                    Position = Vector3.new(step.x, step.y, step.z), 
                    IsJumpPoint = step.IsJumpPoint, 
                    Speed = step.Speed or 16, 
                    Time = step.Time or 0
                }) 
            end
            Data.TotalTime = (#Data.Path > 0) and Data.Path[#Data.Path].Time or (#Data.Path * (1/60))
            if _G.NoxvaUpdateUI then _G.NoxvaUpdateUI() end
        end
    end
end

