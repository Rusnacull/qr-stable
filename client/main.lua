local QRCore = exports['qr-core']:GetCoreObject()
-- Variables
cam = nil
hided = false
spawnedCamera = nil
choosePed = {}
pedSelected = nil
sex = nil
zoom = 4.0
offset = 0.2
DeleteeEntity = true
inCustomization = false

local InterP = true
local adding = true
local showroomHorse_entity
local showroomHorse_model
local entity
local entity2
local MyHorse_entity
local MyWagon_entity
local IdMyHorse
local saddlecloths = {}
local acshorn = {}
local bags = {}
local horsetails = {}
local manes = {}
local saddles = {}
local stirrups = {}
local acsluggage = {}
local lantern = {}
local Mask = {}
local mustache = {} -- new
local horsebridles = {}-- new
local horseholster = {}--
local horseshoes = {}--
local promptGroup
local varStringCasa = CreateVarString(10, "LITERAL_STRING", Lang:t('stable.stable'))
local blip
local prompts = {}
local SpawnPoint = {}
local StablePoint = {}
local HeadingPoint
local CamPos = {}
local SpawnplayerHorse = 0
local Spawnplayerwagon = 0
local horseModel
local horseName
local horseDBID
local wagonModel
local wagonName
local horseComponents = {}
local initializing = false
local initializing2 = false
local supporterstatus = 0
local flying = false
local dead = false
local horsemax
local horsecurrent
local selectionofwagons = {}

local exp
local sex
local wagonid
local wagonmaxweight = Config.HorseInvWeight
local wagonmaxslots = Config.HorseInvSlots

local horsemaxweight = Config.HorseInvWeight
local horsemaxslots = Config.HorseInvSlots


local alreadySentShopData = false

myHorses = {}
SaddlesUsing = nil
SaddleclothsUsing = nil
StirrupsUsing = nil
BagsUsing = nil
ManesUsing = nil
HorseTailsUsing = nil
AcsHornUsing = nil
AcsLuggageUsing = nil
LanternUsing = nil
MaskUsing = nil
MustacheUsing = nil
HorsebridlesUsing = nil
HorseholsterUsing = nil
HorseshoesUsing = nil






cameraUsing = {
    {
        name = "Horse",
        x = 0.2,
        y = 0.0,
        z = 1.8
    },
    {
        name = "Olhos",
        x = 0.0,
        y = -0.4,
        z = 0.65
    }
}

-- Functions

RegisterNetEvent("qr-stable:finda")
AddEventHandler("qr-stable:finda", function(x)
    horseDBID = x
    --print(horseDBID)
end)

RegisterNetEvent("qr-stable:findb")
AddEventHandler("qr-stable:findb", function(x)
 wagonid = x 
end)

Citizen.CreateThread(function() -- onesync culling
    while true do
        Citizen.Wait(10)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        if entity ~= nil then
            local coords2 = GetEntityCoords(entity)
            if GetDistanceBetweenCoords(coords,coords2,  true) > 500 then
                if horseDBID ~= nil and not IsEntityDead(entity) then
                    local stamina = Citizen.InvokeNative(0x775A1CA7893AA8B5,entity, Citizen.ResultAsFloat()) --ACTUAL STAMINA CORE GETTER
                    local health = GetEntityHealth(entity, Citizen.ResultAsInteger())
                    local stats = {stamina = stamina, health = health}
                    TriggerServerEvent("qr-stable:savehorsestats",horseDBID,stats)
                    --print("Salvez Status Cal 1 ")
                    --TriggerServerEvent("qr-stable:removenetwork",horseDBID)
                    
                end
                DeleteEntity(entity)
                entity = nil
            end
        end
        if entity2 ~= nil then
            local coords2 = GetEntityCoords(entity2)
            if GetDistanceBetweenCoords(coords,coords2,  true) > 500 then
                DeleteEntity(entity2)
                entity2 = nil
            end
        end
    end
end)


--horses[i].id, horses[i].citizenid, horses[i].model, horses[i].name, horses[i].comps, horses[i].exp, horses[i].sex, horses[i].lvl
--local function SetHorseInfo(horse_id, horse_cid, horse_model, horse_name, horse_components, viatacal, staminacal)
local function SetHorseInfo(horse_id, horse_cid, horse_model, horse_name, horse_components, horse_exp, sexz, horse_lvl, horse_maxweight, horse_maxslots)
    horseDBID = horse_id
	horseID = horse_cid
	horseModel = horse_model
    horseName = horse_name
    horseComponents = horse_components
    exp = horse_exp
    sex = sexz
    horsemaxweight = horse_maxweight
    horsemaxslots = horse_maxslots



    -- print("cal in drum spre tine")
    -- print("Id Cal " ..horseDBID)
    -- print("Id Detinator Cal " ..horseID)
    -- print("Model Cal " ..horseModel)
    -- print("Nume Cal " ..horseName)
    -- print("Componente Cal " ..horseComponents)
    -- print("Experienta Cal " ..exp)
    -- print("Sex Cal " ..sex)
    if not inCustomization then
        InitiateHorse()
    end
end

local function SetwagonInfo(wagon_model, wagon_name, wagon_id, wagon_maxweight, wagon_maxwslots)
    wagonModel = wagon_model
    wagonName = wagon_name
    wagonid = wagon_id
    wagonmaxweight = wagon_maxweight
    wagonmaxslots = wagon_maxwslots
	--print("Setam wagon in client")
    --InitiateWagon()
end



local function NativeSetPedComponentEnabled(ped, component)
    Citizen.InvokeNative(0xD3A7B003ED343FD9, ped, component, true, true, true)
end



RegisterNetEvent("qr-stable:SetWagonInfo")
AddEventHandler("qr-stable:SetWagonInfo", SetwagonInfo)


local function createCamera(entity)
    groundCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
    SetCamCoord(groundCam, StablePoint[1] + 0.5, StablePoint[2] - 3.6, StablePoint[3] )
    SetCamRot(groundCam, -20.0, 0.0, HeadingPoint + 20)
    SetCamActive(groundCam, true)
    RenderScriptCams(true, false, 1, true, true)
    --Wait(3000)
    -- last camera, create interpolate
    fixedCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
    SetCamCoord(fixedCam, StablePoint[1] + 0.5, StablePoint[2] - 3.6, StablePoint[3] +1.8)
    SetCamRot(fixedCam, -20.0, 0, HeadingPoint + 50.0)
    SetCamActive(fixedCam, true)
    SetCamActiveWithInterp(fixedCam, groundCam, 3900, true, true)
    Wait(3900)
    DestroyCam(groundCam)
end

local function getShopData()
    alreadySentShopData = true
    local ret = Config.Horses
    return ret
end

local function setcloth(hash)
    local model2 = GetHashKey(tonumber(hash))
    if not HasModelLoaded(model2) then
        Citizen.InvokeNative(0xFA28FE3A6246FC30, model2)
    end
    Citizen.InvokeNative(0xD3A7B003ED343FD9, MyHorse_entity, tonumber(hash), true, true, true)
end

local function OpenStable()

    if entity ~= nil then
        TaskAnimalFlee(entity, PlayerPedId(), -1)
        Wait(1000)
        DeleteEntity(entity)
    end
    inCustomization = true
            horsesp = true
            local playerHorse = MyHorse_entity
            SetEntityHeading(playerHorse, 334)
            DeleteeEntity = true
            SetNuiFocus(true, true)
            InterP = true
            local hashm = GetEntityModel(playerHorse)

        if hashm ~= nil and IsPedOnMount(PlayerPedId()) then
            createCamera(PlayerPedId())
        else
            createCamera(PlayerPedId())
        end
        if not alreadySentShopData then
            SendNUIMessage(
                {
                    action = "show",
                    shopData = getShopData()
                }
            )
        else
            SendNUIMessage(
                {
                    action = "show"
                }
            )
        end
            TriggerServerEvent("qr-stable:AskForMyHorses")
end

local function rotation(dir)
    local playerHorse = MyHorse_entity
    local pedRot = GetEntityHeading(playerHorse) + dir
    SetEntityHeading(playerHorse, pedRot % 360)
end

local function rotation2(dir)
    local playerWagon = MyWagon_entity
    local pedRot = GetEntityHeading(playerWagon) + dir
    SetEntityHeading(playerWagon, pedRot % 360)
end

local function SetHorseName(data)
    SetNuiFocus(false, false)
    SendNUIMessage(
        {
            action = "hide"
        }
    )
    Wait(200)
    local HorseName = ""

	CreateThread(function()
		AddTextEntry('FMMC_MPM_NA', Lang:t('stable.set_name'))
		DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
		while (UpdateOnscreenKeyboard() == 0) do
			DisableAllControlActions(0);
			Wait(0);
		end
		if (GetOnscreenKeyboardResult()) then
            HorseName = GetOnscreenKeyboardResult()
            TriggerServerEvent('qr-stable:BuyHorse', data, HorseName)


            SetNuiFocus(true, true)
            SendNUIMessage(
            {
                action = "show",
                shopData = getShopData()
            }
        )

        Wait(1000)
        TriggerServerEvent("qr-stable:AskForMyHorses")
		end
    end)
end

local function CloseStable()
	local dados = {
		SaddlesUsing,
		SaddleclothsUsing,
		StirrupsUsing,
		BagsUsing,
		ManesUsing,
		HorseTailsUsing,
		AcsHornUsing,
		AcsLuggageUsing,
		LanternUsing,
        MaskUsing,
        MustacheUsing,
        HorsebridlesUsing,
        HorseholsterUsing,
        HorseshoesUsing,

	}
	local DadosEncoded = json.encode(dados)
    --print(DadosEncoded)
	if DadosEncoded ~= "[]" then
        --print(DadosEncoded)
		TriggerServerEvent("qr-stable:UpdateHorseComponents", dados, IdMyHorse, MyHorse_entity )
		Wait(1000)
		DeleteEntity(SpawnplayerHorse)
        SpawnplayerHorse = 0
        inCustomization = false
	end
end


local gettingstatus = false
local horsestats = {}
RegisterNetEvent("qr-stable:recstats")
AddEventHandler("qr-stable:recstats", function(stats)
    if stats ~= nil then
        horsestats = stats

        gettingstatus = false
    end
    --InitiateHorse()
    --gettingstatus = false
end)


