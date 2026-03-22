insulate("SavedVariables:", function()

    require("Class")
    require("Settings")
    require("SavedVariables")

    before_each(function()
        -- Stub the ESO globals to a placebo implementation.
        _G.GetWorldName = function() return "TestServer" end
        -- The ZO_SavedVars:NewAccountWide is stubbed to return the Settings defaults.
        _G.ZO_SavedVars = {
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
            end
        }
    end)

    describe("name:", function()
        it("Check against the SavedVariables declaration in HomeGroupPositions.addon.lua.", function()
            local addonName = nil
            for line in io.lines("obj/HomeGroupPositions/HomeGroupPositions.addon") do
                addonName = line:match("^## SavedVariables:%s*(.+)$")
                if addonName then break end
            end
            assert.equals(addonName, HomeGroupPositions.SavedVariables.name)
        end)
    end)

    describe("schemaVersion:", function()
        it("Checks the type.", function()
            local schemaVersion = HomeGroupPositions.SavedVariables.serverSpecific.schemaVersion
            assert.is_true(
                type(schemaVersion) == "string" and schemaVersion:match("^%d%d?$") and tonumber(schemaVersion) >= 1
            )
        end)
    end)

    describe("serverSpecific.settings:", function()
        it("Checks the types.", function()
            assert.is_boolean(HomeGroupPositions.SavedVariables.serverSpecific.settings.isCommEnabled)

            local sendInterval = HomeGroupPositions.SavedVariables.serverSpecific.settings.sendInterval
            assert.is_true(type(sendInterval) == "number" and sendInterval >= 1)

            local pruneTimeout = HomeGroupPositions.SavedVariables.serverSpecific.settings.pruneTimeout
            assert.is_true(type(pruneTimeout) == "number" and pruneTimeout >= 1)

            local windowX = HomeGroupPositions.SavedVariables.serverSpecific.settings.windowX
            assert.is_true(windowX == nil or (type(windowX) == "number" and windowX >= 0))

            local windowY = HomeGroupPositions.SavedVariables.serverSpecific.settings.windowY
            assert.is_true(windowY == nil or (type(windowY) == "number" and windowY >= 0))
        end)
    end)

    describe("serverSpecific.schemaVersion:", function()
        it("Checks the type.", function()
            local schemaVersion = HomeGroupPositions.SavedVariables.serverSpecific.schemaVersion
            assert.is_true(
                type(schemaVersion) == "string" and schemaVersion:match("^%d%d?$") and tonumber(schemaVersion) >= 1
            )
        end)
    end)

    describe("serverSpecific.lastSaved:", function()
        it("Checks the type.", function()
            assert.is_true(HomeGroupPositions.SavedVariables.serverSpecific.lastSaved == "Never")
        end)
    end)

    describe("Load():", function()
        it("Loads the Settings.", function()
            HomeGroupPositions.SavedVariables:Load()

            assert.is_equal(
                HomeGroupPositions.SavedVariables.serverSpecific.settings.isCommEnabled,
                HomeGroupPositions.Settings.serverSpecific.isCommEnabled
            )
            assert.equals(
                HomeGroupPositions.SavedVariables.serverSpecific.settings.sendInterval,
                HomeGroupPositions.Settings.serverSpecific.sendInterval
            )
            assert.equals(
                HomeGroupPositions.SavedVariables.serverSpecific.settings.pruneTimeout,
                HomeGroupPositions.Settings.serverSpecific.pruneTimeout
            )
            assert.equals(
                HomeGroupPositions.SavedVariables.serverSpecific.settings.windowX,
                HomeGroupPositions.Settings.serverSpecific.windowX
            )
            assert.equals(
                HomeGroupPositions.SavedVariables.serverSpecific.settings.windowY,
                HomeGroupPositions.Settings.serverSpecific.windowY
            )
        end)
    end)

    describe("Save():", function()
        it("Saves the Settings into the saved variables.", function()
            HomeGroupPositions.SavedVariables.serverSpecific.settings = {}
            HomeGroupPositions.Settings.serverSpecific = {
                isCommEnabled = false,
                sendInterval = 200,
                pruneTimeout = 2,
                windowX = nil,
                windowY = nil,
            }

            HomeGroupPositions.SavedVariables:Save()

            assert.is_false(HomeGroupPositions.SavedVariables.serverSpecific.settings.isCommEnabled)
            assert.equals(200, HomeGroupPositions.SavedVariables.serverSpecific.settings.sendInterval)
            assert.equals(2, HomeGroupPositions.SavedVariables.serverSpecific.settings.pruneTimeout)
            assert.is_nil(HomeGroupPositions.SavedVariables.serverSpecific.settings.windowX)
            assert.is_nil(HomeGroupPositions.SavedVariables.serverSpecific.settings.windowY)
        end)

        it("Timestamps the last save.", function()
            HomeGroupPositions.SavedVariables:Save()
            local lastSaved = HomeGroupPositions.SavedVariables.serverSpecific.lastSaved
            assert.is_truthy(lastSaved:match("^%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d$"))
        end)
    end)
end)
