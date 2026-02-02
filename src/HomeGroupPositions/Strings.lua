for stringId, stringValue in pairs(HomeGroupPositions.localizationStrings) do
    HomeGroupPositions.API.CreateStringId('HOME_GROUP_POSITIONS_' .. stringId, stringValue)
end
