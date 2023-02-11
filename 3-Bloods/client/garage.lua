ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

-- Garage

function GarageBloods()
  local GarageBloods = RageUI.CreateMenu("", "Voici les véhicule disponible", X, Y, "Gang", "Gang", nil, nil, nil, nil)
    RageUI.Visible(GarageBloods, not RageUI.Visible(GarageBloods))
        while GarageBloods do
            Citizen.Wait(0)
                RageUI.IsVisible(GarageBloods, true, true, true, function()

                    for k,v in pairs(VoitureBloods) do
                    RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                        Citizen.Wait(1)  
                            spawnuniCarBloods(v.modele)
                            RageUI.CloseAll()
                            end
                        end)
                    end
                end, function()
                end)
            if not RageUI.Visible(GarageBloods) then
            GarageBloods = RMenu:DeleteType("Garage", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Bloods.Job then
            local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Bloods.pos.garage.position.x, Bloods.pos.garage.position.y, Bloods.pos.garage.position.z)
            if dist3 <= 2.0 and Bloods.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Bloods.pos.garage.position.x, Bloods.pos.garage.position.y, Bloods.pos.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist3 <= 1.0 then
                Timer = 0   
                    RageUI.Text({ message = "Appuyez sur ~p~[E]~s~ pour accéder au garage", time_display = 1 })
                    if IsControlJustPressed(1,51) then           
                        GarageBloods()
                    end   
                end
            end 
        Citizen.Wait(Timer)
     end
end)

Citizen.CreateThread(function()
        while true do
            local Timer = 5000
            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Bloods.Job then
            local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
            local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Bloods.pos.deleteveh.position.x, Bloods.pos.deleteveh.position.y, Bloods.pos.deleteveh.position.z)
            if dist3 <= 5.0 and Bloods.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Bloods.pos.deleteveh.position.x, Bloods.pos.deleteveh.position.y, Bloods.pos.deleteveh.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist3 <= 3.0 then
                Timer = 0   
                    RageUI.Text({ message = "Appuyez sur ~p~[E]~s~ pour supprimée ton véhicule", time_display = 1 })
                    if IsControlJustPressed(1,51) then           
                        DeleteEntity(veh)
                    end   
                end
            end 
        Citizen.Wait(Timer)
     end
end)

function spawnuniCarBloods(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    local vehicle = CreateVehicle(car, Bloods.pos.spawnvoiture.position.x, Bloods.pos.spawnvoiture.position.y, Bloods.pos.spawnvoiture.position.z, Bloods.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "Bloods"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(PlayerPedId(),vehicle,-1)
end