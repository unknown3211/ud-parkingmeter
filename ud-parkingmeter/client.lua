local model = 'prop_parknmeter_02'
local displaytime = 900000 -- 15mins
local paidMeters = {}

Citizen.CreateThread(function()
    exports["qb-target"]:AddTargetModel(model, { 
    options = { 
        { 
            type = "server", 
            event = "payparking", 
            icon = "fas fa-circle", 
            label = "Pay Parking ($50)", 
        }, 
    }, 
        distance = 1.0 
    })

    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        for coords, endTime in pairs(paidMeters) do
            if GetDistanceBetweenCoords(playerCoords, coords.x, coords.y, coords.z, true) < 10.0 then
                if GetGameTimer() < endTime then
                    Draw3DText(coords.x, coords.y, coords.z + 1.0, 'Paid', { r = 0, g = 255, b = 0 })
                else
                    paidMeters[coords] = nil
                end
            end
        end
    end
end)

RegisterNetEvent('parking:payed')
AddEventHandler('parking:payed', function(modelCoords)
    if modelCoords and type(modelCoords) == "table" and modelCoords.coords and modelCoords.coords.z then
        local coords = modelCoords.coords
        paidMeters[coords] = GetGameTimer() + displaytime
    end
end)

function Draw3DText(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end