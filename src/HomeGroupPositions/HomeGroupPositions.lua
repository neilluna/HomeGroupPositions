function HomeGroupPositions:OnAddOnLoaded(event, name)
    if name ~= self.className then return end
    EVENT_MANAGER:UnregisterForEvent(self.displayName, EVENT_ADD_ON_LOADED)

    self.log = LibDebugLogger:Create(self.className)
    self.log:SetEnabled(true)
    self.log:Info('OnAddOnLoaded() called.')

    self.chat = LibChatMessage("HomeGroupPositions", "HGP")

    ZO_PreHook('Logout', function() self.SavedVariables:Save() return false end)
    ZO_PreHook('ReloadUI', function() self.SavedVariables:Save() return false end)
    ZO_PreHook('Quit', function() self.SavedVariables:Save() return false end)

    self.SavedVariables:Load()
    self.SettingsUI:Create()
end

function HomeGroupPositions:Init()
    self.displayName = GetString(HOME_GROUP_POSITIONS_TITLE)
    EVENT_MANAGER:RegisterForEvent(
        self.displayName,
        EVENT_ADD_ON_LOADED,
        function(event, name) self:OnAddOnLoaded(event, name) end
    )
end

HomeGroupPositions:Init()
