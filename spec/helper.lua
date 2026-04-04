package.path = table.concat({"./obj/HomeGroupPositions/?.lua", package.path}, ";")

-- ESO API stubs — individual tests may override these.
GetCurrentHouseOwner = function() return "@TestOwner" end
GetCurrentZoneHouseId = function() return 47 end
GetDisplayName = function() return "@TestPlayer" end
GetPlayerCameraHeading = function() return 0 end
GetPlayerWorldPositionInHouse = function() return 100, 200, 300 end
GetWorldName = function() return "TestServer" end

ZO_SavedVars = {
    NewAccountWide = function(self, savedVariablesName, version, namespace, defaults, profile)
        return {
            settings = {
                isCommEnabled = defaults.settings.isCommEnabled,
                sendInterval = defaults.settings.sendInterval,
                pruneTimeout = defaults.settings.pruneTimeout,

                windowX = defaults.settings.windowX,
                windowY = defaults.settings.windowY,
            },
            schemaVersion = defaults.schemaVersion,
            lastSaved = defaults.lastSaved,
        }
    end,
}
