describe("Settings", function()

    setup(function()
        require("Class")
        require("Settings")
    end)

    describe("defaults.serverSpecific", function()

        it("isCommEnabled defaults to false", function()
            assert.is_false(HomeGroupPositions.Settings.defaults.serverSpecific.isCommEnabled)
        end)

        it("sendInterval defaults to 200", function()
            assert.equals(200, HomeGroupPositions.Settings.defaults.serverSpecific.sendInterval)
        end)

        it("pruneTimeout defaults to 2", function()
            assert.equals(2, HomeGroupPositions.Settings.defaults.serverSpecific.pruneTimeout)
        end)

        it("windowX defaults to nil", function()
            assert.is_nil(HomeGroupPositions.Settings.defaults.serverSpecific.windowX)
        end)

        it("windowY defaults to nil", function()
            assert.is_nil(HomeGroupPositions.Settings.defaults.serverSpecific.windowY)
        end)

    end)

    describe("limits.sendInterval", function()

        it("min is 200", function()
            assert.equals(200, HomeGroupPositions.Settings.limits.sendInterval.min)
        end)

        it("max is 1000", function()
            assert.equals(1000, HomeGroupPositions.Settings.limits.sendInterval.max)
        end)

        it("step is 50", function()
            assert.equals(50, HomeGroupPositions.Settings.limits.sendInterval.step)
        end)

        it("min is not greater than max", function()
            assert.is_true(
                HomeGroupPositions.Settings.limits.sendInterval.min
                    <= HomeGroupPositions.Settings.limits.sendInterval.max
            )
        end)

    end)

    describe("limits.pruneTimeout", function()

        it("min is 1", function()
            assert.equals(1, HomeGroupPositions.Settings.limits.pruneTimeout.min)
        end)

        it("max is 10", function()
            assert.equals(10, HomeGroupPositions.Settings.limits.pruneTimeout.max)
        end)

        it("step is 1", function()
            assert.equals(1, HomeGroupPositions.Settings.limits.pruneTimeout.step)
        end)

        it("min is not greater than max", function()
            assert.is_true(
                HomeGroupPositions.Settings.limits.pruneTimeout.min
                    <= HomeGroupPositions.Settings.limits.pruneTimeout.max
            )
        end)

    end)

end)
