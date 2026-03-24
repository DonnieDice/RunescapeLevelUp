RSLU = RSLU or {}

local ADDON_VERSION = "2.0.0"
local ADDON_NAME = "RunescapeLevelUp"
local TITLE = "[|cff767778R|r|cffffffffunescape |r|cff767778L|r|cffffffffevel-|r|cff767778U|r|cffffffffp|r|cff767778!|r]"
local SOUND_PATHS = {
    high = "Interface\\Addons\\RunescapeLevelUp\\sounds\\old_school_runescape_high.ogg",
    medium = "Interface\\Addons\\RunescapeLevelUp\\sounds\\old_school_runescape_med.ogg",
    low = "Interface\\Addons\\RunescapeLevelUp\\sounds\\old_school_runescape_low.ogg"
}
local DEFAULT_SOUND_ID = 569593
local PREFIX = "|cff767778RSLU|r"

RSLU.defaults = {
    enabled = true,
    soundVariant = "medium",
    muteDefault = true,
    showWelcome = true,
    volume = "Master",
    firstRun = true
}

function RSLU:InitializeSettings()
    RSLUSettings = RSLUSettings or {}
    for key, value in pairs(self.defaults) do
        if RSLUSettings[key] == nil then
            RSLUSettings[key] = value
        end
    end
end

function RSLU:GetSetting(key)
    if not RSLUSettings then
        return self.defaults[key]
    end
    local value = RSLUSettings[key]
    if value ~= nil then
        return value
    end
    return self.defaults[key]
end

function RSLU:SetSetting(key, value)
    RSLUSettings = RSLUSettings or {}
    RSLUSettings[key] = value
end

function RSLU:PlayCustomLevelUpSound()
    if not self:GetSetting("enabled") then
        return
    end
    local soundPath = SOUND_PATHS[self:GetSetting("soundVariant") or "medium"]
    if soundPath then
        PlaySoundFile(soundPath, self:GetSetting("volume") or "Master")
    end
end

function RSLU:MuteDefaultLevelUpSound()
    if self:GetSetting("enabled") and self:GetSetting("muteDefault") then
        MuteSoundFile(DEFAULT_SOUND_ID)
    end
end

function RSLU:UnmuteDefaultLevelUpSound()
    UnmuteSoundFile(DEFAULT_SOUND_ID)
end

function RSLU:DisplayWelcomeMessage()
    if not self:GetSetting("showWelcome") then
        return
    end
    local version = "|cff8080ff(v" .. ADDON_VERSION .. ")|r"
    local status = self:GetSetting("enabled") and self.L["ENABLED_STATUS"] or self.L["DISABLED_STATUS"]
    print(PREFIX .. " - " .. TITLE .. " " .. status .. " " .. version)
    if self:GetSetting("firstRun") then
        print(PREFIX .. " " .. self.L["COMMUNITY_MESSAGE"])
        self:SetSetting("firstRun", false)
    end
    print(PREFIX .. " " .. self.L["TYPE_HELP"])
end

function RSLU:ShowHelp()
    print(PREFIX .. " " .. self.L["HELP_HEADER"])
    print(PREFIX .. " " .. self.L["HELP_TEST"])
    print(PREFIX .. " " .. self.L["HELP_ENABLE"])
    print(PREFIX .. " " .. self.L["HELP_DISABLE"])
    print(PREFIX .. " " .. self.L["HELP_WELCOME"])
    print(PREFIX .. " |cffffffff/rslu high|r - Use high quality sound")
    print(PREFIX .. " |cffffffff/rslu med|r - Use medium quality sound")
    print(PREFIX .. " |cffffffff/rslu low|r - Use low quality sound")
end

function RSLU:HandleSlashCommand(args)
    local command = string.lower(args or "")
    if command == "" or command == "help" then
        self:ShowHelp()
    elseif command == "test" then
        print(PREFIX .. ": " .. self.L["PLAYING_TEST"])
        self:PlayCustomLevelUpSound()
    elseif command == "enable" then
        self:SetSetting("enabled", true)
        self:MuteDefaultLevelUpSound()
        print(PREFIX .. ": " .. self.L["ADDON_ENABLED"])
    elseif command == "disable" then
        self:SetSetting("enabled", false)
        self:UnmuteDefaultLevelUpSound()
        print(PREFIX .. ": " .. self.L["ADDON_DISABLED"])
    elseif command == "welcome" then
        local newValue = not self:GetSetting("showWelcome")
        self:SetSetting("showWelcome", newValue)
        print(PREFIX .. ": " .. (newValue and self.L["WELCOME_TOGGLE_ON"] or self.L["WELCOME_TOGGLE_OFF"]))
    elseif command == "high" then
        self:SetSetting("soundVariant", "high")
        print(PREFIX .. ": " .. string.format(self.L["SOUND_VARIANT_SET"], "high"))
    elseif command == "med" or command == "medium" then
        self:SetSetting("soundVariant", "medium")
        print(PREFIX .. ": " .. string.format(self.L["SOUND_VARIANT_SET"], "medium"))
    elseif command == "low" then
        self:SetSetting("soundVariant", "low")
        print(PREFIX .. ": " .. string.format(self.L["SOUND_VARIANT_SET"], "low"))
    else
        print(PREFIX .. " " .. self.L["ERROR_PREFIX"] .. " " .. self.L["ERROR_UNKNOWN_COMMAND"])
    end
end

SLASH_RSLU1 = "/rslu"
SlashCmdList["RSLU"] = function(args)
    RSLU:HandleSlashCommand(args)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_LEVEL_UP" then
        RSLU:PlayCustomLevelUpSound()
    elseif event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == ADDON_NAME then
            RSLU:InitializeSettings()
            RSLU:MuteDefaultLevelUpSound()
        end
    elseif event == "PLAYER_LOGIN" then
        RSLU:DisplayWelcomeMessage()
    elseif event == "PLAYER_LOGOUT" then
        RSLU:UnmuteDefaultLevelUpSound()
    end
end)
