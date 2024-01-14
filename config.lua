Config = {
    -- Set the keybind to stop carrying a player
    stopCarryKeybind = "G", -- Default keybind which can players change in settings
    leaveTrunkKeybind = "E", -- Default keybind which can players change in settings
    showPlayerInTrunk = false, -- Option to show player hiden in trunk
    allowCarryAsCommand = false, -- This option will allow /carry command. Target will be working too
    allowBlackout = false, -- This function allows player screen to be blackouted when trunk is closed if trunk opens player will see again.
}
--[[
    EXPORTS

    exports['s1n_carryandhideintrunk']:isPedOnCarry() - returns true if player is carried and false if not

]]--
