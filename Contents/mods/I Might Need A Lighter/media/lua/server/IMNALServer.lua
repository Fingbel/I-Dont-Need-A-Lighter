if isClient() then return end

local IMNALClientCommands = {}
local IMNALvehicles = {}

function IMNALClientCommands.Update(player, args)	
    if not isServer() then return end	     
    if(IMNALvehicles[args.vehicle] == nill) then 
        local rand = CarLighterRandomizer()
        IMNALvehicles[args.vehicle] = rand
    end
    sendServerCommand(player,"IMNAL","CLUpdate", {playerID = args.playerID, CL = IMNALvehicles[args.vehicle]})

end

IMNALClientCommands.OnClientCommand = function(module, command, player, args)
    if module == 'IMNAL' and IMNALClientCommands[command] then
        print("Parsing IMNAL client command")
        local argStr = ''
        args = args or {}
        for k,v in pairs(args) do
            argStr = argStr..' '..k..'='..tostring(v)
        end
         print('received '..module..' '..command..' '..tostring(player)..argStr)
        IMNALClientCommands[command](player, args)
    end
end

Events.OnClientCommand.Add(IMNALClientCommands.OnClientCommand);

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