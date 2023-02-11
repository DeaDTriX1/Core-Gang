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


Citizen.CreateThread(function()
    if Bloods.jeveuxblips then
    local Bloodsmap = AddBlipForCoord(Bloods.pos.blips.position.x, Bloods.pos.blips.position.y, Bloods.pos.blips.position.z)
    SetBlipSprite(Bloodsmap, Bloods.Blips.Sprite)
    SetBlipColour(Bloodsmap, Bloods.Blips.Color)
    SetBlipScale(Bloodsmap, Bloods.Blips.Taille)
    SetBlipAsShortRange(Bloodsmap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Bloods.Blips.Name)
    EndTextCommandSetBlipName(Bloodsmap)
    end
end)


-- Marqueur du joueur

function MarquerJoueur()
    local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
    local pos = GetEntityCoords(ped)
    local target, distance = ESX.Game.GetClosestPlayer()
    if distance <= 4.0 then
    DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 0, 255, 170, 0, 1, 2, 1, nil, nil, 0)
end
end

function GetCloseVehi()
    local player = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)
    local vCoords = GetEntityCoords(vehicle)
    DrawMarker(2, vCoords.x, vCoords.y, vCoords.z + 1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 102, 0, 170, 0, 1, 2, 0, nil, nil, 0)
end

-- HANDCUFF

function LoadAnimDict(dictname)
    if not HasAnimDictLoaded(dictname) then
        RequestAnimDict(dictname) 
        while not HasAnimDictLoaded(dictname) do 
            Citizen.Wait(1)
        end
    end
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

function getPlayerInv(player)
    
Items = {}
Armes = {}
ArgentSale = {}
ArgentMoney = {}
ArgentBank = {}

ESX.TriggerServerCallback('Bloods:getOtherPlayerData', function(data)

    for i=1, #data.accounts, 1 do
        if data.accounts[i].name == 'bank' and data.accounts[i].money >= 0 then
            table.insert(ArgentBank, {
                label    = ESX.Math.Round(data.accounts[i].money),
                value    = 'bank',
                itemType = 'item_bank',
                amount   = data.accounts[i].money
            })
        end

         if data.accounts[i].name == 'money' and data.accounts[i].money >= 0 then
            table.insert(ArgentMoney, {
                label    = ESX.Math.Round(data.money),
                value    = 'money',
                itemType = 'item_money',
                amount   = data.money
            })
        end

        if data.accounts[i].name == 'black_money' and data.accounts[i].money >= 0 then
            table.insert(ArgentSale, {
                label    = ESX.Math.Round(data.accounts[i].money),
                value    = 'black_money',
                itemType = 'item_account',
                amount   = data.accounts[i].money
            })
        end
    end

    for i=1, #data.weapons, 1 do
        table.insert(Armes, {
            label    = ESX.GetWeaponLabel(data.weapons[i].name),
            value    = data.weapons[i].name,
            right    = data.weapons[i].ammo,
            itemType = 'item_weapon',
            amount   = data.weapons[i].ammo
        })
    end

    for i=1, #data.inventory, 1 do
        if data.inventory[i].count > 0 then
            table.insert(Items, {
                label    = data.inventory[i].label,
                right    = data.inventory[i].count,
                value    = data.inventory[i].name,
                itemType = 'item_standard',
                amount   = data.inventory[i].count
            })
        end
    end
end, GetPlayerServerId(player))
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end