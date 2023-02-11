ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societyCripsmoney = nil
local societyblackCripsmoney = nil

Citizen.CreateThread(function()
    ESX.TriggerServerCallback('Crips:getBlackMoneySociety', function(inventory)
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

function BossCrips()
  local CripsAction = RageUI.CreateMenu("", "Voici les action du BOSS", X, Y, "Gang", "Gang", nil, nil, nil, nil)
    RageUI.Visible(CripsAction, not RageUI.Visible(CripsAction))

            while CripsAction do
                Citizen.Wait(0)
                    RageUI.IsVisible(CripsAction, true, true, true, function()

                    if societyCripsmoney ~= nil then
                        RageUI.ButtonWithStyle("Argent Gang :", nil, {RightLabel = "$" .. societyCripsmoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Retirer argent de Gang",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = KeyboardInput("Montant", "", 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                RageUI.Popup({message = "Montant invalide"})
                            else
                                TriggerServerEvent('five_banque:retraitentreprise', amount, Crips.Job)
                                RefreshCripsMoney()
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
                                TriggerServerEvent('five_banque:depotentreprise', amount, Crips.Job)
                                RefreshCripsMoney()
                            end
                        end
                    end) 

                    RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ActionBossCrips()
                            RageUI.CloseAll()
                        end
                    end)

                        RageUI.Separator("↓ Argent Sale ↓")
            

                        if societyblackCripsmoney ~= nil then
                            RageUI.ButtonWithStyle("Argent sale : ", nil, {RightLabel = "$" .. societyblackCripsmoney}, true, function()
                            end)
                        end
    
                        RageUI.ButtonWithStyle("Déposer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                    local count = KeyboardInput("Combien ?", "", 100)
                                    TriggerServerEvent('Crips:putblackmoney', 'item_account', 'black_money', tonumber(count))
                                    Deposerargentsale()
                                    ESX.TriggerServerCallback('Crips:getBlackMoneySociety', function(inventory) 
                                end)
                                RefreshblackCripsMoney()
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Retirer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local count = KeyboardInput("Combien ?", "", 100)
                                ESX.TriggerServerCallback('Crips:getBlackMoneySociety', function(inventory) 
                                TriggerServerEvent('Crips:getItem', 'item_account', 'black_money', tonumber(count))
                                Retirerargentsale()
                                RefreshblackCripsMoney()
                                end)
                            end
                        end)
                    end, function()
                end)
            if not RageUI.Visible(CripsAction) then
            CripsAction = RMenu:DeleteType("Actions Patron", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 1000
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Crips.Job and ESX.PlayerData.job2.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Crips.pos.boss.position.x, Crips.pos.boss.position.y, Crips.pos.boss.position.z)
        if dist3 <= 3.0 and Crips.jeveuxmarker then
            Timer = 0
            DrawMarker(20, Crips.pos.boss.position.x, Crips.pos.boss.position.y, Crips.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~p~[E]~s~ pour accéder aux actions patron", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        RefreshCripsMoney()   
                        RefreshblackCripsMoney()        
                        BossCrips()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshCripsMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('five_society:getSocietyMoney', function(money)
            UpdateSocietyCripsMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function RefreshblackCripsMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('Crips:getBlackMoneySociety', function(inventory)
            UpdateSocietyblackCripsMoney(inventory)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietyblackCripsMoney(inventory)
    societyblackCripsmoney = ESX.Math.GroupDigits(inventory.blackMoney)
end

function UpdateSocietyCripsMoney(money)
    societyCripsmoney = ESX.Math.GroupDigits(money)
end

function ActionBossCrips()
    TriggerEvent('five_society', Crips.Job, false, false)
end

function Deposerargentsale()
    ESX.TriggerServerCallback('Crips:getPlayerInventoryBlack', function(inventory)
        while DepositBlackCrips do
            Citizen.Wait(0)
        end
    end)
end

function Retirerargentsale()
	ESX.TriggerServerCallback('Crips:getBlackMoneySociety', function(inventory)
	    while StockBlackCrips do
		    Citizen.Wait(0)
	    end
    end)
end
