if isClient() then return end

local IMNALClientCommands = {}
local IMNALvehicles = {}

function IMNALClientCommands.Update(player, args)	
    if not isServer() then return end	
    if(IMNALvehicles[args.vehicle] == nill) then 
        local rand = CarLighterRandomizer()
        IMNALvehicles[args.vehicle] = rand
        print("NEW CAR DETECTED - RESULT IS : ", rand)
    end
    sendServerCommand(player,"IMNAL","CLUpdate", {playerID = args.playerID, CL = IMNALvehicles[args.vehicle], vehicle = args.vehicle})
end

function IMNALClientCommands.Upgrade(player, args)	
    if not isServer() then return end	
    print("UPGRADE DETECTED")
    IMNALvehicles[args.vehicle] = args.newCL
    sendServerCommand(player,"IMNAL","CLUpdate", {playerID = args.playerID, CL = IMNALvehicles[args.vehicle], vehicle = args.vehicle})
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

