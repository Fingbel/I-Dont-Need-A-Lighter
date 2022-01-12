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
		local inventory = playerObj:getInventory()
		if CheckInventoryForCigarette (inventory) ~= 0 then 
			if  seat == 0 or seat == 1 then
				print (vehicle:getBatteryCharge())
				if vehicle:getBatteryCharge() > 0 then			
					if vehicle:isHotwired() or vehicle:isKeysInIgnition() then
						menu:addSlice(getText("ContextMenu_StartCarSmoking"), getTexture("media/ui/vehicles/carSmoking.png"), OnCarSmoking, playerObj)
					end
				end
			end
		end
		menu:addToUIManager()
	end
end

--This is the function starting the car smoking sequence
function OnCarSmoking(_playerObj)
	local inventory = _playerObj:getInventory()
	local cigarette = inventory:getItemFromType("Base.Cigarettes")
	local vehicle = _playerObj:getVehicle()
	
	if CheckInventoryForCigarette (inventory) == 2 then
		cigarette = TransferCigarette (_playerObj)
	end
	
	print("We should start smokingnow ")
	--TODO add batterydrain on use 
	--vehicle.battery =  vehicle:getBatteryCharge() - 100
	ISTimedActionQueue.add(IsCarSmoking:new(_playerObj, cigarette, 460))
	
end