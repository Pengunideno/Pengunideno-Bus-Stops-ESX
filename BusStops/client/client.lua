local isTraveling = false

local function notify(message, type)
    lib.notify({
        title = 'Bus Service',
        description = message,
        type = type,
        position = 'top'
    })
end

local function teleportPlayer(location, label)
    if isTraveling then return end
    isTraveling = true

    lib.hideTextUI()
    DoScreenFadeOut(1000)
    Wait(1000)

    if not lib.progressBar({
        duration = 5000,
        label = 'Traveling...',
        useWhileDead = false,
        canCancel = false,
        disableControls = { mouse = true, player = true, vehicle = true }
    }) then
        isTraveling = false
        return
    end

    RequestCollisionAtCoord(location.x, location.y, location.z)
    local startTime = GetGameTimer()
    while not HasCollisionLoadedAroundEntity(cache.ped) and GetGameTimer() - startTime < 15000 do
        Wait(50)
    end

    SetEntityCoordsNoOffset(cache.ped, location.x, location.y, location.z + 0.05, false, false, true)
    SetEntityHeading(cache.ped, 50.0)
    Wait(800)
    DoScreenFadeIn(1000)

    lib.showTextUI('[E] - Open Bus Stop Menu', { position = "top-center", icon = 'bus' })
    isTraveling = false
    notify("You've arrived at " .. label, 'success')
end

local function handleBusTravel(stop)
    if #(cache.coords - stop.location) < 2.0 then
        notify("You're already at " .. stop.label, 'error')
        return
    end

    if not lib.callback.await('penguineodoBus:chargePlayer', false, stop.price) then
        notify("Insufficient funds for the bus ride.", 'error')
        return
    end

    notify("Charged $" .. stop.price .. " for the bus ride to " .. stop.label, 'success')
    teleportPlayer(stop.location, stop.label)
end

local function initializeBusStops()
    local options = {}

    for _, stop in ipairs(busStops) do
        options[#options + 1] = {
            title = stop.label,
            description = 'Travel to ' .. stop.label,
            icon = 'map-marker',
            onSelect = function()
                if cache.vehicle then
                    notify("You can't use this while in a vehicle.", 'error')
                else
                    handleBusTravel(stop)
                end
            end
        }

        lib.points.new({
            coords = stop.location,
            distance = 2.0,
            onEnter = function()
                lib.showTextUI('[E] - Open Bus Stop Menu', { position = 'top-center', icon = 'bus' })
            end,
            onExit = lib.hideTextUI,
            nearby = function()
                if IsControlJustPressed(0, 38) and not cache.vehicle then
                    lib.showContext('busStop')
                end
            end
        })
    end

    lib.registerContext({
        id = 'busStop',
        title = 'Bus Stop',
        options = options
    })
end

SetTimeout(1000, initializeBusStops)