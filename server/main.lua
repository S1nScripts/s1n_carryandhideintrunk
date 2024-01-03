local playersInTrunk = {}
local discordWebhook = ''
local botName = ''
local embedColor = '' -- Needs to be a decimal from. You can get decimal colors from spycolor.com

lib.locale()

RegisterNetEvent("s1n_carryandhideintrunk:carry", function (targetPlayerId)
    local source = source

    if targetPlayerId < 1 then return end -- Just in case someone tried triggering event with -1 

    local dist = #(GetEntityCoords(GetPlayerPed(targetPlayerId)) - GetEntityCoords(GetPlayerPed(source)))
    if dist > 10 then DropPlayer(source, 'Exploit') return end -- Its possible to trigger this server-side event from client and tp player so

    embeds = {
        {
            ["color"] = embedColor,
            ["title"] = locale('webhook_start_carry_title'),
            ["description"] = locale('webhook_start_carry_msg'),
            ["fields"] = {
                {
                    ["name"] = locale('webhook_lifter_name_and_id'),
                    ['value'] = GetPlayerName(source) .. ' **ID:**' .. source,
                    ['inline'] = true
                },
                {
                    ["name"] = locale('webhook_lifted_name_and_id'),
                    ['value'] = GetPlayerName(targetPlayerId) .. ' **ID:**' .. targetPlayerId,
                    ['inline'] = true
                },
                {
                    ["name"] = locale('webhook_distance_between_lifter_and_lifted'),
                    ['value'] = dist,
                    ['inline'] = true
                },
            },
            ["footer"] = {
                ["text"] = os.date('%d. %m. %Y  o %H:%M', os.time()),
            },
        }
    }
    PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', json.encode({username = botName, embeds = embeds}), { ['Content-Type'] = 'application/json' })
    TriggerClientEvent("s1n_carryandhideintrunk:carry", targetPlayerId, source)
end)

RegisterNetEvent("s1n_carryandhideintrunk:stopCarrying", function (targetPlayerId, networkTargetVehicleId)
    local source = source
    embeds = {
        {
            ["color"] = embedColor,
            ["title"] = locale('webhook_stop_carry_title'),
            ["description"] = locale('webhook_stop_carry_msg'),
            ["fields"] = {
                {
                    ["name"] = locale('webhook_lifter_name_and_id'),
                    ['value'] = GetPlayerName(source) .. ' **ID:**' .. source,
                    ['inline'] = true
                },
                {
                    ["name"] = locale('webhook_lifted_name_and_id'),
                    ['value'] = GetPlayerName(targetPlayerId) .. ' **ID:**' .. targetPlayerId,
                    ['inline'] = true
                },
            },
            ["footer"] = {
                ["text"] = os.date('%d. %m. %Y  o %H:%M', os.time()),
            },
        }
    }
    PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', json.encode({username = botName, embeds = embeds}), { ['Content-Type'] = 'application/json' })
    
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

    embeds = {
        {
            ["color"] = embedColor,
            ["title"] = locale('webhook_hide_in_trunk_title'),
            ["description"] = locale('webhook_hide_in_trunk_msg'),
            ["fields"] = {
                {
                    ["name"] = locale('webhook_hide_lifter'),
                    ['value'] = GetPlayerName(source) .. ' **ID:**' .. source,
                    ['inline'] = true
                },
                {
                    ["name"] = locale('webhook_hide_lifted'),
                    ['value'] = GetPlayerName(targetPlayerId) .. ' **ID:**' .. targetPlayerId,
                    ['inline'] = true
                },
                {
                    ["name"] = locale('webhook_hide_vehicle'),
                    ['value'] = networkTargetVehicleId,
                    ['inline'] = true
                },
            },
            ["footer"] = {
                ["text"] = os.date('%d. %m. %Y  o %H:%M', os.time()),
            },
        }
    }
    PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', json.encode({username = botName, embeds = embeds}), { ['Content-Type'] = 'application/json' })
    
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