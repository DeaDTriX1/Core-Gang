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

-- VESTIAIRE

function VestiaireCrips()
    local VestiaireCrips = RageUI.CreateMenu("", "Prenez vos tenue ici", X, Y, "Gang", "Gang", nil, nil, nil, nil)
        RageUI.Visible(VestiaireCrips, not RageUI.Visible(VestiaireCrips))
    while VestiaireCrips do
        Citizen.Wait(0)
            RageUI.IsVisible(VestiaireCrips, true, true, true, function()

                RageUI.ButtonWithStyle("Prendre sa tenue", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        UniformeCrips()
                    end
                end)

                RageUI.ButtonWithStyle("Reprendre sa tenue civil", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        TenuCivil()
                    end
                end)

                end, function() 
                end)
    
                if not RageUI.Visible(VestiaireCrips) then
                    VestiaireCrips = RMenu:DeleteType("Crips", true)
        end
    end
end

function UniformeCrips()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = Crips.tenue.male
        else
            uniformObject = Crips.tenue.female
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)end

function TenuCivil()
ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
TriggerEvent('skinchanger:loadSkin', skin)
end)
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Crips.Job then
        local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Crips.pos.Vestiaire.position.x, Crips.pos.Vestiaire.position.y, Crips.pos.Vestiaire.position.z)
        if dist3 <= 2.0 and Crips.jeveuxmarker then
            Timer = 0
            DrawMarker(20, Crips.pos.Vestiaire.position.x, Crips.pos.Vestiaire.position.y, Crips.pos.Vestiaire.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 1.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~p~[E]~s~ pour accéder au Vestiaire", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            VestiaireCrips()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)