local dontrun = false
function InitiateHorse(atCoords) -- findme 
    --print("cam asa ceva")
    if initializing then
        return
    end
	--print("aici incepe totu 1 ")
    initializing = true

    if horseModel == nil and horseName == nil then
        Citizen.Wait(1000)
        if horseModel == nil and horseName == nil then
				QRCore.Functions.Notify(Config.Language.nohorse, 'error')
            dontrun = true
        else
            dontrun = false
        end
    end
    if dontrun then
		--print("Incehei initializarea 1")
        initializing = false
    else
        if SpawnplayerHorse ~= 0 then
            if horseDBID ~= nil and not IsEntityDead(entity) then
                local stamina = Citizen.InvokeNative(0x775A1CA7893AA8B5,entity, Citizen.ResultAsFloat()) --ACTUAL STAMINA CORE GETTER
                local health = GetEntityHealth(entity, Citizen.ResultAsInteger())
                local stats = {stamina = stamina, health = health}
				--print("Spawnezzzzzzzzzzzzzzzzzzzz")
                TriggerServerEvent("qr-stable:savehorsestats", horseDBID, stats)
                --print("Salvez Status Cal 2 ")
                --TriggerServerEvent("qr-stable:removenetwork", horseDBID)
            end
            DeleteEntity(SpawnplayerHorse)
            SpawnplayerHorse = 0
        end

        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)

        local modelHash = GetHashKey(horseModel)

        if not HasModelLoaded(modelHash) then
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Citizen.Wait(10)
            end
        end

        local spawnPosition
        local spawnPosition = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, Config.spawnrange, 0) --- this would be better to spawn horse on nearest road. so it doesnt spawn inside houses.
        if spawnPosition == nil then
			--print("inchid dupa spawn 1")
            initializing = false
            return
        end

        entity = CreatePed(modelHash, spawnPosition, GetEntityHeading(ped), true, true)
        SetModelAsNoLongerNeeded(modelHash)
        local spawnable = vector3(0, 0, 0)
        local spawnable2 = vector3(0, 0, 0)
        local nothing, roadpoint = GetClosestRoad(spawnPosition.x,spawnPosition.y,spawnPosition.z,0.0,25,spawnable,spawnable2,0,0,0.0,true)
        local dist = GetDistanceBetweenCoords(spawnPosition,roadpoint, true)
        if Config.horsedistancecall-20 > dist then 
            spawnPosition = roadpoint
        end

        local height = 100
        SetEntityCoords(entity, spawnPosition.x, spawnPosition.y, height + 0.0)
        FreezeEntityPosition(entity, true)
        Wait(1000)
        local foundground, groundZ, normal  = GetGroundZAndNormalFor_3dCoord(spawnPosition.x, spawnPosition.y, height + 0.0)
        while not foundground do 
        	height = height + 10
        	foundground, groundZ, normal = GetGroundZAndNormalFor_3dCoord(spawnPosition.x, spawnPosition.y, height + 0.0)
        	Wait(100)
        end
        SetEntityCoords(entity, spawnPosition.x, spawnPosition.y, groundZ)
        FreezeEntityPosition(entity, false)
        Citizen.InvokeNative(0xA91E6CF94404E8C9,entity)

        --[[ zone = Citizen.InvokeNative(0x43AD8FC02B429D33,x,y,z,-1)
        if zone == -108848014 or zone == -2066240242 or zone == 892930832 or zone == -2145992129 then 
            SetEntityCoords(entity, x + 5, y + 5, z, true, true, true, false)
        else
            for height = 1, 1000 do
                SetEntityCoords(entity, spawnPosition.x, spawnPosition.y, height + 0.0, true, true, true, false)
                local foundGround, zPos = GetGroundZAndNormalFor_3dCoord(spawnPosition.x, spawnPosition.y, height + 0.0)
                if foundGround then
                    SetEntityCoords(entity, spawnPosition.x, spawnPosition.y, height + 0.0, true, true, true, false)
                    break
                end
                Citizen.Wait(5)
            end
        end ]]
        
        Citizen.InvokeNative(0x9587913B9E772D29, entity, 0)
        Citizen.InvokeNative(0x4DB9D03AC4E1FA84, entity, -1, -1, 0)
        Citizen.InvokeNative(0xBCC76708E5677E1D, entity, 0)
        Citizen.InvokeNative(0xB8B6430EAD2D2437, entity, GetHashKey("PLAYER_HORSE"))
        Citizen.InvokeNative(0xFD6943B6DF77E449, entity, false)
        SetPedConfigFlag(entity, 324, true)
        SetPedConfigFlag(entity, 211, true)
        SetPedConfigFlag(entity, 208, true)
        SetPedConfigFlag(entity, 209, true)
        SetPedConfigFlag(entity, 400, true)
        SetPedConfigFlag(entity, 297, true)
        SetPedConfigFlag(entity, 136, false)
        SetPedConfigFlag(entity, 312, false)
        SetPedConfigFlag(entity, 113, true)
        SetPedConfigFlag(entity, 301, false)
        SetPedConfigFlag(entity, 277, true)
        SetPedConfigFlag(entity, 319, false)
        SetPedConfigFlag(entity, 6, true)

        SetAnimalTuningBoolParam(entity, 25, false)
        SetAnimalTuningBoolParam(entity, 24, false)
        SetAnimalTuningBoolParam(entity, 48, false)

        TaskAnimalUnalerted(entity, -1, false, 0, 0)
        Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
        SpawnplayerHorse = entity
        local network = NetworkGetNetworkIdFromEntity(entity)
        --TriggerServerEvent("qr-stable:addnetwork",network,horseDBID)

        Citizen.InvokeNative(0xED1C764997A86D5A, PlayerPedId(), entity)
        SetPedNameDebug(entity, horseName)
        SetPedPromptName(entity, horseName)
        SetAttributePoints(entity, 7, exp)
        if horseComponents ~= nil and horseComponents ~= "0" then
            for _, componentHash in pairs(json.decode(horseComponents)) do
                NativeSetPedComponentEnabled(entity, tonumber(componentHash))
            end
        end
        if horseModel == "A_C_Horse_MP_Mangy_Backup" then
            NativeSetPedComponentEnabled(entity, 0x106961A8) --sela
            NativeSetPedComponentEnabled(entity, 0x508B80B9) --blanket
        end
        TaskGoToEntity(entity, ped, -1, 7.2, 2.0, 0, 0)
        SetPedConfigFlag(entity, 297, true) -- Enable_Horse_Leadin
        local bliph = Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, entity)
        Citizen.InvokeNative(0x9CB1A1623062F402, bliph, horseName)
        N_0xe6d4e435b56d5bd0(GetPlayerIndex(),entity)
        if sex == 1 then
            Citizen.InvokeNative(0x5653AB26C82938CF, entity, 41611, 1.0)
            Citizen.InvokeNative(0xCC8CA3E88256E58F, entity, 0, 1, 1, 1, 0)
            initializing = false
			--print("Sex 1")
        else
            Citizen.InvokeNative(0x5653AB26C82938CF, entity, 41611, 0.0)
            Citizen.InvokeNative(0xCC8CA3E88256E58F, entity, 0, 1, 1, 1, 0)
            initializing = false
			--print("Sex 2")
        end
		-- print("chemam status cal din DB")
		-- print("Id Cal")
		-- print(tonumber(horseDBID))
		
        gettingstatus = true
        TriggerServerEvent("qr-stable:gethorsestats",horseDBID)
		-- print("inainte de getstatus")
		-- print(json.encode(horsestats))

        while gettingstatus do
            Wait(1000)
        end

		-- print("Status luat din DB")
		-- print(json.encode(horsestats))
        -- if next(horsestats) == nil  then
		if next(horsestats) == nil  then
			--print("VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV")
            local stamina = Citizen.InvokeNative(0xCB42AFE2B613EE55,entity, Citizen.ResultAsFloat()) --max stamina 
            local stamina2 = Citizen.InvokeNative(0x775A1CA7893AA8B5,entity, Citizen.ResultAsFloat()) --current stamina 
            local check = stamina - stamina2
            local valueStamina = Citizen.InvokeNative(0x36731AC041289BB1, entity, 1, Citizen.ResultAsInteger())
            local valueHealth = Citizen.InvokeNative(0x36731AC041289BB1, entity, 0, Citizen.ResultAsInteger())
            Citizen.InvokeNative(0xC6258F41D86676E0, entity, 1, valueStamina + 100)
            Citizen.InvokeNative(0xC6258F41D86676E0, entity, 0, valueHealth + 100)
            local health = GetEntityMaxHealth(entity, Citizen.ResultAsInteger())

            SetEntityHealth(entity, health,0)
            Citizen.InvokeNative(0xC3D4B754C0E86B9E,entity,check+0.0)
            local stats = {stamina = stamina2+check, health = health}
			
            TriggerServerEvent("qr-stable:savehorsestats", horseDBID, stats)
            --print("Salvez Status Cal 3 ")
        else
			--print("Capcanaaaaaaaa")
				-----Test
				--Citizen.InvokeNative(0xBA8818212633500A,entity, 7, 1); -- SET_TRANSPORT_CONFIG_FLAG players cant use this horse
			
            local stamina2 = Citizen.InvokeNative(0x775A1CA7893AA8B5,entity, Citizen.ResultAsFloat()) --current stamina 
            local stamina = Citizen.InvokeNative(0xCB42AFE2B613EE55,entity, Citizen.ResultAsFloat()) --max stamina 
            local maxhealth = GetEntityMaxHealth(entity, Citizen.ResultAsInteger())
            local check = (horsestats.stamina-stamina2)
            if stamina2 + check >= stamina then
                local valueStamina = Citizen.InvokeNative(0x36731AC041289BB1, entity, 1, Citizen.ResultAsInteger())
                Citizen.InvokeNative(0xC6258F41D86676E0, entity, 1, valueStamina + 100)
            end
            if horsestats.health >= maxhealth then
                local valueHealth = Citizen.InvokeNative(0x36731AC041289BB1, entity, 0, Citizen.ResultAsInteger())
                Citizen.InvokeNative(0xC6258F41D86676E0, entity, 0, valueHealth + 100)
            end
            if horsestats.health > 0 then
                -- print(horsestats.health,"saved health")
                Citizen.InvokeNative(0xC6258F41D86676E0, entity, 0, horsestats.health)
                --SetEntityHealth(entity, horsestats.health,0)
            end
            if (stamina2 + check) > 0 then
                -- print(horsestats.stamina,"saved Stamina")
                Citizen.InvokeNative(0xC3D4B754C0E86B9E,entity,check+0.0)
            end
            
        end
    end
