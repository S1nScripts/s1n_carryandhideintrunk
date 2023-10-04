RegisterNetEvent("s1n_carryandhideintrunk:carry", function (targetPlayerId)
    local source = source

    -- Avoid exploits
    if #(GetEntityCoords(GetPlayerPed(targetPlayerId)) - GetEntityCoords(GetPlayerPed(source))) > 10 then return end

    TriggerClientEvent("s1n_carryandhideintrunk:carry", targetPlayerId, source)
end)

RegisterNetEvent("s1n_carryandhideintrunk:stopCarrying", function (targetPlayerId)
    TriggerClientEvent("s1n_carryandhideintrunk:stopCarrying", targetPlayerId)
end)

RegisterNetEvent("s1n_carryandhideintrunk:hidePlayer", function (targetPlayerId, networkTargetVehicleId)
    local source = source

    -- Avoid exploits
    if #(GetEntityCoords(GetPlayerPed(targetPlayerId)) - GetEntityCoords(GetPlayerPed(source))) > 10 then return end

    TriggerClientEvent("s1n_carryandhideintrunk:hidePlayer", targetPlayerId, networkTargetVehicleId)
end)