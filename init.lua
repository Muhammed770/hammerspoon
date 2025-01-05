-- Author: @muhammed770
-- Source: https://github.com/Muhammed770/hammerspoon
-- Github Profile: https://github.com/Muhammed770
-- Description: This script disconnects a Bluetooth device when the system goes to sleep and reconnects it when the system wakes up.

local bluetoothDevice = "aa-bc-47-d3-ee-gg" -- MAC address of the Bluetooth device to connect/disconnect
local log = hs.logger.new("SleepWatcher", "debug")

local function isBluetoothPoweredOn()
    local output, status, type, rc = hs.execute("/opt/homebrew/bin/blueutil -p", false)
    log.i("Bluetooth power status: " .. output)
    output = output:gsub("%s+", "")

    return output == "1"
end

function handleSleepAndWake(eventType)
    local eventNames = {
        [1] = "System Will Power Off",
        [2] = "System Did Power On",
        [3] = "System Will Sleep",
        [4] = "System Did Wake",
        [10] = "Screens Did Sleep",
        [11] = "Screens Did Wake",
    }
    if eventType == hs.caffeinate.watcher.systemWillSleep then
        log.i("System is going to sleep. Attempting to disconnect Bluetooth device.")
        hs.execute("/opt/homebrew/bin/blueutil --unpair \"" .. bluetoothDevice .. "\"", false)
    elseif eventType == hs.caffeinate.watcher.systemDidWake then
        if (not isBluetoothPoweredOn()) then
            log.i("Bluetooth is powered off. Skipping reconnection.")
            return
        end
        log.i("System woke up. Attempting to reconnect Bluetooth device.")
        hs.execute("/opt/homebrew/bin/blueutil --pair \"" .. bluetoothDevice .. "\"", false)
    else
        log.i("Unhandled event type: " .. tostring(eventType) .. " (" .. (eventNames[eventType] or "Unknown") .. ")")
    end
end

caffeinateWatcher = hs.caffeinate.watcher.new(handleSleepAndWake)
caffeinateWatcher:start()
