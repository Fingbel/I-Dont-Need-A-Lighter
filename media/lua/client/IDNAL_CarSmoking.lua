--NoLighterNeeded Mod by Fingbel

--We save the vanilla function responsible for showing radialmenu in a car
local old_ISVehicleMenu_showRadialMenu = ISVehicleMenu.showRadialMenu


function ISVehicleMenu.showRadialMenu(playerObj)
	
	--Let's run the vanilla function before our code
	old_ISVehicleMenu_showRadialMenu(playerObj)	
	local vehicle = playerObj:getVehicle()
	local smokables = CheckSmokable(playerObj)
	
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
			if smokables ~= nil then

			if  seat == 0 or seat == 1 then
				if vehicle:getBatteryCharge() > 0 then			
					if vehicle:isHotwired() or vehicle:isKeysInIgnition() then
						menu:addSlice(smokables[0]:getDisplayName(), getTexture("media/ui/vehicles/carSmoking.png"), OnCarSmoking, playerObj)
					end
				end
			end
		end
		menu:addToUIManager()
	end
end

--This is the function starting the car smoking sequence
function OnCarSmoking(_player)
	local smokables = CheckSmokable(_player)
	local _cigarette = smokables[0]
	local vehicle = _player:getVehicle()
			--Do we need to transfer cigarette from a bag first ? 
		if _cigarette:getContainer() ~= _player:getInventory() then
			ISTimedActionQueue.add(ISInventoryTransferAction:new (_player,  _cigarette, _cigarette:getContainer(), _player:getInventory(), 5))
		end


	ISTimedActionQueue.add(IsCarSmoking:new(_player, _cigarette, 460))
	
end