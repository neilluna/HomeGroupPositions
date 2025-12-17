function HomeGroupPositions:GetMyInfo()
    local x, y, z = GetPlayerWorldPositionInHouse()
    return {
        character = GetUnitName('player'),
        player = GetDisplayName(),
        x = x,
        y = y,
        z = z,
        -- heading = GetPlayerCameraHeading(),
        -- house = GetCurrentZoneHouseId(),
        -- timestamp = GetGameTimeMilliseconds(),
    }
end

function HomeGroupPositions:EnableCommand()
    HomeGroupPositions.Settings.serverSpecific.commEnabled = true
end

function HomeGroupPositions:DisableCommand()
    HomeGroupPositions.Settings.serverSpecific.commEnabled = false
end

function HomeGroupPositions:ShowCommand()
    HomeGroupPositions.UI:Show()
end

function HomeGroupPositions:HideCommand()
    HomeGroupPositions.UI:Hide()
end

function HomeGroupPositions:CreateSlashCommands()
    local parentCommand = LibSlashCommander:Register(
        GetString(HOME_GROUP_POSITIONS_SLASH_COMMAND),
        function() end,
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
    HomeGroupPositions.log:Info('Logout with ' .. hookName)
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
    -- self.UI:Update()

    self:CreateSlashCommands()
end

function HomeGroupPositions:Init()
    EVENT_MANAGER:RegisterForEvent(
        self.name,
        EVENT_ADD_ON_LOADED,
        function(event, name) self:OnAddOnLoaded(event, name) end
    )
end

HomeGroupPositions:Init()
