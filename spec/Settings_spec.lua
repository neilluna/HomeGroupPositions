insulate("Settings:", function()

    require("Class")
    require("Settings")

    describe("defaults.serverSpecific:", function()
        it("Checks the types.", function()
            assert.is_boolean(HomeGroupPositions.Settings.defaults.serverSpecific.isCommEnabled)

            local sendInterval = HomeGroupPositions.Settings.defaults.serverSpecific.sendInterval
            assert.is_true(type(sendInterval) == "number" and sendInterval >= 1)

            local pruneTimeout = HomeGroupPositions.Settings.defaults.serverSpecific.pruneTimeout
            assert.is_true(type(pruneTimeout) == "number" and pruneTimeout >= 1)

            local windowX = HomeGroupPositions.Settings.defaults.serverSpecific.windowX
            assert.is_true(windowX == nil or (type(windowX) == "number" and windowX >= 0))

            local windowY = HomeGroupPositions.Settings.defaults.serverSpecific.windowY
            assert.is_true(windowY == nil or (type(windowY) == "number" and windowY >= 0))
        end)
    end)

    describe("limits.sendInterval:", function()
        it("Checks the types.", function()
            local min = HomeGroupPositions.Settings.limits.sendInterval.min
            assert.is_true(type(min) == "number" and min >= 1)

            local max = HomeGroupPositions.Settings.limits.sendInterval.max
            assert.is_true(type(max) == "number" and max >= 1 and max >= min)

            local step = HomeGroupPositions.Settings.limits.sendInterval.step
            assert.is_true(type(step) == "number" and step >= 1)
        end)

        it("Checks that the default value is within min and max.", function()
            assert.is_true(
                HomeGroupPositions.Settings.defaults.serverSpecific.sendInterval
                    >= HomeGroupPositions.Settings.limits.sendInterval.min
                    and HomeGroupPositions.Settings.defaults.serverSpecific.sendInterval
                    <= HomeGroupPositions.Settings.limits.sendInterval.max
            )
        end)
    end)

    describe("limits.pruneTimeout:", function()
        it("Checks the types.", function()
            local min = HomeGroupPositions.Settings.limits.pruneTimeout.min
            assert.is_true(type(min) == "number" and min >= 1)

            local max = HomeGroupPositions.Settings.limits.pruneTimeout.max
            assert.is_true(type(max) == "number" and max >= 1 and max >= min)

            local step = HomeGroupPositions.Settings.limits.pruneTimeout.step
            assert.is_true(type(step) == "number" and step >= 1)
        end)

        it("Checks that the default value is within min and max.", function()
            assert.is_true(
                HomeGroupPositions.Settings.defaults.serverSpecific.pruneTimeout
                    >= HomeGroupPositions.Settings.limits.pruneTimeout.min
                    and HomeGroupPositions.Settings.defaults.serverSpecific.pruneTimeout
                    <= HomeGroupPositions.Settings.limits.pruneTimeout.max
            )
        end)
    end)

    describe("serverSpecific", function()
        it("Checks that this is an empty table.", function()
            assert.is_table(HomeGroupPositions.Settings.serverSpecific)
            assert.is_equal(0, #HomeGroupPositions.Settings.serverSpecific)
        end)
    end)
end)
