function HomeGroupPositions:IsGroupedAndInHouse()
    local inHouse = (HomeGroupPositions.API.GetCurrentZoneHouseId() or 0) > 0
    local inGroup = true  -- IsUnitGrouped('player')
    return inHouse and inGroup
end

function HomeGroupPositions:GetMyInfo()
    local x, y, z = HomeGroupPositions.API.GetPlayerWorldPositionInHouse()
    return {
        player = HomeGroupPositions.API.GetDisplayName(),
        x = x,
        y = y,
        z = z,
        heading = HomeGroupPositions.API.GetPlayerCameraHeading() * 180 / math.pi,
        house = HomeGroupPositions.API.GetCurrentZoneHouseId(),
        owner = HomeGroupPositions.API.GetCurrentHouseOwner(),
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
                house = myInfo.house,
                owner = myInfo.owner,
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
    local parentCommand = HomeGroupPositions.Libs.LibSlashCommander.Register(
        HomeGroupPositions.API.GetString(HOME_GROUP_POSITIONS_SLASH_COMMAND),
        function() self:ToggleShowHideCommand() end,
        HomeGroupPositions.API.GetString(HOME_GROUP_POSITIONS_SLASH_COMMAND_DESCRIPTION)
    )

    local enableCommand = HomeGroupPositions.Libs.LibSlashCommander.RegisterSubCommand(parentCommand)
    HomeGroupPositions.Libs.LibSlashCommander.AddAlias(
        enableCommand,
        HomeGroupPositions.API.GetString(HOME_GROUP_POSITIONS_COMMAND_ENABLE)
    )
    HomeGroupPositions.Libs.LibSlashCommander.SetDescription(
        enableCommand,
        HomeGroupPositions.API.GetString(HOME_GROUP_POSITIONS_COMMAND_ENABLE_DESCRIPTION)
    )
    HomeGroupPositions.Libs.LibSlashCommander.SetCallback(enableCommand, function() self:EnableCommand() end)

    local disableCommand = HomeGroupPositions.Libs.LibSlashCommander.RegisterSubCommand(parentCommand)
    HomeGroupPositions.Libs.LibSlashCommander.AddAlias(
        disableCommand,
        HomeGroupPositions.API.GetString(HOME_GROUP_POSITIONS_COMMAND_DISABLE)
    )
    HomeGroupPositions.Libs.LibSlashCommander.SetDescription(
        disableCommand,
        HomeGroupPositions.API.GetString(HOME_GROUP_POSITIONS_COMMAND_DISABLE_DESCRIPTION)
    )
    HomeGroupPositions.Libs.LibSlashCommander.SetCallback(disableCommand, function() self:DisableCommand() end)

    local showCommand = HomeGroupPositions.Libs.LibSlashCommander.RegisterSubCommand(parentCommand)
    HomeGroupPositions.Libs.LibSlashCommander.AddAlias(
        showCommand,
        HomeGroupPositions.API.GetString(HOME_GROUP_POSITIONS_COMMAND_SHOW)
    )
    HomeGroupPositions.Libs.LibSlashCommander.SetDescription(
        showCommand,
        HomeGroupPositions.API.GetString(HOME_GROUP_POSITIONS_COMMAND_SHOW_DESCRIPTION)
    )
    HomeGroupPositions.Libs.LibSlashCommander.SetCallback(showCommand, function() self:ShowCommand() end)

    local hideCommand = HomeGroupPositions.Libs.LibSlashCommander.RegisterSubCommand(parentCommand)
    HomeGroupPositions.Libs.LibSlashCommander.AddAlias(
        hideCommand,
        HomeGroupPositions.API.GetString(HOME_GROUP_POSITIONS_COMMAND_HIDE)
    )
    HomeGroupPositions.Libs.LibSlashCommander.SetDescription(
        hideCommand,
        HomeGroupPositions.API.GetString(HOME_GROUP_POSITIONS_COMMAND_HIDE_DESCRIPTION)
    )
    HomeGroupPositions.Libs.LibSlashCommander.SetCallback(hideCommand, function() self:HideCommand() end)
end

function HomeGroupPositions:Logout(hookName)
    HomeGroupPositions.Libs.LibDebugLogger.Info(self.log, 'Logout via ' .. hookName)
    self.SavedVariables:Save()
    return false  -- Allow the logout to proceed.
end

function HomeGroupPositions:OnAddOnLoaded(event, name)
    if name ~= self.name then return end
    HomeGroupPositions.API.UnregisterForEvent(self.name, EVENT_ADD_ON_LOADED)

    self.log = HomeGroupPositions.Libs.LibDebugLogger:Create(self.name)
    HomeGroupPositions.Libs.LibDebugLogger.SetEnabled(self.log, true)
    HomeGroupPositions.Libs.LibDebugLogger.Info(self.log, 'Logging started.')

    self.displayName = HomeGroupPositions.API.GetString(HOME_GROUP_POSITIONS_TITLE)

    HomeGroupPositions.API.PreHook('Logout', function() return self:Logout('Logout') end)
    HomeGroupPositions.API.PreHook('ReloadUI', function() return self:Logout('ReloadUI') end)
    HomeGroupPositions.API.PreHook('Quit', function() return self:Logout('Quit') end)

    self.SavedVariables:Load()
    self.SettingsUI:Create()

    self.UI:Create()
    self.UI:ScheduleUpdate()

    self:CreateSlashCommands()
end

function HomeGroupPositions:Initialize()
    HomeGroupPositions.API.RegisterForEvent(
        self.name,
        EVENT_ADD_ON_LOADED,
        function(event, name) self:OnAddOnLoaded(event, name) end
    )
end
