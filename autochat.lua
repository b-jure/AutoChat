local _, addon = ...

addon.AC_Interval = 0
addon.AC_TimeSinceLastUpdate = 0

-- Print text (debug)
function addon:AC_Print(text)
    local prefix = "AutoChat"
    DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: %s", prefix, text))
end

-- Send Chat Message
function addon:AC_SendMessage()
    local id = tonumber(self:AC_GetEditBoxText("ChannelEditBox"), 10)
    if id == nil then
        self:AC_Print("Invalid or missing 'ID")
        self:AC_Stop()
        return
    end
    addon.AC_ID = math.abs(id)
    local message = _G["ACScrollFrame"].EditBox:GetText()
    if (message == "" or message == nil) then
        self:AC_Print("Invalid or missing 'message'")
        self:AC_Stop()
        return
    end
    SendChatMessage(message, "CHANNEL", "COMMON", tostring(addon.AC_ID))
end

-- Frame OnUpdate handler
function addon:AC_OnUpdate(elapsed)
    if self.AC_Interval > 0 then -- run only when AutoChat is started
        self.AC_TimeSinceLastUpdate = self.AC_TimeSinceLastUpdate + elapsed
        if self.AC_TimeSinceLastUpdate > self.AC_Interval then
            self:AC_SendMessage()
            self.AC_TimeSinceLastUpdate = 0
        end
    end
end

-- Stop AutoChat
function addon:AC_Stop()
    self.AC_Interval = 0
    self.AC_TimeSinceLastUpdate = 0
    self.AC_ID = 0
end

-- Start AutoChat
function addon:AC_Start()
    if self.AC_Interval > 0 then return end -- if already started just return
    local interval = tonumber(self:AC_GetEditBoxText("IntervalEditBox")) or 0
    if interval == nil or interval == 0 then
        self:AC_Print("Invalid 'Interval'")
        self:AC_Stop()
        return
    end
    self.AC_Interval = math.abs(interval) -- set positive non-zero interval (1-999)
    self:AC_SendMessage() -- send initial message
end
