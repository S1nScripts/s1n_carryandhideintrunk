local playersInTrunk = {}

RegisterNetEvent("s1n_carryandhideintrunk:carry", function (targetPlayerId)
    local source = source

    if targetPlayerId < 1 then return end -- Just in case someone tried triggering event with -1 

    local dist = #(GetEntityCoords(GetPlayerPed(targetPlayerId)) - GetEntityCoords(GetPlayerPed(source)))
    if dist > 10 then DropPlayer(source, 'Exploit') return end -- Its possible to trigger this server-side event from client and tp player so

    TriggerClientEvent("s1n_carryandhideintrunk:carry", targetPlayerId, source)
end)

RegisterNetEvent("s1n_carryandhideintrunk:stopCarrying", function (targetPlayerId, networkTargetVehicleId)
    if  playersInTrunk[targetPlayerId] then
        playersInTrunk[targetPlayerId] = nil
    end

    TriggerClientEvent("s1n_carryandhideintrunk:stopCarrying", targetPlayerId, networkTargetVehicleId)
end)

RegisterNetEvent("s1n_carryandhideintrunk:hidePlayer", function (targetPlayerId, networkTargetVehicleId)
    local source = source

    if targetPlayerId < 1 then return end -- Just in case someone tried triggering event with -1 

    local dist = #(GetEntityCoords(GetPlayerPed(targetPlayerId)) - GetEntityCoords(GetPlayerPed(source)))
    if dist > 10 then DropPlayer(source, 'Exploit') return end -- Its possible to trigger this server-side event from client and tp player so

    playersInTrunk[targetPlayerId] = true
    TriggerClientEvent("s1n_carryandhideintrunk:hidePlayer", targetPlayerId, networkTargetVehicleId)
end)

RegisterNetEvent("s1n_carryandhideintrunk:addPlayerToTrunkListing", function (networkTargetVehicleId)
    if playersInTrunk[networkTargetVehicleId] then return end

    playersInTrunk[networkTargetVehicleId] = true
end)


RegisterNetEvent("s1n_carryandhideintrunk:removeMeFromTrunkListing", function (networkTargetVehicleId)
    local source = source

    if not playersInTrunk[networkTargetVehicleId] then return end

    playersInTrunk[networkTargetVehicleId] = nil
end)

--
--- Callbacks
--


lib.callback.register('s1n_carryandhideintrunk:checkEmptyTrunk', function(source, networkTargetVehicleId)
    return not playersInTrunk[networkTargetVehicleId]
end)


AddEventHandler("playerDropped", function ()
    local source = source

    if playersInTrunk[source] then
        playersInTrunk[source] = nil
    end
end)


---
---- Version check
---

lib.versionCheck('S1nScripts/s1n_carryandhideintrunk')