# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

An Elder Scrolls Online (ESO) addon that shares each group member's position and heading while inside a player house. It is written in Lua and packaged for installation into the ESO AddOns directory.

## Build, install, and test

All build commands use PowerShell via `make.ps1` at the repo root.

```powershell
# Build only (src → obj → dist zip)
./make.ps1 -Verbose

# Build and install to the local ESO AddOns directory
./make.ps1 -Verbose -Install

# Clean build artifacts (obj/ and dist/)
./make.ps1 -Verbose -Clean

# Uninstall from ESO AddOns directory
./make.ps1 -Verbose -Uninstall
```

Version metadata is read from `build-info.ini`. Build tokens in source files (`[SEMANTIC_VERSION]`, `[PACKED_VERSION]`, `[API_VERSION]`, `[SCHEMA_VERSION]`, etc.) are replaced during the build step — **never edit files in `obj/` directly**.

Tests use the [busted](https://lunarmodules.github.io/busted/) framework and run against the built output in `obj/`:

```powershell
# Run all tests
busted

# Run a single spec file
busted spec/SavedVariables_spec.lua
```

The `spec/helper.lua` sets `package.path` to `./obj/HomeGroupPositions/?.lua`, so tests require a build before running.

## Architecture

### Initialization order

Files are loaded by ESO in the order listed in `HomeGroupPositions.addon`. The global `HomeGroupPositions` table is created in `Class.lua`, then the remaining modules attach themselves as sub-tables before `Initialize.lua` calls `HomeGroupPositions:Initialize()` as the final step.

### Settings / SavedVariables split

- `Settings.lua` holds the canonical defaults and live values (`HomeGroupPositions.Settings.serverSpecific`).
- `SavedVariables.lua` handles persistence: on load it calls `ZO_SavedVars:NewAccountWide` and copies values into `Settings.serverSpecific`; on logout/reload/quit it copies them back and saves. Schema migration is handled in `SavedVariables:Load()`.

### UI

The window layout is defined in `UI.xml` and manipulated from `UI.lua`. `SettingsUI.lua` creates the LibAddonMenu panel.

### Slash commands

Registered in `HomeGroupPositions:CreateSlashCommands()` using LibSlashCommander. The root command toggles the window; sub-commands are `enable`, `disable`, `show`, and `hide`.
