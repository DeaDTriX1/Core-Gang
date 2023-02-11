ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societyBloodsmoney = nil
local societyblackBloodsmoney = nil

Citizen.CreateThread(function()
    ESX.TriggerServerCallback('Bloods:getBlackMoneySociety', function(inventory)
        argent = inventory
    end)
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job2 == nil do
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


RegisterNetEvent('esx:setjob')
AddEventHandler('esx:setjob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setjob2')
AddEventHandler('esx:setjob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

---------------- FONCTIONS ------------------

function BossBloods()
  local BloodsAction = RageUI.CreateMenu("", "Voici les action du BOSS", X, Y, "Gang", "Gang", nil, nil, nil, nil)
    RageUI.Visible(BloodsAction, not RageUI.Visible(BloodsAction))

            while BloodsAction do
                Citizen.Wait(0)
                    RageUI.IsVisible(BloodsAction, true, true, true, function()

                    if societyBloodsmoney ~= nil then
                        RageUI.ButtonWithStyle("Argent Gang :", nil, {RightLabel = "$" .. societyBloodsmoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Retirer argent de Gang",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = KeyboardInput("Montant", "", 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                RageUI.Popup({message = "Montant invalide"})
                            else
                                TriggerServerEvent('five_banque:retraitentreprise', amount, Bloods.Job)
                                RefreshBloodsMoney()
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Déposer argent de Gang",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = KeyboardInput("Montant", "", 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                RageUI.Popup({message = "Montant invalide"})
                            else
                                TriggerServerEvent('five_banque:depotentreprise', amount, Bloods.Job)
                                RefreshBloodsMoney()
                            end
                        end
                    end) 

                    RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ActionBossBloods()
                            RageUI.CloseAll()
                        end
                    end)

                        RageUI.Separator("↓ Argent Sale ↓")
            

                        if societyblackBloodsmoney ~= nil then
                            RageUI.ButtonWithStyle("Argent sale : ", nil, {RightLabel = "$" .. societyblackBloodsmoney}, true, function()
                            end)
                        end
    
                        RageUI.ButtonWithStyle("Déposer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                    local count = KeyboardInput("Combien ?", "", 100)
                                    TriggerServerEvent('Bloods:putblackmoney', 'item_account', 'black_money', tonumber(count))
                                    Deposerargentsale()
                                    ESX.TriggerServerCallback('Bloods:getBlackMoneySociety', function(inventory) 
                                end)
                                RefreshblackBloodsMoney()
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Retirer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local count = KeyboardInput("Combien ?", "", 100)
                                ESX.TriggerServerCallback('Bloods:getBlackMoneySociety', function(inventory) 
                                TriggerServerEvent('Bloods:getItem', 'item_account', 'black_money', tonumber(count))
                                Retirerargentsale()
                                RefreshblackBloodsMoney()
                                end)
                            end
                        end)
                    end, function()
                end)
            if not RageUI.Visible(BloodsAction) then
            BloodsAction = RMenu:DeleteType("Actions Patron", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 1000
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Bloods.Job and ESX.PlayerData.job2.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Bloods.pos.boss.position.x, Bloods.pos.boss.position.y, Bloods.pos.boss.position.z)
        if dist3 <= 3.0 and Bloods.jeveuxmarker then
            Timer = 0
            DrawMarker(20, Bloods.pos.boss.position.x, Bloods.pos.boss.position.y, Bloods.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~p~[E]~s~ pour accéder aux actions patron", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        RefreshBloodsMoney()   
                        RefreshblackBloodsMoney()        
                        BossBloods()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshBloodsMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('five_society:getSocietyMoney', function(money)
            UpdateSocietyBloodsMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function RefreshblackBloodsMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('Bloods:getBlackMoneySociety', function(inventory)
            UpdateSocietyblackBloodsMoney(inventory)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietyblackBloodsMoney(inventory)
    societyblackBloodsmoney = ESX.Math.GroupDigits(inventory.blackMoney)
end

function UpdateSocietyBloodsMoney(money)
    societyBloodsmoney = ESX.Math.GroupDigits(money)
end

function ActionBossBloods()
    TriggerEvent('five_society', Bloods.Job, false, false)
end

function Deposerargentsale()
    ESX.TriggerServerCallback('Bloods:getPlayerInventoryBlack', function(inventory)
        while DepositBlackBloods do
            Citizen.Wait(0)
        end
    end)
end

function Retirerargentsale()
	ESX.TriggerServerCallback('Bloods:getBlackMoneySociety', function(inventory)
	    while StockBlackBloods do
		    Citizen.Wait(0)
	    end
    end)
end
