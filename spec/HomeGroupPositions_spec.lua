insulate("HomeGroupPositions:", function()

    require("Class")
    require("Settings")
    require("HomeGroupPositions")

    -- References to addon functions that may be overridden in tests.
    local OriginalIsGroupedAndInHouse = nil
    local OriginalGetMyInfo = nil

    before_each(function()
        -- Save references to addon functions that may be overridden in tests.
        OriginalIsGroupedAndInHouse = HomeGroupPositions.IsGroupedAndInHouse
        OriginalGetMyInfo = HomeGroupPositions.GetMyInfo

        -- Stub the ESO globals to a placebo implementation.
        _G.GetCurrentHouseOwner = function() return "@TestOwner" end
        _G.GetCurrentZoneHouseId = function() return 47 end
        _G.GetDisplayName = function() return "@TestPlayer" end
        _G.GetPlayerCameraHeading = function() return 0 end
        _G.GetPlayerWorldPositionInHouse = function() return 100, 200, 300 end
    end)

    after_each(function()
        -- Restore addon functions that may have been overridden in tests.
        HomeGroupPositions.IsGroupedAndInHouse = OriginalIsGroupedAndInHouse
        HomeGroupPositions.GetMyInfo = OriginalGetMyInfo
    end)

    describe("IsGroupedAndInHouse():", function()
        it("Return true when the house ID is 0 or positive.", function()
            assert.is_true(HomeGroupPositions:IsGroupedAndInHouse())
        end)

        it("Return false when the house ID is negative.", function()
            _G.GetCurrentZoneHouseId = function() return -1 end
            assert.is_false(HomeGroupPositions:IsGroupedAndInHouse())
        end)

        it("Return false when the house ID is nil.", function()
            _G.GetCurrentZoneHouseId = function() return nil end
            assert.is_false(HomeGroupPositions:IsGroupedAndInHouse())
        end)
    end)

    describe("GetMyInfo():", function()
        it("Check the player's info.", function()
            assert.is_same(
                {
                    player = "@TestPlayer",
                    x = 100,
                    y = 200,
                    z = 300,
                    heading = 0,
                    house = 47,
                    owner = "@TestOwner",
                },
                HomeGroupPositions:GetMyInfo()
            )
        end)
    end)

    describe("GetGroupMembers():", function()
        it("Return a table of group members when in a house.", function()
            HomeGroupPositions.IsGroupedAndInHouse = function() return true end
            HomeGroupPositions.GetMyInfo = function()
                return {
                    player = "@TestPlayer",
                    x = 100,
                    y = 200,
                    z = 300,
                    heading = 0,
                    house = 47,
                    owner = "@TestOwner",
                }
            end

            local members = HomeGroupPositions:GetGroupMembers()
            assert.equals(1, #members)
            assert.is_same(
                {
                    player = "@TestPlayer",
                    x = 100,
                    y = 200,
                    z = 300,
                    heading = 0,
                    house = 47,
                    owner = "@TestOwner",
                },
                members[1]
            )
        end)

        it("Return an empty table when not in a house.", function()
            HomeGroupPositions.IsGroupedAndInHouse = function() return false end
            assert.equals(0, #HomeGroupPositions:GetGroupMembers())
        end)
    end)

    describe("EnableCommand():", function()
        it("Return true when Settings.serverSpecific.isCommEnabled is set to true.", function()
            HomeGroupPositions.Settings.serverSpecific.isCommEnabled = false
            HomeGroupPositions:EnableCommand()
            assert.is_true(HomeGroupPositions.Settings.serverSpecific.isCommEnabled)
        end)
    end)

    describe("DisableCommand():", function()
        it("Return false when Settings.serverSpecific.isCommEnabled is set to false.", function()
            HomeGroupPositions.Settings.serverSpecific.isCommEnabled = true
            HomeGroupPositions:DisableCommand()
            assert.is_false(HomeGroupPositions.Settings.serverSpecific.isCommEnabled)
        end)
    end)
end)
