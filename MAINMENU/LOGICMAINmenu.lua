-- ==========================================
-- NOXVA HUB - LOGIC MAIN MENU (KEY SYSTEM)
-- DEVELOPED BY DANZY
-- ==========================================
local MainMenuLogic = {}

-- [ SETTINGAN KEY & DISCORD LU DI SINI ]
MainMenuLogic.ValidKey = "DANZYV2" 
MainMenuLogic.DiscordLink = "https://discord.gg/VbumttfB2"

function MainMenuLogic:CheckSupport(PlaceId)
    -- Ngebaca langsung dari Database di NOXVAmain.lua
    if _G.NoxvaSupportedGames and _G.NoxvaSupportedGames[PlaceId] then
        return true, _G.NoxvaSupportedGames[PlaceId].Name
    end
    return false, "Game Not Supported"
end

function MainMenuLogic:VerifyKey(InputKey)
    if InputKey == self.ValidKey then
        return true, "Key Valid!"
    else
        return false, "Invalid Key!"
    end
end

-- ==========================================
-- LOGIC BUKA DISCORD & COPY LINK
-- ==========================================
function MainMenuLogic:OpenDiscord()
    local statusPesan = "Copied to Clipboard!"
    
    if setclipboard then
        setclipboard(self.DiscordLink)
    end
    
    local reqFunc = request or (syn and syn.request) or http_request
    if reqFunc then
        local success = pcall(function()
            reqFunc({
                Url = self.DiscordLink,
                Method = "GET"
            })
        end)
        if success then
            statusPesan = "Opening Discord..."
        end
    end
    
    return statusPesan
end

return MainMenuLogic
