HomeGroupPositions.UI = {
    name = 'HomeGroupPositionsWindow',

    -- Convenience abbreviations.
    api = HomeGroupPositions.API,

    window = nil,  -- Top-level window.
    updateUIInterval = 125,  -- How often to update the UI (milliseconds).

    maxRows = 12,  -- Maximum number of rows to display. Matches the maxiimum group size.
    rows = {},  -- Table of row controls.

    -- Keep this in sync with the hidden attribute of the TopLevelControl "HomeGroupPositionsWindow" in UI.xml.
    isVisible = false,  -- Is the window visible?
}

function HomeGroupPositions.UI:CreateHeader()
    local headers = self.api.GetNamedChild(self.window, "Headers")

    local playerLabel =  self.api.GetNamedChild(headers, "PlayerLabel")
    self.api.SetText(playerLabel, self.api.GetString(HOME_GROUP_POSITIONS_PLAYER_LABEL))

    local xLabel = self.api.GetNamedChild(headers, "XLabel")
    self.api.SetText(xLabel, self.api.GetString(HOME_GROUP_POSITIONS_X_LABEL))

    local yLabel = self.api.GetNamedChild(headers, "YLabel")
    self.api.SetText(yLabel, self.api.GetString(HOME_GROUP_POSITIONS_Y_LABEL))

    local zLabel = self.api.GetNamedChild(headers, "ZLabel")
    self.api.SetText(zLabel, self.api.GetString(HOME_GROUP_POSITIONS_Z_LABEL))

    local headingLabel = self.api.GetNamedChild(headers, "HeadingLabel")
    self.api.SetText(headingLabel, self.api.GetString(HOME_GROUP_POSITIONS_HEADING_LABEL))
end

function HomeGroupPositions.UI:CreateList()
    local list = self.api.GetNamedChild(self.window, "List")
    for index = 1, self.maxRows do
        local rowName = 'HomeGroupPositionsListRow' .. index
        local row = self.api.CreateControlFromVirtual(rowName, list, 'HomeGroupPositionsListRowTemplate')
        self.api.SetAnchor(row, TOPLEFT, list, TOPLEFT, 0, (index - 1) * 30)

        self.api.SetText(self.api.GetNamedChild(row, "PlayerLabel"), '')
        self.api.SetText(self.api.GetNamedChild(row, "XLabel"), '')
        self.api.SetText(self.api.GetNamedChild(row, "YLabel"), '')
        self.api.SetText(self.api.GetNamedChild(row, "ZLabel"), '')
        self.api.SetText(self.api.GetNamedChild(row, "HeadingLabel"), '')

        self.rows[index] = row
    end
end

function HomeGroupPositions.UI:SaveWindowPosition()
    HomeGroupPositions.Settings.serverSpecific.windowX = self.api.GetLeft(self.window)
    HomeGroupPositions.Settings.serverSpecific.windowY = self.api.GetTop(self.window)
end

function HomeGroupPositions.UI:Create()
    self.window = HomeGroupPositionsWindow

    local windowX = HomeGroupPositions.Settings.serverSpecific.windowX
    local windowY = HomeGroupPositions.Settings.serverSpecific.windowY

    if windowX and windowY then
        self.api.ClearAnchors(self.window)
        self.api.SetAnchor(self.window, TOPLEFT, GuiRoot, TOPLEFT, windowX, windowY)
    end
    self:SaveWindowPosition()

    self:CreateHeader()
    self:CreateList()

    self.api.OnMoveStop(self.window, function() self:SaveWindowPosition() end)
    self.api.OnCloseClicked(self.window, function(control, button, upInside) self:Hide() end)

    -- Keep these in sync with the hidden attribute of the TopLevelControl "HomeGroupPositionsWindow" in UI.xml.
    self.isVisible = false
    self.api.SetHidden(self.window, true)
end

function HomeGroupPositions.UI:Update()
    local groupMembers = HomeGroupPositions:GetGroupMembers()
    for index = 1, self.maxRows do
        local row = self.rows[index]

        local playerLabel = self.api.GetNamedChild(row, "PlayerLabel")
        local xLabel = self.api.GetNamedChild(row, "XLabel")
        local yLabel = self.api.GetNamedChild(row, "YLabel")
        local zLabel = self.api.GetNamedChild(row, "ZLabel")
        local headingLabel = self.api.GetNamedChild(row, "HeadingLabel")

        local member = groupMembers[index]
        if member then
            self.api.SetText(playerLabel, member.player)
            self.api.SetText(xLabel, string.format('%-7.0f', member.x))
            self.api.SetText(yLabel, string.format('%-7.0f', member.y))
            self.api.SetText(zLabel, string.format('%-7.0f', member.z))
            self.api.SetText(headingLabel, string.format('%-3.2f', member.heading))
        else
            self.api.SetText(playerLabel, '')
            self.api.SetText(xLabel, '')
            self.api.SetText(yLabel, '')
            self.api.SetText(zLabel, '')
            self.api.SetText(headingLabel, '')
        end
    end
end

function HomeGroupPositions.UI:Show()
    self.isVisible = true
    if HomeGroupPositions:IsGroupedAndInHouse() then
        self:Update()
        self.api.SetHidden(self.window, false)
    else
        -- Leave the visibility flag set, but hide the window.
        self.api.SetHidden(self.window, true)
    end
end

function HomeGroupPositions.UI:Hide()
    self.isVisible = false
    self.api.SetHidden(self.window, true)
end

function HomeGroupPositions.UI:ToggleShowHide()
    if self.isVisible then self:Hide() else self:Show() end
end

function HomeGroupPositions.UI:ScheduleUpdate()
    if HomeGroupPositions:IsGroupedAndInHouse() then
        if self.isVisible then self:Update() end
        self.api.SetHidden(self.window, not self.isVisible)  -- Sync the window to the visibility flag.
    else
        -- Leave the visibility flag as is, but hide the window.
        self.api.SetHidden(self.window, true)
    end

    self.api.CallLater(function() self:ScheduleUpdate() end, self.updateUIInterval)
end
