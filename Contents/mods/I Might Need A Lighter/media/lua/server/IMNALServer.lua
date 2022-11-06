local vehicles = {}

function IMNALonClientCommand(module, command, player, args)	
    if not isServer() then return end	
    if module ~= "IMNAL" then return end;  	
    if command == "IMNALCLCheck" then           
        if(vehicles[args["vehicle"]] == nill) then 
            local rand = CarLighterRandomizer()
            vehicles[args["vehicle"]] = rand
        end
        local argsB = {}
        argsB["playerID"] = args["PlayerID"]
        argsB["CL"]= rand
        sendServerCommand(player,"IMNAL","IMNALCLUpdate", argsB)
    end
end

Events.OnClientCommand.Add(IMNALonClientCommand);

function CarLighterRandomizer()
	--is the socket broken ?
	local rand2 = ZombRand(100)
	if(rand2 >50) then return "0" end
	--is it in good shape but empty ?
	local rand3 = ZombRand(100)
	if(rand3 >50) then return "1" end
	--is it in good shape and populated ?
	return "2"
end