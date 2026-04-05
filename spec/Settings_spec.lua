insulate("Settings:", function()

    require("Class")
    require("Settings")

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

    it("Check the type and member names.", function()
        assert.is_table(HomeGroupPositions.Settings)
        assert.is_true(ContainsExactly(HomeGroupPositions.Settings, {"defaults", "limits", "serverSpecific"}))
    end)

    describe("defaults:", function()
        it("Check the type and member names.", function()
            assert.is_table(HomeGroupPositions.Settings.defaults)
            assert.is_true(ContainsExactly(HomeGroupPositions.Settings.defaults, {"serverSpecific"}))
        end)
    end)

    describe("defaults.serverSpecific:", function()
        it("Check the type and member names.", function()
            assert.is_table(HomeGroupPositions.Settings.defaults.serverSpecific)
            assert.is_true(ContainsExactly(
                HomeGroupPositions.Settings.defaults.serverSpecific, {"isCommEnabled", "sendInterval", "pruneTimeout"}
            ))
        end)

        it("Check the member types.", function()
            assert.is_boolean(HomeGroupPositions.Settings.defaults.serverSpecific.isCommEnabled)

            local sendInterval = HomeGroupPositions.Settings.defaults.serverSpecific.sendInterval
            assert.is_true(type(sendInterval) == "number" and sendInterval >= 1)

            local pruneTimeout = HomeGroupPositions.Settings.defaults.serverSpecific.pruneTimeout
            assert.is_true(type(pruneTimeout) == "number" and pruneTimeout >= 1)

            assert.is_nil(HomeGroupPositions.Settings.defaults.serverSpecific.windowX)
            assert.is_nil(HomeGroupPositions.Settings.defaults.serverSpecific.windowY)
        end)
    end)

    describe("limits:", function()
        it("Check the type and member names.", function()
            assert.is_table(HomeGroupPositions.Settings.limits)
            assert.is_true(ContainsExactly(HomeGroupPositions.Settings.limits, {"sendInterval", "pruneTimeout"}))
        end)
    end)

    describe("limits.sendInterval:", function()
        it("Check the type and member names.", function()
            assert.is_table(HomeGroupPositions.Settings.limits.sendInterval)
            assert.is_true(ContainsExactly(HomeGroupPositions.Settings.limits.sendInterval, {"min", "max", "step"}))
        end)

        it("Check the member types.", function()
            local min = HomeGroupPositions.Settings.limits.sendInterval.min
            assert.is_true(type(min) == "number" and min >= 1)

            local max = HomeGroupPositions.Settings.limits.sendInterval.max
            assert.is_true(type(max) == "number" and max >= 1 and max >= min)

            local step = HomeGroupPositions.Settings.limits.sendInterval.step
            assert.is_true(type(step) == "number" and step >= 1)
        end)

        it("Check that the default value is within min and max.", function()
            local sendInterval = HomeGroupPositions.Settings.defaults.serverSpecific.sendInterval
            assert.is_true(
                sendInterval >= HomeGroupPositions.Settings.limits.sendInterval.min
                and sendInterval <= HomeGroupPositions.Settings.limits.sendInterval.max
            )
        end)
    end)

    describe("limits.pruneTimeout:", function()
        it("Check the type and member names.", function()
            assert.is_table(HomeGroupPositions.Settings.limits.pruneTimeout)
            assert.is_true(ContainsExactly(HomeGroupPositions.Settings.limits.pruneTimeout, {"min", "max", "step"}))
        end)

        it("Check the member types.", function()
            local min = HomeGroupPositions.Settings.limits.pruneTimeout.min
            assert.is_true(type(min) == "number" and min >= 1)

            local max = HomeGroupPositions.Settings.limits.pruneTimeout.max
            assert.is_true(type(max) == "number" and max >= 1 and max >= min)

            local step = HomeGroupPositions.Settings.limits.pruneTimeout.step
            assert.is_true(type(step) == "number" and step >= 1)
        end)

        it("Check that the default value is within min and max.", function()
            local pruneTimeout = HomeGroupPositions.Settings.defaults.serverSpecific.pruneTimeout
            assert.is_true(
                pruneTimeout >= HomeGroupPositions.Settings.limits.pruneTimeout.min
                and pruneTimeout <= HomeGroupPositions.Settings.limits.pruneTimeout.max
            )
        end)
    end)

    describe("serverSpecific", function()
        it("Check the type and member names.", function()
            assert.is_table(HomeGroupPositions.Settings.serverSpecific)
            assert.is_true(ContainsExactly(HomeGroupPositions.Settings.serverSpecific, {}))
        end)
    end)
end)
