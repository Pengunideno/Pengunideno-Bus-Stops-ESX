RegisterServerEvent('penguineodoBus:chargePlayer')
AddEventHandler('penguineodoBus:chargePlayer', function(amount, busStopLabel, busStopCoords)
    local player = ESX.GetPlayerFromId(source)
    local playerMoney = player.getMoney()
    local peggiAmnt = 100
    
    if playerMoney >= peggiAmnt then
        player.removeMoney(peggiAmnt)
        TriggerClientEvent('penguineodoBus:purchase', source, peggiAmnt, busStopCoords)
    else
        TriggerClientEvent('penguineodoBus:notifyBrokeBoy', source)
    end
end)