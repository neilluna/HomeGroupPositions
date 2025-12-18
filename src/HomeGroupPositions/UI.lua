HomeGroupPositions.UI = {
    name = 'HomeGroupPositionsWindow',

    window = nil,  -- Top-level window.
    updateUIInterval = 125,  -- How often to update the UI (milliseconds).

    maxRows = 12,  -- Maximum number of rows to display. Matches the maxiimum group size.
    rows = {},  -- Table of row controls.
}

function HomeGroupPositions.UI:CreateHeader(window)
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

function HomeGroupPositions.UI:CreateList(window)
    local list = window:GetNamedChild("List")
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

function HomeGroupPositions.UI:Create()
    self.window = HomeGroupPositionsWindow

    self:CreateHeader(self.window)
    self:CreateList(self.window)

    self.window.OnCloseClicked = function(control, button, upInside) self:Hide() end

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
            headingLabel:SetText(string.format('%-3.2f', member.heading))
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
    self:Update()
    self.window:SetHidden(false)
end

function HomeGroupPositions.UI:Hide()
    self.window:SetHidden(true)
end

function HomeGroupPositions.UI:ToggleShowHide()
    if self.window:IsHidden() then
        self:Show()
    else
        self:Hide()
    end
end

function HomeGroupPositions.UI:ScheduleUpdate()
    if not self.window:IsHidden() then self:Update() end
    zo_callLater(function() self:ScheduleUpdate() end, self.updateUIInterval)
end
