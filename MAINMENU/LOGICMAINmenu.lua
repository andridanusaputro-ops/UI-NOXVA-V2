-- ==========================================
-- NOXVA HUB - LOGIC MAIN MENU (KEY SYSTEM)
-- DEVELOPED BY DANZY
-- ==========================================
local MainMenuLogic = {}

-- [ SETTINGAN KEY & DISCORD ]
MainMenuLogic.ValidKey = "DANZY" 
MainMenuLogic.DiscordLink = "https://discord.gg/noxvahub" 

-- [ DATABASE GAME YANG DI-SUPPORT ]
MainMenuLogic.SupportedGames = {
    [81008840993724] = "Fisch / Realpse", -- Ganti sama ID game Fisch lu
    [2753915549] = "Blox Fruits", -- Contoh game lain
    -- Tinggal tambahin ID game lain ke depannya di sini
}

-- Fungsi cek support game
function MainMenuLogic:CheckSupport(PlaceId)
    if self.SupportedGames[PlaceId] then
        return true, self.SupportedGames[PlaceId]
    end
    return false, "Game Not Supported"
end

function MainMenuLogic:VerifyKey(InputKey)
    if InputKey == self.ValidKey then
        return true, "Key Valid! Authenticating..."
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
