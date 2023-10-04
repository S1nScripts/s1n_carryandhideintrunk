local inTrunk = false
local carrying = false
local carryingEntity

local beingCarried = false
local disableKeysTemporary = false


--
--- Functions
--


local function disableKeys()
    disableKeysTemporary = true

    Citizen.CreateThread(function()
        while disableKeysTemporary do
            Citizen.Wait(0)

            -- Can't loop it because it won't have the attended effect due to the wait time
            DisableControlAction(0, 77, true)
            DisableControlAction(0, 323, true)
            DisableControlAction(0, 20, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 29, true)
            DisableControlAction(0, 20, true)
            DisableControlAction(0, 26, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 46, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 74, true)
            DisableControlAction(0, 74, true)
            DisableControlAction(0, 7, true)
            DisableControlAction(0, 244, true)
            DisableControlAction(0, 249, true)
            DisableControlAction(0, 199, true)
            DisableControlAction(0, 44, true)
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 245, true)
            DisableControlAction(0, 303, true)
            DisableControlAction(0, 0, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 35, true)
            DisableControlAction(0, 77, true)
            DisableControlAction(0, 246, true)
            DisableControlAction(0, 20, true)
            DisableControlAction(0, 48, true)
            DisableControlAction(0, 49, true)
            DisableControlAction(0, 75, true)
            DisableControlAction(0, 144, true)
            DisableControlAction(0, 145, true)
            DisableControlAction(0, 185, true)
            DisableControlAction(0, 251, true)
        end
    end)
end

local function checkTrunkOpen(vehicle)
    local playerPedId = PlayerPedId()

    if GetVehicleDoorAngleRatio(vehicle, 5) >= 0.9 then
        if IsEntityVisible(playerPedId) then return end

        SetEntityVisible(playerPedId, true, false)
    else
        if not IsEntityVisible(playerPedId) then return end

        SetEntityVisible(playerPedId, false, false)
    end
end

local function startCheckTrunkOpenLoop()
    Citizen.CreateThread(function ()
        while inTrunk do
            Citizen.Wait(0)

            local vehicle = GetEntityAttachedTo(PlayerPedId())
            checkTrunkOpen(vehicle)
        end
    end)
end

local function hide(playerPedId, data)
    disableKeys()

    SetCarBootOpen(data.entity)
    SetEntityCollision(playerPedId, false, false)

    Wait(350)

    AttachEntityToEntity(playerPedId, data.entity, -1, 0.0, -1.8, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)

    RequestAnimDict("timetable@floyd@cryingonbed@base")

    while not HasAnimDictLoaded("timetable@floyd@cryingonbed@base") do
        Wait(0)
    end

    TaskPlayAnim(playerPedId, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)

    Wait(50)

    inTrunk = true

    Wait(1500)

    SetVehicleDoorShut(data.entity, 5, false)
    startCheckTrunkOpenLoop()

    Wait(250)

    SetEntityVisible(playerPedId, false, 0)
end

local function leaveTrunk(playerPedId, data)
    disableKeysTemporary = false

    SetCarBootOpen(data.entity)
    SetEntityCollision(playerPedId, true, true)

    Wait(750)

    inTrunk = false

    DetachEntity(playerPedId, true, true)
    ClearPedTasks(playerPedId)

    local behindPos = GetOffsetFromEntityInWorldCoords(data.entity, 0.0, -3.0, 0.0)


    SetEntityCoords(playerPedId, behindPos.x, behindPos.y, behindPos.z, true, true, true, false)

    Wait(250)

    SetVehicleDoorShut(data.entity, 5, false)

    Wait(250)

    SetEntityVisible(playerPedId, true, 0)
end

local function carryPlayer(data)
    if not data.entity then return print("data.entity: nil value") end

    carrying = true
    carryingEntity = data.entity

    RequestAnimDict("missfinale_c2mcs_1")

    while not HasAnimDictLoaded("missfinale_c2mcs_1") do
        Wait(0)
    end

    TriggerServerEvent("s1n_carryandhideintrunk:carry", GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))

    TaskPlayAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 8.0, -8.0, 100000, 49, 0, false, false, false)
    lib.showTextUI("[G] - Stop carrying")
end

local function hidePlayer(data)
    TriggerServerEvent("s1n_carryandhideintrunk:hidePlayer", GetPlayerServerId(NetworkGetPlayerIndexFromPed(carryingEntity)), NetworkGetNetworkIdFromEntity(data.entity))
end


--
--- Nets
--


