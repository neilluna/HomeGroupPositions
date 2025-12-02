HomeGroupPositions.SettingsUI = {
    name = 'HomeGroupPositionsSettings',
    panel = nil,
}

function HomeGroupPositions.SettingsUI:Create()
    local panelInfo = {
        type = 'panel',
        name = GetString(HOME_GROUP_POSITIONS_TITLE),
        displayName = GetString(HOME_GROUP_POSITIONS_SETTINGS_TITLE),
        author = HomeGroupPositions.author,
        version = HomeGroupPositions.version,
    }
    self.panel = LibAddonMenu2:RegisterAddonPanel(self.name, panelInfo)

    local controls = {
        {
            type = 'checkbox',
            name = GetString(HOME_GROUP_POSITIONS_SETTINGS_COMM_ENABLED),
            tooltip = GetString(HOME_GROUP_POSITIONS_SETTINGS_COMM_ENABLED_TOOLTIP),
            getFunc = function() return HomeGroupPositions.Settings.serverSpecific.commEnabled end,
            setFunc = function(value)
                HomeGroupPositions.Settings.serverSpecific.commEnabled = value
                -- Apply changes immediately.
            end,
        },
        {
            type = 'editbox',
            name = GetString(HOME_GROUP_POSITIONS_SETTINGS_CHANNEL_NAME),
            tooltip = GetString(HOME_GROUP_POSITIONS_SETTINGS_CHANNEL_NAME_TOOLTIP),
            getFunc = function() return HomeGroupPositions.Settings.serverSpecific.channelName end,
            setFunc = function(value)
                HomeGroupPositions.Settings.serverSpecific.channelName = value
                -- Apply changes immediately.
            end,
            isMultiline = false,
        },
        {
            type = 'slider',
            name = GetString(HOME_GROUP_POSITIONS_SETTINGS_SEND_INTERVAL),
            tooltip = GetString(HOME_GROUP_POSITIONS_SETTINGS_SEND_INTERVAL_TOOLTIP),
            min = HomeGroupPositions.Settings.limits.sendInterval.min,
            max = HomeGroupPositions.Settings.limits.sendInterval.max,
            step = HomeGroupPositions.Settings.limits.sendInterval.step,
            getFunc = function() return HomeGroupPositions.Settings.serverSpecific.sendInterval end,
            setFunc = function(value)
                HomeGroupPositions.Settings.serverSpecific.sendInterval = value
                -- Apply changes immediately.
            end,
        },
        {
            type = 'slider',
            name = GetString(HOME_GROUP_POSITIONS_SETTINGS_PRUNE_TIMEOUT),
            tooltip = GetString(HOME_GROUP_POSITIONS_SETTINGS_PRUNE_TIMEOUT_TOOLTIP),
            min = HomeGroupPositions.Settings.limits.pruneTimeout.min,
            max = HomeGroupPositions.Settings.limits.pruneTimeout.max,
            step = HomeGroupPositions.Settings.limits.pruneTimeout.step,
            getFunc = function() return HomeGroupPositions.Settings.serverSpecific.pruneTimeout end,
            setFunc = function(value)
                HomeGroupPositions.Settings.serverSpecific.pruneTimeout = value
                -- Apply changes immediately.
            end,
        },
    }
    LibAddonMenu2:RegisterOptionControls(self.name, controls)
end
