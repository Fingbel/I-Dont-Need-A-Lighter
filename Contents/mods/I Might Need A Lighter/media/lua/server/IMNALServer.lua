if isClient() then return end

local IMNALClientCommands = {}
ModData.getOrCreate("IMNALVehicles")

local function IMNALMPStarted()
    if not isServer() then return end    
    if( ModData.get("IMNALVehicles").IMNALvehicles == nill) then
        ModData.get("IMNALVehicles").IMNALvehicles = {}
    end
end

function IMNALClientCommands.Update(player, args)	
    if not isServer() then return end	
    print()
    if( ModData.get("IMNALVehicles").IMNALvehicles[args.vehicle] == nill) then 
        local rand = CarLighterRandomizer()
        ModData.get("IMNALVehicles").IMNALvehicles[args.vehicle] = rand
        print("NEW CAR DETECTED - RESULT IS : ", ModData.get("IMNALVehicles").IMNALvehicles[args.vehicle])
    end
    sendServerCommand(player,"IMNAL","CLUpdate", {playerID = args.playerID, CL =  ModData.get("IMNALVehicles").IMNALvehicles[args.vehicle], vehicle = args.vehicle})
    --gameTime:getModData().IMNALvehicles = IMNALvehicles 
    local vehicleID = args.vehicle
end

function IMNALClientCommands.Upgrade(player, args)	
    if not isServer() then return end	
    print("UPGRADE DETECTED")
    ModData.get("IMNALVehicles").IMNALvehicles[args.vehicle] = args.newCL
    sendServerCommand(player,"IMNAL","CLUpdate", {playerID = args.playerID, CL =  ModData.get("IMNALVehicles").IMNALvehicles[args.vehicle], vehicle = args.vehicle})

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


Events.OnClientCommand.Add(IMNALClientCommands.OnClientCommand)
Events.OnServerStarted.Add(IMNALMPStarted)