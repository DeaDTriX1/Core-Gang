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

function Menuf6Families()
    local MainFamilies = RageUI.CreateMenu("", "Interactions", X, Y, "Gang", "Gang", nil, nil, nil, nil)
    local InventaireFamilies = RageUI.CreateSubMenu(MainFamilies, " ", "Interactions")
    local MenotteFamilies = RageUI.CreateSubMenu(MainFamilies, " ", "Interactions")
    local VehiculeFamilies = RageUI.CreateSubMenu(MainFamilies, " ", "Interactions")
    RageUI.Visible(MainFamilies, not RageUI.Visible(MainFamilies))
    while MainFamilies do
        Citizen.Wait(0)

            RageUI.IsVisible(MainFamilies, true, true, true, function()

                RageUI.Separator("Action Gang")

                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                RageUI.ButtonWithStyle("~r~→ Action Menotte", "~b~Menotter / Démenotté / Escorter", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, MenotteFamilies)

                RageUI.ButtonWithStyle("~r~→ Action Véhicule", "~b~Mettre / Enlevée du véhicule", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                end, VehiculeFamilies)


            RageUI.ButtonWithStyle("→~r~Crocheter le véhicule", "~b~Crocheter le vehicule avec le marker", {RightLabel = nil}, true, function(Hovered, Active, Selected)
                if Active then
                    GetCloseVehi()
                if Selected then
                    local playerPed = PlayerPedId()
                    local vehicle = ESX.Game.GetVehicleInDirection()
                    local coords = GetEntityCoords(playerPed) 
                    if IsPedSittingInAnyVehicle(playerPed) then
                        RageUI.Popup({message = "<C>Sorter du véhicule"})
                        return
                    end
                    
                    if DoesEntityExist(vehicle) then
                        isBusy = true
                        TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
                        Citizen.CreateThread(function()
                        Citizen.Wait(10000)
                    
                        SetVehicleDoorsLocked(vehicle, 1)
                        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                        ClearPedTasksImmediately(playerPed)
                        RageUI.Popup({message = "<C>Véhicule dévérouiller"})
                        isBusy = false
                        end)
                    else
                        RageUI.Popup({message = "<C>Pas de véhicule proche"})
                    end
                    Wait(5000)
                end
            end
            end)

            RageUI.Separator("Action Fouille")

                RageUI.ButtonWithStyle("→~r~Fouiller", "~b~Fouille la personne avec le marker au dessus de lui", {RightLabel = "→"}, closestPlayer ~= -1 and closestDistance <= 3.0, function(Hovered, Active, Selected)
                if Active then
                    MarquerJoueur()
                        if Selected then
                            local target, distance = ESX.Game.GetClosestPlayer()
                            local target_id = GetPlayerServerId(target)
                            playerheading = GetEntityHeading(PlayerPedId())
                            playerlocation = GetEntityForwardVector(PlayerPedId())
                            playerCoords = GetEntityCoords(PlayerPedId())
                            if distance <= 2.0 then 
                            getPlayerInv(closestPlayer)
                        else
                            Wait(500)
                            RageUI.CloseAll()
                            RageUI.Popup({message = "Personne autour de vous"})
                        end
                    end
                end
                end, InventaireFamilies)

                RageUI.ButtonWithStyle("→~r~Carte d'identité", nil, {RightLabel = "→"}, closestPlayer ~= -1 and closestDistance <= 3.0, function(Hovered, Active, Selected)
                    if Active then
                        MarquerJoueur()
                        if (Selected) then
                            local target, distance = ESX.Game.GetClosestPlayer()
                            local target_id = GetPlayerServerId(target)
                            playerheading = GetEntityHeading(PlayerPedId())
                            playerlocation = GetEntityForwardVector(PlayerPedId())
                            playerCoords = GetEntityCoords(PlayerPedId())
                            if distance <= 2.0 then  
                            ESX.ShowNotification("Recherche en cours...")
                            Citizen.Wait(2000)
                            carteidentite(closestPlayer)
                    else
                        ESX.ShowNotification('Aucun joueurs à proximité')
                    end
                    end
                end
                end)

                RageUI.Separator("↓ Annonce ↓")

        
                RageUI.ButtonWithStyle("Personnalisé", "~b~Passe une annonce au nom de la Families !", {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        local msg = KeyboardInput("Message", "", 100)
                        TriggerServerEvent('Families:Perso', msg)
                    end
                end)

                end, function() 
                end)

                        RageUI.IsVisible(InventaireFamilies, true, true, true, function()


                        RageUI.Separator("~r~Inventaire de "..GetPlayerName(GetPlayerFromServerId(IdSelected)))

                        RageUI.Separator("↓ ~g~Money ~s~↓")

                        for k,v  in pairs(ArgentBank) do
                            RageUI.ButtonWithStyle("Argent en banque :", "", {RightLabel = v.label.."€"}, true, function(_, _, s)
                            end)
                        end
            
                        for k,v  in pairs(ArgentMoney) do
                            RageUI.ButtonWithStyle("Argent Liquide :", "", {RightLabel = v.label.."€"}, true, function(_, _, s)
                            end)
                        end
            
                        for k,v  in pairs(ArgentSale) do
                            RageUI.ButtonWithStyle("Argent sale ", "", {RightLabel = v.label.."€"}, true, function(_, _, s)
                            end)
                        end
                
                        RageUI.Separator("↓ ~r~Objets ~s~↓")

                        for k,v  in pairs(Items) do
                            RageUI.ButtonWithStyle(v.label, "", {RightLabel = "~r~x"..v.right}, true, function(_, _, s)
                            end)
                        end

                        RageUI.Separator("↓ ~o~Armes ~s~↓")
            
                        for k,v  in pairs(Armes) do
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "avec ~r~"..v.right.. " ~s~balle(s)"}, true, function(_, _, s)
                            end)
                        end
                
                        end, function() 
                        end)

                    RageUI.IsVisible(MenotteFamilies, true, true, true, function()

                         local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

            RageUI.ButtonWithStyle("→~s~ ~p~Menotter", nil, {RightLabel = nil}, closestPlayer ~= -1 and closestDistance <= 3.0, function(Hovered, Active, Selected)
                if Active then
                    MarquerJoueur()
                    if (Selected) then
                            local target, distance = ESX.Game.GetClosestPlayer()
                            local target_id = GetPlayerServerId(target)
                            playerheading = GetEntityHeading(PlayerPedId())
                            playerlocation = GetEntityForwardVector(PlayerPedId())
                            playerCoords = GetEntityCoords(PlayerPedId())
                            if distance <= 2.0 then
                        TriggerServerEvent('Families:mettremenotte', target_id, playerheading, playerCoords, playerlocation)
                        else
                            Wait(500)
                            RageUI.CloseAll()
                            RageUI.Popup({message = "Personne autour de vous"})
                        end
                    end
                end
            end)

            RageUI.ButtonWithStyle("→~s~ ~p~Démenotté", nil, {RightLabel = nil}, closestPlayer ~= -1 and closestDistance <= 3.0, function(Hovered, Active, Selected)
                if Active then
                    MarquerJoueur()
                    if (Selected) then
                            local target, distance = ESX.Game.GetClosestPlayer()
                            local target_id = GetPlayerServerId(target)
                            playerheading = GetEntityHeading(PlayerPedId())
                            playerlocation = GetEntityForwardVector(PlayerPedId())
                            playerCoords = GetEntityCoords(PlayerPedId())
                            if distance <= 2.0 then  
                        TriggerServerEvent('Families:enlevermenotte', target_id, playerheading, playerCoords, playerlocation)
                        else
                            Wait(500)
                            RageUI.CloseAll()
                            RageUI.Popup({message = "Personne autour de vous"})
                        end
                    end
                end
            end)

            RageUI.ButtonWithStyle("→~p~Escorter", "~b~Trainer la personne avec le marker (Uniquement avec menotte)", {RightLabel = nil}, closestPlayer ~= -1 and closestDistance <= 3.0, function(Hovered, Active, Selected)
                if Active then
                    MarquerJoueur()
                    if (Selected) then
                            local target, distance = ESX.Game.GetClosestPlayer()
                            local target_id = GetPlayerServerId(target)
                            playerheading = GetEntityHeading(PlayerPedId())
                            playerlocation = GetEntityForwardVector(PlayerPedId())
                            playerCoords = GetEntityCoords(PlayerPedId())
                            if distance <= 2.0 then  
                    TriggerServerEvent('Families:drag', GetPlayerServerId(closestPlayer))
                        else
                            Wait(500)
                            RageUI.CloseAll()
                            RageUI.Popup({message = "Personne autour de vous"})
                        end
                    end
                end
            end)

                        end, function() 
                        end)

                    RageUI.IsVisible(VehiculeFamilies, true, true, true, function()

                         local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

            RageUI.ButtonWithStyle("→~p~Mettre dans un véhicule", nil, {RightLabel = nil}, closestPlayer ~= -1 and closestDistance <= 3.0, function(Hovered, Active, Selected)
                if Active then
                    MarquerJoueur()
                    if (Selected) then
                            local target, distance = ESX.Game.GetClosestPlayer()
                            local target_id = GetPlayerServerId(target)
                            playerheading = GetEntityHeading(PlayerPedId())
                            playerlocation = GetEntityForwardVector(PlayerPedId())
                            playerCoords = GetEntityCoords(PlayerPedId())
                            if distance <= 2.0 then  
                    TriggerServerEvent('Families:putInVehicle', GetPlayerServerId(closestPlayer))
                        else
                            Wait(500)
                            RageUI.CloseAll()
                            RageUI.Popup({message = "Personne autour de vous"})
                        end
                    end
                end
            end)

            RageUI.ButtonWithStyle("→~p~Sortir du véhicule", nil, {RightLabel = nil}, closestPlayer ~= -1 and closestDistance <= 3.0, function(Hovered, Active, Selected)
                if Active then
                    MarquerJoueur()
                    if (Selected) then
                            local target, distance = ESX.Game.GetClosestPlayer()
                            local target_id = GetPlayerServerId(target)
                            playerheading = GetEntityHeading(PlayerPedId())
                            playerlocation = GetEntityForwardVector(PlayerPedId())
                            playerCoords = GetEntityCoords(PlayerPedId())
                            if distance <= 2.0 then  
                    TriggerServerEvent('Families:OutVehicle', GetPlayerServerId(closestPlayer))
                        else
                            Wait(500)
                            RageUI.CloseAll()
                            RageUI.Popup({message = "Personne autour de vous"})
                        end
                    end
                end
            end)
                        end, function() 
                        end)

                if not RageUI.Visible(MainFamilies) and not RageUI.Visible(InventaireFamilies) and not RageUI.Visible(MenotteFamilies) and not RageUI.Visible(VehiculeFamilies) then
                    MainFamilies = RMenu:DeleteType("Families", true)
        end
    end
