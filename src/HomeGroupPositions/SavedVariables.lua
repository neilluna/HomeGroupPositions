HomeGroupPositions.SavedVariables = {
    -- Must match the SavedVariables declaration in HomeGroupPositions.addon.
    name = 'HomeGroupPositionsSavedVariables',

    schemaVersion = '[SCHEMA_VERSION]',  -- Latest schema version.

    serverSpecific = {
        settings = {
            isCommEnabled = HomeGroupPositions.Settings.defaults.serverSpecific.isCommEnabled,
            sendInterval = HomeGroupPositions.Settings.defaults.serverSpecific.sendInterval,
            pruneTimeout = HomeGroupPositions.Settings.defaults.serverSpecific.pruneTimeout,

            windowX = HomeGroupPositions.Settings.defaults.serverSpecific.windowX,
            windowY = HomeGroupPositions.Settings.defaults.serverSpecific.windowY,
        },
        schemaVersion = '[SCHEMA_VERSION]',  -- Loaded schema version.
        lastSaved = 'Never',
    },
}

function HomeGroupPositions.SavedVariables:Load()
    self.serverSpecific = ZO_SavedVars:NewAccountWide(
        self.name,
        1,
        nil,
        self.serverSpecific,
        GetWorldName()
    )
    -- If self.serverSpecific is an old schema, migrate it here.
    self.serverSpecific.schemaVersion = self.schemaVersion

    HomeGroupPositions.Settings.serverSpecific = {
        isCommEnabled = self.serverSpecific.settings.isCommEnabled,
        sendInterval = self.serverSpecific.settings.sendInterval,
        pruneTimeout = self.serverSpecific.settings.pruneTimeout,

        windowX = self.serverSpecific.settings.windowX,
        windowY = self.serverSpecific.settings.windowY,
    }
end

function HomeGroupPositions.SavedVariables:Save()
    self.serverSpecific.settings = {
        isCommEnabled = HomeGroupPositions.Settings.serverSpecific.isCommEnabled,
        sendInterval = HomeGroupPositions.Settings.serverSpecific.sendInterval,
        pruneTimeout = HomeGroupPositions.Settings.serverSpecific.pruneTimeout,

        windowX = HomeGroupPositions.Settings.serverSpecific.windowX,
        windowY = HomeGroupPositions.Settings.serverSpecific.windowY,
    }
    self.serverSpecific.lastSaved = os.date('%Y-%m-%d %H:%M:%S')
end