end



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local sleep = true
        Wait(30000)
        if entity ~= nil and horseDBID ~= nil and not IsEntityDead(entity) then 
            sleep = false
            local stamina = Citizen.InvokeNative(0x775A1CA7893AA8B5,entity, Citizen.ResultAsFloat()) --ACTUAL STAMINA CORE GETTER
            local health = GetEntityHealth(entity, Citizen.ResultAsInteger())
            local stats = {stamina = stamina, health = health}
            TriggerServerEvent("qr-stable:savehorsestats", horseDBID, stats)
            --print("Salvez Status Cal 4")
			--print(" Trimit la server salveaza Status status cal 5555555")
			--print(json.encode(stats))
        end
        if sleep then 
            Wait(500)
        end
    end
end)


local dontrun = false
local function InitiateWagon(atCoords)
	--print("Initializam Wagon")
    if initializing2 then
        return
    end

    initializing2 = true
	-- print("Model wagon")
	-- print(wagonModel)
	-- print("Nume Wagon")
	-- print(wagonName)

    if wagonModel == nil and wagonName == nil then
		--TriggerServerEvent("qr-stable:RequestMyHorseInfo")
        Wait(1000)
        if wagonModel == nil and wagonName == nil then
			QRCore.Functions.Notify(Config.Language.nowagon, 'error')
            dontrun = true
        else
            dontrun = false
        end
    end
    if dontrun then
        initializing2 = false
    else
        if Spawnplayerwagon ~= 0 then
            DeleteEntity(Spawnplayerwagon)
            Spawnplayerwagon = 0
        end

        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)

        local modelHash = GetHashKey(wagonModel)

        if not HasModelLoaded(modelHash) then
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Citizen.Wait(10)
            end
        end

        local spawnPosition
        local spawnPosition = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, Config.spawnrangewagon, 0)
        if spawnPosition == nil then
            initializing2 = false
            return
        end
        entity2 = CreateVehicle(modelHash, spawnPosition.x, spawnPosition.y, spawnPosition.z, 0, true, false)
        SetModelAsNoLongerNeeded(modelHash)
        local spawnable = vector3(0, 0, 0)
        local spawnable2 = vector3(0, 0, 0)
        local nothing, roadpoint = GetClosestRoad(spawnPosition.x,spawnPosition.y,spawnPosition.z,0.0,25,spawnable,spawnable2,0,0,0.0,true)
        local dist = GetDistanceBetweenCoords(spawnPosition,roadpoint, true)
        if Config.horsedistancecall-20 > dist then
            spawnPosition = roadpoint
        end
        local height = 100
        SetEntityCoords(entity2, spawnPosition.x, spawnPosition.y, height + 0.0)
        FreezeEntityPosition(entity2, true)
        Wait(1000)
        local foundground, groundZ, normal  = GetGroundZAndNormalFor_3dCoord(spawnPosition.x, spawnPosition.y, height + 0.0)
        while not foundground do
        	height = height + 10
        	foundground, groundZ, normal = GetGroundZAndNormalFor_3dCoord(spawnPosition.x, spawnPosition.y, height + 0.0)
        	Wait(100)
        end
        SetEntityCoords(entity2, spawnPosition.x, spawnPosition.y, groundZ)
        FreezeEntityPosition(entity2, false)
        Citizen.InvokeNative(0xA91E6CF94404E8C9,entity2)


        Spawnplayerwagon = entity2
        local network = NetworkGetNetworkIdFromEntity(entity2)
        --TriggerServerEvent("qr-stable:addnetwork2",network,wagonid)
        Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, entity2)
        SetVehicleHasBeenOwnedByPlayer(entity2, true)
        initializing2 = false
    end
end



function WhistleHorse()
    if Config.callnearstable then
        --print("cheama cal 1")
        flying = true
        if entity ~= nil then
            if GetScriptTaskStatus(entity, 0x4924437D, 0) ~= 0 then
                local pcoords = GetEntityCoords(PlayerPedId())
                local hcoords = GetEntityCoords(entity)
                local caldist = Vdist(pcoords.x, pcoords.y, pcoords.z, hcoords.x, hcoords.y, hcoords.z)
                TaskGoToEntity(entity, PlayerPedId(), -1, 7.2, 2.0, 0, 0)
            end
        else
            if callstable() then
                TriggerServerEvent('qr-stable:CheckSelectedHorse')
            else
                QRCore.Functions.Notify(Config.Language.toofarfromstable, 'error')
            end
        end
    else
        --print("cheama cal 2")
        flying = true
        if entity ~= nil then
            --print("cheama cal 11")
            if GetScriptTaskStatus(entity, 0x4924437D, 0) ~= 0 then
                local pcoords = GetEntityCoords(PlayerPedId())
                local hcoords = GetEntityCoords(entity)
                local caldist = Vdist(pcoords.x, pcoords.y, pcoords.z, hcoords.x, hcoords.y, hcoords.z)
                --print("cheama cal 12")
                if caldist >= Config.horsedistancecall then
                    --print("cheama cal 14")
                    if not Config.dontallowhorseintown then
                        if horseDBID ~= nil and not IsEntityDead(entity) then
                            local stamina = Citizen.InvokeNative(0x775A1CA7893AA8B5,entity, Citizen.ResultAsFloat()) --ACTUAL STAMINA CORE GETTER
                            local health = GetEntityHealth(entity, Citizen.ResultAsInteger())
                            local stats = {stamina = stamina, health = health}
                            TriggerServerEvent("qr-stable:savehorsestats",horseDBID,stats)
                            --TriggerServerEvent("qr-stable:removenetwork",horseDBID)
                            --print("Salvez Status Cal 5 ")
                        end
                        DeleteEntity(entity)
                        entity = nil
                        TriggerServerEvent('qr-stable:CheckSelectedHorse')
                    else
                        local pedCoords = GetEntityCoords(PlayerPedId())
                        local town_hash = Citizen.InvokeNative(0x43AD8FC02B429D33, pedCoords, 1)
                        if IsTownBanned(town_hash) then
                            QRCore.Functions.Notify(Config.Language.tooclosetown, 'error')
                        else
                            if horseDBID ~= nil and not IsEntityDead(entity) then
                                local stamina = Citizen.InvokeNative(0x775A1CA7893AA8B5,entity, Citizen.ResultAsFloat()) --ACTUAL STAMINA CORE GETTER
                                local health = GetEntityHealth(entity, Citizen.ResultAsInteger())
                                local stats = {stamina = stamina, health = health}
                                TriggerServerEvent("qr-stable:savehorsestats",horseDBID,stats)
                                --TriggerServerEvent("qr-stable:removenetwork",horseDBID)
                                --print("Salvez Status Cal 6 ")
                            end
                            DeleteEntity(entity)
                            entity = nil
 
                            TriggerServerEvent('qr-stable:CheckSelectedHorse')
                        end
                    end
                else
                    --print("cheama cal aaaa")
                    TaskGoToEntity(entity, PlayerPedId(), -1, 7.2, 2.0, 0, 0)
                end
            end
        else
            if not Config.dontallowhorseintown then
                TriggerServerEvent('qr-stable:CheckSelectedHorse')
            else
                local pedCoords = GetEntityCoords(PlayerPedId())
                local town_hash = Citizen.InvokeNative(0x43AD8FC02B429D33, pedCoords, 1)
                if IsTownBanned(town_hash) then
                    QRCore.Functions.Notify(Config.Language.tooclosetown, 'error')
                else
                    TriggerServerEvent('qr-stable:CheckSelectedHorse')
                    --print("cheama cal")
                end
            end
        end
    end
end



IsTownBanned = function (town)
	for k,v in pairs(Config.BannedTowns) do
		if town == GetHashKey(v) then
			return true
		end
	end
	return false
end


--- pentru open inventory la caruta
-- local volumeArea = Citizen.InvokeNative(0xB3FB80A32BAE3065, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0) -- _CREATE_VOLUME_SPHERE

-- function GetClosestveh(coords, range)
--     local vehiclesToDraw = {}
--     if volumeArea then 
--         Citizen.InvokeNative(0x541B8576615C33DE, volumeArea, coords.x, coords.y, coords.z) -- SET_VOLUME_COORDS
--         local itemsFound = Citizen.InvokeNative(0x886171A12F400B89, volumeArea, itemSet2, 2) -- Get volume items into itemset
--         if itemsFound then
--             n = 0
--             while n < itemsFound do
--                 vehiclesToDraw[(GetIndexedItemInItemset(n, itemSet2))] = true
--                 n = n + 1
--             end
--         end
--         Citizen.InvokeNative(0x20A4BF0E09BEE146, itemSet2)
--         for k,v in pairs(vehiclesToDraw) do 
--             Citizen.InvokeNative(0x20A4BF0E09BEE146, itemSet2)
--             return k
--         end
        
--     end
--     if IsItemsetValid(itemSet2) then
--         Citizen.InvokeNative(0x20A4BF0E09BEE146, itemSet2)
--     end
-- end

-- local closewagon
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(500)
--         local coords = GetEntityCoords(PlayerPedId())
--         closewagon = GetClosestveh(coords)
        
--     end
-- end)







-- Facut
local function Whistlewagon()
    if Config.callnearstablewagon then
        if SpawnplayerHorse ~= 0 then
            if GetScriptTaskStatus(SpawnplayerHorse, 0x4924437D, 0) ~= 0 then
                local pcoords = GetEntityCoords(PlayerPedId())
                local hcoords = GetEntityCoords(SpawnplayerHorse)
                local caldist = #(pcoords - hcoords)
                if caldist >= 100 then
                    DeleteEntity(SpawnplayerHorse)
                    Wait(1000)
                    SpawnplayerHorse = 0
                else
                    TaskGoToEntity(SpawnplayerHorse, PlayerPedId(), -1, 7.2, 2.0, 0, 0)
                end
            end
        else
            TriggerServerEvent('qr-stable:CheckSelectedwagon')
            Wait(1000)
            InitiateWagon()
        end
    else
        if SpawnplayerHorse ~= 0 then
            if GetScriptTaskStatus(SpawnplayerHorse, 0x4924437D, 0) ~= 0 then
                local pcoords = GetEntityCoords(PlayerPedId())
                local hcoords = GetEntityCoords(SpawnplayerHorse)
                local caldist = #(pcoords - hcoords)
                if caldist >= 100 then
                    DeleteEntity(SpawnplayerHorse)
                    Wait(1000)
                    SpawnplayerHorse = 0
                else
                    TaskGoToEntity(SpawnplayerHorse, PlayerPedId(), -1, 7.2, 2.0, 0, 0)
                end
            end
        else
            TriggerServerEvent('qr-stable:CheckSelectedwagon')
            Wait(1000)
            InitiateWagon()
        end
    end
