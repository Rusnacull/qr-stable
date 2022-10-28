local QRCore = exports['qr-core']:GetCoreObject()
local SelectedHorseId = {}
local Horses

CreateThread(function()
	if GetCurrentResourceName() ~= "qr-stable" then
		print("^1=====================================")
		print("^1SCRIPT NAME OTHER THAN ORIGINAL")
		print("^1YOU SHOULD STOP SCRIPT")
		print("^1CHANGE NAME TO: ^2qr-stable^1")
		print("^1=====================================^0")
	end
end)

RegisterNetEvent("qr-stable:UpdateHorseComponents", function(components, idhorse, MyHorse_entity)
	local src = source
	local encodedComponents = json.encode(components)
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	local id = idhorse
	MySQL.Async.execute("UPDATE horses SET `components`=@components WHERE `citizenid`=@citizenid AND `id`=@id", {components = encodedComponents, citizenid = Playercid, id = id}, function(done)
		TriggerClientEvent("qr-stable:client:UpdadeHorseComponents", src, MyHorse_entity, components)
	end)
end)

RegisterNetEvent("qr-stable:CheckSelectedHorse", function()
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid

	MySQL.Async.fetchAll('SELECT * FROM horses WHERE `citizenid`=@citizenid;', {citizenid = Playercid}, function(horses)
		if #horses ~= 0 then
			for i = 1, #horses do
				if horses[i].selected == 1 then
					TriggerClientEvent("qr-stable:SetHorseInfo", src, horses[i].id, horses[i].citizenid, horses[i].model, horses[i].name, horses[i].components)
				end
			end
		end
	end)
end)

RegisterNetEvent("qr-stable:AskForMyHorses", function()
	local src = source
	local horseId = nil
	local components = nil
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	MySQL.Async.fetchAll('SELECT * FROM horses WHERE `citizenid`=@citizenid;', {citizenid = Playercid}, function(horses)
		if horses[1]then
			horseId = horses[1].id
		else
			horseId = nil
		end

		MySQL.Async.fetchAll('SELECT * FROM horses WHERE `citizenid`=@citizenid;', {citizenid = Playercid}, function(components)
			if components[1] then
				components = components[1].components
			end
		end)
		TriggerClientEvent("qr-stable:ReceiveHorsesData", src, horses)
	end)
end)

RegisterNetEvent("qr-stable:BuyHorse", function(data, name)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid

	MySQL.Async.fetchAll('SELECT * FROM horses WHERE `citizenid`=@citizenid;', {citizenid = Playercid}, function(horses)
		if #horses >= 3 then
			TriggerClientEvent('qr-core:client:DrawText', src, 'you can have a maximum of 3 horses!', 'left')
			Wait(5000) -- display text for 5 seconds
			TriggerClientEvent('qr-core:client:HideText', src)
			return
		end
		Wait(200)
		if data.IsGold then
			local currentBank = Player.Functions.GetMoney('bank')
			if data.Gold <= currentBank then
				local bank = Player.Functions.RemoveMoney("bank", data.Gold, "stable-bought-horse")
				TriggerClientEvent('qr-core:client:DrawText', src, 'horse purchased for $'..data.Gold, 'left')
				Wait(5000) -- display text for 5 seconds
				TriggerClientEvent('qr-core:client:HideText', src)
				TriggerEvent('qbr-log:server:CreateLog', 'shops', 'Stable', 'green', "**"..GetPlayerName(Player.PlayerData.source) .. " (citizenid: "..Player.PlayerData.citizenid.." | id: "..Player.PlayerData.source..")** bought a horse for $"..data.Gold..".")
			else
				TriggerClientEvent('qr-core:client:DrawText', src, 'not enough money!', 'left')
				Wait(5000) -- display text for 5 seconds
				TriggerClientEvent('qr-core:client:HideText', src)
				return
			end
		else
			if Player.Functions.RemoveMoney("cash", data.Dollar, "stable-bought-horse") then
				TriggerClientEvent('qr-core:client:DrawText', src, 'horse purchased for $'..data.Dollar, 'left')
				Wait(5000) -- display text for 5 seconds
				TriggerClientEvent('qr-core:client:HideText', src)
				TriggerEvent('qbr-log:server:CreateLog', 'shops', 'Stable', 'green', "**"..GetPlayerName(Player.PlayerData.source) .. " (citizenid: "..Player.PlayerData.citizenid.." | id: "..Player.PlayerData.source..")** bought a horse for $"..data.Dollar..".")
			else
				TriggerClientEvent('qr-core:client:DrawText', src, 'not enough money!', 'left')
				Wait(5000) -- display text for 5 seconds
				TriggerClientEvent('qr-core:client:HideText', src)
				return
			end
		end
	MySQL.Async.execute('INSERT INTO horses (`citizenid`, `name`, `model`) VALUES (@Playercid, @name, @model);',
		{
			Playercid = Playercid,
			name = tostring(name),
			model = data.ModelH
		}, function(rowsChanged)

		end)
	end)
end)

RegisterNetEvent("qr-stable:SelectHorseWithId", function(id)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	MySQL.Async.fetchAll('SELECT * FROM horses WHERE `citizenid`=@citizenid;', {citizenid = Playercid}, function(horse)
		for i = 1, #horse do
			local horseID = horse[i].id
			MySQL.Async.execute("UPDATE horses SET `selected`='0' WHERE `citizenid`=@citizenid AND `id`=@id", {citizenid = Playercid,  id = horseID}, function(done)
			end)

			Wait(300)

			if horse[i].id == id then
				MySQL.Async.execute("UPDATE horses SET `selected`='1' WHERE `citizenid`=@citizenid AND `id`=@id", {citizenid = Playercid, id = id}, function(done)
					TriggerClientEvent("qr-stable:SetHorseInfo", src, horse[i].model, horse[i].name, horse[i].components)
				end)
			end
		end
	end)
end)

RegisterNetEvent("qr-stable:SellHorseWithId", function(id)
	local modelHorse = nil
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	MySQL.Async.fetchAll('SELECT * FROM horses WHERE `citizenid`=@citizenid;', {citizenid = Playercid}, function(horses)

		for i = 1, #horses do
		   if tonumber(horses[i].id) == tonumber(id) then
				modelHorse = horses[i].model
				MySQL.Async.fetchAll('DELETE FROM horses WHERE `citizenid`=@citizenid AND`id`=@id;', {citizenid = Playercid,  id = id}, function(result)
				end)
			end
		end

		for k,v in pairs(Config.Horses) do
			for models,values in pairs(v) do
				if models ~= "name" then
					if models == modelHorse then
						local price = tonumber(values[3]/2)
						Player.Functions.AddMoney("cash", price, "stable-sell-horse")
						TriggerEvent('qbr-log:server:CreateLog', 'shops', 'Stable', 'red', "**"..GetPlayerName(Player.PlayerData.source) .. " (citizenid: "..Player.PlayerData.citizenid.." | id: "..Player.PlayerData.source..")** sold a horse for $"..price..".")
					end
				end
			end
		end
	end)
end)

-- feed horse
QRCore.Functions.CreateUseableItem("carrot", function(source, item)
    local Player = QRCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("qr-stable:client:feedhorse", source, item.name, 25)
    end
end)

QRCore.Functions.CreateUseableItem("sugar", function(source, item)
    local Player = QRCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("qr-stable:client:feedhorse", source, item.name, 50)
    end
end)

-- brush horse
QRCore.Functions.CreateUseableItem("horsebrush", function(source, item)
    local Player = QRCore.Functions.GetPlayer(source)
	TriggerClientEvent("qr-stable:client:brushhorse", source, item.name)
end)