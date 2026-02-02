HomeGroupPositions.API = {}

function HomeGroupPositions.API.CallLater(callback, delay)
    zo_callLater(callback, delay)
end

function HomeGroupPositions.API.ClearAnchors(control)
    control:ClearAnchors()
end

function HomeGroupPositions.API.CreateControlFromVirtual(controlName, parent, virtualName)
    return WINDOW_MANAGER:CreateControlFromVirtual(controlName, parent, virtualName)
end

function HomeGroupPositions.API.CreateStringId(stringVariable, stringValue)
    ZO_CreateStringId(stringVariable, stringValue)
end

function HomeGroupPositions.API.GetCurrentHouseOwner()
    return GetCurrentHouseOwner()
end

function HomeGroupPositions.API.GetCurrentZoneHouseId()
    return GetCurrentZoneHouseId()
end

function HomeGroupPositions.API.GetDisplayName()
    return GetDisplayName()
end

function HomeGroupPositions.API.GetLeft(control)
    return control:GetLeft()
end

function HomeGroupPositions.API.GetNamedChild(parentControl, childName)
    return parentControl:GetNamedChild(childName)
end

function HomeGroupPositions.API.GetPlayerCameraHeading()
    return GetPlayerCameraHeading()
end

function HomeGroupPositions.API.GetPlayerWorldPositionInHouse()
    return GetPlayerWorldPositionInHouse()
end

function HomeGroupPositions.API.GetString(stringVariable)
    return GetString(stringVariable)
end

function HomeGroupPositions.API.GetTop(control)
    return control:GetTop()
end

function HomeGroupPositions.API.GetWorldName()
    return GetWorldName()
end

function HomeGroupPositions.API.NewAccountWideSavedVars(savedVariablesTable, version, namespace, defaults, profile)
    return ZO_SavedVars:NewAccountWide(savedVariablesTable, version, namespace, defaults, profile)
end

function HomeGroupPositions.API.OnCloseClicked(control, callback)
    control.OnCloseClicked = callback
end

function HomeGroupPositions.API.OnMoveStop(control, callback)
    control.OnMoveStop = callback
end

function HomeGroupPositions.API.PreHook(functionName, hookFunction)
    ZO_PreHook(functionName, hookFunction)
end

function HomeGroupPositions.API.RegisterForEvent(addonName, event, callback)
    EVENT_MANAGER:RegisterForEvent(addonName, event, callback)
end

function HomeGroupPositions.API.SetAnchor(control, point, relativeTo, relativePoint, offsetX, offsetY)
    control:SetAnchor(point, relativeTo, relativePoint, offsetX, offsetY)
end

function HomeGroupPositions.API.SetHidden(control, isHidden)
    control:SetHidden(isHidden)
end

function HomeGroupPositions.API.SetText(control, text)
    control:SetText(text)
end

function HomeGroupPositions.API.UnregisterForEvent(addonName, event)
    EVENT_MANAGER:UnregisterForEvent(addonName, event)
end

HomeGroupPositions.Libs = {}
HomeGroupPositions.Libs.LibAddonMenu2 = {}

function HomeGroupPositions.Libs.LibAddonMenu2.RegisterAddonPanel(addonID, panelData)
    return LibAddonMenu2:RegisterAddonPanel(addonID, panelData)
end

function HomeGroupPositions.Libs.LibAddonMenu2.RegisterOptionControls(addonID, optionsTable)
    LibAddonMenu2:RegisterOptionControls(addonID, optionsTable)
end

HomeGroupPositions.Libs.LibDebugLogger = {}

function HomeGroupPositions.Libs.LibDebugLogger:Create(addonName)
    return LibDebugLogger:Create(addonName)
end

function HomeGroupPositions.Libs.LibDebugLogger.SetEnabled(logger, isEnabled)
    logger:SetEnabled(isEnabled)
end

function HomeGroupPositions.Libs.LibDebugLogger.Info(logger, message)
    logger:Info(message)
end

HomeGroupPositions.Libs.LibSlashCommander = {}

function HomeGroupPositions.Libs.LibSlashCommander.AddAlias(command, alias)
    command:AddAlias(alias)
end

function HomeGroupPositions.Libs.LibSlashCommander.Register(command, callback, description)
    return LibSlashCommander:Register(command, callback, description)
end

function HomeGroupPositions.Libs.LibSlashCommander.RegisterSubCommand(parentCommand)
    return parentCommand:RegisterSubCommand()
end

function HomeGroupPositions.Libs.LibSlashCommander.SetDescription(command, description)
    command:SetDescription(description)
end

function HomeGroupPositions.Libs.LibSlashCommander.SetCallback(command, callback)
    command:SetCallback(callback)
end
