-- ==========================================
-- NOXVA HUB - LOGIC MAIN MENU (KEY SYSTEM)
-- DEVELOPED BY DANZY
-- ==========================================
local MainMenuLogic = {}

-- [ SETTINGAN KEY & DISCORD LU DI SINI ]
MainMenuLogic.ValidKey = "DANZY" 
MainMenuLogic.DiscordLink = "https://discord.gg/VbumttfB2"

-- [ DATABASE GAME YANG DI-SUPPORT ]
MainMenuLogic.SupportedGames = {
    [81008840993724] = "Realpse Kesepian",
}

function MainMenuLogic:CheckSupport(PlaceId)
    if self.SupportedGames[PlaceId] then
        return true, self.SupportedGames[PlaceId]
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
    
    -- 1. Copy ke clipboard buat jaga-jaga
    if setclipboard then
        setclipboard(self.DiscordLink)
    end
    
    -- 2. Coba paksa buka browser otomatis
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
