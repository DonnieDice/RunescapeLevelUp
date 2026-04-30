--=====================================================================================
-- RSLU | RunescapeLevelUp - core.lua
-- Version: 3.0.0
-- Author: DonnieDice
-- RGX Mods Collection - RealmGX Community Project
--=====================================================================================

local RGX = assert(_G.RGXFramework, "RSLU: RGX-Framework not loaded")

RSLU = RSLU or {}

local ADDON_VERSION = "3.0.0"
local ADDON_NAME = "RunescapeLevelUp"
local ICON_PATH = "|Tinterface/addons/RunescapeLevelUp/media/icon:16:16|t"
local PREFIX = ICON_PATH .. " |cff767778RSLU:|r"
local TITLE = "[|cff767778R|r|cffffffffunescape|r |cff767778L|r|cffffffffevel-|r|cff767778U|r|cffffffffp|r|cff767778!|r]"

RSLU.version = ADDON_VERSION
RSLU.addonName = ADDON_NAME

local Sound = RGX:GetSound()

local handle = Sound:Register(ADDON_NAME, {
sounds = {
high = "Interface\\Addons\\RunescapeLevelUp\\sounds\\old_school_runescape_high.ogg",
medium = "Interface\\Addons\\RunescapeLevelUp\\sounds\\old_school_runescape_med.ogg",
low = "Interface\\Addons\\RunescapeLevelUp\\sounds\\old_school_runescape_low.ogg",
},
defaultSoundId = 569593,
savedVar = "RSLUSettings",
defaults = {
enabled = true,
soundVariant = "medium",
muteDefault = true,
showWelcome = true,
volume = "Master",
firstRun = true,
},
triggerEvent = "PLAYER_LEVEL_UP",
addonVersion = ADDON_VERSION,
})

RSLU.handle = handle

local L = RSLU.L or {}
local initialized = false

local function ShowHelp()
print(PREFIX .. " " .. (L["HELP_HEADER"] or ""))
print(PREFIX .. " " .. (L["HELP_TEST"] or ""))
print(PREFIX .. " " .. (L["HELP_ENABLE"] or ""))
print(PREFIX .. " " .. (L["HELP_DISABLE"] or ""))
print(PREFIX .. " |cffffffff/rslu high|r - Use high quality sound")
print(PREFIX .. " |cffffffff/rslu med|r - Use medium quality sound")
print(PREFIX .. " |cffffffff/rslu low|r - Use low quality sound")
end

local function HandleSlashCommand(args)
local command = string.lower(args or "")
if command == "" or command == "help" then
ShowHelp()
elseif command == "test" then
print(PREFIX .. " " .. (L["PLAYING_TEST"] or ""))
handle:Test()
elseif command == "enable" then
handle:Enable()
print(PREFIX .. " " .. (L["ADDON_ENABLED"] or ""))
elseif command == "disable" then
handle:Disable()
print(PREFIX .. " " .. (L["ADDON_DISABLED"] or ""))
elseif command == "high" then
handle:SetVariant("high")
print(PREFIX .. " " .. string.format(L["SOUND_VARIANT_SET"] or "%s", "high"))
elseif command == "med" or command == "medium" then
handle:SetVariant("medium")
print(PREFIX .. " " .. string.format(L["SOUND_VARIANT_SET"] or "%s", "medium"))
elseif command == "low" then
handle:SetVariant("low")
print(PREFIX .. " " .. string.format(L["SOUND_VARIANT_SET"] or "%s", "low"))
else
print(PREFIX .. " " .. (L["ERROR_PREFIX"] or "") .. " " .. (L["ERROR_UNKNOWN_COMMAND"] or ""))
end
end

RGX:RegisterEvent("ADDON_LOADED", function(event, addonName)
if addonName ~= ADDON_NAME then return end
handle:SetLocale(RSLU.L)
L = RSLU.L or {}
handle:Init()
initialized = true
end, "RSLU_ADDON_LOADED")

RGX:RegisterEvent("PLAYER_LEVEL_UP", function()
if initialized then
handle:Play()
end
end, "RSLU_PLAYER_LEVEL_UP")

RGX:RegisterEvent("PLAYER_LOGIN", function()
if not initialized then
handle:SetLocale(RSLU.L)
L = RSLU.L or {}
handle:Init()
initialized = true
end
handle:ShowWelcome(PREFIX, TITLE)
end, "RSLU_PLAYER_LOGIN")

RGX:RegisterEvent("PLAYER_LOGOUT", function()
handle:Logout()
end, "RSLU_PLAYER_LOGOUT")

RGX:RegisterSlashCommand("rslu", function(msg)
local ok, err = pcall(HandleSlashCommand, msg)
if not ok then
print(PREFIX .. " |cffff0000RSLU Error:|r " .. tostring(err))
end
end, "RSLU_SLASH")
