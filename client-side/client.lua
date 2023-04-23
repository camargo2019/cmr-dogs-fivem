---- Developer by git@camargo2019

local CMR = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP - Creative SummerZ Original
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")

--- Creative Functions

function CMR.playAnim(upper, dict, loop)
    return vRP.playAnim(upper, dict, loop)
end

function CMR.stopAnim(is)
    return vRP.stopAnim(is)
end

function CMR.ClosestPed(distance)
    return vRP.ClosestPed(distance)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CMR Dogs - Tunnel
-----------------------------------------------------------------------------------------------------------------------------------------
sCMR = Tunnel.getInterface("cmr_dogs")

is_sit = false

function getValidateDogModel(dog)
    local model = GetEntityModel(dog)
    for _, v in pairs(config.model) do
        if GetHashKey(v.model) == model then
            return v.anim_name
        end
    end

    return false
end

function getValidateOwnerAndDog(dog_id, owner_id)
    for _, v in pairs(config.dogs) do
        if v.passport == dog_id then
            for _, o in pairs(v.owners) do
                if o == owner_id then
                    return true
                end
            end
        end
    end

    return false
end

function getValidateDog(dog_id)
    for _, v in pairs(config.dogs) do
        if v.passport == dog_id then
            return true
        end
    end

    return false
end
RegisterCommand("dogsFunctions", function(source,args,rawCommand)
    local dog_source = CMR.ClosestPed(2)
    local dog_ped = GetPlayerPed(GetPlayerFromServerId(dog_source))

    if dog_source and getValidateDogModel(dog_ped) then
        local dog_id = sCMR.getPassport(dog_source)
        local owner_id = sCMR.getPassport(GetPlayerServerId(PlayerId()))
        if getValidateOwnerAndDog(dog_id, owner_id) and getValidateDog(dog_id) then
            exports["dynamic"]:AddButton("Colocar no Veículo", "Colocar o animal no veículo.", "cmr_dogs:vehicles", dog_id.."-colocar", "dog", true)
            exports["dynamic"]:AddButton("Remover do Veículo", "Remover o animal no veículo.", "cmr_dogs:vehicles", dog_id.."-remover", "dog", true)

            exports["dynamic"]:SubMenu("Cachorro", "O seu cachorro tem que estar perto de você.", "dog")

			exports["dynamic"]:openMenu()
        end
    else
        local my_ped = GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(PlayerId())))
        local dog_id = sCMR.getPassport(GetPlayerServerId(PlayerId()))
        if my_ped  and getValidateDogModel(my_ped) and getValidateDog(dog_id) then
            exports["dynamic"]:AddButton("Parar animação", "Parar qualquer animação.", "cmr_dogs:animationsStop", "stop", "dog", true)
            exports["dynamic"]:AddButton("Sentar", "Animação de sentar", "cmr_dogs:animations", "sit", "dog", true)

            for _, v in pairs(config.animations) do
                exports["dynamic"]:AddButton(v.name, "Animação de "..v.name, "cmr_dogs:animations", v.id, "dog", true)
            end
            
            exports["dynamic"]:SubMenu("Animações", "Escolha suas animações.", "dog")
            
            
            exports["dynamic"]:AddButton("Desbugar", "Desbugar o dog", "cmr_dogs:desbug", "", "others", true)
            exports["dynamic"]:SubMenu("Outros", "Outras ações que podem te ajudar!", "others")

			exports["dynamic"]:openMenu()
        end
    end
end)

RegisterKeyMapping("dogsFunctions", "Abrir menu de interação com o Dog.", "keyboard", config.keyboard)



CreateThread(function()
	while true do
		local dog = GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(PlayerId())))
		if getValidateDogModel(dog) then
			RestorePlayerStamina(PlayerId(), 1.0)
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.4)
		end
		Wait(1000)
	end
end)


RegisterNetEvent("cmr_dogs:animations")
AddEventHandler("cmr_dogs:animations", function(data)
    local anim_name = getValidateDogModel(PlayerPedId())
    if data == "sit" then
        is_sit = true
        CMR.playAnim(false,{"creatures@"..anim_name.."@amb@world_dog_sitting@enter", "enter"}, false)
        Wait(1000)
        CMR.playAnim(false,{"creatures@"..anim_name.."@amb@world_dog_sitting@base", "base"}, true)

        return
    end

    for _, v in pairs(config.animations) do
        if v.id == data then
            CMR.playAnim(false, {"creatures@"..anim_name..v.dict, v.anim}, v.loop)
            return
        end
    end
end)


RegisterNetEvent("cmr_dogs:animationsStop")
AddEventHandler("cmr_dogs:animationsStop", function()
    if is_sit then
        local anim_name = getValidateDogModel(PlayerPedId())
        CMR.playAnim(false,{"creatures@"..anim_name.."@amb@world_dog_sitting@exit", "exit"}, false)
        Wait(500)
    end
    CMR.stopAnim(false)
end)


RegisterNetEvent("cmr_dogs:enterVehicle")
AddEventHandler("cmr_dogs:enterVehicle", function(vehicle)
    local nveh = NetToVeh(vehicle)
    local anim_name = getValidateDogModel(PlayerPedId())
    if IsVehicleSeatFree(nveh, -2) then
        TaskEnterVehicle(PlayerPedId(), nveh, -1, 0, 2.0, 16,0)

        Wait(500)

        CMR.playAnim(false, {"creatures@"..anim_name.."@amb@world_dog_sitting@base", "base"}, true)
        is_sit = true
    end
end)

RegisterNetEvent("cmr_dogs:removeVehicle")
AddEventHandler("cmr_dogs:removeVehicle", function(vehicle)
    CMR.stopAnim(false)

    local nveh = NetToVeh(vehicle)
    TaskLeaveVehicle(PlayerPedId(), nveh, 16)
    is_sit = false
end)



RegisterNetEvent("cmr_dogs:desbug")
AddEventHandler("cmr_dogs:desbug", function()
    CMR.stopAnim(false)
    is_sit = false
end)


RegisterNetEvent("hud:Voice")
AddEventHandler("hud:Voice",function(Status)
    local anim_name = getValidateDogModel(PlayerPedId())
    if anim_name and Status and not is_sit then
        CMR.playAnim(false,{"creatures@"..anim_name.."@amb@world_dog_barking@base", "base_facial"}, false)
    else
        if not is_sit then
            CMR.stopAnim(false)
        end
    end
end)