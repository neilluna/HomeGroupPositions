package.path = table.concat({"./obj/HomeGroupPositions/?.lua", package.path}, ";")

-- ESO API stubs — individual tests may override these.
GetWorldName = function() return "NA Megaserver" end
GetCurrentZoneHouseId = function() return 0 end
GetPlayerWorldPositionInHouse = function() return 100, 200, 300 end
GetDisplayName = function() return "@TestPlayer" end
GetPlayerCameraHeading = function() return 0 end
GetCurrentHouseOwner = function() return "@Owner" end

ZO_SavedVars = {
    NewAccountWide = function(self, name, version, tag, defaults, worldName)
        -- Simulate loading saved data: return whatever was passed as defaults.
        return defaults
    end,
}
