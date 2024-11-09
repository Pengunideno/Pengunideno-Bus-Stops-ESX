local busStops = {
    { location = vec3(56.99, -1540.62, 29.29), label = "Strawberry Avenue" },
    { location = vec3(788.67, -775.57, 26.42), label = "San Andreas Avenue" },
    { location = vec3(304.25, -764.83, 29.31), label = "Legion Square" },
}

local isTraveling = false

function isAtBusStop(busStop)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords.xyz - busStop.location.xyz)
    return distance < 2.0
end

function isNearBusStop()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, stop in ipairs(busStops) do
        local distance = #(playerCoords.xyz - stop.location.xyz)
        if distance < 1.5 then
            return true
        end
    end
    return false
end

function openBusStopMenu()
    lib.registerContext({
        id = 'Bus Stop Menu',
        title = "Bus stop",
        options = {
            {
                title = 'Strawberry Avenue',
                description = 'Travel to Strawberry Avenue',
                icon = 'map-marker',
                onSelect = function()
                    if not isAtBusStop(busStops[1]) then
                        TriggerServerEvent('penguineodoBus:chargePlayer', 100, busStops[1].label, busStops[1])
                    else
                        lib.notify({
                            title = "Bus Service",
                            description = "You are already at Strawberry Avenue!",
                            type = "error",
                            position = "top",
                            iconAnimation = "beat"
                        })
                    end
                end
            },
            {
                title = 'San Andreas Avenue',
                description = 'Travel to San Andreas Avenue',
                icon = 'map-marker',
                onSelect = function()
                    if not isAtBusStop(busStops[2]) then
                        TriggerServerEvent('penguineodoBus:chargePlayer', 100, busStops[2].label, busStops[2])
                    else
                        lib.notify({
                            title = "Bus Service",
                            description = "You are already at San Andreas Avenue!",
                            type = "error",
                            position = "top",
                            iconAnimation = "beat"
                        })
                    end
                end
            },
            {
                title = 'Legion Square',
                description = 'Travel to Legion Square',
                icon = 'map-marker',
                onSelect = function()
                    if not isAtBusStop(busStops[3]) then
                        TriggerServerEvent('penguineodoBus:chargePlayer', 100, busStops[3].label, busStops[3])
                    else
                        lib.notify({
                            title = "Bus Service",
                            description = "You are already at Legion Square!",
                            type = "error",
                            position = "top",
                            iconAnimation = "beat"
                        })
                    end
                end
            },
        }
    })
    lib.showContext('Bus Stop Menu')
end

function teleportPlayer(busStop)
    lib.hideTextUI()
    isTraveling = true

    DoScreenFadeOut(1000)
    Wait(1000)

    lib.progressBar({
        duration = 5000,
        label = "Traveling...",
        useWhileDead = false,
        canCancel = false,
        disableControls = {
            mouse = true,
            player = true,
            vehicle = true
        }
    })

    SetEntityCoordsNoOffset(PlayerPedId(), busStop.location.x, busStop.location.y, busStop.location.z, true, true, true)
    SetEntityHeading(PlayerPedId(), busStop.heading or 0.0)

    Wait(800)

    DoScreenFadeIn(1000)

    lib.showTextUI('[E] - Open Bus Stop Menu', {
        position = "top-center",
        icon = 'bus'
    })

    isTraveling = false

    lib.notify({
        title = "Bus Service",
        description = "You have arrived at " .. busStop.label,
        type = "success",
        position = "top"
    })
end

RegisterNetEvent('penguineodoBus:purchase')
AddEventHandler('penguineodoBus:purchase', function(amount, busStop)
    if busStop then
        lib.notify({
            title = "Bus Service",
            description = "You have been charged $" .. amount .. " for the bus ride to " .. busStop.label .. ". Enjoy your ride!",
            type = "success",
            position = "top"
        })
        teleportPlayer(busStop)
    else
        print("Error: busStop data is nil.")
    end
end)

RegisterNetEvent('penguineodoBus:notifyBrokeBoy')
AddEventHandler('penguineodoBus:notifyBrokeBoy', function()
    lib.notify({
        title = "Bus Service",
        description = "You have insufficient funds for the bus ride.",
        type = "error",
        position = "top"
    })
end)

CreateThread(function()
    local isNear = false;
    while true do
        Wait(0)

        isNear = isNearBusStop();
        
        if not isTraveling and isNear then
            lib.showTextUI('[E] - Open Bus Stop Menu', {
                position = "top-center",
                icon = 'bus'
            })
            if IsControlJustPressed(0, 38) then
                openBusStopMenu()
                lib.hideTextUI()
            end
        else
            lib.hideTextUI()
        end

        if not isNear then
            Wait(500)
        end
    end
end)