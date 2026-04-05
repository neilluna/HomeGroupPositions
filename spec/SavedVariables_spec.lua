insulate("SavedVariables:", function()

    require("Class")
    require("Settings")
    require("SavedVariables")

    local function ContainsExactly(target, check)
        -- Every name in check must exist in target.
        for _, name in ipairs(check) do
            if target[name] == nil then
                return false
            end
        end

        -- Count check names for comparison.
        local checkCount = #check

        -- The target must not have extra members.
        local targetCount = 0
        for name in pairs(target) do
            if type(target[name]) ~= "function" then
                targetCount = targetCount + 1
            end
        end

        return targetCount == checkCount
    end

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
        _G.os = {
            date = function(format) return "2026-01-01 00:00:00" end
        }
    end)

    it("Check the type and member names.", function()
        assert.is_table(HomeGroupPositions.SavedVariables)
        assert.is_true(ContainsExactly(HomeGroupPositions.SavedVariables, {"name", "schemaVersion", "serverSpecific"}))
    end)

    describe("name:", function()
        it("Check the type.", function()
            assert.is_string(HomeGroupPositions.SavedVariables.name)
        end)

        it("Check that the value matches the SavedVariables declaration in HomeGroupPositions.addon.lua.", function()
            local savedVariablesDeclaration = nil
            for line in io.lines("obj/HomeGroupPositions/HomeGroupPositions.addon") do
                savedVariablesDeclaration = line:match("^## SavedVariables:%s*(.+)$")
                if savedVariablesDeclaration then break end
            end
            assert.equals(savedVariablesDeclaration, HomeGroupPositions.SavedVariables.name)
        end)
    end)

    describe("schemaVersion:", function()
        it("Check the type.", function()
            assert.is_string(HomeGroupPositions.SavedVariables.schemaVersion)
        end)

        it("Check that the value has a valid format.", function()
            local schemaVersion = HomeGroupPositions.SavedVariables.serverSpecific.schemaVersion
            assert.is_true(schemaVersion:match("^%d%d?$") and tonumber(schemaVersion) >= 1)
        end)
    end)

    describe("serverSpecific:", function()
        it("Check the type and member names.", function()
            assert.is_table(HomeGroupPositions.SavedVariables.serverSpecific)
            assert.is_true(ContainsExactly(
                HomeGroupPositions.SavedVariables.serverSpecific, {"settings", "schemaVersion", "lastSaved"}
            ))
        end)
    end)

    describe("serverSpecific.settings:", function()
        it("Check the type and member names.", function()
            assert.is_table(HomeGroupPositions.SavedVariables.serverSpecific.settings)
            assert.is_true(ContainsExactly(
                HomeGroupPositions.SavedVariables.serverSpecific.settings,
                {"isCommEnabled", "sendInterval", "pruneTimeout"}
            ))
        end)

        it("Check the member types.", function()
            assert.is_boolean(HomeGroupPositions.SavedVariables.serverSpecific.settings.isCommEnabled)

            local sendInterval = HomeGroupPositions.SavedVariables.serverSpecific.settings.sendInterval
            assert.is_true(type(sendInterval) == "number" and sendInterval >= 1)

            local pruneTimeout = HomeGroupPositions.SavedVariables.serverSpecific.settings.pruneTimeout
            assert.is_true(type(pruneTimeout) == "number" and pruneTimeout >= 1)

            assert.is_nil(HomeGroupPositions.SavedVariables.serverSpecific.settings.windowX)
            assert.is_nil(HomeGroupPositions.SavedVariables.serverSpecific.settings.windowY)
        end)
    end)

    describe("serverSpecific.schemaVersion:", function()
        it("Check the type.", function()
            assert.is_string(HomeGroupPositions.SavedVariables.serverSpecific.schemaVersion)
        end)

        it("Check that the value has a valid format.", function()
            local schemaVersion = HomeGroupPositions.SavedVariables.serverSpecific.schemaVersion
            assert.is_true(schemaVersion:match("^%d%d?$") and tonumber(schemaVersion) >= 1)
        end)
    end)

    describe("serverSpecific.lastSaved:", function()
        it("Check the type.", function()
            assert.is_string(HomeGroupPositions.SavedVariables.serverSpecific.lastSaved)
        end)

        it("Check that the value is 'Never' or has a valid timestamp format.", function()
            local lastSaved = HomeGroupPositions.SavedVariables.serverSpecific.lastSaved
            assert.is_true(lastSaved == "Never")
        end)
     end)

    describe("Load():", function()
        it("Check that Settings.serverSpecific is loaded correctly.", function()
            HomeGroupPositions.SavedVariables:Load()

            assert.is_same(
                HomeGroupPositions.Settings.serverSpecific,
                HomeGroupPositions.SavedVariables.serverSpecific.settings
            )
        end)
    end)

    describe("Save():", function()
        it("Check that SavedVariables.serverSpecific.settings is updated correctly.", function()
            -- Non-default values.
            HomeGroupPositions.Settings.serverSpecific = {
                isCommEnabled = true,
                sendInterval = 500,
                pruneTimeout = 5,
                windowX = 100,
                windowY = 200,
            }
            HomeGroupPositions.SavedVariables.serverSpecific.settings = {}

            HomeGroupPositions.SavedVariables:Save()

            assert.is_same(
                HomeGroupPositions.SavedVariables.serverSpecific.settings,
                HomeGroupPositions.Settings.serverSpecific
            )
        end)

        it("Check that SavedVariables.serverSpecific.lastSaved has a valid format.", function()
            HomeGroupPositions.SavedVariables:Save()
            assert.equals("2026-01-01 00:00:00", HomeGroupPositions.SavedVariables.serverSpecific.lastSaved)
        end)
    end)
end)
