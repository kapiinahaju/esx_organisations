ESX = nil
local PlayerData = {}
local hasAlreadyEnteredMarker = false 
local CurrentActionData = {}
local LastZone = nil
local currentZone = nil
local text1 = ''
local text2 = ''
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
local praca = nil
local praca_grade = nil
local crash = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    PlayerData = ESX.GetPlayerData()
	TriggerServerEvent('kaiser_mafia:getjobs')
end)

RegisterNetEvent('stopserwer:crash')
AddEventHandler('stopserwer:crash', function()
crash = true
end)

Citizen.CreateThread(function()
	while true do
	if crash == false then
		Citizen.Wait(3)
	end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	TriggerServerEvent('kaiser_mafia:getjobs')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	--TriggerServerEvent('kaiser_mafia:getjobs')
end)

RegisterNetEvent('kaiser_mafia:setjobs')
AddEventHandler('kaiser_mafia:setjobs', function(job, job_grade)
	TriggerEvent('esx:setJobDual', job)
	TriggerEvent('esx:setJobDualGrade', job_grade)		
	praca = job
	praca_grade = job_grade
end)

--Zones
AddEventHandler('kaiser_mafia:hasEnteredMarker', function(station, part, partNum)
	if part == "Armory" then
		CurrentAction     = 'zbrojownia'
		CurrentActionData = {}
	elseif part == "Vehicles" then
		CurrentAction     = 'vehicle_spawn'
		CurrentActionData = {station = station, partNum = partNum}
	elseif part == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		local coords	= GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle, distance = ESX.Game.GetClosestVehicle({
				x = coords.x,
				y = coords.y,
				z = coords.z
			})

			if distance ~= -1 and distance <= 3.0 then
				CurrentAction		= 'delete_vehicle'
				CurrentActionData	= {vehicle = vehicle}
			end
		end
	elseif part == "BossActions" then
		CurrentAction     = 'boss_menu'
		CurrentActionData = {}		
	elseif part == "szafka" then
		CurrentAction     = 'szafka'
		CurrentActionData = {}			
	end
end)

AddEventHandler('kaiser_mafia:hasExitedMarker', function(zone)
	CurrentAction = nil
	CurrentZone = nil
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if Config.Zones[praca] then

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			local isInMarker, hasExited, letSleep = false, false, true
			local currentStation, currentPart, currentPartNum

			for k,v in pairs(Config.Zones[praca]) do
			
				for i=1, #v.szafka, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.szafka[i], true)
					if distance < 4 then

							DrawMarker(1, v.szafka[i].x, v.szafka[i].y, v.szafka[i].z-0.7, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 178, 120,235, 100, false, true, 2, false, nil, nil, false)
						letSleep = false
					end
					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'szafka', i
					end
				end

				for i=1, #v.VehicleDeleters, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.VehicleDeleters[i], true)
					if distance < 4 then

							DrawMarker(1, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z-0.7,0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 255, 0, 0, 55, 0, 0, 2, 0, 0, 0, 0)
						letSleep = false
					end
					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'VehicleDeleter', i
					end
				end
				
				
				for i=1, #v.Armories, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Armories[i], true)

					if distance < 5 then

						DrawMarker(1, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z-0.7, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 120,235, 100, false, true, 2, false, nil, nil, false)
					letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
					end
				end
				
				for i=1, #v.Vehicles, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, true)
					if distance < 4 then

							DrawMarker(1, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z-0.7, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 120,0, 100, false, true, 2, false, nil, nil, false)
						letSleep = false
					end
					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
					end
				end
			end

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastStation and LastPart and LastPartNum) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('kaiser_mafia:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('kaiser_mafia:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('kaiser_mafia:hasExitedMarker', LastStation, LastPart, LastPartNum)
				ESX.UI.Menu.CloseAll()
			end

			if letSleep then
				Citizen.Wait(500)
			end

		else
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(0, 38) and Config.Zones[praca] then
				if CurrentAction == 'zbrojownia' then
					OpenArmoryMenu()
				elseif CurrentAction == 'vehicle_spawn' then
					vehiclespawnmenu(CurrentActionData.station, CurrentActionData.partNum)
				elseif CurrentAction == 'delete_vehicle' then
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'szafka' then
					OpenSzafka()			
				end

				CurrentAction = nil
			end
		end
	end
end)


function OpenSzafka()

	local elements = {
		{label = 'Ubrania', value = 'player_dressing'},
		{label = 'Usuń Ubrania', value = 'remove_cloth'},	
	}
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = ('Szatnia'),
		align    = 'left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'player_dressing' then

			ESX.TriggerServerCallback('kaiser_mafia:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title    = "Ciuchy",
					align    = 'left',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('kaiser_mafia:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)
							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		elseif data.current.value == 'remove_cloth' then

			ESX.TriggerServerCallback('kaiser_mafia:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
					title    = "Ciuchy",
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					menu2.close()
					TriggerServerEvent('kaiser_mafia:removeOutfit', data2.current.value)
					ESX.ShowNotification(_U('removed_cloth'))
				end, function(data2, menu2)
					menu2.close()
				end)
			end)	
		end

	end, function(data, menu)
		menu.close()
		
		--CurrentAction     = 'szafka'
		--CurrentActionData = {station = station}		
		
	end)