end


function fleeHorse(playerHorse)
    if horseDBID ~= nil and not IsEntityDead(entity) then
        local stamina = Citizen.InvokeNative(0x775A1CA7893AA8B5,entity, Citizen.ResultAsFloat()) --ACTUAL STAMINA CORE GETTER
        local health = GetEntityHealth(entity, Citizen.ResultAsInteger())
        local stats = {stamina = stamina, health = health}
        TriggerServerEvent("qr-stable:savehorsestats", horseDBID, stats)
        --print("Salvez Status Cal 7 ")
    end
    TaskAnimalFlee(entity, PlayerPedId(), -1)
    Wait(5000)
    DeleteEntity(entity)
    --TriggerServerEvent("qr-stable:removenetwork",horseDBID)
    if SpawnplayerHorse ~= 0 then
        SpawnplayerHorse = 0
    end
    if entity ~= nil then
        entity = nil
    end
    if horseModel ~= nil then
        horseModel = nil
    end
    if horseName ~= nil then
        horseName = nil
    end
end



-- local function fleeHorse(playerHorse)
--     TaskAnimalFlee(SpawnplayerHorse, PlayerPedId(), -1)
--     Wait(5000)
--     DeleteEntity(SpawnplayerHorse)
--     Wait(1000)
--     SpawnplayerHorse = 0
--     entity = nil
-- end

function fleewagon(Spawnplayerwagon)
    Wait(5000)
    DeleteEntity(Spawnplayerwagon)
    Wait(1000)
    if Mywagon_entity ~= nil then
        DeleteEntity(Mywagon_entity)
        Mywagon_entity = nil
    end

    if entity2 ~= nil then
        DeleteEntity(entity2)
        entity2 = nil
    end

    if Spawnplayerwagon ~= nil then
        DeleteEntity(Spawnplayerwagon)
        Spawnplayerwagon = nil
    end

    if showroomwagon_entity ~= nil then
        DeleteEntity(showroomwagon_entity)
        showroomwagon_entity = nil
    end
    if wagonModel ~= nil then
        wagonModel = nil
    end
    if wagonName ~= nil then
        wagonName = nil
    end
end

RegisterNetEvent('qr-stable:exp')
AddEventHandler('qr-stable:exp', function(v,x)
    if v == entity then
        local maxp = GetMaxAttributePoints(entity,7)
        local xp = x
        TriggerServerEvent("qr-stable:addexpbonding", maxp, horseDBID, xp)
        if Config.Debug then
            print("Client ".."max xp: "..maxp.." | ID: "..horseDBID.." | exp "..xp)
        end
    end
end)

RegisterNetEvent('qr-stable:updatehorse')
AddEventHandler('qr-stable:updatehorse', function(exp)
    horsebonding = exp
    SetAttributePoints(entity, 7, horsebonding)
end)



function whenKeyJustPressed(key)
    if Citizen.InvokeNative(0x580417101DDB492F, 0, key) then
        return true
    else
        return false
    end
end


local keyopen = false --addprop

Citizen.CreateThread(function() -- horse menu
    while true do
        Citizen.Wait(1)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local horseCoords = GetEntityCoords(entity)
        local wagonCoords = GetEntityCoords(entity2)
        local sleep = true
        if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, horseCoords.x, horseCoords.y, horseCoords.z, false) < 2  then
         sleep = false
            if IsDisabledControlJustReleased(0,1287709438) then -- findme
                if not IsPedOnMount(PlayerPedId()) then
                    Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), entity, GetHashKey("Interaction_LootSaddleBags"), 0, 1)
                    local network = NetworkGetNetworkIdFromEntity(entity)
                    local model = GetEntityModel(entity)
                    TriggerServerEvent("qr-stable:searchhorse",network,model)
                    Wait(500)
                end
            end
            if whenKeyJustPressed(Config.keys.two) then
                if entity ~= nil then
                    horsemax = GetMaxAttributePoints(entity,7)
                    horsecurrent = GetAttributePoints(entity,7)
                    levels()
                    if keyopen == false then
                        WarMenu.OpenMenu('horse')
                    else end
                end
            end	
        end
        if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, wagonCoords.x, wagonCoords.y, wagonCoords.z, false) < 2  then
         sleep = false
            if whenKeyJustPressed(Config.keys.two) then
                if entity2 ~= nil then
                    if keyopen == false then
                        WarMenu.OpenMenu('wagon')
                    else end
                end
            end	
        end
       
        if sleep then 
            Citizen.Wait(1000)
        end	
    end    
end)

function levels()
    local max = GetMaxAttributePoints(entity,7)
    local current = GetAttributePoints(entity,7)
    local third = max / 3
    if current >= max then 
        level = 4
    elseif current >= third and third * 2 > current then
        level = 2
    elseif current >= third * 2 and max > current  then
        level = 3
    elseif third > current then
        level = 1
    end
end

-- local function GetClosestPlayer() -- interactions, job, tracker
--     local closestPlayers = QRCore.Functions.GetPlayersFromCoords()
--     local closestDistance = -1
--     local closestPlayer = -1
--     local coords = GetEntityCoords(PlayerPedId())

--     for i = 1, #closestPlayers, 1 do
--         if closestPlayers[i] ~= PlayerId() then
--             local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
--             local distance = #(pos - coords)

--             if closestDistance == -1 or closestDistance > distance then
--                 closestPlayer = closestPlayers[i]
--                 closestDistance = distance
--             end
--         end
--     end

--     return closestPlayer, closestDistance
-- end


Citizen.CreateThread( function()
    WarMenu.CreateMenu('horse', Config.Language.horseinfo)
    WarMenu.CreateMenu('wagon', Config.Language.wagoninfo)
    WarMenu.CreateSubMenu('transferhorse', 'horse', Config.Language.sure)
    WarMenu.CreateSubMenu('transferwagon', 'wagon', Config.Language.sure)
    while true do
        if WarMenu.IsMenuOpened('horse') then
            if WarMenu.Button(Config.Language.horsename ..horseName) then
            end
            if WarMenu.Button(Config.Language.horsetrainlevel ..level) then
               
            end
            if WarMenu.Button(Config.Language.horsetrainexp..horsecurrent.." / "..horsemax) then
            end
            if WarMenu.MenuButton(Config.Language.givehorseowner, 'transferhorse') then end
            if WarMenu.Button(Config.Language.saddlebags) then
                if not IsPedOnMount(PlayerPedId()) then 
                    Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), entity, GetHashKey("Interaction_LootSaddleBags"), 0, 1)
                end
                WarMenu.CloseMenu()
                local network = NetworkGetNetworkIdFromEntity(entity)
                local model = GetEntityModel(entity)
                if SpawnplayerHorse ~= 0 then
                    Wait(1000)
                    InvHorse(SpawnplayerHorse)
                end
            end
        elseif WarMenu.IsMenuOpened('wagon') then
            if WarMenu.Button(Config.Language.wagonname..wagonName) then 
            end
            if Config.syn_outfitter then 
                if WarMenu.Button(Config.Language.equipment) then 
                    WarMenu.CloseMenu()
                    TriggerEvent("syn_outfitter:open")
                end
            end
            if WarMenu.Button(Config.Language.dismiss) then 
                fleewagon(Spawnplayerwagon)
                WarMenu.CloseMenu()
            end
            if WarMenu.MenuButton(Config.Language.givewagonowner, 'transferwagon') then end
            if WarMenu.Button(Config.Language.wagoninv) then
                WarMenu.CloseMenu()
                local network = NetworkGetNetworkIdFromEntity(entity2)
                local model = GetEntityModel(entity2)
                if Spawnplayerwagon ~= 0 then
                    Wait(1000)
                    InvWagon(Spawnplayerwagon)
                end
            end
        elseif WarMenu.IsMenuOpened('transferhorse') then
            if WarMenu.Button(Config.Language.yes) then
                -- local player, distance = GetClosestPlayer()

                -- if player ~= -1 and distance < 50.0 then
                --     local playerId = GetPlayerServerId(player)
                --     QRCore.Functions.TriggerCallback('police:GetPlayerStatus', function(result)
                --         if result then
                --             for k, v in pairs(result) do
                --                 QRCore.Functions.Notify(''..v..'', 'success')
                --                 SetPedAsTempPlayerHorse(v, horseDBID)
                --             end
                --         end
                --     end, playerId)

                -- end
                
                -- if Config.vorp then
                --     TriggerEvent("vorpinputs:getInput", "Confirm", "Player ID", function(cb)
                --         local playerid =     tonumber(cb)
                --         TriggerServerEvent("qr-stable:transferownership", playerid, horseDBID)
                --     end)
                -- elseif Config.redem then
                --     TriggerEvent("syn_inputs:sendinputs", "Confirm", "Player ID", function(cb)
                --         local playerid =     tonumber(cb)
                --         TriggerServerEvent("qr-stable:transferownership", playerid, horseDBID)
                --     end)
                -- end
                --fleeHorse(SpawnplayerHorse)

                --end
                QRCore.Functions.Notify('In viitor asa scrie nu ?', 'success')

                WarMenu.CloseMenu()
            end
            if WarMenu.Button(Config.Language.no) then
                WarMenu.CloseMenu()
            end
         elseif WarMenu.IsMenuOpened('transferwagon') then
            if WarMenu.Button(Config.Language.yes) then
                if Config.vorp then
                    TriggerEvent("qr-inputs:getInput", "Confirm", "Player ID", function(cb)
                        local playerid =     tonumber(cb)
                        TriggerServerEvent("qr-stable:transferownership2", playerid, wagonid)
                    end)
                elseif Config.redem then
                    TriggerEvent("qr-inputs:sendinputs", "Confirm", "Player ID", function(cb)
                        local playerid =     tonumber(cb)
                        TriggerServerEvent("qr-stable:transferownership2", playerid, wagonid)
                    end)
                end
                fleewagon(Spawnplayerwagon)
                WarMenu.CloseMenu()
            end
            if WarMenu.Button(Config.Language.no) then
                WarMenu.CloseMenu()
            end 
        end
        WarMenu.Display()
		Citizen.Wait(0)
	end
end)


