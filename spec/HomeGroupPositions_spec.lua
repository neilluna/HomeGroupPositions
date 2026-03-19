describe("HomeGroupPositions", function()

    setup(function()
        require("Class")
        require("Settings")
        require("SavedVariables")
        require("HomeGroupPositions")
    end)

    before_each(function()
        HomeGroupPositions.Settings.serverSpecific = {
            isCommEnabled = false,
            sendInterval = 200,
            pruneTimeout = 2,
            windowX = nil,
            windowY = nil,
        }
        -- Reset ESO stubs to safe defaults.
        -- Use _G explicitly so overrides reach the module's global environment.
        _G.GetCurrentZoneHouseId = function() return 0 end
        _G.GetPlayerWorldPositionInHouse = function() return 100, 200, 300 end
        _G.GetDisplayName = function() return "@TestPlayer" end
        _G.GetPlayerCameraHeading = function() return 0 end
        _G.GetCurrentHouseOwner = function() return "@Owner" end
    end)

    describe("IsGroupedAndInHouse", function()

        it("returns false when houseId is 0", function()
            _G.GetCurrentZoneHouseId = function() return 0 end
            assert.is_false(HomeGroupPositions:IsGroupedAndInHouse())
        end)

        it("returns false when houseId is nil", function()
            _G.GetCurrentZoneHouseId = function() return nil end
            assert.is_false(HomeGroupPositions:IsGroupedAndInHouse())
        end)

        it("returns true when houseId is positive", function()
            _G.GetCurrentZoneHouseId = function() return 47 end
            assert.is_true(HomeGroupPositions:IsGroupedAndInHouse())
        end)

    end)

    describe("GetMyInfo", function()

        it("returns the display name as player", function()
            _G.GetDisplayName = function() return "@Tester" end
            assert.equals("@Tester", HomeGroupPositions:GetMyInfo().player)
        end)

        it("returns world position x, y, z", function()
            _G.GetPlayerWorldPositionInHouse = function() return 10, 20, 30 end
            local info = HomeGroupPositions:GetMyInfo()
            assert.equals(10, info.x)
            assert.equals(20, info.y)
            assert.equals(30, info.z)
        end)

        it("returns current house id", function()
            _G.GetCurrentZoneHouseId = function() return 47 end
            assert.equals(47, HomeGroupPositions:GetMyInfo().house)
        end)

        it("returns current house owner", function()
            _G.GetCurrentHouseOwner = function() return "@Houseowner" end
            assert.equals("@Houseowner", HomeGroupPositions:GetMyInfo().owner)
        end)

        it("converts camera heading from radians to degrees (0 rad = 0 deg)", function()
            _G.GetPlayerCameraHeading = function() return 0 end
            assert.equals(0, HomeGroupPositions:GetMyInfo().heading)
        end)

        it("converts camera heading from radians to degrees (pi rad = 180 deg)", function()
            _G.GetPlayerCameraHeading = function() return math.pi end
            local heading = HomeGroupPositions:GetMyInfo().heading
            assert.is_true(math.abs(heading - 180) < 0.0001)
        end)

        it("converts camera heading from radians to degrees (pi/2 rad = 90 deg)", function()
            _G.GetPlayerCameraHeading = function() return math.pi / 2 end
            local heading = HomeGroupPositions:GetMyInfo().heading
            assert.is_true(math.abs(heading - 90) < 0.0001)
        end)

    end)

    describe("GetGroupMembers", function()

        it("returns an empty table when not in a house", function()
            GetCurrentZoneHouseId = function() return 0 end
            assert.equals(0, #HomeGroupPositions:GetGroupMembers())
        end)

        it("returns one entry when in a house", function()
            _G.GetCurrentZoneHouseId = function() return 47 end
            assert.equals(1, #HomeGroupPositions:GetGroupMembers())
        end)

        it("entry contains the player's position and info", function()
            _G.GetCurrentZoneHouseId = function() return 47 end
            _G.GetDisplayName = function() return "@TestPlayer" end
            _G.GetPlayerWorldPositionInHouse = function() return 10, 20, 30 end
            _G.GetPlayerCameraHeading = function() return 0 end
            _G.GetCurrentHouseOwner = function() return "@Owner" end

            local member = HomeGroupPositions:GetGroupMembers()[1]

            assert.equals("@TestPlayer", member.player)
            assert.equals(10, member.x)
            assert.equals(20, member.y)
            assert.equals(30, member.z)
            assert.equals(47, member.house)
            assert.equals("@Owner", member.owner)
        end)

    end)

    describe("EnableCommand", function()

        it("sets isCommEnabled to true", function()
            HomeGroupPositions.Settings.serverSpecific.isCommEnabled = false
            HomeGroupPositions:EnableCommand()
            assert.is_true(HomeGroupPositions.Settings.serverSpecific.isCommEnabled)
        end)

        it("is idempotent when already enabled", function()
            HomeGroupPositions.Settings.serverSpecific.isCommEnabled = true
            HomeGroupPositions:EnableCommand()
            assert.is_true(HomeGroupPositions.Settings.serverSpecific.isCommEnabled)
        end)

    end)

    describe("DisableCommand", function()

        it("sets isCommEnabled to false", function()
            HomeGroupPositions.Settings.serverSpecific.isCommEnabled = true
            HomeGroupPositions:DisableCommand()
            assert.is_false(HomeGroupPositions.Settings.serverSpecific.isCommEnabled)
        end)

        it("is idempotent when already disabled", function()
            HomeGroupPositions.Settings.serverSpecific.isCommEnabled = false
            HomeGroupPositions:DisableCommand()
            assert.is_false(HomeGroupPositions.Settings.serverSpecific.isCommEnabled)
        end)

    end)

end)
