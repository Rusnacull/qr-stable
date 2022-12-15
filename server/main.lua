local QRCore = exports['qr-core']:GetCoreObject()
local SelectedHorseId = {}
local SelectedWagonId = {}
local Horses
local Wagons


RegisterNetEvent("qr-stable:UpdateHorseComponents", function(components, idhorse, MyHorse_entity)
	local src = source
	local encodedComponents = json.encode(components)
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	local id = idhorse
	MySQL.Async.execute("UPDATE alp_stable_horses SET `comps`=@comps WHERE `citizenid`=@citizenid AND `id`=@id", {comps = encodedComponents, citizenid = Playercid, id = id}, function(done)
		TriggerClientEvent("qr-stable:client:UpdadeHorseComponents", src, MyHorse_entity, components)
	end)
end)


RegisterNetEvent("qr-stable:savehorsestats", function(idhorse, status)
	local src = source
	local encodedStatus = json.encode(status)
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	local id = idhorse
	--print(id, MyHorse_entity, encodedStatus)
	--TriggerEvent("qr-stable:CheckSelectedHorse", src)
	MySQL.Async.execute("UPDATE alp_stable_horses SET `lvl`=@lvl WHERE `citizenid`=@citizenid AND `id`=@id", {lvl = encodedStatus, citizenid = Playercid, id = id}, function(done)


		TriggerClientEvent("qr-stable:recstats", src, status)
		-- print("Encodeddddddddddddddd")
		-- print(encodedStatus)
		-- print("Status de pe server trimit mai departe")
		-- print(encodedStatus)
	end)


end)


RegisterNetEvent("qr-stable:CheckSelectedHorse", function()
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	--print("Cautam calul tau" ..Playercid)
	MySQL.Async.fetchAll('SELECT * FROM alp_stable_horses WHERE `citizenid`=@citizenid;', {citizenid = Playercid}, function(horses)
		if #horses ~= 0 then
			for i = 1, #horses do
				if horses[i].selected == 1 then --components[1].components
					TriggerClientEvent("qr-stable:finda", horses[i].id)
					TriggerClientEvent("qr-stable:SetHorseInfo", src, horses[i].id, horses[i].citizenid, horses[i].model, horses[i].name, horses[i].comps, horses[i].exp, horses[i].sex, horses[i].lvl, horses[i].maxweight , horses[i].maxslots)
					--TriggerClientEvent("qr-stable:SetHorseInfo", src, horses[i].id, horses[i].citizenid, horses[i].model, horses[i].name, horses[i].comps, horses[i].exp, horses[i].sex, horses[i].lvl)
					--print("Detalii Cal")
					--print(horses[i].id, horses[i].citizenid, horses[i].model, horses[i].name, horses[i].comps, horses[i].exp, horses[i].sex, horses[i].lvl)

					--print("Detalii Cal ID")
					--print(horses[i].id)
					--TriggerClientEvent("qr-stable:SetHorseInfo", src)
					--TriggerEvent("qr-stable:AskForMyHorses", src)
				end
			end
		end
	end)
end)


RegisterNetEvent("qr-stable:gethorsestats", function(horseDBID)
	--print("Id cal")
	--print(horseDBID)
	local src = source
	--local horseDBID = nil
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	--print("Continuam din DB")
	 MySQL.Async.fetchAll('SELECT * FROM alp_stable_horses WHERE `citizenid`=@citizenid and `id`=@id;', {citizenid = Playercid, id = horseDBID}, function(horses)
		--local horses = {stamina={235,55}, "stamina":136.576416015625}
		if #horses ~= 0 then
			for i = 1, #horses do
				if horses[i].selected == 1 then
					--TriggerClientEvent("qr-stable:SetHorseInfo", src, horses[i].id, horses[i].citizenid, horses[i].model, horses[i].name, horses[i].comps, horses[i].exp, horses[i].sex, horses[i].lvl)
					local statusamui = json.decode(statusamuinuimans)

					
					TriggerClientEvent("qr-stable:recstats", src, statusamui)
					
				end
			end
		end
	end)
end)

