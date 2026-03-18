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
        registerForRefresh = true,  -- Refresh all controls when a setting is changed and when the panel is shown.
        registerForDefaults = true,  -- Set all controls back to default values.
    }
    self.panel = LibAddonMenu2:RegisterAddonPanel(self.name, panelInfo)

    local controls = {
        {
            type = 'checkbox',
            name = GetString(HOME_GROUP_POSITIONS_SETTINGS_COMM_ENABLED),
            tooltip = GetString(HOME_GROUP_POSITIONS_SETTINGS_COMM_ENABLED_TOOLTIP),
            getFunc = function() return HomeGroupPositions.Settings.serverSpecific.isCommEnabled end,
            setFunc = function(value) HomeGroupPositions.Settings.serverSpecific.isCommEnabled = value end,
            default = HomeGroupPositions.Settings.defaults.serverSpecific.isCommEnabled,
        },
        {
            type = 'slider',
            name = GetString(HOME_GROUP_POSITIONS_SETTINGS_SEND_INTERVAL),
            tooltip = GetString(HOME_GROUP_POSITIONS_SETTINGS_SEND_INTERVAL_TOOLTIP),
            min = HomeGroupPositions.Settings.limits.sendInterval.min,
            max = HomeGroupPositions.Settings.limits.sendInterval.max,
            step = HomeGroupPositions.Settings.limits.sendInterval.step,
            getFunc = function() return HomeGroupPositions.Settings.serverSpecific.sendInterval end,
            setFunc = function(value) HomeGroupPositions.Settings.serverSpecific.sendInterval = value end,
            default = HomeGroupPositions.Settings.defaults.serverSpecific.sendInterval,
        },
        {
            type = 'slider',
            name = GetString(HOME_GROUP_POSITIONS_SETTINGS_PRUNE_TIMEOUT),
            tooltip = GetString(HOME_GROUP_POSITIONS_SETTINGS_PRUNE_TIMEOUT_TOOLTIP),
            min = HomeGroupPositions.Settings.limits.pruneTimeout.min,
            max = HomeGroupPositions.Settings.limits.pruneTimeout.max,
            step = HomeGroupPositions.Settings.limits.pruneTimeout.step,
            getFunc = function() return HomeGroupPositions.Settings.serverSpecific.pruneTimeout end,
            setFunc = function(value) HomeGroupPositions.Settings.serverSpecific.pruneTimeout = value end,
            default = HomeGroupPositions.Settings.defaults.serverSpecific.pruneTimeout,
        },
    }
    LibAddonMenu2:RegisterOptionControls(self.name, controls)
end