local function createCam(creatorType)
    for k, v in pairs(cams) do
        if cams[k].type == creatorType then
            cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", cams[k].x, cams[k].y, cams[k].z, cams[k].rx, cams[k].ry, cams[k].rz, cams[k].fov, false, 0) -- CAMERA COORDS
            SetCamActive(cam, true)
            RenderScriptCams(true, false, 3000, true, false)
            createPeds()
        end
    end
end

local function interpCamera(cameraName, entity)
    for k, v in pairs(cameraUsing) do
        if cameraUsing[k].name == cameraName then
            tempCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
            AttachCamToEntity(tempCam, entity, cameraUsing[k].x + CamPos[1], cameraUsing[k].y + CamPos[2], cameraUsing[k].z)
            SetCamActive(tempCam, true)
            SetCamRot(tempCam, -30.0, 0, HeadingPoint + 50.0)
            if InterP then
                SetCamActiveWithInterp(tempCam, fixedCam, 1200, true, true)
                InterP = false
            end
        end
    end
end

--NUI Callbacks

RegisterNUICallback("rotate", function(data, cb)
	if (data["key"] == "left") then
		rotation(20)
	else
		rotation(-20)
	end
	cb("ok")
end)

RegisterNUICallback("rotate2", function(data, cb)
	if (data["key"] == "left") then
		rotation2(20)
	else
		rotation2(-20)
	end
	cb("ok")
end)

RegisterNUICallback("Saddles", function(data)
	zoom = 4.0
	offset = 0.2
	if tonumber(data.id) == 0 then
		num = 0
		SaddlesUsing = num
		local playerHorse = MyHorse_entity
		Citizen.InvokeNative(0xD710A5007C2AC539, playerHorse, 0xBAA7E618, 0) -- RemoveTagFromMetaPed
		Citizen.InvokeNative(0xCC8CA3E88256E58F, playerHorse, 0, 1, 1, 1, 0) -- Actually remove the component
	else
		local num = tonumber(data.id)
		hash = ("0x" .. saddles[num])
		setcloth(hash)
		SaddlesUsing = ("0x" .. saddles[num])
	end
end)

RegisterNUICallback("Saddlecloths", function(data)
	zoom = 4.0
	offset = 0.2
	if tonumber(data.id) == 0 then
		num = 0
		SaddleclothsUsing = num
		local playerHorse = MyHorse_entity
		Citizen.InvokeNative(0xD710A5007C2AC539, playerHorse, 0xDA6DADCA, 0) -- RemoveTagFromMetaPed
		Citizen.InvokeNative(0xCC8CA3E88256E58F, playerHorse, 0, 1, 1, 1, 0) -- Actually remove the component
	else
		local num = tonumber(data.id)
		hash = ("0x" .. saddlecloths[num])
		setcloth(hash)
		SaddleclothsUsing = ("0x" .. saddlecloths[num])
	end
end)

RegisterNUICallback("Stirrups", function(data)
	zoom = 4.0
	offset = 0.2
	if tonumber(data.id) == 0 then
		num = 0
		StirrupsUsing = num
		local playerHorse = MyHorse_entity
		Citizen.InvokeNative(0xD710A5007C2AC539, playerHorse, 0xDA6DADCA, 0) -- RemoveTagFromMetaPed
		Citizen.InvokeNative(0xCC8CA3E88256E58F, playerHorse, 0, 1, 1, 1, 0) -- Actually remove the component
	else
		local num = tonumber(data.id)
		hash = ("0x" .. stirrups[num])
		setcloth(hash)
		StirrupsUsing = ("0x" .. stirrups[num])
	end
end)

RegisterNUICallback("Bags", function(data)
	zoom = 4.0
	offset = 0.2
	if tonumber(data.id) == 0 then
		num = 0
		BagsUsing = num
		local playerHorse = MyHorse_entity
		Citizen.InvokeNative(0xD710A5007C2AC539, playerHorse, 0xDA6DADCA, 0) -- RemoveTagFromMetaPed
		Citizen.InvokeNative(0xCC8CA3E88256E58F, playerHorse, 0, 1, 1, 1, 0) -- Actually remove the component
	else
		local num = tonumber(data.id)
		hash = ("0x" .. bags[num])
		setcloth(hash)
		BagsUsing = ("0x" .. bags[num])
	end
end)

RegisterNUICallback("Manes", function(data)
	zoom = 4.0
	offset = 0.2
	if tonumber(data.id) == 0 then
		num = 0
		ManesUsing = num
		local playerHorse = MyHorse_entity
		Citizen.InvokeNative(0xD710A5007C2AC539, playerHorse, 0xDA6DADCA, 0) -- RemoveTagFromMetaPed
		Citizen.InvokeNative(0xCC8CA3E88256E58F, playerHorse, 0, 1, 1, 1, 0) -- Actually remove the component
	else
		local num = tonumber(data.id)
		hash = ("0x" .. manes[num])
		setcloth(hash)
		ManesUsing = ("0x" .. manes[num])
	end
end)

RegisterNUICallback("HorseTails", function(data)
	zoom = 4.0
	offset = 0.2
	if tonumber(data.id) == 0 then
		num = 0
		HorseTailsUsing = num
		local playerHorse = MyHorse_entity
		Citizen.InvokeNative(0xD710A5007C2AC539, playerHorse, 0xDA6DADCA, 0) -- RemoveTagFromMetaPed
		Citizen.InvokeNative(0xCC8CA3E88256E58F, playerHorse, 0, 1, 1, 1, 0) -- Actually remove the component
	else
		local num = tonumber(data.id)
		hash = ("0x" .. horsetails[num])
		setcloth(hash)
		HorseTailsUsing = ("0x" .. horsetails[num])
	end
end)

RegisterNUICallback("AcsHorn", function(data)
	zoom = 4.0
	offset = 0.2
	if tonumber(data.id) == 0 then
		num = 0
		AcsHornUsing = num
		local playerHorse = MyHorse_entity
		Citizen.InvokeNative(0xD710A5007C2AC539, playerHorse, 0xDA6DADCA, 0) -- RemoveTagFromMetaPed
		Citizen.InvokeNative(0xCC8CA3E88256E58F, playerHorse, 0, 1, 1, 1, 0) -- Actually remove the component
	else
		local num = tonumber(data.id)
		hash = ("0x" .. acshorn[num])
		setcloth(hash)
		AcsHornUsing = ("0x" .. acshorn[num])
	end
end)

RegisterNUICallback("AcsLuggage", function(data)
	zoom = 4.0
	offset = 0.2
	if tonumber(data.id) == 0 then
		num = 0
		AcsLuggageUsing = num
		local playerHorse = MyHorse_entity
		Citizen.InvokeNative(0xD710A5007C2AC539, playerHorse, 0xDA6DADCA, 0) -- RemoveTagFromMetaPed
		Citizen.InvokeNative(0xCC8CA3E88256E58F, playerHorse, 0, 1, 1, 1, 0) -- Actually remove the component
	else
		local num = tonumber(data.id)
		hash = ("0x" .. acsluggage[num])
		setcloth(hash)
		AcsLuggageUsing = ("0x" .. acsluggage[num])
	end
end)

RegisterNUICallback("Mask", function(data)
	zoom = 4.0
	offset = 0.2
	if tonumber(data.id) == 0 then
		num = 0
		HorseMaskUsing = num
		local playerHorse = MyHorse_entity
		Citizen.InvokeNative(0xD710A5007C2AC539, playerHorse, 0xD3500E5D, 0) -- RemoveTagFromMetaPed
		Citizen.InvokeNative(0xCC8CA3E88256E58F, playerHorse, 0, 1, 1, 1, 0) -- Actually remove the component
	else
		local num = tonumber(data.id)
		hash = ("0x" .. horsemask[num])
		setcloth(hash)
		HorseMaskUsing = ("0x" .. horsemask[num])
	end
end)

RegisterNUICallback("Lantern", function(data)
	zoom = 4.0
	offset = 0.2
	if tonumber(data.id) == 0 then
		num = 0
		HorseLanternUsing = num
		local playerHorse = MyHorse_entity
		Citizen.InvokeNative(0xD710A5007C2AC539, playerHorse, 0xD3500E5D, 0) -- RemoveTagFromMetaPed
		Citizen.InvokeNative(0xCC8CA3E88256E58F, playerHorse, 0, 1, 1, 1, 0) -- Actually remove the component
	else
		local num = tonumber(data.id)
		hash = ("0x" .. lantern[num])
		setcloth(hash)
		HorseLanternUsing = ("0x" .. lantern[num])
	end
end)

RegisterNUICallback(
    "Mustache",
    function(data)
        zoom = 4.0
        offset = 0.2
        if tonumber(data.id) == 0 then
            num = 0
            MustacheUsing = num
            local playerHorse = MyHorse_entity
            Citizen.InvokeNative(0xD710A5007C2AC539, playerHorse, 0xBAA7E618, 0) -- HAT REMOVE
            Citizen.InvokeNative(0xCC8CA3E88256E58F, playerHorse, 0, 1, 1, 1, 0) -- Actually remove the component
        else
            local num = tonumber(data.id)
            hash = ("0x" .. mustache[num].hash) -- add .hash
            setcloth(hash)
            MustacheUsing = ("0x" .. mustache[num].hash) -- add .hash
        end
    end
)


RegisterNUICallback(
    "Horsebridles",
    function(data)
        zoom = 4.0
        offset = 0.2
        if tonumber(data.id) == 0 then
            num = 0
            HorsebridlesUsing = num
            local playerHorse = MyHorse_entity
            Citizen.InvokeNative(0xD710A5007C2AC539, playerHorse, 0xBAA7E618, 0) -- HAT REMOVE
            Citizen.InvokeNative(0xCC8CA3E88256E58F, playerHorse, 0, 1, 1, 1, 0) -- Actually remove the component
        else
            local num = tonumber(data.id)
            hash = ("0x" .. horsebridles[num].hash) -- add .hash
            setcloth(hash)
            HorsebridlesUsing = ("0x" .. horsebridles[num].hash) -- add .hash
        end
    end
)

RegisterNUICallback(
    "Horseholster",
    function(data)
        zoom = 4.0
        offset = 0.2
        if tonumber(data.id) == 0 then
            num = 0
            HorseholsterUsing = num
            local playerHorse = MyHorse_entity
            Citizen.InvokeNative(0xD710A5007C2AC539, playerHorse, 0xBAA7E618, 0) -- HAT REMOVE
            Citizen.InvokeNative(0xCC8CA3E88256E58F, playerHorse, 0, 1, 1, 1, 0) -- Actually remove the component
        else
            local num = tonumber(data.id)
            hash = ("0x" .. horseholster[num].hash) -- add .hash
            setcloth(hash)
            HorseholsterUsing = ("0x" .. horseholster[num].hash) -- add .hash
        end
    end
)

