describe("SavedVariables", function()

    setup(function()
        require("Class")
        require("Settings")
        require("SavedVariables")
    end)

    before_each(function()
        HomeGroupPositions.Settings.serverSpecific = {
            isCommEnabled = false,
            sendInterval = 200,
            pruneTimeout = 2,
            windowX = nil,
            windowY = nil,
        }
        HomeGroupPositions.SavedVariables.serverSpecific = {
            settings = {
                isCommEnabled = false,
                sendInterval = 200,
                pruneTimeout = 2,
                windowX = nil,
                windowY = nil,
            },
            schemaVersion = HomeGroupPositions.SavedVariables.schemaVersion,
            lastSaved = "Never",
        }
    end)

    describe("Save", function()

        it("copies isCommEnabled to saved data", function()
            HomeGroupPositions.Settings.serverSpecific.isCommEnabled = true
            HomeGroupPositions.SavedVariables:Save()
            assert.is_true(HomeGroupPositions.SavedVariables.serverSpecific.settings.isCommEnabled)
        end)

        it("copies sendInterval to saved data", function()
            HomeGroupPositions.Settings.serverSpecific.sendInterval = 500
            HomeGroupPositions.SavedVariables:Save()
            assert.equals(500, HomeGroupPositions.SavedVariables.serverSpecific.settings.sendInterval)
        end)

        it("copies pruneTimeout to saved data", function()
            HomeGroupPositions.Settings.serverSpecific.pruneTimeout = 5
            HomeGroupPositions.SavedVariables:Save()
            assert.equals(5, HomeGroupPositions.SavedVariables.serverSpecific.settings.pruneTimeout)
        end)

        it("copies windowX to saved data", function()
            HomeGroupPositions.Settings.serverSpecific.windowX = 100
            HomeGroupPositions.SavedVariables:Save()
            assert.equals(100, HomeGroupPositions.SavedVariables.serverSpecific.settings.windowX)
        end)

        it("copies windowY to saved data", function()
            HomeGroupPositions.Settings.serverSpecific.windowY = 200
            HomeGroupPositions.SavedVariables:Save()
            assert.equals(200, HomeGroupPositions.SavedVariables.serverSpecific.settings.windowY)
        end)

        it("sets lastSaved to a YYYY-MM-DD HH:MM:SS timestamp", function()
            HomeGroupPositions.SavedVariables:Save()
            local lastSaved = HomeGroupPositions.SavedVariables.serverSpecific.lastSaved
            assert.is_not.equals("Never", lastSaved)
            assert.is_truthy(lastSaved:match("^%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d$"))
        end)

    end)

    describe("Load", function()

        it("copies isCommEnabled from saved data to Settings", function()
            HomeGroupPositions.SavedVariables.serverSpecific.settings.isCommEnabled = true
            HomeGroupPositions.SavedVariables:Load()
            assert.is_true(HomeGroupPositions.Settings.serverSpecific.isCommEnabled)
        end)

        it("copies sendInterval from saved data to Settings", function()
            HomeGroupPositions.SavedVariables.serverSpecific.settings.sendInterval = 750
            HomeGroupPositions.SavedVariables:Load()
            assert.equals(750, HomeGroupPositions.Settings.serverSpecific.sendInterval)
        end)

        it("copies pruneTimeout from saved data to Settings", function()
            HomeGroupPositions.SavedVariables.serverSpecific.settings.pruneTimeout = 7
            HomeGroupPositions.SavedVariables:Load()
            assert.equals(7, HomeGroupPositions.Settings.serverSpecific.pruneTimeout)
        end)

        it("copies windowX from saved data to Settings", function()
            HomeGroupPositions.SavedVariables.serverSpecific.settings.windowX = 300
            HomeGroupPositions.SavedVariables:Load()
            assert.equals(300, HomeGroupPositions.Settings.serverSpecific.windowX)
        end)

        it("copies windowY from saved data to Settings", function()
            HomeGroupPositions.SavedVariables.serverSpecific.settings.windowY = 400
            HomeGroupPositions.SavedVariables:Load()
            assert.equals(400, HomeGroupPositions.Settings.serverSpecific.windowY)
        end)

        it("stamps schemaVersion onto the saved data", function()
            HomeGroupPositions.SavedVariables:Load()
            assert.equals(
                HomeGroupPositions.SavedVariables.schemaVersion,
                HomeGroupPositions.SavedVariables.serverSpecific.schemaVersion
            )
        end)

    end)

end)
