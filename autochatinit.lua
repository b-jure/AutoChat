local _, addon = ...

-- Slash commands
addon.AC_Commands = {
    help = function()
        addon:AC_Print("/ac [help] - display help (this)")
        addon:AC_Print("/ac open  - open AutoChat UI")
        addon:AC_Print("/ac close  - close AutoChat UI")
        addon:AC_Print("/ac toggle  - toggle AutoChat UI")
        addon:AC_Print("/ac start   - start AutoChat")
        addon:AC_Print("/ac stop  - stop AutoChat")
        addon:AC_Print("/ac isrun  - print wheter AutoChat is running")
    end,
    open = function() addon.MainFrame:Show() end,
    close = function() addon.MainFrame:Hide() end,
    toggle = function()
        local MainFrame = addon.MainFrame
        if MainFrame:IsShown() then
            MainFrame:Hide()
        else
            MainFrame:Show()
        end
    end,
    start = function() addon:AC_Start() end,
    stop = function() addon:AC_Stop() end,
    isrun = function()
        if addon.AC_Interval == 0 then -- not running ?
            addon:AC_Print("AutoChat is stopped.")
        else -- running
            addon:AC_Print(string.format("AutoChat is running with parameters: interval: %d, ID: %d.", addon.AC_Interval,
                                         addon.AC_ID))
        end
    end
}

-- Slash Commands handler
local function SlashCommand(str)
    if #str == 0 then
        addon.AC_Commands.help()
        return
    end
    local args = {}
    local regx = "[^%s]+"
    for token in string.gmatch(str, regx) do table.insert(args, token) end
    local location = addon.AC_Commands
    for i, arg in ipairs(args) do
        arg = string.lower(arg)
        if type(location[arg]) == "function" then -- arg holds executable function
            location[arg](unpack(args, i + 1)) -- function args are the rest of the tokens
        elseif type(location[arg]) == "table" then -- arg holds table
            location = location[arg] -- set new location to that table
        else -- commands[arg] is of invalid type (most probably nil)
            addon:AC_Print("unkown command")
            addon.AC_Commands.help()
            return
        end
    end
end

-- Enables slash commands
local function EnableSlashCommands()
    SLASH_AutoChat1 = "/ac"
    SLASH_AutoChat2 = "/autochat"
    SlashCmdList.AutoChat = SlashCommand
end

function addon:AC_Init()
    self.Name = "AC"
    self.MainFrame = self.MainFrame or self:AC_CreateUI() -- generate UI
    self.MainFrame:Show()
    self.MainFrame:HookScript("OnUpdate", function(_, elapsed) addon:AC_OnUpdate(elapsed) end)
    EnableSlashCommands()
end

addon:AC_Init()