RegisterNUICallback(
    "Horseshoes",
    function(data)
        zoom = 4.0
        offset = 0.2
        if tonumber(data.id) == 0 then
            num = 0
            HorseshoesUsing = num
            local playerHorse = MyHorse_entity
            Citizen.InvokeNative(0xD710A5007C2AC539, playerHorse, 0xBAA7E618, 0) -- HAT REMOVE
            Citizen.InvokeNative(0xCC8CA3E88256E58F, playerHorse, 0, 1, 1, 1, 0) -- Actually remove the component
        else
            local num = tonumber(data.id)
            hash = ("0x" .. horseshoes[num].hash) -- add .hash
            setcloth(hash)
            HorseshoesUsing = ("0x" .. horseshoes[num].hash) -- add .hash
        end
    end
)



RegisterNUICallback("selectHorse", function(data)
	TriggerServerEvent("qr-stable:SelectHorseWithId", tonumber(data.horseID))
end)

RegisterNUICallback("sellHorse", function(data)
	DeleteEntity(showroomHorse_entity)
	TriggerServerEvent("qr-stable:SellHorseWithId", tonumber(data.horseID))
	TriggerServerEvent("qr-stable:AskForMyHorses")
	alreadySentShopData = false
	Wait(300)

	SendNUIMessage(
		{
			action = "show",
			shopData = getShopData()
		}
	)
	TriggerServerEvent("qr-stable:AskForMyHorses")

end)

RegisterNUICallback("loadHorse", function(data)
	local horseModel = data.horseModel

	if showroomHorse_model == horseModel then
		return
	end

	if MyHorse_entity ~= nil then
		DeleteEntity(MyHorse_entity)
		MyHorse_entity = nil
	end

	local modelHash = GetHashKey(horseModel)

	if IsModelValid(modelHash) then
		if not HasModelLoaded(modelHash) then
			RequestModel(modelHash)
			while not HasModelLoaded(modelHash) do
				Wait(10)
			end
		end
	end

	if showroomHorse_entity ~= nil then
		DeleteEntity(showroomHorse_entity)
		showroomHorse_entity = nil
	end

	showroomHorse_model = horseModel
	showroomHorse_entity = CreatePed(modelHash, SpawnPoint.x, SpawnPoint.y, SpawnPoint.z - 0.98, SpawnPoint.h, false, 0)
	Citizen.InvokeNative(0x283978A15512B2FE, showroomHorse_entity, true)
	Citizen.InvokeNative(0x58A850EAEE20FAA3, showroomHorse_entity)
	NetworkSetEntityInvisibleToNetwork(showroomHorse_entity, true)
	SetVehicleHasBeenOwnedByPlayer(showroomHorse_entity, true)
	interpCamera("Horse", showroomHorse_entity)
end)

RegisterNUICallback("loadMyHorse", function(data)
	local horseModel = data.horseModel
	IdMyHorse = data.IdHorse
    --TriggerEvent('qr-stable:SetHorseInfo')
    --TriggerServerEvent('qr-stable:CheckSelectedHorse')
	if showroomHorse_model == horseModel then
		return
	end

	if showroomHorse_entity ~= nil then
		DeleteEntity(showroomHorse_entity)
		showroomHorse_entity = nil
	end

	if MyHorse_entity ~= nil then
		DeleteEntity(MyHorse_entity)
		MyHorse_entity = nil
	end

	showroomHorse_model = horseModel

	local modelHash = GetHashKey(showroomHorse_model)

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			Wait(10)
		end
	end

	MyHorse_entity = CreatePed(modelHash, SpawnPoint.x, SpawnPoint.y, SpawnPoint.z - 0.98, SpawnPoint.h, false, 0)
	Citizen.InvokeNative(0x283978A15512B2FE, MyHorse_entity, true)
	Citizen.InvokeNative(0x58A850EAEE20FAA3, MyHorse_entity)
	NetworkSetEntityInvisibleToNetwork(MyHorse_entity, true)
	SetVehicleHasBeenOwnedByPlayer(MyHorse_entity, true)
	local horseComponents = json.decode(data.HorseComp)
	if horseComponents ~= '[]' then
		for _, Key in pairs(horseComponents) do
			local model2 = GetHashKey(tonumber(Key))
			if not HasModelLoaded(model2) then
				Citizen.InvokeNative(0xFA28FE3A6246FC30, model2)
			end
			Citizen.InvokeNative(0xD3A7B003ED343FD9, MyHorse_entity, tonumber(Key), true, true, true)
		end
	end
	interpCamera("Horse", MyHorse_entity)
end)

RegisterNUICallback("BuyHorse", function(data)
	SetHorseName(data)
end)

RegisterNUICallback("CloseStable", function()
	SetNuiFocus(false, false)
	SendNUIMessage(
		{
			action = "hide"
		}
	)
	SetEntityVisible(PlayerPedId(), true)

	showroomHorse_model = nil

	if showroomHorse_entity ~= nil then
		DeleteEntity(showroomHorse_entity)
	end

	if MyHorse_entity ~= nil then
		DeleteEntity(MyHorse_entity)
	end

	DestroyAllCams(true)
	showroomHorse_entity = nil
	alreadySentShopData = false
	CloseStable()
end)

--Events

AddEventHandler("onResourceStop",function(resourceName)
	if resourceName == GetCurrentResourceName() then
		for _, prompt in pairs(prompts) do
			PromptDelete(prompt)
			RemoveBlip(blip)
		end
	end
end)

AddEventHandler("onResourceStop", function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end
	SetNuiFocus(false, false)
	SendNUIMessage(
		{
			action = "hide"
		}
	)
end)

AddEventHandler("onResourceStop", function(resourceName)
	if GetCurrentResourceName() == resourceName then
		DeleteEntity(SpawnplayerHorse)
		SpawnplayerHorse = 0
		DeleteEntity(Spawnplayerwagon)
		Spawnplayerwagon = 0
	end
end)

RegisterNetEvent("qr-stable:SetHorseInfo", SetHorseInfo)




RegisterNetEvent('qr-stable:client:UpdadeHorseComponents', function(MyHorse_entity, components)
    for _, value in pairs(components) do
        NativeSetPedComponentEnabled(MyHorse_entity, value)
    end
end)


RegisterNetEvent("qr-stable:ReceiveHorsesData", function(dataHorses)
	SendNUIMessage(
		{
			myHorsesData = dataHorses
		}
	)
end)

-- Threads


Citizen.CreateThread(function() -- check death
    while true do
        Citizen.Wait(1)
        local sleep = true
        if entity ~= nil and DoesEntityExist(entity) then
            if IsEntityDead(entity) and dead == false then
                sleep = false
                if SpawnplayerHorse ~= nil then
                    SpawnplayerHorse = 0
                end
                if entity ~= nil then
                    entity = nil
                end
                if horseModel ~= nil then
                    horseModel = nil
                end
                if horseName ~= nil then
                    horseName = nil
                end
                dead = true
            end
        end
        if dead then
            sleep = false
            --print("Cal mort ..........")
            QRCore.Functions.Notify(Config.Language.asteaptacalmort ..Config.deadtimer, 'eroor')
            Citizen.Wait(Config.deadtimer)
			QRCore.Functions.Notify(Config.Language.payfordead ..Config.horsehealcost, 'eroor')

            --TriggerServerEvent("qr-stable:paydeadhorse")
            dead = false
        end
        if sleep then
            Citizen.Wait(1000)
        end
    end
end)






CreateThread(function()
	while true do
		Wait(1)
		local coords = GetEntityCoords(PlayerPedId())
		for _, prompt in pairs(prompts) do
			if PromptIsJustPressed(prompt) then
				for k, v in pairs(Config.Stables) do
					if #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z)) < 7 then
						HeadingPoint = v.Heading
						StablePoint = {v.Pos.x, v.Pos.y, v.Pos.z}
						CamPos = {v.SpawnPoint.CamPos.x, v.SpawnPoint.CamPos.y}
						SpawnPoint = {x = v.SpawnPoint.Pos.x, y = v.SpawnPoint.Pos.y, z = v.SpawnPoint.Pos.z, h = v.SpawnPoint.Heading}
						Wait(300)
					end
				end
				OpenStable()
			end
		end
	end
end)

