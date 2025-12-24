function HomeGroupPositions:IsGroupedAndInHouse()
    local inHouse = (GetCurrentZoneHouseId() or 0) > 0
    local inGroup = true  -- IsUnitGrouped('player')
    return inHouse and inGroup
end

function HomeGroupPositions:GetMyInfo()
    local x, y, z = GetPlayerWorldPositionInHouse()
    return {
        player = GetDisplayName(),
        x = x,
        y = y,
        z = z,
        heading = GetPlayerCameraHeading() * 180 / math.pi,
        house = GetCurrentZoneHouseId(),
        owner = GetDisplayName(),
    }
end

-- Temporary: Mimics group members data.
function HomeGroupPositions:GetGroupMembers()
    local groupMembers = {}

    if self:IsGroupedAndInHouse() then
        local myInfo = self:GetMyInfo()
        table.insert(
            groupMembers,
            {
                player = myInfo.player,
                x = myInfo.x,
                y = myInfo.y,
                z = myInfo.z,
                heading = myInfo.heading,
            }
        )
    end

    return groupMembers
end

function HomeGroupPositions:EnableCommand()
    self.Settings.serverSpecific.isCommEnabled = true
end

function HomeGroupPositions:DisableCommand()
    self.Settings.serverSpecific.isCommEnabled = false
end

function HomeGroupPositions:ShowCommand()
    self.UI:Show()
end

function HomeGroupPositions:HideCommand()
    self.UI:Hide()
end

function HomeGroupPositions:ToggleShowHideCommand()
    self.UI:ToggleShowHide()
end

function HomeGroupPositions:CreateSlashCommands()
    local parentCommand = LibSlashCommander:Register(
        GetString(HOME_GROUP_POSITIONS_SLASH_COMMAND),
        function() self:ToggleShowHideCommand() end,
        GetString(HOME_GROUP_POSITIONS_SLASH_COMMAND_DESCRIPTION)
    )

    local enableCommand = parentCommand:RegisterSubCommand()
    enableCommand:AddAlias(GetString(HOME_GROUP_POSITIONS_COMMAND_ENABLE))
    enableCommand:SetDescription(GetString(HOME_GROUP_POSITIONS_COMMAND_ENABLE_DESCRIPTION))
    enableCommand:SetCallback(function() self:EnableCommand() end)

    local disableCommand = parentCommand:RegisterSubCommand()
    disableCommand:AddAlias(GetString(HOME_GROUP_POSITIONS_COMMAND_DISABLE))
    disableCommand:SetDescription(GetString(HOME_GROUP_POSITIONS_COMMAND_DISABLE_DESCRIPTION))
    disableCommand:SetCallback(function() self:DisableCommand() end)

    local showCommand = parentCommand:RegisterSubCommand()
    showCommand:AddAlias(GetString(HOME_GROUP_POSITIONS_COMMAND_SHOW))
    showCommand:SetDescription(GetString(HOME_GROUP_POSITIONS_COMMAND_SHOW_DESCRIPTION))
    showCommand:SetCallback(function() self:ShowCommand() end)

    local hideCommand = parentCommand:RegisterSubCommand()
    hideCommand:AddAlias(GetString(HOME_GROUP_POSITIONS_COMMAND_HIDE))
    hideCommand:SetDescription(GetString(HOME_GROUP_POSITIONS_COMMAND_HIDE_DESCRIPTION))
    hideCommand:SetCallback(function() self:HideCommand() end)
end

function HomeGroupPositions:Logout(hookName)
    self.log:Info('Logout via ' .. hookName)
    self.SavedVariables:Save()
    return false  -- Allow the logout to proceed.
end

function HomeGroupPositions:OnAddOnLoaded(event, name)
    if name ~= self.name then return end
    EVENT_MANAGER:UnregisterForEvent(self.name, EVENT_ADD_ON_LOADED)

    self.log = LibDebugLogger:Create(self.name)
    self.log:SetEnabled(true)
    self.log:Info('Logging started.') 

    self.displayName = GetString(HOME_GROUP_POSITIONS_TITLE)

    ZO_PreHook('Logout', function() return self:Logout('Logout') end)
    ZO_PreHook('ReloadUI', function() return self:Logout('ReloadUI') end)
    ZO_PreHook('Quit', function() return self:Logout('Quit') end)

    self.SavedVariables:Load()
    self.SettingsUI:Create()

    self.UI:Create()
    self.UI:ScheduleUpdate()

    self:CreateSlashCommands()
end

function HomeGroupPositions:Initialize()
    EVENT_MANAGER:RegisterForEvent(
        self.name,
        EVENT_ADD_ON_LOADED,
        function(event, name) self:OnAddOnLoaded(event, name) end
    )
end

HomeGroupPositions:Initialize()
