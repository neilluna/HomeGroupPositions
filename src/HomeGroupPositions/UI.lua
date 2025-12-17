HomeGroupPositions.UI = {
    name = 'HomeGroupPositionsWindow',

    window = nil,  -- Top-level window.
    updateUIInterval = 250,  -- How often to update the UI (milliseconds).

    maxRows = 12,  -- Maximum number of rows to display. Matches the maxiimum group size.
    rows = nil,  -- Table to hold the row controls.
}


function HomeGroupPositions.UI:FormatLabel(label)
    return string.format('%-40s', label)
end

function HomeGroupPositions.UI:FormatCoordinate(coordinate)
    return string.format('%-8.1f', coordinate)
end

function HomeGroupPositions.UI:CreateHeader(window)
    local headers = self.window:GetNamedChild("Headers")

    local characterAccountLabel = headers:GetNamedChild("CharacterAccountLabel")
    characterAccountLabel:SetText(GetString(HOME_GROUP_POSITIONS_CHARACTER_ACCOUNT_LABEL))

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

        local characterAccountLabel = row:GetNamedChild("CharacterAccountLabel")
        characterAccountLabel:SetText('Paraselene Alqwi (@Paraselene-Alqwi)')

        local xLabel = row:GetNamedChild("XLabel")
        xLabel:SetText('123456789')

        local yLabel = row:GetNamedChild("YLabel")
        yLabel:SetText('123456789')

        local zLabel = row:GetNamedChild("ZLabel")
        zLabel:SetText('123456789')

        local headingLabel = row:GetNamedChild("HeadingLabel")
        headingLabel:SetText('123456789')
    end
end

function HomeGroupPositions.UI:Create()
    self.window = HomeGroupPositionsWindow

    self:CreateHeader(self.window)
    self:CreateList(self.window)

    self.window:SetHidden(true)
end

function HomeGroupPositions.UI:Show()
    self.window:SetHidden(false)
end

function HomeGroupPositions.UI:Hide()
    self.window:SetHidden(true)
end

function HomeGroupPositions.UI:Update()
    if self.window:IsHidden() then return end

    local inHouse = (GetCurrentZoneHouseId() or 0) > 0
    if not inHouse then
        self:Hide()
        return
    end

    local myInfo = HomeGroupPositions:GetMyInfo()
    local groupMembers = {}
    table.insert(
        groupMembers,
        {
            player = myInfo.player,
            character = myInfo.character,
            x = myInfo.x,
            y = myInfo.y,
            z = myInfo.z,
            heading = myInfo.heading,
        }
    )

    for i = 1, self.maxRows do
        local member = groupMembers[i]
        if member then
            local label = string.format('%s (%s)', member.character, member.player)
            local t = string.format('%-100s%-8d%-8d%-8d', label, member.x, member.y, member.z)
            self.rows[i]:SetText(t)
        else
            self.rows[i]:SetText(i)
        end
    end

    zo_callLater(function() self:Update() end, self.updateUIInterval)
end
