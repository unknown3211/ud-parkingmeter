local QBCore = exports['qb-core']:GetCoreObject()
local paytype = "cash"
local amount = 50

RegisterServerEvent('payparking')
AddEventHandler('payparking', function(modelCoords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local moneyType = Player.Functions.GetMoney(paytype)
    
    if moneyType >= amount then
        Player.Functions.RemoveMoney(paytype, amount)
        TriggerClientEvent('QBCore:Notify', src, 'Payment Successful', 'success')
        TriggerClientEvent('parking:payed', src, modelCoords)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Not Enough Cash', 'error')
    end
end)