-- Author: @muhammed770
-- Source: https://github.com/Muhammed770/hammerspoon
-- Github Profile: https://github.com/Muhammed770
-- Description: This script disconnects a Bluetooth device when the system goes to sleep and reconnects it when the system wakes up.


local bluetoothDevice = "aa-bb-cc-11-22-33" -- MAC address of the Bluetooth device to connect/disconnect
local log = hs.logger.new("SleepWatcher", "debug") 

function handleSleepAndWake(eventType)
    if eventType == hs.caffeinate.watcher.systemWillSleep then
        log.i("System is going to sleep. Attempting to disconnect Bluetooth device.")
        hs.execute("/opt/homebrew/bin/blueutil --disconnect \"" .. bluetoothDevice .. "\"", false)
    elseif eventType == hs.caffeinate.watcher.systemDidWake then
        log.i("System woke up. Attempting to reconnect Bluetooth device.")
        hs.execute("/opt/homebrew/bin/blueutil --connect \"" .. bluetoothDevice .. "\"", false)
    end
end

caffeinateWatcher = hs.caffeinate.watcher.new(handleSleepAndWake)
caffeinateWatcher:start()
