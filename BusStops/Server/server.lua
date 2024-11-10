local function chargePlayer(source, price)
    if not source or not price or type(price) ~= 'number' or price <= 0 then return false end

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    if xPlayer.getMoney() >= price then	
        xPlayer.removeMoney(price)
        return true
    end

    return false
end

lib.callback.register('penguineodoBus:chargePlayer', chargePlayer)