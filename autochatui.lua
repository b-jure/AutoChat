local _, addon = ...

local function widgetname(name) return (addon.Name .. name) end

function addon:AC_CreateUI()
    -- Main Frame [https://www.townlong-yak.com/framexml/5.4.8/UIPanelTemplates.xml#2294]
    local MainFrame = self.MainFrame
    MainFrame = CreateFrame("Frame", widgetname("MainFrame"), UIParent, "BasicFrameTemplate")
    MainFrame:SetPoint("CENTER", UIParent, "CENTER")
    MainFrame:SetSize(300, 300)
    MainFrame:SetClampedToScreen(true)
    MainFrame:EnableMouse(true)
    MainFrame:SetMovable(true)
    MainFrame:RegisterForDrag("LeftButton")
    MainFrame:SetScript("OnDragStart", function(s) s:StartMoving() end)
    MainFrame:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
    local Title = MainFrame.TitleText
    Title:SetText("AutoChat")
    Title:ClearAllPoints()
    Title:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 5, -5)

    -- Start button [https://www.townlong-yak.com/framexml/5.4.8/SharedUIPanelTemplates.xml#301]
    local StartButton = MainFrame.StartButton
    StartButton = CreateFrame("Button", widgetname("StartButton"), MainFrame, "UIPanelButtonTemplate")
    StartButton:SetPoint("BOTTOM", MainFrame, "BOTTOM", 0, 5)
    StartButton:SetPoint("LEFT", MainFrame, "LEFT", 5, 0)
    StartButton:SetSize(60, 25)
    StartButton:SetText("Start")
    StartButton:SetScript("OnClick", function(_, _, down) if not down then addon:AC_Start() end end)

    -- Stop button [https://www.townlong-yak.com/framexml/5.4.8/SharedUIPanelTemplates.xml#301]
    local StopButton = MainFrame.StopButton
    StopButton = CreateFrame("Button", widgetname("StopButton"), MainFrame, "UIPanelButtonTemplate")
    StopButton:SetPoint("BOTTOM", MainFrame, "BOTTOM", 0, 5)
    StopButton:SetPoint("LEFT", StartButton, "RIGHT", 5, 0)
    StopButton:SetSize(60, 25)
    StopButton:SetText("Stop")
    StopButton:SetScript("OnClick", function(_, _, down) if not down then addon:AC_Stop() end end)

    -- Scroll frame with text area [https://www.townlong-yak.com/framexml/5.4.8/UIPanelTemplates.xml#3254]
    local ScrollFrame = MainFrame.ScrollFrame
    ScrollFrame = CreateFrame("ScrollFrame", widgetname("ScrollFrame"), MainFrame, "InputScrollFrameTemplate")
    ScrollFrame:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 6, -26)
    ScrollFrame:SetPoint("TOPRIGHT", MainFrame, "TOPRIGHT", -9, -26)
    ScrollFrame:SetPoint("BOTTOM", StopButton, "TOP", 0, 5)
    ScrollFrame:SetMovable(false)
    local EditBox = ScrollFrame.EditBox
    EditBox:EnableMouse(true)
    EditBox:SetAutoFocus(false)
    EditBox:SetMaxLetters(255)
    EditBox:SetFont("Fonts\\ARIALN.TTF", 15)

    -- Channel Number text
    local ChannelNumberText = MainFrame:CreateFontString(nil, "ARTWORK", "GameTooltipText")
    ChannelNumberText:SetPoint("TOP", ScrollFrame, "BOTTOM", 0, -13)
    ChannelNumberText:SetPoint("LEFT", StopButton, "RIGHT", 10, 0)
    ChannelNumberText:SetText("ID:")
    MainFrame.ChannelNumberText = ChannelNumberText
    -- Channel Number edit box [https://www.townlong-yak.com/framexml/5.4.8/UIPanelTemplates.xml#645]
    local ChannelEditBox = MainFrame.ChannelEditBox
    ChannelEditBox = CreateFrame("EditBox", widgetname("ChannelEditBox"), MainFrame, "InputBoxTemplate")
    ChannelEditBox:SetPoint("TOP", ScrollFrame, "BOTTOM", 0, -5)
    ChannelEditBox:SetPoint("LEFT", ChannelNumberText, "RIGHT", 10, 0)
    ChannelEditBox:SetAutoFocus(false)
    ChannelEditBox:SetWidth(20)
    ChannelEditBox:SetMaxLetters(2)

    -- Interval text
    local IntervalText = MainFrame:CreateFontString(nil, "ARTWORK", "GameTooltipText")
    IntervalText:SetPoint("TOP", ScrollFrame, "BOTTOM", 0, -13)
    IntervalText:SetPoint("LEFT", ChannelEditBox, "RIGHT", 10, 0)
    IntervalText:SetText("Interval:")
    MainFrame.IntervalText = IntervalText
    -- Interval text edit box
    local IntervalEditBox = MainFrame.IntervalEditBox
    IntervalEditBox = CreateFrame("EditBox", widgetname("IntervalEditBox"), MainFrame, "InputBoxTemplate")
    IntervalEditBox:SetPoint("TOP", ScrollFrame, "BOTTOM", 0, -5)
    IntervalEditBox:SetPoint("LEFT", IntervalText, "RIGHT", 10, 0)
    IntervalEditBox:SetAutoFocus(false)
    IntervalEditBox:SetWidth(30)
    IntervalEditBox:SetMaxLetters(3)

    return MainFrame
end

-- Get the text from generic 'EditBox'
-- @EditBoxName: string
function addon:AC_GetEditBoxText(EditBoxName) return _G[widgetname(EditBoxName)]:GetText() end