CreateThread(function()
	for _, v in pairs(Config.Stables) do
		local blip = N_0x554d9d53f696d002(1664425300, v.Pos.x, v.Pos.y, v.Pos.z)
		SetBlipSprite(blip, 4221798391, 1)
		SetBlipScale(blip, 0.2)
		Citizen.InvokeNative(0x9CB1A1623062F402, blip, v.Name)
		local prompt = PromptRegisterBegin()
		PromptSetActiveGroupThisFrame(promptGroup, varStringCasa)
		PromptSetControlAction(prompt, 0xE8342FF2)
		PromptSetText(prompt, CreateVarString(10, "LITERAL_STRING", "Open Stable"))
		PromptSetStandardMode(prompt, true)
		PromptSetEnabled(prompt, 1)
		PromptSetVisible(prompt, 1)
		PromptSetHoldMode(prompt, 1)
		PromptSetPosition(prompt, v.Pos.x, v.Pos.y, v.Pos.z)
		N_0x0c718001b77ca468(prompt, 3.0)
		PromptSetGroup(prompt, promptGroup)
		PromptRegisterEnd(prompt)
		prompts[#prompts+1] = prompt
	end
end)

CreateThread(function()
	while true do
	Wait(100)
		if MyHorse_entity ~= nil then
			SendNUIMessage(
				{
					EnableCustom = "true"
				}
			)
		else
			SendNUIMessage(
				{
					EnableCustom = "false"
				}
			)
		end
	end
end)

CreateThread(function()
	while true do
		local getHorseMood = Citizen.InvokeNative(0x42688E94E96FD9B4, SpawnplayerHorse, 3, 0, Citizen.ResultAsFloat())
		if getHorseMood >= 0.60 then
		Citizen.InvokeNative(0x06D26A96CA1BCA75, SpawnplayerHorse, 3, PlayerPedId())
		Citizen.InvokeNative(0xA1EB5D029E0191D3, SpawnplayerHorse, 3, 0.99)
		end
		Wait(30000)
	end
end)

CreateThread(function()
	while true do
        Citizen.Wait(1)
        if Citizen.InvokeNative(0x91AEF906BCA88877, 0, Config.keys.three) and dead == false then -- Control =  H
            WhistleHorse()
            --print("Apasat si chemat")
            Citizen.Wait(6000)
            --print("Apasat si chemat")
        elseif Citizen.InvokeNative(0x91AEF906BCA88877, 0, Config.keys.three) and dead then

            QRCore.Functions.Notify(Config.Language.deadhorse, 'error')
            
            Citizen.Wait(6000)
        end

        if Citizen.InvokeNative(0x91AEF906BCA88877, 0, Config.keys.one) then -- Control =  U
            Citizen.InvokeNative(0xB31A277C1AC7B7FF,PlayerPedId(),1,2,GetHashKey("KIT_EMOTE_ACTION_FOLLOW_ME_1"),0,0,0,0,0)  -- FULL BODY EMOTE
            Whistlewagon()
			Citizen.Wait(6000)
        end

        if Citizen.InvokeNative(0xF3A21BCD95725A4A, 0, Config.keys.four) and IsPedOnMount(PlayerPedId()) then -- alt to rear up on horse 
            if Citizen.InvokeNative(0x580417101DDB492F, 0, Config.keys.five) then
                if entity ~= nil then
                    if GetMount(PlayerPedId()) == entity then 
                        levels()
                        if level >= 2 then
                            TaskHorseAction(GetMount(PlayerPedId()), 1,0,0)
                        else
                            TaskHorseAction(GetMount(PlayerPedId()), 2,0,0)
                        end
                    else
                        TaskHorseAction(GetMount(PlayerPedId()), 2,0,0)
                    end
                else
                    TaskHorseAction(GetMount(PlayerPedId()), 2,0,0)
                end
                Citizen.Wait(6000)
            end
        end

        if Citizen.InvokeNative(0x91AEF906BCA88877, 0, 0x4216AF06) then -- Control = Horse Flee            
			if SpawnplayerHorse ~= 0 then
				fleeHorse(SpawnplayerHorse)
			end
        end
        if Citizen.InvokeNative(0x91AEF906BCA88877, 0, QRCore.Shared.Keybinds['B']) then -- horse inventory
			if SpawnplayerHorse ~= 0 then
                Wait(1000)
				InvHorse(SpawnplayerHorse)
			end
		end
    end
end)





local lead
local counter = 0
local rest = false
local riding
local stopriding
local counter2 = 0
local stopincrease = false
Citizen.CreateThread(function() -- horse leading
    while true do
        Citizen.Wait(1)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local horseCoords = GetEntityCoords(entity)
        local sleep = true
        if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, horseCoords.x, horseCoords.y, horseCoords.z, false) < 2  then
         sleep = false
         local x = GetMaxAttributePoints(entity,7)
         local y = GetAttributePoints(entity,7)
            if x == y then
                stopincrease = true
            else
                stopincrease = false
            end
            if Citizen.InvokeNative(0x91AEF906BCA88877, 0, 0x17D3BFF5) then -- Control = InteractLeadAnimal           
                if entity ~= nil and rest == false and stopincrease == false then
                    lead = 1
                end
                if rest then
                    if Config.vorp then
                        TriggerEvent("vorp:TipBottom", Config.Language.tired, 2000)
                    elseif Config.redem then
                        TriggerEvent("redem_roleplay:ShowObjective", Config.Language.tired, 2000)
                    end
                end
            end
            if Citizen.InvokeNative(0x91AEF906BCA88877, 0, 0x7914A3DD) then -- Control = StopLeadingAnimal           
                if entity ~= nil then
                    if lead == 1 then 
                        lead = 0
                        TriggerEvent('qr-stable:exp', entity, counter)
                        Citizen.Wait(500)
                        counter = 0
                    end
                end
            end	
        end
        if sleep then 
            Citizen.Wait(1000)
        end	
    end    
end)


Citizen.CreateThread(function() -- disable instancing errors
    while true do
        Citizen.Wait(1)
        local sleep = true
        local visable = IsEntityVisible(PlayerPedId())
        
        if not visable then 
            sleep = false
            TriggerEvent('qr-stable:deleteinfo')
        end
        if sleep then 
            Citizen.Wait(1000)
        end	
    end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local sleep = true 
        if lead == 1 then
            sleep = false 
            if IsPedWalking(PlayerPedId()) then
                Citizen.Wait(Config.horselead) -- 6 seconds
                counter = counter + 1 -- amount to increase 
            end
            if counter >= 100 then -- limit increase till rest 
                TriggerEvent('qr-stable:exp', entity, counter)
                Citizen.Wait(500)
                counter = 0
                lead = 0
                if Config.vorp then
                    TriggerEvent("vorp:TipBottom", Config.Language.tired2 , 2000)
                elseif Config.redem then
                    TriggerEvent("redem_roleplay:ShowObjective", Config.Language.tired2 , 2000)
                end
                rest = true
            end
            if  IsPedSprinting(PlayerPedId()) then 
                TriggerEvent('qr-stable:exp', entity, counter)
                Citizen.Wait(500)
                counter = 0
                lead = 0
            end
            if  IsPedRunning(PlayerPedId()) then 
                TriggerEvent('qr-stable:exp', entity, counter)
                Citizen.Wait(500)
                counter = 0
                lead = 0
            end
            if  IsPedRagdoll(PlayerPedId()) then 
                TriggerEvent('qr-stable:exp', entity, counter)
                Citizen.Wait(500)
                counter = 0
                lead = 0
            end
            if Citizen.InvokeNative(0x91AEF906BCA88877, 0, 0xB238FE0B) then
                TriggerEvent('qr-stable:exp', entity, counter)
                Citizen.Wait(500)
                counter = 0
                lead = 0
            end
        end
        if sleep then 
            Wait(500)
        end
    end    
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        local sleep = true 
        if rest then  
            sleep = false 
            Citizen.Wait(300000) -- wait for 5 minutes for rest to reset 
            if Config.vorp then
                TriggerEvent("vorp:TipBottom", Config.Language.better, 2000)
            elseif Config.redem then
                TriggerEvent("redem_roleplay:ShowObjective", Config.Language.better, 2000)
            end
            rest = false
        end
        if sleep then 
            Wait(500)
        end
    end    
end)

Citizen.CreateThread(function() -- horse riding
    while true do
        Citizen.Wait(1)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local horseCoords = GetEntityCoords(entity)
        local sleep = true
        if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, horseCoords.x, horseCoords.y, horseCoords.z, false) < 2  then
         sleep = false
         local x = GetMaxAttributePoints(entity,7)
         local y = GetAttributePoints(entity,7)
            if x == y then
                stopincrease = true
            else
                stopincrease = false
            end
            if IsPedOnMount(player) and GetMount(player) == entity and stopincrease == false then -- Control = InteractLeadAnimal           
                riding = 1
            else 
                if riding == 1 then
                    --TriggerEvent('qr-stable:exp', entity, counter2)
                    --print("1 "..counter2)
                    Citizen.Wait(500)
                    counter2 = 0
                    riding = 0
                end
            end
        end
        if sleep then 
            Citizen.Wait(1000)
        end	
    end    
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local sleep = true
        if riding == 1 then -- 
            sleep = false 
            local walk = IsPedWalking(entity)
            local run = IsPedRunning(entity)
            local sprint = IsPedSprinting(entity)
             if walk or sprint or run then
                Citizen.Wait(Config.horseride) -- 12 seconds
                counter2 = counter2 + 1 -- amount to increase 
                --print("2 "..counter2)
            end 
        end
        if sleep then 
            Citizen.Wait(1000)
        end	
    end    
end)


RegisterNetEvent("qr-stable:deleteinfo")
AddEventHandler("qr-stable:deleteinfo",function()
    if Mywagon_entity ~= nil then
        DeleteEntity(Mywagon_entity)
        Mywagon_entity = nil
    end

    if entity2 ~= nil then
        DeleteEntity(entity2)
        entity2 = nil
    end

    if Spawnplayerwagon ~= nil then
        DeleteEntity(Spawnplayerwagon)
        Spawnplayerwagon = nil
    end

    if showroomwagon_entity ~= nil then
        DeleteEntity(showroomwagon_entity)
        showroomwagon_entity = nil
    end

    if SpawnplayerHorse ~= nil then
        DeleteEntity(SpawnplayerHorse)    
        SpawnplayerHorse = nil
    end
    if entity ~= nil then
        DeleteEntity(entity)    
        entity = nil
    end
    if wagonModel ~= nil then
        wagonModel = nil
    end
    if wagonName ~= nil then
        wagonName = nil
    end
end)





