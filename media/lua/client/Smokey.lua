--NoLighterNeeded Mod by Fingbel

NoLighterNeeded = NoLighterNeeded
local Smokey = {}

local function LightCigOnOven(_player, _context, _worldObjects, _test)


	local player = getSpecificPlayer(_player);
	local stats = player:getStats();
	local inventory = player:getInventory();
	
	--Global check for cigarette
	if CheckInventoryForCigarette(inventory) ~= 0 then
		
		--We have cigarette, let's see if we have a source of flame where we clicked
		for i,stove in ipairs(_worldObjects) do

			--did we clicked a lit  stove which is not a microwave?
			if instanceof(stove, 'IsoStove') and stove:Activated() and not 	stove:isMicrowave() then
				_context:addOption(getText('ContextMenu_LightCigaretteWithOven'), player, OnStoveSmoking, stove)
			
			--did we clicked a lit fireplace ?
			elseif instanceof(stove,'IsoFireplace') and stove:isLit() then
				_context:addOption(getText('ContextMenu_LightCigaretteWithFireplace'), player, OnStoveSmoking, stove)
			
			--did we clicked a lit barbecue ?
			elseif instanceof(stove,'IsoBarbecue') and stove:isLit() then
				_context:addOption(getText('ContextMenu_LightCigaretteWithBarbecue'), player, OnStoveSmoking, stove)
			
			--did we clicked a Campfire ? We check the sprite directly to check if the campfire is lit or not
			elseif instanceof(stove, "IsoObject") and stove:getSpriteName() == "camping_01_5" then
				_context:addOption(getText('ContextMenu_LightCigaretteWithCampFire'), player, OnStoveSmoking, stove)
				
			--did we clicked on a Fire ? You mad man
			elseif instanceof(stove, "IsoFire") then
				_context:addOption(getText('ContextMenu_LightCigaretteWithFire'), player, OnStoveSmoking, stove)	
				print("FIRE!")
			end

		end		
	end
end

function OnSmoking (_player, _stove, _cigarette)

function OnStoveSmoking(_player, _stove)
	local cigarette = _player:getInventory():getItemFromType("Base.Cigarettes")
	local inventory = _player:getInventory()
	
	if luautils.walkAdj(_player, _stove:getSquare(), true) then 
		if CheckInventoryForCigarette (inventory) == 2 then
			cigarette = TransferCigarette (_player)
		end
	end

	if luautils.walkAdj(_player, _stove:getSquare(), true) then 
		ISTimedActionQueue.add(IsStoveSmoking:new(_player, _stove, cigarette, 460))
	end
end


	
function CheckInventoryForCigarette(inventory)
	local inventoryItems = inventory:getItems()

	--do we have cigarette in our pocket ?
	if inventory:containsType('Cigarettes') then 
		print ("Found cigarette in my pocket")
		return 1
	end
	
	--We Check inventory for all items
	for i=0, inventoryItems:size()-1 do	
	
		--We look for container
		if inventoryItems:get(i):getCategory() == ("Container") then
			--We look inside each container for cigarettes				
			local bagContent = inventoryItems:get(i):getItemContainer():getItems()			
			
			for i=0, bagContent:size()-1 do			
				if bagContent:get(i):getType() == ('Cigarettes') then		
					return 2
				end
			end
		end
	end
	return 0
end

function TransferCigarette(player)

local inventoryItems = player:getInventory():getItems();	

	--We Check inventory for all items
	for i=0, inventoryItems:size()-1 do	
	
		--We look for container
		if inventoryItems:get(i):getCategory() == ("Container") then
			local bag = inventoryItems:get(i)
				
			--We look inside each container for cigarettes				
			local bagContent = bag:getItemContainer():getItems()
					
			for i=0, bagContent:size()-1 do	
				
				--Did we found a cigarette ?
				if bagContent:get(i):getType() == ('Cigarettes') then
					
					--We did, let's transfer it to the main inventory
					ISTimedActionQueue.add(ISInventoryTransferAction:new (player, bagContent:get(i), bag:getItemContainer() , player:getInventory(), 5))					
					
					return bagContent:get(i)
				end
			end
		end
	end
end
=======
	if luautils.walkAdj(_player, _stove:getSquare(), false) then
		ISTimedActionQueue.add(ISSmoking:new(_player, _stove,_cigarette, 460))
	end
	
end

Events.OnFillWorldObjectContextMenu.Add(LightCigOnOven)
