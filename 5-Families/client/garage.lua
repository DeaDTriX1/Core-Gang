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

function GarageFamilies()
  local GarageFamilies = RageUI.CreateMenu("", "Voici les véhicule disponible", X, Y, "Gang", "Gang", nil, nil, nil, nil)
    RageUI.Visible(GarageFamilies, not RageUI.Visible(GarageFamilies))
        while GarageFamilies do
            Citizen.Wait(0)
                RageUI.IsVisible(GarageFamilies, true, true, true, function()

                    for k,v in pairs(VoitureFamilies) do
                    RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
                        if (Selected) then
                        Citizen.Wait(1)  
                            spawnuniCarFamilies(v.modele)
                            RageUI.CloseAll()
                            end
                        end)
                    end
                end, function()
                end)
            if not RageUI.Visible(GarageFamilies) then
            GarageFamilies = RMenu:DeleteType("Garage", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Families.Job then
            local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Families.pos.garage.position.x, Families.pos.garage.position.y, Families.pos.garage.position.z)
            if dist3 <= 2.0 and Families.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Families.pos.garage.position.x, Families.pos.garage.position.y, Families.pos.garage.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if dist3 <= 1.0 then
                Timer = 0   
                    RageUI.Text({ message = "Appuyez sur ~p~[E]~s~ pour accéder au garage", time_display = 1 })
                    if IsControlJustPressed(1,51) then           
                        GarageFamilies()
                    end   
                end
            end 
        Citizen.Wait(Timer)
     end
end)

Citizen.CreateThread(function()
        while true do
            local Timer = 5000
            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Families.Job then
            local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
            local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
            local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Families.pos.deleteveh.position.x, Families.pos.deleteveh.position.y, Families.pos.deleteveh.position.z)
            if dist3 <= 5.0 and Families.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Families.pos.deleteveh.position.x, Families.pos.deleteveh.position.y, Families.pos.deleteveh.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
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

function spawnuniCarFamilies(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    local vehicle = CreateVehicle(car, Families.pos.spawnvoiture.position.x, Families.pos.spawnvoiture.position.y, Families.pos.spawnvoiture.position.z, Families.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "Families"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(PlayerPedId(),vehicle,-1)
end