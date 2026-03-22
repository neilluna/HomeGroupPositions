HomeGroupPositions.UI = {
    name = 'HomeGroupPositionsWindow',

    window = nil,  -- Top-level window.
    updateUIInterval = 125,  -- How often to update the UI (milliseconds).

    maxRows = 12,  -- Maximum number of rows to display. Matches the maxiimum group size.
    rows = {},  -- Table of row controls.

    -- Keep this in sync with the hidden attribute of the TopLevelControl "HomeGroupPositionsWindow" in UI.xml.
    isVisible = false,  -- Is the window visible?
}

function HomeGroupPositions.UI:CreateHeader()
    local headers = self.window:GetNamedChild("Headers")

    local playerLabel = headers:GetNamedChild("PlayerLabel")
    playerLabel:SetText(GetString(HOME_GROUP_POSITIONS_PLAYER_LABEL))

    local xLabel = headers:GetNamedChild("XLabel")
    xLabel:SetText(GetString(HOME_GROUP_POSITIONS_X_LABEL))

    local yLabel = headers:GetNamedChild("YLabel")
    yLabel:SetText(GetString(HOME_GROUP_POSITIONS_Y_LABEL))

    local zLabel = headers:GetNamedChild("ZLabel")
    zLabel:SetText(GetString(HOME_GROUP_POSITIONS_Z_LABEL))

    local headingLabel = headers:GetNamedChild("HeadingLabel")
    headingLabel:SetText(GetString(HOME_GROUP_POSITIONS_HEADING_LABEL))
end

function HomeGroupPositions.UI:CreateList()
    local list = self.window:GetNamedChild("List")
    for index = 1, self.maxRows do
        local rowName = 'HomeGroupPositionsListRow' .. index
        local row = WINDOW_MANAGER:CreateControlFromVirtual(rowName, list, 'HomeGroupPositionsListRowTemplate')
        row:SetAnchor(TOPLEFT, list, TOPLEFT, 0, (index - 1) * 30)

        row:GetNamedChild("PlayerLabel"):SetText('')
        row:GetNamedChild("XLabel"):SetText('')
        row:GetNamedChild("YLabel"):SetText('')
        row:GetNamedChild("ZLabel"):SetText('')
        row:GetNamedChild("HeadingLabel"):SetText('')

        self.rows[index] = row
    end
end

function HomeGroupPositions.UI:SaveWindowPosition()
    HomeGroupPositions.Settings.serverSpecific.windowX = self.window:GetLeft()
    HomeGroupPositions.Settings.serverSpecific.windowY = self.window:GetTop()
end

function HomeGroupPositions.UI:Create()
    self.window = HomeGroupPositionsWindow

    local windowX = HomeGroupPositions.Settings.serverSpecific.windowX
    local windowY = HomeGroupPositions.Settings.serverSpecific.windowY

    if windowX and windowY then
        self.window:ClearAnchors()
        self.window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, windowX, windowY)
    end
    self:SaveWindowPosition()

    self:CreateHeader()
    self:CreateList()

    self.window.OnMoveStop = function() self:SaveWindowPosition() end
    self.window.OnCloseClicked = function(control, button, upInside) self:Hide() end

    -- Keep these in sync with the hidden attribute of the TopLevelControl "HomeGroupPositionsWindow" in UI.xml.
    self.isVisible = false
    self.window:SetHidden(true)
end

function HomeGroupPositions.UI:Update()
    local groupMembers = HomeGroupPositions:GetGroupMembers()
    for index = 1, self.maxRows do
        local row = self.rows[index]

        local playerLabel = row:GetNamedChild("PlayerLabel")
        local xLabel = row:GetNamedChild("XLabel")
        local yLabel = row:GetNamedChild("YLabel")
        local zLabel = row:GetNamedChild("ZLabel")
        local headingLabel = row:GetNamedChild("HeadingLabel")

        local member = groupMembers[index]
        if member then
            playerLabel:SetText(member.player)
            xLabel:SetText(string.format('%-7.0f', member.x))
            yLabel:SetText(string.format('%-7.0f', member.y))
            zLabel:SetText(string.format('%-7.0f', member.z))
            headingLabel:SetText(string.format('%-1.4f', member.heading))
        else
            playerLabel:SetText('')
            xLabel:SetText('')
            yLabel:SetText('')
            zLabel:SetText('')
            headingLabel:SetText('')
        end
    end
end

function HomeGroupPositions.UI:Show()
    self.isVisible = true
    if HomeGroupPositions:IsGroupedAndInHouse() then
        self:Update()
        self.window:SetHidden(false)
    else
        -- Leave the visibility flag set, but hide the window.
        self.window:SetHidden(true)
    end
end

function HomeGroupPositions.UI:Hide()
    self.isVisible = false
    self.window:SetHidden(true)
end

function HomeGroupPositions.UI:ToggleShowHide()
    if self.isVisible then self:Hide() else self:Show() end
end

function HomeGroupPositions.UI:ScheduleUpdate()
    if HomeGroupPositions:IsGroupedAndInHouse() then
        if self.isVisible then self:Update() end
        self.window:SetHidden(not self.isVisible)  -- Sync the window to the visibility flag.
    else
        -- Leave the visibility flag as is, but hide the window.
        self.window:SetHidden(true)
    end

    zo_callLater(function() self:ScheduleUpdate() end, self.updateUIInterval)
end
