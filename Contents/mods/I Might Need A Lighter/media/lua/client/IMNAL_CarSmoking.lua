--I Might Need A Lighter Mod by Fingbel
local old_ISVehicleMenu_showRadialMenu = ISVehicleMenu.showRadialMenu
IMNALServerCommands = {}
IMNALSPVehicles = {}

local function OnInitGlobalModData(isNewGame)
	if(isNewGame == true)then
		IMNALSPVehicles = ModData.create("IMNALSPVehicles")
	end
	IMNALSPVehicles = ModData.get("IMNALSPVehicles")
end

Events.OnInitGlobalModData.Add(OnInitGlobalModData)

function OnEnterVehicleCLCheck(player)
	sendClientCommand(player, 'IMNAL', 'Update', {vehicle = player:getVehicle():getSqlId(), playerID = player:getOnlineID()})
	print(player:getVehicle():getSqlId())	
	print("Client command sent")
	if(getWorld():getGameMode() ~= "Multiplayer")then
		if(IMNALSPVehicles[player:getVehicle():getSqlId()] == nill) then
			IMNALSPVehicles[player:getVehicle():getSqlId()] = CarLighterRandomizer()
			print("NEW CAR DETECTED")
			player:getModData().CL = IMNALSPVehicles[player:getVehicle():getSqlId()]
		end
		player:getModData().CL = IMNALSPVehicles[player:getVehicle():getSqlId()]
	end
end

Events.OnEnterVehicle.Add(OnEnterVehicleCLCheck)

function IMNALServerCommands.CLUpdate(args)	
	--if not isClient() then return end	   
		print("Server command received")
		print(args.CL)
		getPlayerByOnlineID(args.playerID):getModData().CL = args.CL    
end

IMNALServerCommands.OnServerCommand = function(module, command, args)
    if module == 'IMNAL' and IMNALServerCommands[command] then
        print("Parsing IMNAL server command")
        local argStr = ''
        args = args or {}
        for k,v in pairs(args) do
            argStr = argStr..' '..k..'='..tostring(v)
        end
        IMNALServerCommands[command](args)
    end
end

Events.OnServerCommand.Add(IMNALServerCommands.OnServerCommand)

--This is the added code to the base function
function ISVehicleMenu.showRadialMenu(player)
	--Here we first call the base function
	old_ISVehicleMenu_showRadialMenu(player)

	local isPaused = UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0
	if isPaused then return end

	local vehicle = player:getVehicle()
	local smokables = CheckInventoryForCigarette(player)
	local carLighter = CheckInventoryForCarLighter(player)

	if vehicle ~= nil then
		--Now we run our code
		local menu = getPlayerRadialMenu(player:getPlayerNum())

		--Did we received the correct data ?
		print("Vehicle : ", player:getModData().CL)
	
		--Gamepad stuff
		if menu:isReallyVisible() then
			if menu.joyfocus then
				setJoypadFocus(player:getPlayerObjNum(), nil)
			end 
			menu:undisplay()
			return
		end
		local seat = vehicle:getSeat(player)
		
		if seat <=1 then
			if player:getModData().CL == "0" then
				menu:addSlice(getText("Car Lighter socket needs repair"),getTexture("media/ui/vehicles/carLighterNeedRepair.png"),OnCarLighterSocketRepair, player) 
				return
			elseif player:getModData().CL == "1" and carLighter == nill then 
				menu:addSlice(getText("No Car Lighter present"),getTexture("media/ui/vehicles/noCarLighter.png")) 
				return
			elseif player:getModData().CL == "1" and carLighter ~= nill then
				menu:addSlice(getText("Install Car Lighter"),getTexture("media/ui/vehicles/CarLighterCanBeInstalled.png"),OnCarLighterInstalling, player, carLighter ) 
				return
			end

			--Do we have everything ?
			if player:getModData().CL == "2" and smokables ~= nil and vehicle:getBatteryCharge() >= 0.03 and (vehicle:isHotwired() or vehicle:isKeysInIgnition()) then
				menu:addSlice(getText('ContextMenu_CarLighter'), getTexture("media/ui/vehicles/carSmokingBatteryCigarette.png"), OnSubMenu, player, vehicle)
				return

			--What are we missing ?
			elseif smokables == nil and vehicle:getBatteryCharge() >= 0.03 and (vehicle:isHotwired() or vehicle:isKeysInIgnition()) then
				 menu:addSlice(getText('ContextMenu_CarLighter')  ..":" .. getText('ContextMenu_CarOutOfCigarette'), getTexture("media/ui/vehicles/carSmokingBatteryContactNoCigarette.png"), OnSubMenu, player, vehicle)	
				 
			elseif smokables == nil and vehicle:getBatteryCharge() < 0.03 and (vehicle:isHotwired() or vehicle:isKeysInIgnition()) then
				menu:addSlice(getText('ContextMenu_CarLighter') ..":" .. getText('ContextMenu_CarOutOfCigarette') .. getText('ContextMenu_CarNoBattery'),getTexture("media/ui/vehicles/carSmokingNoBatteryContactNoCigarette.png"), OnSubMenu, player, vehicle) 						

			elseif smokables == nil and vehicle:getBatteryCharge() < 0.03 and (not vehicle:isHotwired() or not vehicle:isKeysInIgnition()) then
				menu:addSlice(getText('ContextMenu_CarLighter') ..":" .. getText('ContextMenu_CarOutOfCigarette') .. getText('ContextMenu_CarNoBattery') .. getText('ContextMenu_CarNoKeyOrWire'),getTexture("media/ui/vehicles/carSmokingNoBatteryNoContactNoCigarette.png"), OnSubMenu, player, vehicle )

			elseif smokables == nil and vehicle:getBatteryCharge() >= 0.03 and (not vehicle:isHotwired() or not vehicle:isKeysInIgnition()) then
				menu:addSlice(getText('ContextMenu_CarLighter') ..":".. getText('ContextMenu_CarOutOfCigarette') .. getText('ContextMenu_CarNoKeyOrWire'),getTexture("media/ui/vehicles/carSmokingBatteryNoContactNoCigarette.png"), OnSubMenu, player, vehicle ) 

			elseif smokables ~= nil and vehicle:getBatteryCharge() >= 0.03 and (not vehicle:isHotwired() or not vehicle:isKeysInIgnition()) then
				menu:addSlice(getText('ContextMenu_CarLighter') ..":" .. getText('ContextMenu_CarNoKeyOrWire'),getTexture("media/ui/vehicles/carSmokingBatteryNoContactCigarette.png"), OnSubMenu, player, vehicle) 

			elseif smokables ~= nil and vehicle:getBatteryCharge() < 0.03 and  (vehicle:isHotwired() or  vehicle:isKeysInIgnition()) then
				 menu:addSlice(getText('ContextMenu_CarLighter') ..":".. getText('ContextMenu_CarNoBattery'),getTexture("media/ui/vehicles/carSmokingNoBatteryContactCigarette.png"), OnSubMenu, player, vehicle) 

			elseif smokables ~= nil and vehicle:getBatteryCharge() < 0.03 and (not vehicle:isHotwired() or not vehicle:isKeysInIgnition()) then
				 menu:addSlice(getText('ContextMenu_CarLighter') ..":".. getText('ContextMenu_CarNoBattery') .. getText('ContextMenu_CarNoKeyOrWire'),getTexture("media/ui/vehicles/carSmokingNoBatteryNoContactCigarette.png"), OnSubMenu, player, vehicle) 		
			end
		end
		menu:addToUIManager()
	end
