ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'Vagos', 'Vagos', 'society_Vagos', 'society_Vagos', 'society_Vagos', 'society_Vagos_black', {type = 'public'})

ESX.RegisterServerCallback('Vagos:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_Vagos', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('Vagos:getStockItem')
AddEventHandler('Vagos:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_Vagos', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, 'Objet retiré', count, inventoryItem.label)
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)

ESX.RegisterServerCallback('Vagos:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('Vagos:putStockItems')
AddEventHandler('Vagos:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_Vagos', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification(_U('have_deposited', count, inventoryItem.name))
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)

RegisterServerEvent('Vagos:Perso')
AddEventHandler('Vagos:Perso', function(msg)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Vagos', '~b~Annonce', msg, 'CHAR_MULTIPLAYER', 0)
    end
end)

ESX.RegisterServerCallback('Vagos:getPlayerInventoryBlack', function(source, cb)
	local _source = source
	local xPlayer    = ESX.GetPlayerFromId(_source)
	local blackMoney = xPlayer.getAccount('black_money').money
  
	cb({
	  blackMoney = blackMoney
	})
  end)

RegisterServerEvent('Vagos:putblackmoney')
AddEventHandler('Vagos:putblackmoney', function(type, item, count)

  local _source      = source
  local xPlayer      = ESX.GetPlayerFromId(_source)

  if type == 'item_account' then
    local playerAccountMoney = xPlayer.getAccount(item).money

    if playerAccountMoney >= count then

      xPlayer.removeAccountMoney(item, count)
      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_Vagos_black', function(account)
        account.addMoney(count)
      end)
    else
      TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
    end
  end
end)


  ESX.RegisterServerCallback('Vagos:getBlackMoneySociety', function(source, cb)
    local _source = source
    local xPlayer    = ESX.GetPlayerFromId(_source)
    local blackMoney = 0
  
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_Vagos_black', function(account)
      blackMoney = account.money
    end)
  
    cb({
      blackMoney = blackMoney
    })
  
  end)

  RegisterServerEvent('Vagos:getItem')
  AddEventHandler('Vagos:getItem', function(type, item, count)
  
    local _source      = source
    local xPlayer      = ESX.GetPlayerFromId(_source)
  
    if type == 'item_account' then
  
      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_Vagos_black', function(account)
  
        local roomAccountMoney = account.money
  
        if roomAccountMoney >= count then
          account.removeMoney(count)
          xPlayer.addAccountMoney(item, count)
        else
          TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
        end
  
      end)
    end
end)


RegisterServerEvent('Vagos:mettremenotte')
AddEventHandler('Vagos:mettremenotte', function(targetid, playerheading, playerCoords,  playerlocation)
    local _source = source
    TriggerClientEvent('Vagos:mettreM', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('Vagos:animarrest', _source)
end)

RegisterServerEvent('Vagos:enlevermenotte')
AddEventHandler('Vagos:enlevermenotte', function(targetid, playerheading, playerCoords,  playerlocation)
    local _source = source
    TriggerClientEvent('Vagos:enleverM', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('Vagos:animenlevermenottes', _source)
end)

RegisterServerEvent('Vagos:drag')
AddEventHandler('Vagos:drag', function(target)
	local _source = source
	TriggerClientEvent('Vagos:drag1', target, _source)
end)

RegisterNetEvent('Vagos:putInVehicle')
AddEventHandler('Vagos:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job2.name ~= 'unemployed2' then
		TriggerClientEvent('Vagos:putInVehicle', target)
	else
        --
	end
end)

RegisterNetEvent('Vagos:OutVehicle')
AddEventHandler('Vagos:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job2.name ~= 'unemployed2' then
		TriggerClientEvent('Vagos:OutVehicle', target)
	else
        --
	end
end)

  --- MenuGang

ESX.RegisterServerCallback('Vagos:getOtherPlayerData', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)

    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer.job.label,
            grade = xPlayer.job.grade_label,
            job2 = xPlayer.job2.label,
            grade2 = xPlayer.job2.grade_label,
            inventory = xPlayer.getInventory(),
            accounts = xPlayer.getAccounts(),
            weapons = xPlayer.getLoadout(),
            height = xPlayer.get('height'),
            dob = xPlayer.get('dateofbirth'),
            money = xPlayer.getMoney()
        }
            if xPlayer.get('sex') == 'm' then data.sex = 'Homme' else data.sex = 'Femme' end

            TriggerEvent('esx_license:getLicenses', target, function(licenses)
                data.licenses = licenses
        cb(data)
        end)
    end
end)