ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societyBallasmoney = nil
local societyblackBallasmoney = nil

Citizen.CreateThread(function()
    ESX.TriggerServerCallback('Ballas:getBlackMoneySociety', function(inventory)
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

function BossBallas()
  local BallasAction = RageUI.CreateMenu("", "Voici les action du BOSS", X, Y, "Gang", "Gang", nil, nil, nil, nil)
    RageUI.Visible(BallasAction, not RageUI.Visible(BallasAction))

            while BallasAction do
                Citizen.Wait(0)
                    RageUI.IsVisible(BallasAction, true, true, true, function()

                    if societyBallasmoney ~= nil then
                        RageUI.ButtonWithStyle("Argent Gang :", nil, {RightLabel = "$" .. societyBallasmoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Retirer argent de Gang",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = KeyboardInput("Montant", "", 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                RageUI.Popup({message = "Montant invalide"})
                            else
                                TriggerServerEvent('five_banque:retraitentreprise', amount, Ballas.Job)
                                RefreshBallasMoney()
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
                                TriggerServerEvent('five_banque:depotentreprise', amount, Ballas.Job)
                                RefreshBallasMoney()
                            end
                        end
                    end) 

                    RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ActionBossBallas()
                            RageUI.CloseAll()
                        end
                    end)

                        RageUI.Separator("↓ Argent Sale ↓")
            

                        if societyblackBallasmoney ~= nil then
                            RageUI.ButtonWithStyle("Argent sale : ", nil, {RightLabel = "$" .. societyblackBallasmoney}, true, function()
                            end)
                        end
    
                        RageUI.ButtonWithStyle("Déposer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                    local count = KeyboardInput("Combien ?", "", 100)
                                    TriggerServerEvent('Ballas:putblackmoney', 'item_account', 'black_money', tonumber(count))
                                    Deposerargentsale()
                                    ESX.TriggerServerCallback('Ballas:getBlackMoneySociety', function(inventory) 
                                end)
                                RefreshblackBallasMoney()
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Retirer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local count = KeyboardInput("Combien ?", "", 100)
                                ESX.TriggerServerCallback('Ballas:getBlackMoneySociety', function(inventory) 
                                TriggerServerEvent('Ballas:getItem', 'item_account', 'black_money', tonumber(count))
                                Retirerargentsale()
                                RefreshblackBallasMoney()
                                end)
                            end
                        end)
                    end, function()
                end)
            if not RageUI.Visible(BallasAction) then
            BallasAction = RMenu:DeleteType("Actions Patron", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 1000
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Ballas.Job and ESX.PlayerData.job2.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Ballas.pos.boss.position.x, Ballas.pos.boss.position.y, Ballas.pos.boss.position.z)
        if dist3 <= 3.0 and Ballas.jeveuxmarker then
            Timer = 0
            DrawMarker(20, Ballas.pos.boss.position.x, Ballas.pos.boss.position.y, Ballas.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~p~[E]~s~ pour accéder aux actions patron", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        RefreshBallasMoney()   
                        RefreshblackBallasMoney()        
                        BossBallas()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshBallasMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('five_society:getSocietyMoney', function(money)
            UpdateSocietyBallasMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function RefreshblackBallasMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('Ballas:getBlackMoneySociety', function(inventory)
            UpdateSocietyblackBallasMoney(inventory)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietyblackBallasMoney(inventory)
    societyblackBallasmoney = ESX.Math.GroupDigits(inventory.blackMoney)
end

function UpdateSocietyBallasMoney(money)
    societyBallasmoney = ESX.Math.GroupDigits(money)
end

function ActionBossBallas()
    TriggerEvent('five_society', Ballas.Job, false, false)
end

function Deposerargentsale()
    ESX.TriggerServerCallback('Ballas:getPlayerInventoryBlack', function(inventory)
        while DepositBlackBallas do
            Citizen.Wait(0)
        end
    end)
end

function Retirerargentsale()
	ESX.TriggerServerCallback('Ballas:getBlackMoneySociety', function(inventory)
	    while StockBlackBallas do
		    Citizen.Wait(0)
	    end
    end)
end