end

function OnSubMenu(player, vehicle)
	local smokables = CheckInventoryForCigarette(player) --TODO : this could be a parameter, we are wasting power
	local menu = getPlayerRadialMenu(player:getPlayerNum())
	menu:clear()
	
	--Draw the radial menu again
	menu:setX(getPlayerScreenLeft(player:getPlayerNum()) + getPlayerScreenWidth(player:getPlayerNum()) / 2 - menu:getWidth() / 2)
	menu:setY(getPlayerScreenTop(player:getPlayerNum()) + getPlayerScreenHeight(player:getPlayerNum()) / 2 - menu:getHeight() / 2)

	local texture = Joypad.Texture.AButton

	if player:getModData().CL == "2" and smokables ~= nil and vehicle:getBatteryCharge() > 0.03 and (vehicle:isHotwired() or vehicle:isKeysInIgnition())  then
		for i=0, getTableSize(smokables) -1 do --TODO : this need to have a hardcap to not fuck up the radialmenu
			menu:addSlice(smokables[i]:getDisplayName(), smokables[i]:getTexture(), OnCarSmoking, player, smokables[i] )
		end
	end
	if player:getModData().CL == "2" then
		menu:addSlice(getText("Remove Car Lighter"), getTexture("media/ui/vehicles/CarLighterCanBeRemoved.png"), OnCarLighterUnInstalling, player)	
	end
	menu:addToUIManager()

	if JoypadState.players[player:getPlayerNum()+1] then
		menu:setHideWhenButtonReleased(Joypad.DPadUp)
		setJoypadFocus(player:getPlayerNum(), menu)
		player:setJoypadIgnoreAimUntilCentered(true)
	end
end

--This is the function starting the car smoking sequence
function OnCarSmoking(_player, _cigarette)
	local carlighterBaseTimer = 125
	local batteryDurabilityMult = _player:getVehicle():getBattery():getCondition()/100
	local batteryChargeMult = _player:getVehicle():getBattery():getInventoryItem():getUsedDelta()
	local carlighterFinalTimer = (carlighterBaseTimer/batteryDurabilityMult)/batteryChargeMult

	--Do we need to transfer cigarette from a bag first ? 
	if _cigarette:getContainer() ~= _player:getInventory() then
		ISTimedActionQueue.add(ISInventoryTransferAction:new (_player,  _cigarette, _cigarette:getContainer(), _player:getInventory(), 5))
	end

	--TODO : We need to decide here if the attempt failed and broke the car lighter and/or the socket


	--We need some time for the lighter to heat
	ISTimedActionQueue.add(IsCarLighting:new (_player, _cigarette, carlighterFinalTimer))
	
	--Let's smoke now
	ISTimedActionQueue.add(IsCarSmoking:new(_player, _cigarette, 460))
end

function OnCarLighterInstalling(_player, _carlighter)

	--Do we need to transfer the lighter from a bag first ? 
	if _carlighter:getContainer() ~= _player:getInventory() then
		ISTimedActionQueue.add(ISInventoryTransferAction:new (_player,  _carlighter, _carlighter:getContainer(), _player:getInventory(), 5))
	end
	ISTimedActionQueue.add(IsInstallingCarLighter:new(_player,_carlighter, 30))
end


function OnCarLighterUnInstalling(_player)
	ISTimedActionQueue.add(IsUnInstallingCarLighter:new(_player,30))
end

function OnCarLighterSocketRepair(_player)
	ISTimedActionQueue.add(IsRepairingCLSocket:new(_player,400))
end