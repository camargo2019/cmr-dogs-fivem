---- Developer by git@camargo2019

CMR = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP - Creative SummerZ Original
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")

--- Creative Functions

function CMR.getPassport(player)
    return vRP.Passport(player)
end

function CMR.getSource(passport)
    return vRP.Source(passport)
end

function CMR.VehicleList(player, distance)
    return vRPC.VehicleList(player, distance)
end

function CMR.SkinCharacter(passport, model)
    return vRP.SkinCharacter(passport, model)
end

function CMR.Skin(source, model)
    return vRPC.Skin(source, model)
end

function playerSpawn(user_id, source, first_spawn)
    CMR.DogSpawn(user_id)
end
AddEventHandler("vRP:playerSpawn", playerSpawn)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CMR Dogs - Tunnel
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel.bindInterface("cmr_dogs", CMR)

function CMR.DogSpawn(user_id)
    Wait(2000)

    for _, v in pairs(config.dogs) do
        if v.passport == user_id then
            local dog_source = CMR.getSource(v.passport)
            
            if dog_source then
				CMR.Skin(dog_source, v.model)
				CMR.SkinCharacter(v.passport, v.model)
            end
        end
    end
end

RegisterServerEvent("cmr_dogs:vehicles")
AddEventHandler("cmr_dogs:vehicles", function(data)
    local owner_source = source
    local splits = splitString(data, "-")

    if splits[1] ~= nil then
        local dog_source = CMR.getSource(splits[1])

        if splits[2] == "colocar" then
			local Vehicle,Network,Plate,vehName,vehClass = CMR.VehicleList(source, 2)

			if Vehicle then
                TriggerClientEvent("cmr_dogs:enterVehicle", dog_source, Network)
            else
                TriggerClientEvent("Notify", owner_source, "vermelho", "Não tem veiculo perto!", 5000)
			end
        elseif splits[2] == "remover" then
			local Vehicle,Network,Plate,vehName,vehClass = CMR.VehicleList(source, 3)

			if Vehicle then
                TriggerClientEvent("cmr_dogs:removeVehicle", dog_source, Network)
            else
                TriggerClientEvent("Notify", owner_source, "vermelho", "Não tem veiculo perto!", 5000)
			end
        end
    end
end)


RegisterServerEvent("cmr_dogs:desbug")
AddEventHandler("cmr_dogs:desbug", function()
    local source = source

    CMR.DogSpawn(CMR.getPassport(source))
    TriggerClientEvent("cmr_dogs:desbug", source)
end)

RegisterServerEvent("cmr_dogs:animations")
AddEventHandler("cmr_dogs:animations", function(data)
    TriggerClientEvent("cmr_dogs:animations", source, data)
end)

RegisterServerEvent("cmr_dogs:animationsStop")
AddEventHandler("cmr_dogs:animationsStop", function()
    TriggerClientEvent("cmr_dogs:animationsStop", source)
end)