RegisterNetEvent("s1n_carryandhideintrunk:carry", function(carrierId)
    beingCarried = true
    disableKeys()

    RequestAnimDict("nm")

    while not HasAnimDictLoaded("nm") do
        Wait(0)
    end

    -- Player carried
    local playerPedId = PlayerPedId()
    local carrier = GetPlayerPed(GetPlayerFromServerId(carrierId))
    if not carrier then return print("carrier: not found") end

    TaskPlayAnim(playerPedId, "nm", "firemans_carry", 8.0, -8.0, 100000, 33, 0, false, false, false)
    AttachEntityToEntity(playerPedId, carrier, 0, 0.26, 0.15, 0.63, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
end)


RegisterNetEvent("s1n_carryandhideintrunk:stopCarrying", function()
    beingCarried = false
    disableKeysTemporary = false

    DetachEntity(PlayerPedId(), true, false)
    ClearPedSecondaryTask(PlayerPedId())
end)

RegisterNetEvent("s1n_carryandhideintrunk:hidePlayer", function(vehicleId)
    local playerPedId = PlayerPedId()
    local vehicle = NetworkGetEntityFromNetworkId(vehicleId)
    if not vehicle then return print("vehicleId: entity not found") end

    disableKeys()

    DetachEntity(playerPedId, true, false)
    ClearPedSecondaryTask(playerPedId)

    SetCarBootOpen(vehicle)
    SetEntityCollision(playerPedId, false, false)

    Wait(350)

    AttachEntityToEntity(playerPedId, vehicle, -1, 0.0, -1.8, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)

    RequestAnimDict("timetable@floyd@cryingonbed@base")

    while not HasAnimDictLoaded("timetable@floyd@cryingonbed@base") do
        Wait(0)
    end

    TaskPlayAnim(playerPedId, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)

    Wait(50)


    Wait(1500)

    SetVehicleDoorShut(vehicle, 5, false)

    Wait(250)

    SetEntityVisible(playerPedId, false, 0)
    lib.showTextUI("[E] - Get out of the trunk")
end)

RegisterCommand("detach", function ()
    DetachEntity(PlayerPedId(), true, false)
    ClearPedSecondaryTask(PlayerPedId())
end, false)


--
--- ox_target interactions
--


exports["ox_target"]:addGlobalPlayer(
        {
            name = 'ox_target:carry',
            icon = 'fa-solid fa-car-rear',
            label = "Carry player",
            canInteract = function(entity, distance, coords, name, boneId)
                return true
            end,
            onSelect = function(data)
                carryPlayer(data)
            end
        }
)

exports["ox_target"]:addGlobalVehicle(
        {
            {
                name = 'ox_target:trunk:hide',
                icon = 'fa-solid fa-car-rear',
                label = "Put the person in the trunk",
                bones = 'boot',
                canInteract = function(entity, distance, coords, name, boneId)
                    if inTrunk then return end
                    if not carrying then return end

                    if GetVehicleDoorLockStatus(entity) > 1 then return end
                    if IsVehicleDoorDamaged(entity, 5) then return end
                    return #(coords - GetEntityBonePosition_2(entity, boneId)) < 0.9
                end,
                onSelect = function(data)
                    hidePlayer(data)
                end
            },
            {
                name = 'ox_target:trunk:hide',
                icon = 'fa-solid fa-car-rear',
                label = "Hide in trunk",
                bones = 'boot',
                canInteract = function(entity, distance, coords, name, boneId)
                    if inTrunk then return end
                    if carrying then return end
                    if beingCarried then return end

                    if GetVehicleDoorLockStatus(entity) > 1 then return end
                    if IsVehicleDoorDamaged(entity, 5) then return end
                    return #(coords - GetEntityBonePosition_2(entity, boneId)) < 0.9
                end,
                onSelect = function(data)
                    local playerPedId = PlayerPedId()

                    hide(playerPedId, data)
                end
            },
            {
                name = 'ox_target:trunk:leave',
                icon = 'fa-solid fa-car-rear',
                label = "Leave the trunk",
                bones = 'boot',
                canInteract = function(entity, distance, coords, name, boneId)
                    if not inTrunk then return end
                    if carrying then return end

                    if GetVehicleDoorLockStatus(entity) > 1 then return end
                    if IsVehicleDoorDamaged(entity, 5) then return end
                    return #(coords - GetEntityBonePosition_2(entity, boneId)) < 0.9
                end,
                onSelect = function(data)
                    local playerPedId = PlayerPedId()

                    leaveTrunk(playerPedId, data)
                end
            }
        }
)


--
-- Keybinds
--


lib.addKeybind({
    name = 'stopcarry',
    description = 'press G to stop carry',
    defaultKey = 'G',
    onPressed = function(self)
        if not carrying then return end

        TriggerServerEvent("s1n_carryandhideintrunk:stopCarrying", GetPlayerServerId(NetworkGetPlayerIndexFromPed(carryingEntity)))

        --DetachEntity(PlayerPedId(), true, false)
        ClearPedSecondaryTask(PlayerPedId())
        lib.hideTextUI()

    end,
})