CreateThread(function()
	while adding do
		Wait(0)
		for i, v in ipairs(HorseComp) do
			if v.category == "Saddlecloths" then
				saddlecloths[#saddlecloths+1] = v.Hash
			elseif v.category == "AcsHorn" then
				acshorn[#acshorn+1] = v.Hash
			elseif v.category == "Bags" then
				bags[#bags+1] = v.Hash
			elseif v.category == "HorseTails" then
				horsetails[#horsetails+1] = v.Hash
			elseif v.category == "Manes" then
				manes[#manes+1] = v.Hash
			elseif v.category == "Saddles" then
				saddles[#saddles+1] = v.Hash
			elseif v.category == "Stirrups" then
				stirrups[#stirrups+1] = v.Hash
			elseif v.category == "AcsLuggage" then
				acsluggage[#acsluggage+1] = v.Hash
			elseif v.category == "Mask" then
				Mask[#Mask+1] = v.Hash
			elseif v.category == "Lantern" then
				lantern[#lantern+1] = v.Hash
            elseif v.category == "Mustache" then
				mustache[#mustache+1] = v.Hash
            elseif v.category == "Horsebridles" then
				horsebridles[#horsebridles+1] = v.Hash
            elseif v.category == "Horseholster" then
				horseholster[#horseholster+1] = v.Hash
            elseif v.category == "Horseshoes" then
				horseshoes[#horseshoes+1] = v.Hash
			end
		end
		adding = false
	end
end)

-- trigger horse inventory
function InvHorse()
    --print("Deschizi inventar")
    if SpawnplayerHorse ~= 0 then
		local pcoords = GetEntityCoords(PlayerPedId())
		local hcoords = GetEntityCoords(SpawnplayerHorse)
		if #(pcoords - hcoords) <= 1.7 then
			TriggerEvent('qr-stable:client:horseinventory')
		else
            QRCore.Functions.Notify('Esti prea departe de Cal', 'success')
			--print("Nu esti aproape pentru a deschide inventarul")
		end
    else
        QRCore.Functions.Notify('Nu ai nici un Cal Activ', 'success')
		--print("Nu ai nici un Cal Activ")
    end
end

-- horse inventory
RegisterNetEvent('qr-stable:client:horseinventory', function()
	local horsestash = "HorseInv"..horseDBID
    TriggerServerEvent("inventory:server:OpenInventory", "stash", horsestash, { maxweight = horsemaxweight or Config.HorseInvWeight, slots = horsemaxslots or Config.HorseInvSlots, })
    TriggerEvent("inventory:client:SetCurrentStash", horsestash)
end)



-- trigger horse inventory
function InvWagon()
    --print("Deschizi inventar")
    if Spawnplayerwagon ~= 0 then
		local pcoords = GetEntityCoords(PlayerPedId())
		local hcoords = GetEntityCoords(Spawnplayerwagon)
		if #(pcoords - hcoords) <= 1.7 then
			TriggerEvent('qr-stable:client:wagoninventory')
		else
            QRCore.Functions.Notify('Esti prea departe de Caruta', 'success')
			--print("Nu esti aproape pentru a deschide inventarul")
		end
    else
        QRCore.Functions.Notify('Nu ai nici o Caruta Activa', 'success')
		--print("Nu ai nici un Cal Activ")
    end
end

-- horse inventory
RegisterNetEvent('qr-stable:client:wagoninventory', function()
	local wagonstash = "Wagon"..wagonid
    TriggerServerEvent("inventory:server:OpenInventory", "stash", wagonstash, { maxweight = wagonmaxweight, slots = wagonmaxslots })
    TriggerEvent("inventory:client:SetCurrentStash", wagonstash)
end)





------------------------------------------------------------------------------------------------------------------------------------

-- feed horse
RegisterNetEvent('qr-stable:client:feedhorseTest')
AddEventHandler('qr-stable:client:feedhorseTest', function(itemName, increase)
    Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), SpawnplayerHorse, -224471938, 0, 0) -- TaskAnimalInteraction
    Wait(5)
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
    local Health = GetAttributePoints(SpawnplayerHorse, 0)
    local newHealth = Health + increase
    local Stamina = GetAttributePoints(SpawnplayerHorse, 1)
    local newStamina = Stamina + increase
    Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 0, newHealth) --core
    Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 1, newStamina) --core

	-- fill up cores
	Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 0, newHealth) -- ATTRIBUTE_CORE_HEALTH
	Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 1, newStamina) -- ATTRIBUTE_CORE_STAMINA
	EnableAttributeOverpower(SpawnplayerHorse, 0, 300.0) -- 3x
	EnableAttributeOverpower(SpawnplayerHorse, 1, 300.0) -- 3x
	SetAttributePoints(SpawnplayerHorse, 0, newHealth) -- 3x
	SetAttributePoints(SpawnplayerHorse, 1, newStamina) -- 3x
	Citizen.InvokeNative(0xF6A7C08DF2E28B28, SpawnplayerHorse, 0, newHealth) -- ATTRIBUTE_CORE_HEALTH
	Citizen.InvokeNative(0xF6A7C08DF2E28B28, SpawnplayerHorse, 1, newStamina) -- ATTRIBUTE_CORE_STAMINA


	--print("Viata initiala")
	--print(Health)
	--print("Viata cu +")
	--print(newHealth)


	--print("Stamina initiala")
	--print(Stamina)
	--print("Stamina cu +")
	--print(newStamina)
end)



-- feed horse 1
RegisterNetEvent('rus-stables:client:resetcal')
AddEventHandler('rus-stables:client:resetcal', function(itemName, increase)
    TaskAnimalFlee(SpawnplayerHorse, PlayerPedId(), -1)
    Wait(5000)
	PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
    DeleteEntity(SpawnplayerHorse)
    Wait(1000)


	PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
	SpawnplayerHorse = 0
    entity = nil
end)



-- feed horse 1
RegisterNetEvent('qr-stable:client:feedhorse')
AddEventHandler('qr-stable:client:feedhorse', function(itemName, increase)
    Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), SpawnplayerHorse, -224471938, 0, 0) -- TaskAnimalInteraction
    Wait(5000)
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
    local Health = GetAttributeCoreValue(SpawnplayerHorse, 0)
    local newHealth = Health + increase
    --local Stamina = GetAttributeCoreValue(SpawnplayerHorse, 0)
    --local newStamina = Stamina + increase
    Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 0, newHealth) --core
    Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 1, newStamina) --core

	PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)


end)

-- feed horse 1
RegisterNetEvent('qr-stable:client:feedhorse1')
AddEventHandler('qr-stable:client:feedhorse1', function(itemName, increase)
    Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), SpawnplayerHorse, -224471938, 0, 0) -- TaskAnimalInteraction
    Wait(5000)
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
    local Health = GetAttributeCoreValue(SpawnplayerHorse, 0)
    local newHealth = Health + increase
    --local Stamina = GetAttributeCoreValue(SpawnplayerHorse, 0)
    --local newStamina = Stamina + increase
    Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 0, newHealth) --core
    --Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 1, newStamina) --core

	PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)


end)

-- feed horse 2
RegisterNetEvent('qr-stable:client:feedhorse2')
AddEventHandler('qr-stable:client:feedhorse2', function(itemName, increase)
    Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), SpawnplayerHorse, -224471938, 0, 0) -- TaskAnimalInteraction
    Wait(5000)
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
    --local Health = GetAttributeCoreValue(SpawnplayerHorse, 0)
    --local newHealth = Health + increase
    local Stamina = GetAttributeCoreValue(SpawnplayerHorse, 1)
    local newStamina = Stamina + increase
    --Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 0, newHealth) --core
    Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 1, newStamina) --core

	PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)


end)

-- feed horse
RegisterNetEvent('qr-stable:client:feedhorsedrog1')
AddEventHandler('qr-stable:client:feedhorsedrog1', function(itemName, increase)
    Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), SpawnplayerHorse, -224471938, 0, 0) -- TaskAnimalInteraction
    Wait(5000)
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
    local Health = GetAttributeCoreValue(SpawnplayerHorse, 0)
    local newHealth = Health + increase
    local Stamina = GetAttributeCoreValue(SpawnplayerHorse, 1)
    local newStamina = Stamina + increase
    Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 0, newHealth) --core
    --Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 1, newStamina) --core

	-- fill up cores
	Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 0, 100) -- ATTRIBUTE_CORE_HEALTH
	--Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 1, 100) -- ATTRIBUTE_CORE_STAMINA
	EnableAttributeOverpower(SpawnplayerHorse, 0, 900.0) -- 3x
	--EnableAttributeOverpower(SpawnplayerHorse, 1, 900.0) -- 3x
	Citizen.InvokeNative(0xF6A7C08DF2E28B28, SpawnplayerHorse, 0, 900.0) -- ATTRIBUTE_CORE_HEALTH
	--Citizen.InvokeNative(0xF6A7C08DF2E28B28, SpawnplayerHorse, 1, 900.0) -- ATTRIBUTE_CORE_STAMINA
	-- play core fillup sound
	PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)


end)

-- feed horse
RegisterNetEvent('qr-stable:client:feedhorsedrog2')
AddEventHandler('qr-stable:client:feedhorsedrog2', function(itemName, increase)
    Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), SpawnplayerHorse, -224471938, 0, 0) -- TaskAnimalInteraction
    Wait(5000)
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
    local Health = GetAttributeCoreValue(SpawnplayerHorse, 0)
    local newHealth = Health + increase
    local Stamina = GetAttributeCoreValue(SpawnplayerHorse, 1)
    local newStamina = Stamina + increase
    --Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 0, newHealth) --core
    Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 1, newStamina) --core

	-- fill up cores
	--Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 0, 100) -- ATTRIBUTE_CORE_HEALTH
	Citizen.InvokeNative(0xC6258F41D86676E0, SpawnplayerHorse, 1, 100) -- ATTRIBUTE_CORE_STAMINA
	--EnableAttributeOverpower(SpawnplayerHorse, 0, 900.0) -- 3x
	EnableAttributeOverpower(SpawnplayerHorse, 1, 900.0) -- 3x
	--Citizen.InvokeNative(0xF6A7C08DF2E28B28, SpawnplayerHorse, 0, 900.0) -- ATTRIBUTE_CORE_HEALTH
	Citizen.InvokeNative(0xF6A7C08DF2E28B28, SpawnplayerHorse, 1, 900.0) -- ATTRIBUTE_CORE_STAMINA
	-- play core fillup sound
	PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)


end)



-- brush horse
RegisterNetEvent('qr-stable:client:brushhorse')
AddEventHandler('qr-stable:client:brushhorse', function(itemName)
    Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), SpawnplayerHorse, GetHashKey("INTERACTION_BRUSH"), 0, 0)
	Wait(8000)
	Citizen.InvokeNative(0xE3144B932DFDFF65, SpawnplayerHorse, 0.0, -1, 1, 1)
	ClearPedEnvDirt(SpawnplayerHorse)
	ClearPedDamageDecalByZone(SpawnplayerHorse, 10, "ALL")
	ClearPedBloodDamage(SpawnplayerHorse)
	Citizen.InvokeNative(0xD8544F6260F5F01E, SpawnplayerHorse, 10)
	QRCore.Functions.Notify('Frumos si Curat', 'success')
end)

RegisterNetEvent('qr-stable:client:seringaviata')
AddEventHandler('qr-stable:client:seringaviata', function(itemName)

    Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), SpawnplayerHorse, GetHashKey("Interaction_Injection_Quick"), GetHashKey("p_cs_syringe01x"), 1)
    QRCore.Functions.Notify('Ai injectat calul cu Viata', 'success')
    Wait(1000)
    EnableAttributeOverpower(SpawnplayerHorse, 0, 100.0) -- 3x


end)

RegisterNetEvent('qr-stable:client:seringastamina')
AddEventHandler('qr-stable:client:seringastamina', function(itemName)

    Citizen.InvokeNative(0xCD181A959CFDD7F4, PlayerPedId(), SpawnplayerHorse, GetHashKey("Interaction_Injection_Quick"), GetHashKey("p_cs_syringe01x"), 1)
    QRCore.Functions.Notify('Ai injectat calul cu Stamina', 'success')
    Wait(1000)
    EnableAttributeOverpower(SpawnplayerHorse, 1, 100.0)
end)





















