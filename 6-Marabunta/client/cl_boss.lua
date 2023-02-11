ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societyMarabuntamoney = nil
local societyblackMarabuntamoney = nil

Citizen.CreateThread(function()
    ESX.TriggerServerCallback('Marabunta:getBlackMoneySociety', function(inventory)
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

function BossMarabunta()
  local MarabuntaAction = RageUI.CreateMenu("", "Voici les action du BOSS", X, Y, "Gang", "Gang", nil, nil, nil, nil)
    RageUI.Visible(MarabuntaAction, not RageUI.Visible(MarabuntaAction))

            while MarabuntaAction do
                Citizen.Wait(0)
                    RageUI.IsVisible(MarabuntaAction, true, true, true, function()

                    if societyMarabuntamoney ~= nil then
                        RageUI.ButtonWithStyle("Argent Gang :", nil, {RightLabel = "$" .. societyMarabuntamoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Retirer argent de Gang",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = KeyboardInput("Montant", "", 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                RageUI.Popup({message = "Montant invalide"})
                            else
                                TriggerServerEvent('five_banque:retraitentreprise', amount, Marabunta.Job)
                                RefreshMarabuntaMoney()
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
                                TriggerServerEvent('five_banque:depotentreprise', amount, Marabunta.Job)
                                RefreshMarabuntaMoney()
                            end
                        end
                    end) 

                    RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ActionBossMarabunta()
                            RageUI.CloseAll()
                        end
                    end)

                        RageUI.Separator("↓ Argent Sale ↓")
            

                        if societyblackMarabuntamoney ~= nil then
                            RageUI.ButtonWithStyle("Argent sale : ", nil, {RightLabel = "$" .. societyblackMarabuntamoney}, true, function()
                            end)
                        end
    
                        RageUI.ButtonWithStyle("Déposer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                    local count = KeyboardInput("Combien ?", "", 100)
                                    TriggerServerEvent('Marabunta:putblackmoney', 'item_account', 'black_money', tonumber(count))
                                    Deposerargentsale()
                                    ESX.TriggerServerCallback('Marabunta:getBlackMoneySociety', function(inventory) 
                                end)
                                RefreshblackMarabuntaMoney()
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Retirer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local count = KeyboardInput("Combien ?", "", 100)
                                ESX.TriggerServerCallback('Marabunta:getBlackMoneySociety', function(inventory) 
                                TriggerServerEvent('Marabunta:getItem', 'item_account', 'black_money', tonumber(count))
                                Retirerargentsale()
                                RefreshblackMarabuntaMoney()
                                end)
                            end
                        end)
                    end, function()
                end)
            if not RageUI.Visible(MarabuntaAction) then
            MarabuntaAction = RMenu:DeleteType("Actions Patron", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 1000
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Marabunta.Job and ESX.PlayerData.job2.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Marabunta.pos.boss.position.x, Marabunta.pos.boss.position.y, Marabunta.pos.boss.position.z)
        if dist3 <= 3.0 and Marabunta.jeveuxmarker then
            Timer = 0
            DrawMarker(20, Marabunta.pos.boss.position.x, Marabunta.pos.boss.position.y, Marabunta.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~p~[E]~s~ pour accéder aux actions patron", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        RefreshMarabuntaMoney()   
                        RefreshblackMarabuntaMoney()        
                        BossMarabunta()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshMarabuntaMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('five_society:getSocietyMoney', function(money)
            UpdateSocietyMarabuntaMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function RefreshblackMarabuntaMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('Marabunta:getBlackMoneySociety', function(inventory)
            UpdateSocietyblackMarabuntaMoney(inventory)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietyblackMarabuntaMoney(inventory)
    societyblackMarabuntamoney = ESX.Math.GroupDigits(inventory.blackMoney)
end

function UpdateSocietyMarabuntaMoney(money)
    societyMarabuntamoney = ESX.Math.GroupDigits(money)
end

function ActionBossMarabunta()
    TriggerEvent('five_society', Marabunta.Job, false, false)
end

function Deposerargentsale()
    ESX.TriggerServerCallback('Marabunta:getPlayerInventoryBlack', function(inventory)
        while DepositBlackMarabunta do
            Citizen.Wait(0)
        end
    end)
end

function Retirerargentsale()
	ESX.TriggerServerCallback('Marabunta:getBlackMoneySociety', function(inventory)
	    while StockBlackMarabunta do
		    Citizen.Wait(0)
	    end
    end)
end
