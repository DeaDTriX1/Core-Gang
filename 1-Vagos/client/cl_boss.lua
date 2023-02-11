ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local societyVagosmoney = nil
local societyblackVagosmoney = nil

Citizen.CreateThread(function()
    ESX.TriggerServerCallback('Vagos:getBlackMoneySociety', function(inventory)
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

function BossVagos()
  local VagosAction = RageUI.CreateMenu("", "Voici les action du BOSS", X, Y, "Gang", "Gang", nil, nil, nil, nil)
    RageUI.Visible(VagosAction, not RageUI.Visible(VagosAction))

            while VagosAction do
                Citizen.Wait(0)
                    RageUI.IsVisible(VagosAction, true, true, true, function()

                    if societyVagosmoney ~= nil then
                        RageUI.ButtonWithStyle("Argent Gang :", nil, {RightLabel = "$" .. societyVagosmoney}, true, function()
                        end)
                    end

                    RageUI.ButtonWithStyle("Retirer argent de Gang",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local amount = KeyboardInput("Montant", "", 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                RageUI.Popup({message = "Montant invalide"})
                            else
                                TriggerServerEvent('five_banque:retraitentreprise', amount, Vagos.Job)
                                RefreshVagosMoney()
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
                                TriggerServerEvent('five_banque:depotentreprise', amount, Vagos.Job)
                                RefreshVagosMoney()
                            end
                        end
                    end) 

                    RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ActionBossVagos()
                            RageUI.CloseAll()
                        end
                    end)

                        RageUI.Separator("↓ Argent Sale ↓")
            

                        if societyblackVagosmoney ~= nil then
                            RageUI.ButtonWithStyle("Argent sale : ", nil, {RightLabel = "$" .. societyblackVagosmoney}, true, function()
                            end)
                        end
    
                        RageUI.ButtonWithStyle("Déposer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                    local count = KeyboardInput("Combien ?", "", 100)
                                    TriggerServerEvent('Vagos:putblackmoney', 'item_account', 'black_money', tonumber(count))
                                    Deposerargentsale()
                                    ESX.TriggerServerCallback('Vagos:getBlackMoneySociety', function(inventory) 
                                end)
                                RefreshblackVagosMoney()
                            end
                        end)
    
                        RageUI.ButtonWithStyle("Retirer argent sale",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local count = KeyboardInput("Combien ?", "", 100)
                                ESX.TriggerServerCallback('Vagos:getBlackMoneySociety', function(inventory) 
                                TriggerServerEvent('Vagos:getItem', 'item_account', 'black_money', tonumber(count))
                                Retirerargentsale()
                                RefreshblackVagosMoney()
                                end)
                            end
                        end)
                    end, function()
                end)
            if not RageUI.Visible(VagosAction) then
            VagosAction = RMenu:DeleteType("Actions Patron", true)
        end
    end
end   

---------------------------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 1000
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Vagos.Job and ESX.PlayerData.job2.grade_name == 'boss' then
        local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Vagos.pos.boss.position.x, Vagos.pos.boss.position.y, Vagos.pos.boss.position.z)
        if dist3 <= 3.0 and Vagos.jeveuxmarker then
            Timer = 0
            DrawMarker(20, Vagos.pos.boss.position.x, Vagos.pos.boss.position.y, Vagos.pos.boss.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 2.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~p~[E]~s~ pour accéder aux actions patron", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                        RefreshVagosMoney()   
                        RefreshblackVagosMoney()        
                        BossVagos()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshVagosMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('five_society:getSocietyMoney', function(money)
            UpdateSocietyVagosMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function RefreshblackVagosMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('Vagos:getBlackMoneySociety', function(inventory)
            UpdateSocietyblackVagosMoney(inventory)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietyblackVagosMoney(inventory)
    societyblackVagosmoney = ESX.Math.GroupDigits(inventory.blackMoney)
end

function UpdateSocietyVagosMoney(money)
    societyVagosmoney = ESX.Math.GroupDigits(money)
end

function ActionBossVagos()
    TriggerEvent('five_society', Vagos.Job, false, false)
end

function Deposerargentsale()
    ESX.TriggerServerCallback('Vagos:getPlayerInventoryBlack', function(inventory)
        while DepositBlackVagos do
            Citizen.Wait(0)
        end
    end)
end

function Retirerargentsale()
	ESX.TriggerServerCallback('Vagos:getBlackMoneySociety', function(inventory)
	    while StockBlackVagos do
		    Citizen.Wait(0)
	    end
    end)
end
