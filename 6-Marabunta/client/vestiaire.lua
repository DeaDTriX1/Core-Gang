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

function VestiaireMarabunta()
    local VestiaireMarabunta = RageUI.CreateMenu("", "Prenez vos tenue ici", X, Y, "Gang", "Gang", nil, nil, nil, nil)
        RageUI.Visible(VestiaireMarabunta, not RageUI.Visible(VestiaireMarabunta))
    while VestiaireMarabunta do
        Citizen.Wait(0)
            RageUI.IsVisible(VestiaireMarabunta, true, true, true, function()

                RageUI.ButtonWithStyle("Prendre sa tenue", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        UniformeMarabunta()
                    end
                end)

                RageUI.ButtonWithStyle("Reprendre sa tenue civil", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        TenuCivil()
                    end
                end)

                end, function() 
                end)
    
                if not RageUI.Visible(VestiaireMarabunta) then
                    VestiaireMarabunta = RMenu:DeleteType("Marabunta", true)
        end
    end
end

function UniformeMarabunta()
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = Marabunta.tenue.male
        else
            uniformObject = Marabunta.tenue.female
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
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Marabunta.Job then
        local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Marabunta.pos.Vestiaire.position.x, Marabunta.pos.Vestiaire.position.y, Marabunta.pos.Vestiaire.position.z)
        if dist3 <= 2.0 and Marabunta.jeveuxmarker then
            Timer = 0
            DrawMarker(20, Marabunta.pos.Vestiaire.position.x, Marabunta.pos.Vestiaire.position.y, Marabunta.pos.Vestiaire.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 147, 112, 219, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist3 <= 1.0 then
                Timer = 0   
                        RageUI.Text({ message = "Appuyez sur ~p~[E]~s~ pour accéder au Vestiaire", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            VestiaireMarabunta()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)