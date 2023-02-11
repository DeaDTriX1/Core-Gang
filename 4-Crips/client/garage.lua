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

function GarageCrips()
  local GarageCrips = RageUI.CreateMenu("", "Voici les véhicule disponible", X, Y, "Gang", "Gang", nil, nil, nil, nil)
    RageUI.Visible(GarageCrips, not RageUI.Visible(GarageCrips))
        while GarageCrips do
            Citizen.Wait(0)
                RageUI.IsVisible(GarageCrips, true, true, true, function()

                    for k,v in pairs(VoitureCrips) do
                    RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                        Citizen.Wait(1)  
                            spawnuniCarCrips(v.modele)
                            RageUI.CloseAll()
                            end
                        end)
                    end
                end, function()
                end)
            if not RageUI.Visible(GarageCrips) then
            GarageCrips = RMenu:DeleteType("Garage", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Crips.Job then
            local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Crips.pos.garage.position.x, Crips.pos.garage.position.y, Crips.pos.garage.position.z)
            if dist3 <= 2.0 and Crips.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Crips.pos.garage.position.x, Crips.pos.garage.position.y, Crips.pos.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist3 <= 1.0 then
                Timer = 0   
                    RageUI.Text({ message = "Appuyez sur ~p~[E]~s~ pour accéder au garage", time_display = 1 })
                    if IsControlJustPressed(1,51) then           
                        GarageCrips()
                    end   
                end
            end 
        Citizen.Wait(Timer)
     end
end)

Citizen.CreateThread(function()
        while true do
            local Timer = 5000
            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Crips.Job then
            local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
            local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Crips.pos.deleteveh.position.x, Crips.pos.deleteveh.position.y, Crips.pos.deleteveh.position.z)
            if dist3 <= 5.0 and Crips.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Crips.pos.deleteveh.position.x, Crips.pos.deleteveh.position.y, Crips.pos.deleteveh.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
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

function spawnuniCarCrips(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    local vehicle = CreateVehicle(car, Crips.pos.spawnvoiture.position.x, Crips.pos.spawnvoiture.position.y, Crips.pos.spawnvoiture.position.z, Crips.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "Crips"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(PlayerPedId(),vehicle,-1)
end