end

Keys.Register('F6', 'Families', 'Ouvrir le menu Families', function()
	if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Families.Job then
    	Menuf6Families()
	end
end)


function carteidentite(player)
    local CarteFamilies = RageUI.CreateMenu("Carte d'identité", "Informations")
    ESX.TriggerServerCallback('Families:getOtherPlayerData', function(data)
    RageUI.Visible(CarteFamilies, not RageUI.Visible(CarteFamilies))
        while CarteFamilies do
            Citizen.Wait(0)
                RageUI.IsVisible(CarteFamilies, true, true, true, function()
                            RageUI.ButtonWithStyle("Prenom & Nom : ", nil, {RightLabel = data.name}, true, function(Hovered, Active, Selected)
                                if Selected then
                                end
                            end)
                            RageUI.ButtonWithStyle("Sexe : ", nil, {RightLabel = data.sex}, true, function(Hovered, Active, Selected)
                                if Selected then
                                end
                            end)
                            RageUI.ButtonWithStyle("Taille : ", nil, {RightLabel = data.height}, true, function(Hovered, Active, Selected)
                                if Selected then
                                end
                            end)
                            RageUI.ButtonWithStyle("Né le : ", nil, {RightLabel = data.dob}, true, function(Hovered, Active, Selected)
                                if Selected then
                                end
                            end)
                            RageUI.ButtonWithStyle("Metier : ", nil, {RightLabel = data.job.." - "..data.grade}, true, function(Hovered, Active, Selected)
                                if Selected then
                                end
                            end)
                            RageUI.ButtonWithStyle("Orga : ", nil, {RightLabel = data.job2.." - "..data.grade2}, true, function(Hovered, Active, Selected)
                                if Selected then
                                end
                            end)
                            RageUI.Separator("↓ Permis ↓")
                            for i=1, #data.licenses, 1 do
                            RageUI.ButtonWithStyle(data.licenses[i].label, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                                if Selected then
                                end
                            end)
                        end
                end, function()
                end)
            if not RageUI.Visible(CarteFamilies) then
            CarteFamilies = RMenu:DeleteType("Carte d'identite", true)
        end
    end
end, GetPlayerServerId(player))
end