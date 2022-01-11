--NoLighterNeeded Mod by Fingbel

--We save the vanilla function
local old_ISVehicleMenu_showRadialMenu = ISVehicleMenu.showRadialMenu


function ISVehicleMenu.showRadialMenu(playerObj)
	
	--Let's run the vanilla function before our code
	old_ISVehicleMenu_showRadialMenu(playerObj)
	local vehicle = playerObj:getVehicle()
	if vehicle ~= nil then
		local menu = getPlayerRadialMenu(playerObj:getPlayerNum())
		
		--Gamepad stuff
		if menu:isReallyVisible() then
			if menu.joyfocus then
				setJoypadFocus(playerObj:getplayerObjNum(), nil)
			end
			menu:undisplay()
			return
		end
		local seat = vehicle:getSeat(playerObj)
		
		--The custom code
		if  seat == 0 or seat == 1 then
			if vehicle:isEngineRunning() then
				menu:addSlice(getText("ContextMenu_StartCarSmoking"), getTexture("media/ui/vehicles/carSmoking.png"), OnCarSmoking, playerObj)
			end
		end
		menu:addToUIManager()
	end
end

--This is the function starting the car smoking sequence
function OnCarSmoking(_playerObj)
	local inventory = _playerObj:getInventory()
	local cigarette = inventory:getItemFromType("Base.Cigarettes")
	
	
	if CheckInventoryForCigarette (inventory) == 2 then
		StoveSmoking.cigarette = TransferCigarette (_playerObj)
	end

	print("We should start smokingnow ")
	ISTimedActionQueue.add(IsCarSmoking:new(_playerObj, cigarette, 460))
	
end