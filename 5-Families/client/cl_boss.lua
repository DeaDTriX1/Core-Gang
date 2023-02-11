ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societyFamiliesmoney = nil
local societyblackFamiliesmoney = nil

Citizen.CreateThread(function()
    ESX.TriggerServerCallback('Families:getBlackMoneySociety', function(inventory)
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

function BossFamilies()
  local FamiliesAction = RageUI.CreateMenu("", "Voici les action du BOSS", X, Y, "Gang", "Gang", nil, nil, nil, nil)
    RageUI.Visible(FamiliesAction, not RageUI.Visible(FamiliesAction))

            while FamiliesAction do
                Citizen.Wait(0)
                    RageUI.IsVisible(FamiliesAction, true, true, true, function()

                    if societyFamiliesmoney ~= nil then
                        RageUI.ButtonWithStyle("Argent Gang :", nil, {RightLabel = "$" .. societyFamiliesmoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Retirer argent de Gang",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = KeyboardInput("Montant", "", 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                RageUI.Popup({message = "Montant invalide"})
                            else
                                TriggerServerEvent('five_banque:retraitentreprise', amount, Families.Job)
                                RefreshFamiliesMoney()
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
                                TriggerServerEvent('five_banque:depotentreprise', amount, Families.Job)
                                RefreshFamiliesMoney()
                            end
                        end
                    end) 

                    RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ActionBossFamilies()
                            RageUI.CloseAll()
                        end
                    end)

                        RageUI.Separator("↓ Argent Sale ↓")
            

                        if societyblackFamiliesmoney ~= nil then
                            RageUI.ButtonWithStyle("Argent sale : ", nil, {RightLabel = "$" .. societyblackFamiliesmoney}, true, function()
                            end)
                        end
    
                        RageUI.ButtonWithStyle("Déposer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                    local count = KeyboardInput("Combien ?", "", 100)
                                    TriggerServerEvent('Families:putblackmoney', 'item_account', 'black_money', tonumber(count))
                                    Deposerargentsale()
                                    ESX.TriggerServerCallback('Families:getBlackMoneySociety', function(inventory) 
                                end)
                                RefreshblackFamiliesMoney()
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Retirer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local count = KeyboardInput("Combien ?", "", 100)
                                ESX.TriggerServerCallback('Families:getBlackMoneySociety', function(inventory) 
                                TriggerServerEvent('Families:getItem', 'item_account', 'black_money', tonumber(count))
                                Retirerargentsale()
                                RefreshblackFamiliesMoney()
                                end)
                            end
                        end)
                    end, function()
                end)
            if not RageUI.Visible(FamiliesAction) then
            FamiliesAction = RMenu:DeleteType("Actions Patron", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 1000
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Families.Job and ESX.PlayerData.job2.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Families.pos.boss.position.x, Families.pos.boss.position.y, Families.pos.boss.position.z)
        if dist3 <= 3.0 and Families.jeveuxmarker then
            Timer = 0
            DrawMarker(20, Families.pos.boss.position.x, Families.pos.boss.position.y, Families.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~p~[E]~s~ pour accéder aux actions patron", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        RefreshFamiliesMoney()   
                        RefreshblackFamiliesMoney()        
                        BossFamilies()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshFamiliesMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('five_society:getSocietyMoney', function(money)
            UpdateSocietyFamiliesMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function RefreshblackFamiliesMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('Families:getBlackMoneySociety', function(inventory)
            UpdateSocietyblackFamiliesMoney(inventory)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietyblackFamiliesMoney(inventory)
    societyblackFamiliesmoney = ESX.Math.GroupDigits(inventory.blackMoney)
end

function UpdateSocietyFamiliesMoney(money)
    societyFamiliesmoney = ESX.Math.GroupDigits(money)
end

function ActionBossFamilies()
    TriggerEvent('five_society', Families.Job, false, false)
end

function Deposerargentsale()
    ESX.TriggerServerCallback('Families:getPlayerInventoryBlack', function(inventory)
        while DepositBlackFamilies do
            Citizen.Wait(0)
        end
    end)
end

function Retirerargentsale()
	ESX.TriggerServerCallback('Families:getBlackMoneySociety', function(inventory)
	    while StockBlackFamilies do
		    Citizen.Wait(0)
	    end
    end)
end
