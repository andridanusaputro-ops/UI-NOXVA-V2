-- ==========================================
-- NOXVA HUB - LOGIC MAIN MENU (KEY SYSTEM)
-- DEVELOPED BY DANZY
-- ==========================================
local MainMenuLogic = {}

-- [ SETTINGAN KEY & DISCORD LU DI SINI ]
MainMenuLogic.ValidKey = "DANZY" 
MainMenuLogic.DiscordLink = "https://discord.gg/VbumttfB2" -- LINK DC LU

-- [ DATABASE GAME YANG DI-SUPPORT ]
MainMenuLogic.SupportedGames = {
    [81008840993724] = "Realpse kesepian",
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

function MainMenuLogic:CopyDiscordLink()
    if setclipboard then
        setclipboard(self.DiscordLink)
        return true
    end
    return false
end

return MainMenuLogic
