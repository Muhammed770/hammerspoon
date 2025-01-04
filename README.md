# Hammerspoon Bluetooth Automation

This script automates the process of disconnecting a Bluetooth device when your system goes to sleep and reconnecting it when the system wakes up.

## Features
- Automatically disconnects the specified Bluetooth device when the system sleeps.
- Reconnects the Bluetooth device when the system wakes up.

## Requirements

### 1. Install Hammerspoon
- Use Homebrew: 
  ```sh
  brew install --cask hammerspoon
  ```
- Or download it from [Hammerspoon's website](https://www.hammerspoon.org/).

### 2. Install Blueutil
- Install via Homebrew:
  ```sh
  brew install blueutil
  ```

### 3. Configure the `init.lua` File
- Navigate to the `.hammerspoon` directory:
  ```sh
  cd ~/.hammerspoon/
  ```
- Edit (or create) the `init.lua` file and paste the following code:

  ```lua
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

  ```

### 4. Get Your Bluetooth Device MAC Address
- Run the following command to list paired devices:
  ```sh
  blueutil --paired
  ```
- Note the MAC address of your device and replace `"aa-bb-cc-11-22-33"` in the script above with your device's MAC address.

### 5. Allow Hammerspoon Access to Bluetooth
- Open **System Settings > Privacy & Security > Bluetooth**.
- Add **Hammerspoon** to the list of apps allowed to access Bluetooth.

## Troubleshooting
- If you encounter issues with the `blueutil` path, verify its location by running:
  ```sh
  which blueutil
  ```
- If the path differs from `/opt/homebrew/bin/blueutil`, update the path in the script accordingly.

## Notes
- Ensure both Hammerspoon and Blueutil are installed correctly.
- Test the script by manually putting the system to sleep and waking it up.
