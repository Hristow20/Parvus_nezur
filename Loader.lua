-- Add this at the beginning of your script
local function safeLoadScript(scriptPath)
    local success, result = pcall(function()
        return loadstring(GetFile(scriptPath .. ".lua"), scriptPath)()
    end)
    
    if not success then
        warn("Failed to load script: " .. scriptPath)
        warn("Error: " .. tostring(result))
        return nil
    end
    
    return result
end

-- Replace your LoadScript function with this:
local function LoadScript(Script)
    local loaded = safeLoadScript(Script)
    if not loaded then
        warn("Failed to load " .. Script .. ". Falling back to Universal script.")
        return safeLoadScript("Universal")
    end
    return loaded
end

-- Modify your main loading logic:
Parvus.Utilities = safeLoadScript("Utilities/Main") or {}
Parvus.Utilities.UI = safeLoadScript("Utilities/UI") or {}
Parvus.Utilities.Physics = safeLoadScript("Utilities/Physics") or {}
Parvus.Utilities.Drawing = safeLoadScript("Utilities/Drawing") or {}

-- Add error checking before using loaded modules
if not Parvus.Utilities.UI or not Parvus.Utilities.UI.Push then
    warn("UI module not loaded correctly. Notifications may not work.")
else
    Parvus.Utilities.UI:Push({
        Title = "Parvus Hub",
        Description = "Loading scripts...",
        Duration = 3
    })
end

-- Add more robust error handling when loading the game-specific script
local success, result = pcall(function()
    return LoadScript(Parvus.Game.Script)
end)

if not success then
    warn("Failed to load game-specific script. Falling back to Universal.")
    LoadScript("Universal")
end

Parvus.Loaded = true

-- Final notification
if Parvus.Utilities.UI and Parvus.Utilities.UI.Push then
    Parvus.Utilities.UI:Push({
        Title = "Parvus Hub",
        Description = (Parvus.Game.Name or "Universal") .. " loaded!\n\nThis script is open sourced\nIf you have paid for this script\nOr had to go thru ads\nYou have been scammed.",
        Duration = NotificationTime
    })
else
    warn("Parvus Hub loaded. UI notifications not available.")
end