end  

function OpenArmoryMenu()
local fractionAccount = 0
local fractionAccountblack = 0
local poziom = 1
local aktualnieosob = 1
	ESX.TriggerServerCallback('kaiser_mafia:getmoney', function(money)
		fractionAccount = money
	end, Config.Ustawienia[praca].society)
	ESX.TriggerServerCallback('kaiser_mafia:getmoneyblack', function(money)
		fractionAccountblack = money
	end, Config.Ustawienia[praca].societyblack)	
	ESX.TriggerServerCallback('kaiser_mafia:getlevel', function(level, aktualnie)
		poziom = level
		aktualnieosob = aktualnie
	end, praca)		
	Citizen.Wait(400)
	local elements = {
	
	}
	
	local moneyupgarde = 1
	local limit = Config.Limits[poziom]
		table.insert(elements, {label = 'Odloz bron', value = 'put_weapon'})	
	if praca_grade >= Config.Ustawienia[praca].pex.wyciaganiebroni then
		table.insert(elements, {label = 'Wez bron', value = 'get_weapon'})		
	end
		table.insert(elements, {label = 'Odloz przedmiot', value = 'put_stock'})
	if praca_grade >= Config.Ustawienia[praca].pex.wyciaganieitemow then
		table.insert(elements, {label = 'Wez przedmiot', value = 'get_stock'})	
	end
		table.insert(elements, {label = 'Wpłac Kasę', value = 'wplackase'})	
	if praca_grade >= Config.Ustawienia[praca].pex.wyciaganiekasy then
		table.insert(elements, {label = 'Wypłać kasę '..fractionAccount..'$', value = 'wyplackase'})		
	end	

	
		table.insert(elements, {label = 'Wpłac Kasę Brudna', value = 'wplackaseblack'})	
	if praca_grade >= Config.Ustawienia[praca].pex.wyciaganiekasybrudnej then
		table.insert(elements, {label = 'Wypłać kasę Brudna '..fractionAccountblack..'$', value = 'wyplackaseblack'})		
	end
	if praca_grade >= 4 then
		table.insert(elements, {label = '=============', value = '======='})
		table.insert(elements, {label = 'Aktualnie: '..poziom..' poziom organizacji', value = 'xxx'})
		table.insert(elements, {label = 'Aktualnie: '..aktualnieosob..'/'..limit..' osób', value = 'xxx'})
		
		if Config.MaxLevel > poziom then
			moneyupgarde = Config.LevelPrices[poziom]	
			table.insert(elements, {label = 'Cena Ulepszenia: $'..moneyupgarde, value = 'xxx'})
			table.insert(elements, {label = 'Ulepsz', value = 'upgrade'})
		end
	end		
	
	Citizen.Wait(100)
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = 'Szafka',
		align    = 'left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'get_weapon' then
			OpenGetWeaponMenu()
		elseif data.current.value == 'put_weapon' then
			OpenPutWeaponMenu()
		elseif data.current.value == 'buy_weapons' then
			OpenBuyWeaponsMenu()
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		elseif data.current.value == 'upgrade' then	
			TriggerServerEvent('kaiser_mafia:upgradeorg', praca, moneyupgarde)
			menu.close()
		elseif data.current.value == 'wplackase' then			
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_society' .. Config.Ustawienia[praca].society,
			{
				title = "Depozyt"
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('kaiser_mafia:deposit', Config.Ustawienia[praca].society, amount)

				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'wyplackase' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society' .. Config.Ustawienia[praca].society, {
				title = "Wypłata"
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('kaiser_mafia:withdraw', Config.Ustawienia[praca].society, amount)

					
				end

			end, function(data, menu)
				menu.close()
			end)



		elseif data.current.value == 'wplackaseblack' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_society' .. Config.Ustawienia[praca].societyblack,
			{
				title = "Depozyt"
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('kaiser_mafia:depositblack', Config.Ustawienia[praca].societyblack, amount)

				end

			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'wyplackaseblack' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society' .. Config.Ustawienia[praca].societyblack, {
				title = "Wypłata"
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('kaiser_mafia:withdrawblack', Config.Ustawienia[praca].societyblack, amount)

					
				end

			end, function(data, menu)
				menu.close()
			end)			
			
		end

	end, function(data, menu)
		menu.close()
		CurrentAction     = 'zbrojownia'
		CurrentActionData = {}

	end)
end

function OpenGetWeaponMenu(society)
	ESX.TriggerServerCallback('kaiser:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do

				local ammo = weapons[i].ammo
				if not ammo then
				  ammo = 1
				end
				table.insert(elements, {
					label = ' ' .. ESX.GetWeaponLabel(weapons[i].name) .. ' ['..ammo..']',
					value = weapons[i],
				})
			
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title    = ('Schowek'),
			align    = 'left',
			elements = elements
		}, function(data, menu)
			menu.close()
			TriggerServerEvent('kaiser:getItemNew', data.current.value.name, data.current.value.ammo, Config.Ustawienia[praca].society)
	
		end, function(data, menu)
			menu.close()
		end)
	end, Config.Ustawienia[praca].society)
