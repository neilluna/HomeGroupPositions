HomeGroupPositions.SavedVariables = {
    name = 'HomeGroupPositionsSavedVariables',  -- Must match the SavedVariables declaration in HomeGroupPositions.txt.
    schemaVersion = '[SCHEMA_VERSION]',  -- Latest schema version.

    serverSpecific = {
        settings = {
            commEnabled = HomeGroupPositions.Settings.defaults.serverSpecific.commEnabled,
            channelName = HomeGroupPositions.Settings.defaults.serverSpecific.channelName,
            sendInterval = HomeGroupPositions.Settings.defaults.serverSpecific.sendInterval,
            pruneTimeout = HomeGroupPositions.Settings.defaults.serverSpecific.pruneTimeout,
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
        commEnabled = self.serverSpecific.settings.commEnabled,
        channelName = self.serverSpecific.settings.channelName,
        sendInterval = self.serverSpecific.settings.sendInterval,
        pruneTimeout = self.serverSpecific.settings.pruneTimeout,
    }
end

function HomeGroupPositions.SavedVariables:Save()
    self.serverSpecific.settings = {
        commEnabled = HomeGroupPositions.Settings.serverSpecific.commEnabled,
        channelName = HomeGroupPositions.Settings.serverSpecific.channelName,
        sendInterval = HomeGroupPositions.Settings.serverSpecific.sendInterval,
        pruneTimeout = HomeGroupPositions.Settings.serverSpecific.pruneTimeout,
    }
    self.serverSpecific.lastSaved = tostring(os.date('%Y-%m-%d %H:%M:%S'))
end
