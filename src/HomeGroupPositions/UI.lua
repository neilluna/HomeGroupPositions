HomeGroupPositions.UI = {
    name = 'HomeGroupPositionsWindow',

    window = nil,  -- Top-level window.
    isVisible = false,  -- Is the window visible?
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

function HomeGroupPositions.UI:Create()
    local window = HomeGroupPositionsWindow
    local header = window:GetNamedChild("Header")

    local characterAccountLabel = header:GetNamedChild("CharacterAccountLabel")
    characterAccountLabel:SetText(GetString(HOME_GROUP_POSITIONS_CHARACTER_ACCOUNT_LABEL))
    header:GetNamedChild("XLabel"):SetText(GetString(HOME_GROUP_POSITIONS_X_LABEL))
    header:GetNamedChild("YLabel"):SetText(GetString(HOME_GROUP_POSITIONS_Y_LABEL))
    header:GetNamedChild("ZLabel"):SetText(GetString(HOME_GROUP_POSITIONS_Z_LABEL))

    window:SetHidden(true)
    self.window = window
end

function HomeGroupPositions.UI:Show()
    self.isVisible = true
    self.window:SetHidden(false)
end

function HomeGroupPositions.UI:Hide()
    self.isVisible = false
    self.window:SetHidden(true)
end

function HomeGroupPositions.UI:Update()
    local inHouse = (GetCurrentZoneHouseId() or 0) > 0
    if not inHouse then
        self:Hide()
        return
    end

    if not self.isVisible then return end

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
