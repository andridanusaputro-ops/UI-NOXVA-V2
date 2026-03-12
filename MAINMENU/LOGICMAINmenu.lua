-- ==========================================
-- NOXVA HUB - LOGIC MAIN MENU (KEY SYSTEM)
-- DEVELOPED BY DANZY
-- ==========================================
local MainMenuLogic = {}

-- [ SETTINGAN KEY & DISCORD LU DI SINI ]
MainMenuLogic.ValidKey = "DANZY" 
MainMenuLogic.DiscordLink = "https://discord.gg/noxvahub" 

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