RegisterNetEvent("qr-stable:CheckSelectedwagon", function()
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	--print("caut daca e selectat wagon detinut")
	
	MySQL.Async.fetchAll('SELECT * FROM wagons WHERE `citizenid`=@citizenid;', {citizenid = Playercid}, function(wagons)
		--print(tonumber(wagons))
		if #wagons ~= 0 then
			for i = 1, #wagons do
				if wagons[i].selected == 1 then
					
					TriggerClientEvent("qr-stable:SetWagonInfo", src, wagons[i].model, wagons[i].name, wagons[i].id, wagons[i].maxweight , wagons[i].maxslots)
					
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
	MySQL.Async.fetchAll('SELECT * FROM alp_stable_horses WHERE `citizenid`=@citizenid;', {citizenid = Playercid}, function(horses)
		if horses[1]then
			horseId = horses[1].id
		else
			horseId = nil
		end

		MySQL.Async.fetchAll('SELECT * FROM alp_stable_horses WHERE `citizenid`=@citizenid;', {citizenid = Playercid}, function(components)
			if components[1] then
				components = components[1].comps
				print(components)
			end
		end)
		TriggerClientEvent("qr-stable:ReceiveHorsesData", src, horses)
	end)
end)


RegisterNetEvent("qr-stable:BuyHorse", function(data, name)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid

	MySQL.Async.fetchAll('SELECT * FROM alp_stable_horses WHERE `citizenid`=@citizenid;', {citizenid = Playercid}, function(horses)
		if #horses >= 3 then
			TriggerClientEvent('qr-core:client:DrawText', src, 'Poti detine maxim 3 Cai!', 'left')
			Wait(5000) -- display text for 5 seconds
			TriggerClientEvent('qr-core:client:HideText', src)
			return
		end
		Wait(200)
		if data.IsGold then
			local currentBank = Player.Functions.GetMoney('bank')
			if data.Gold <= currentBank then
				local bank = Player.Functions.RemoveMoney("bank", data.Gold, "stable-bought-horse")
				TriggerClientEvent('qr-core:client:DrawText', src, 'Cal cumparat cu suma de $'..data.Gold, 'left')
				Wait(5000) -- display text for 5 seconds
				TriggerClientEvent('qr-core:client:HideText', src)
				TriggerEvent('qbr-log:server:CreateLog', 'shops', 'Stable', 'green', "**"..GetPlayerName(Player.PlayerData.source) .. " (citizenid: "..Player.PlayerData.citizenid.." | id: "..Player.PlayerData.source..")** bought a horse for $"..data.Gold..".")
			else
				TriggerClientEvent('qr-core:client:DrawText', src, 'Nu detii suficienti bani!', 'left')
				Wait(5000) -- display text for 5 seconds
				TriggerClientEvent('qr-core:client:HideText', src)
				return
			end
		else
			if Player.Functions.RemoveMoney("cash", data.Dollar, "stable-bought-horse") then
				TriggerClientEvent('qr-core:client:DrawText', src, 'Cal cumparat cu suma de $'..data.Dollar, 'left')
				Wait(5000) -- display text for 5 seconds
				TriggerClientEvent('qr-core:client:HideText', src)
				TriggerEvent('qbr-log:server:CreateLog', 'shops', 'Stable', 'green', "**"..GetPlayerName(Player.PlayerData.source) .. " (citizenid: "..Player.PlayerData.citizenid.." | id: "..Player.PlayerData.source..")** bought a horse for $"..data.Dollar..".")
			else
				TriggerClientEvent('qr-core:client:DrawText', src, 'Nu detii suficienti bani!', 'left')
				Wait(5000) -- display text for 5 seconds
				TriggerClientEvent('qr-core:client:HideText', src)
				return
			end
		end
	MySQL.Async.execute('INSERT INTO alp_stable_horses (`citizenid`, `name`, `model`) VALUES (@Playercid, @name, @model);',
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
	MySQL.Async.fetchAll('SELECT * FROM alp_stable_horses WHERE `citizenid`=@citizenid;', {citizenid = Playercid}, function(horse)
		for i = 1, #horse do
			local horseID = horse[i].id
			MySQL.Async.execute("UPDATE alp_stable_horses SET `selected`='0' WHERE `citizenid`=@citizenid AND `id`=@id", {citizenid = Playercid,  id = horseID}, function(done)
			end)

			Wait(300)

			if horse[i].id == id then
				MySQL.Async.execute("UPDATE alp_stable_horses SET `selected`='1' WHERE `citizenid`=@citizenid AND `id`=@id", {citizenid = Playercid, id = id}, function(done)
					--TriggerClientEvent("qr-stable:SetHorseInfo", src, horse[i].id, horse[i].citizenid, horse[i].model, horse[i].name, horse[i].comps, horse[i].exp, horse[i].sex, horse[i].lvl)
					TriggerClientEvent("qr-stable:SetHorseInfo", src, horse[i].id, horse[i].citizenid, horse[i].model, horse[i].name, horse[i].comps, horse[i].exp, horse[i].sex, horse[i].lvl, horse[i].maxweight , horse[i].maxslots)
				
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
	MySQL.Async.fetchAll('SELECT * FROM alp_stable_horses WHERE `citizenid`=@citizenid;', {citizenid = Playercid}, function(horses)

		for i = 1, #horses do
		   if tonumber(horses[i].id) == tonumber(id) then
				modelHorse = horses[i].model
				MySQL.Async.fetchAll('DELETE FROM alp_stable_horses WHERE `citizenid`=@citizenid AND`id`=@id;', {citizenid = Playercid,  id = id}, function(result)
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

---- De facut cu carutele
RegisterNetEvent("qr-stable:SelectWagonWithId", function(id)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	MySQL.Async.fetchAll('SELECT * FROM wagons WHERE `citizenid`=@citizenid;', {citizenid = Playercid}, function(wagon)
		for i = 1, #wagon do
			local wagonID = wagon[i].id
			MySQL.Async.execute("UPDATE wagons SET `selected`='0' WHERE `citizenid`=@citizenid AND `id`=@id", {citizenid = Playercid,  id = wagonID}, function(done)
			end)

			Wait(300)

			if wagon[i].id == id then
				MySQL.Async.execute("UPDATE wagons SET `selected`='1' WHERE `citizenid`=@citizenid AND `id`=@id", {citizenid = Playercid, id = id}, function(done)
					TriggerClientEvent("qr-stable:SetWagonInfo", src, wagon[i].model, wagon[i].name, wagon[i].id, wagon[i].maxweight , wagon[i].maxslots)
				end)
			end
		end
	end)
end)

RegisterNetEvent("qr-stable:addexpbonding", function(maxp, horseDBID, xp)
	local src = source
	local Player = QRCore.Functions.GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	if Config.Debug then
		print("max: "..maxp.."| id: "..horseDBID.."| xp: "..xp)
	end
	if xp > 0 then
		MySQL.Async.fetchAll('SELECT * FROM alp_stable_horses WHERE `citizenid`=@citizenid and `id`=@id;', {citizenid = Playercid, id = horseDBID}, function(horse)
			for i = 1, #horse do
				local horseID = horse[i].id
				local horseexp = horse[i].exp
				if Config.Debug then
					print(horseID.." | "..horseexp)
				end
				if xp >= 1 then
					if horseexp <= maxp then
						local saiidam = horseexp + xp
						if Config.Debug then
							print("sa ii dam: "..saiidam)
						end
						MySQL.Async.execute("UPDATE alp_stable_horses SET `exp`=@exp WHERE `citizenid`=@citizenid AND `id`=@id", {citizenid = Playercid, id = horseID, exp = saiidam}, function(done)
						end)
						TriggerClientEvent("qr-stable:updatehorse", saiidam)
					else
					---------
						if Config.Debug then
							print("Nimic pentru "..horseID.." | "..horseexp)
						end
					end
				end
			end
		end)
	end
end)


-- feed horse
QRCore.Functions.CreateUseableItem("carrot", function(source, item)
    local Player = QRCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("qr-stable:client:feedhorse1", source, item.name, 25)
    end
end)

QRCore.Functions.CreateUseableItem("sugar", function(source, item)
    local Player = QRCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("qr-stable:client:feedhorse2", source, item.name, 25)
    end
end)

QRCore.Functions.CreateUseableItem("consumable_special_tonic", function(source, item)
    local Player = QRCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("qr-stable:client:feedhorsedrog1", source, item.name, 25)
    end
end)

QRCore.Functions.CreateUseableItem("consumable_haycube", function(source, item)
    local Player = QRCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("qr-stable:client:feedhorsedrog2", source, item.name, 25)
    end
end)



-- brush horse
QRCore.Functions.CreateUseableItem("horsebrush", function(source, item)
    local Player = QRCore.Functions.GetPlayer(source)
	TriggerClientEvent("qr-stable:client:brushhorse", source, item.name)
end)

-- seringa viata
QRCore.Functions.CreateUseableItem("seringaviata", function(source, item)
    local Player = QRCore.Functions.GetPlayer(source)
	TriggerClientEvent("qr-stable:client:seringaviata", source, item.name)
end)

-- seringa stamina
QRCore.Functions.CreateUseableItem("seringastamina", function(source, item)
    local Player = QRCore.Functions.GetPlayer(source)
	TriggerClientEvent("qr-stable:client:seringastamina", source, item.name)
end)



-- QRCore.Commands.Add("calut", "Status Cal", {}, false, function(source, args)
-- 		TriggerClientEvent("qr-stable:client:feedhorseTest", source, args, 100)
	
	
-- 		--MySQL.Async.execute("UPDATE alp_stable_horses SET `stamina`=@stamina WHERE `citizenid`=@citizenid AND `id`=@id", {stamina = stamina, citizenid = Playercid, id = id}, function(done)
-- 	--end)
-- end)


QRCore.Commands.Add("rcal", "reset cal", {}, false, function(source, args)
	--TriggerClientEvent("qr-stable:client:feedhorseTest", source, args, 1)

	TriggerClientEvent("rus-stables:client:resetcal", source, 1)
	Wait(1000)
	--MySQL.Async.execute("UPDATE alp_stable_horses SET `stamina`=@stamina WHERE `citizenid`=@citizenid AND `id`=@id", {stamina = stamina, citizenid = Playercid, id = id}, function(done)
--end)
end)




QRCore.Commands.Add("statuscal", "Status Cal", {}, false, function(source)
	TriggerClientEvent("qr-stable:client:statuscall", source)


	--MySQL.Async.execute("UPDATE alp_stable_horses SET `stamina`=@stamina WHERE `citizenid`=@citizenid AND `id`=@id", {stamina = stamina, citizenid = Playercid, id = id}, function(done)
--end)
end)


-- QRCore.Commands.Add("setstatus", "Status Cal2", {}, false, function(source)
-- 	TriggerClientEvent("qr-stable:client:statuscall2", source)


-- 	--MySQL.Async.execute("UPDATE alp_stable_horses SET `stamina`=@stamina WHERE `citizenid`=@citizenid AND `id`=@id", {stamina = stamina, citizenid = Playercid, id = id}, function(done)
-- --end)
-- end)