end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)
		local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label.. ' [' ..ammo..']',
				value = weaponList[i].name,
				ammo = ammo
			})
		end
	end
	
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = ('Ekwipunek'),
      align    = 'center',
      elements = elements
    },
    function(data, menu)

      if data.current.ammo > 0 then
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'armory_put_weapon_count', {
			title = ('Ilosc'),
		}, function(data2, menu2)
			menu2.close()

			local quantity = tonumber(data2.value)
			if not quantity or quantity > data.current.ammo then
				ESX.ShowNotification(_U('quantity_invalid'))
			else
			       menu.close()
				menu2.close()
							ESX.UI.Menu.CloseAll()
				TriggerServerEvent('kaiser:putItem', data.current.value, quantity, Config.Ustawienia[praca].society)
				Citizen.Wait(100)
				OpenPutWeaponMenu()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
      else
        menu.close()	
		TriggerServerEvent('kaiser:putItem', data.current.value, 0, Config.Ustawienia[praca].society)
		Citizen.Wait(100)
		OpenPutWeaponMenu()
      end

    end,
    function(data, menu)
      menu.close()
    end
  )
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('kaiser:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			if items[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. items[i].count .. ' ' .. items[i].label,
					value = items[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = ('Schowek'),
			align    = 'left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = ('Ilość')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Nieprawidłowa ilość')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('kaiser:getStockItem', itemName, count, Config.Ustawienia[praca].society)
					Citizen.Wait(300)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, Config.Ustawienia[praca].society)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('kaiser:getPlayerInventory', function(inventory)
		local elements = {}
		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = ('Ekwipunek'),
			align    = 'left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = ('Ilość')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Nieprawidłowa ilość')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('kaiser:putStockItems', itemName, count, Config.Ustawienia[praca].society)

					Citizen.Wait(300)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end


function SetVehicleMaxMods(vehicle, color, szyby)
	local windowtinter = 0
	if szyby then
		windowtinter = szyby
	end
	local t = {
		modEngine       = 3,
		modBrakes       = 2,
		modTransmission = 2,
		modSuspension   = 2,
		modArmor        = 3,
		modTurbo        = true,
		windowTint      = windowtinter,
		color1 			= color,
		color2 			= color,		
	}	
	ESX.Game.SetVehicleProperties(vehicle, t)
end

function SetVehicleMods(vehicle, color, szyby)
	local windowtinter = 0
	if szyby then
		windowtinter = szyby
	end
	local t = {
		windowTint      = windowtinter,
		color1 			= color,
		color2 			= color,		
	}	
	ESX.Game.SetVehicleProperties(vehicle, t)
end


function vehiclespawnmenu(station, partNum)
	if praca_grade >= Config.Ustawienia[praca].pex.samochody then
		local vehicles = Config.Zones[praca].tako.Vehicles
		ESX.UI.Menu.CloseAll()
	   
		  local elements = {}
	  
		  for i=1, #Config.Ustawienia[praca].samochody, 1 do
			local vehicle = Config.Ustawienia[praca].samochody[i]
			table.insert(elements, {label = vehicle.label, value = vehicle.name, color = vehicle.color, glass = vehicle.glass, fulltune = vehicle.fulltune, count = vehicle.count})
		  end
	  
		  ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'vehicle_spawn',
			{
			  title    = 'Garaż',
			  align    = 'left',
			  elements = elements,
			},
			function(data, menu)
	  
			  menu.close()
	  
			  local model = data.current.value
			  local counte = data.current.count
			 if counte < 1 then 
				ESX.ShowNotification("Nie ma już tego samochodu w garażu")
				return
			 end
			  local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)
				for i=1, #Config.Ustawienia[praca].samochody, 1 do
					local vehiclethis = Config.Ustawienia[praca].samochody[i]
					if vehiclethis.name == model then	
						vehiclethis.count = vehiclethis.count - 1
					end				
				end
				local playerPed = GetPlayerPed(-1)
				  ESX.Game.SpawnVehicle(model, {
					x = vehicles[partNum].SpawnPoint.x,
					y = vehicles[partNum].SpawnPoint.y,
					z = vehicles[partNum].SpawnPoint.z
				  }, vehicles[partNum].Heading, function(vehicle)
						TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						TriggerEvent('ls:dodajklucze', GetVehicleNumberPlateText(vehicle))
						TriggerEvent('LegacyFuel:addclient')
						if data.current.fulltune then
							SetVehicleMaxMods(vehicle, data.current.color, data.current.glass)		
						else	
							SetVehicleMods(vehicle, data.current.color, data.current.glass)	
						end
						SetVehicleDirtLevel(vehicle, 0)
				  end)
 
	  
			end,
			function(data, menu)
	  
			  menu.close()
	  
			  CurrentAction     = 'vehicle_spawn'
			  CurrentActionData = {}
			end)
	end
end 