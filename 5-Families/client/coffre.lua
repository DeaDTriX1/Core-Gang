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

function CoffreFamilies()
    local CoffreFamilies = RageUI.CreateMenu("", "Vos object", X, Y, "Gang", "Gang", nil, nil, nil, nil)
        RageUI.Visible(CoffreFamilies, not RageUI.Visible(CoffreFamilies))
            while CoffreFamilies do
            Citizen.Wait(0)
            RageUI.IsVisible(CoffreFamilies, true, true, true, function()

                RageUI.Separator("↓ Objet / Arme ↓")

                    RageUI.ButtonWithStyle("Retirer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            FamiliesRetirerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            FamiliesDeposerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                end, function()
                end)
            if not RageUI.Visible(CoffreFamilies) then
            CoffreFamilies = RMenu:DeleteType("CoffreFamilies", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Families.Job then
            local plycrdjob = GetEntityCoords(PlayerPedId(), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Families.pos.coffre.position.x, Families.pos.coffre.position.y, Families.pos.coffre.position.z)
            if jobdist <= 2.0 and Families.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Families.pos.coffre.position.x, Families.pos.coffre.position.y, Families.pos.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~p~[E]~s~ pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        CoffreFamilies()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)

itemstock = {}
function FamiliesRetirerobjet()
    local StockFamilies = RageUI.CreateMenu("Coffre", "Families", X, Y, "Gang", "Gang", nil, nil, nil, nil)
    ESX.TriggerServerCallback('Families:getStockItems', function(items) 
    itemstock = items
   
    RageUI.Visible(StockFamilies, not RageUI.Visible(StockFamilies))
        while StockFamilies do
            Citizen.Wait(0)
                RageUI.IsVisible(StockFamilies, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count > 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", "", 2)
                                    TriggerServerEvent('Families:getStockItem', v.name, tonumber(count))
                                    FamiliesRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(StockFamilies) then
            StockFamilies = RMenu:DeleteType("Coffre", true)
        end
    end
     end)
end

local PlayersItem = {}
function FamiliesDeposerobjet()
    local StockPlayer = RageUI.CreateMenu("Coffre", "Families", X, Y, "Gang", "Gang", nil, nil, nil, nil)
    ESX.TriggerServerCallback('Families:getPlayerInventory', function(inventory)
        RageUI.Visible(StockPlayer, not RageUI.Visible(StockPlayer))
    while StockPlayer do
        Citizen.Wait(0)
            RageUI.IsVisible(StockPlayer, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                         local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('Families:putStockItems', item.name, tonumber(count))
                                            FamiliesDeposerobjet()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(StockPlayer) then
                StockPlayer = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end
