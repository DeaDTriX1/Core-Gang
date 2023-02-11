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


IsHandcuffed, DragStatus = false, {}
DragStatus.IsDragged     = false

-- HANDCUFF

function LoadAnimDict(dictname)
    if not HasAnimDictLoaded(dictname) then
        RequestAnimDict(dictname) 
        while not HasAnimDictLoaded(dictname) do 
            Citizen.Wait(1)
        end
    end
end

RegisterNetEvent('Ballas:mettreM')
AddEventHandler('Ballas:mettreM', function(playerheading, playercoords, playerlocation)
    playerPed = PlayerPedId()
    SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
    SetPedCanPlayGestureAnims(playerPed, false)
    DisablePlayerFiring(playerPed, true)
    DisplayRadar(false)
    local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
    Wait(500)
    SetEntityCoords(PlayerPedId(), x, y, z)
    SetEntityHeading(PlayerPedId(), playerheading)
    Wait(250)
    LoadAnimDict('mp_arrest_paired')
    TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
    Wait(3760)
    IsHandcuffed = true
    LoadAnimDict('mp_arresting')
    TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)

RegisterNetEvent('Ballas:animarrest')
AddEventHandler('Ballas:animarrest', function()
    Wait(250)
    LoadAnimDict('mp_arrest_paired')
    TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
    Wait(3000)
end) 

RegisterNetEvent('Ballas:enleverM')
AddEventHandler('Ballas:enleverM', function(playerheading, playercoords, playerlocation)
    local x, y, z   = table.unpack(playercoords + playerlocation)
    SetEntityCoords(PlayerPedId(), x, y, z)
    FreezeEntityPosition(playerPed, false)
    SetEntityHeading(PlayerPedId(), playerheading)
    SetPedCanPlayGestureAnims(playerPed, true)
    DisablePlayerFiring(playerPed, false)
    DisplayRadar(true)
    Wait(250)
    LoadAnimDict('mp_arresting')
    TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
    Wait(5500)
    IsHandcuffed = false
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('Ballas:animenlevermenottes')
AddEventHandler('Ballas:animenlevermenottes', function()
    Wait(250)
    LoadAnimDict('mp_arresting')
    TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
    Wait(5500)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('Ballas:putInVehicle')
AddEventHandler('Ballas:putInVehicle', function()
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    if not IsHandcuffed then
        return
    end
    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        if DoesEntityExist(vehicle) then
            local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
            local freeSeat = nil
            for i=maxSeats - 1, 0, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    freeSeat = i
                    break
                end
            end
            if freeSeat ~= nil then
                TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
                DragStatus.IsDragged = false
            end
        end
    end
end)

RegisterNetEvent('Ballas:OutVehicle')
AddEventHandler('Ballas:OutVehicle', function()
    local playerPed = PlayerPedId()

    if not IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    local vehicle = GetVehiclePedIsIn(playerPed, false)
    TaskLeaveVehicle(playerPed, vehicle, 16)
end)

RegisterNetEvent('Ballas:drag1')
AddEventHandler('Ballas:drag1', function(copID)
    if not IsHandcuffed then
        return
    end
    DragStatus.IsDragged = not DragStatus.IsDragged
    DragStatus.CopId     = tonumber(copID)
end)

Citizen.CreateThread(function()
    local playerPed
    local targetPed

    while true do
        Wait(7)

        if IsHandcuffed then
            playerPed = PlayerPedId()
            
            DisableControlAction(0, 1, true) -- Disable pan
            DisableControlAction(0, 2, true) -- Disable tilt
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon
            DisableControlAction(0, 23, true) -- Also 'enter'?
            DisableControlAction(0, 288,  true) -- Disable phone
            DisableControlAction(0, 289, true) -- Inventory
            DisableControlAction(0, 170, true) -- Animations
            DisableControlAction(0, 167, true) -- Job
            DisableControlAction(0, 0, true) -- Disable changing view
            DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true) -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen
            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle
            DisableControlAction(2, 36, true) -- Disable going stealth
            DisableControlAction(0, 47, true)  -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true)  -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
            
            if DragStatus.IsDragged then
                targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))
                -- undrag if target is in an vehicle
                if not IsPedSittingInAnyVehicle(targetPed) then
                    AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                else
                    DragStatus.IsDragged = false
                    DetachEntity(playerPed, true, false)
                end
            else
                DetachEntity(playerPed, true, false)
            end
        else
            Wait(500)
        end
    end
end)