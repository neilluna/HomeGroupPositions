HomeGroupPositions.SavedVariables = {
    name = 'HomeGroupPositionsSavedVariables',  -- Must match the SavedVariables declaration in HomeGroupPositions.txt.
    schemaVersion = '[SCHEMA_VERSION]',  -- Latest schema version.

    serverSpecific = {
        settings = {
            commEnabled = HomeGroupPositions.Settings.defaults.serverSpecific.commEnabled,
            sendInterval = HomeGroupPositions.Settings.defaults.serverSpecific.sendInterval,
            pruneTimeout = HomeGroupPositions.Settings.defaults.serverSpecific.pruneTimeout,
        },
        schemaVersion = '[SCHEMA_VERSION]',  -- Loaded schema version.
        lastSaved = 'Never',
    },
}

function HomeGroupPositions.SavedVariables:Load()
    HomeGroupPositions.log:Info('Loading variables.')

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
        sendInterval = self.serverSpecific.settings.sendInterval,
        pruneTimeout = self.serverSpecific.settings.pruneTimeout,
    }

    HomeGroupPositions.log:Info('Variables loaded.')
end

function HomeGroupPositions.SavedVariables:Save()
    HomeGroupPositions.log:Info('Saving variables.')

    self.serverSpecific.settings = {
        commEnabled = HomeGroupPositions.Settings.serverSpecific.commEnabled,
        sendInterval = HomeGroupPositions.Settings.serverSpecific.sendInterval,
        pruneTimeout = HomeGroupPositions.Settings.serverSpecific.pruneTimeout,
    }
    self.serverSpecific.lastSaved = tostring(os.date('%Y-%m-%d %H:%M:%S'))

    HomeGroupPositions.log:Info('Variables saved.')
end
