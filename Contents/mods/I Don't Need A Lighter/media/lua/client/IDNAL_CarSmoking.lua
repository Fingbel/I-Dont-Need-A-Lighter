--NoLighterNeeded Mod by Fingbel

local old_ISVehicleMenu_showRadialMenu = ISVehicleMenu.showRadialMenu


function ISVehicleMenu.showRadialMenu(player)
	
	--Let's run the vanilla function before our code
	old_ISVehicleMenu_showRadialMenu(player)	
	local vehicle = player:getVehicle()
	local smokables = CheckInventoryForCigarette(player)
	
	if vehicle ~= nil then
		local menu = getPlayerRadialMenu(player:getPlayerNum())
		
		--Gamepad stuff
		if menu:isReallyVisible() then
			if menu.joyfocus then
				setJoypadFocus(player:getplayerObjNum(), nil)
			end 
			menu:undisplay()
			return
		end
		local seat = vehicle:getSeat(player)
		
			--Do we have smokable on us ?
			if smokables ~= nil then

			--Are we in the front set ? 
			if  seat == 0 or seat == 1 then
				
				--Do we have battery left ? 
				if vehicle:getBatteryCharge() > 0 then			
					if vehicle:isHotwired() or vehicle:isKeysInIgnition() then
						
						--If we are using the modded version let's launch the submenu
						if 	IDNAL == "MODDEDIDNAL" then menu:addSlice(getText('ContextMenu_Smoke'), getTexture("media/ui/vehicles/carSmoking.png"), ISVehicleMenu.IDNALOnSubMenu, player)
						
						
						else menu:addSlice(getText('ContextMenu_Smoke'),getTexture("media/ui/vehicles/carSmoking.png"), OnCarSmoking, player, smokables[0] ) end

					end
				end
			end
		end
		--menu:addToUIManager()
	end
end

		--This is the function for the Sub-Menu for the modded version of the car lighter to show-up smokable while in a car
 function ISVehicleMenu.IDNALOnSubMenu(player)
	local smokables = CheckInventoryForCigarette(player)
	local menu = getPlayerRadialMenu(player:getPlayerNum())
	menu:clear()
	
	--Draw the radial menu again
	menu:setX(getPlayerScreenLeft(player:getPlayerNum()) + getPlayerScreenWidth(player:getPlayerNum()) / 2 - menu:getWidth() / 2)
	menu:setY(getPlayerScreenTop(player:getPlayerNum()) + getPlayerScreenHeight(player:getPlayerNum()) / 2 - menu:getHeight() / 2)

	local texture = Joypad.Texture.AButton

	
	for i=0, getTableSize(smokables) -1 do
		print(smokables[i]:getTexture() )
		menu:addSlice(smokables[i]:getDisplayName(), smokables[i]:getTexture(), OnCarSmoking, player, smokables[i] )
	end
	menu:addToUIManager()
end

	--This is the function starting the car smoking sequence
function OnCarSmoking(_player, _cigarette)
	--local smokables = CheckSmokable(_player)
	local vehicle = _player:getVehicle()
			--Do we need to transfer cigarette from a bag first ? 
	if _cigarette:getContainer() ~= _player:getInventory() then
			ISTimedActionQueue.add(ISInventoryTransferAction:new (_player,  _cigarette, _cigarette:getContainer(), _player:getInventory(), 5))
	end
	ISTimedActionQueue.add(IsCarSmoking:new(_player, _cigarette, 460))
end