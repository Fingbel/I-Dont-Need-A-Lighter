--NoLighterNeeded Mod by Fingbel

--We save the vanilla function responsible for showing radialmenu in a car
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
			if CheckInventoryForCigarette (playerObj) ~= 0 then 
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
function OnCarSmoking(_player)
	local cigarette = _player:getInventory():getItemFromType("Base.Cigarettes")
	local vehicle = _player:getVehicle()
	
	--Do we need to transfer the cigarette from a bag ?
	if CheckInventoryForCigarette (_player) == 2 then
		cigarette = TransferCigaretteFromBag (_player)
	end
	
	--print("We should start smoking now ")
	--TODO add batterydrain on use 
	--vehicle.battery =  vehicle:getBatteryCharge() - 100
	ISTimedActionQueue.add(IsCarSmoking:new(_player, cigarette, 460))
	
end