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

function CoffreMarabunta()
    local CoffreMarabunta = RageUI.CreateMenu("", "Vos object", X, Y, "Gang", "Gang", nil, nil, nil, nil)
        RageUI.Visible(CoffreMarabunta, not RageUI.Visible(CoffreMarabunta))
            while CoffreMarabunta do
            Citizen.Wait(0)
            RageUI.IsVisible(CoffreMarabunta, true, true, true, function()

                RageUI.Separator("↓ Objet / Arme ↓")

                    RageUI.ButtonWithStyle("Retirer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            MarabuntaRetirerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            MarabuntaDeposerobjet()
                            RageUI.CloseAll()
                        end
                    end)
                end, function()
                end)
            if not RageUI.Visible(CoffreMarabunta) then
            CoffreMarabunta = RMenu:DeleteType("CoffreMarabunta", true)
        end
    end
end

Citizen.CreateThread(function()
        while true do
            local Timer = 500
            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Marabunta.Job then
            local plycrdjob = GetEntityCoords(PlayerPedId(), false)
            local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Marabunta.pos.coffre.position.x, Marabunta.pos.coffre.position.y, Marabunta.pos.coffre.position.z)
            if jobdist <= 2.0 and Marabunta.jeveuxmarker then
                Timer = 0
                DrawMarker(20, Marabunta.pos.coffre.position.x, Marabunta.pos.coffre.position.y, Marabunta.pos.coffre.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
                end
                if jobdist <= 1.0 then
                    Timer = 0
                        RageUI.Text({ message = "Appuyez sur ~p~[E]~s~ pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        CoffreMarabunta()
                    end   
                end
            end 
        Citizen.Wait(Timer)   
    end
end)

itemstock = {}
function MarabuntaRetirerobjet()
    local StockMarabunta = RageUI.CreateMenu("Coffre", "Marabunta", X, Y, "Gang", "Gang", nil, nil, nil, nil)
    ESX.TriggerServerCallback('Marabunta:getStockItems', function(items) 
    itemstock = items
   
    RageUI.Visible(StockMarabunta, not RageUI.Visible(StockMarabunta))
        while StockMarabunta do
            Citizen.Wait(0)
                RageUI.IsVisible(StockMarabunta, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count > 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", "", 2)
                                    TriggerServerEvent('Marabunta:getStockItem', v.name, tonumber(count))
                                    MarabuntaRetirerobjet()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(StockMarabunta) then
            StockMarabunta = RMenu:DeleteType("Coffre", true)
        end
    end
     end)
end

local PlayersItem = {}
function MarabuntaDeposerobjet()
    local StockPlayer = RageUI.CreateMenu("Coffre", "Marabunta", X, Y, "Gang", "Gang", nil, nil, nil, nil)
    ESX.TriggerServerCallback('Marabunta:getPlayerInventory', function(inventory)
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
                                            TriggerServerEvent('Marabunta:putStockItems', item.name, tonumber(count))
                                            MarabuntaDeposerobjet()
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
