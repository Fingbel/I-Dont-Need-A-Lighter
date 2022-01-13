--I Don't Need A Lighter Mod by Fingbel

IDNAL = IDNAL

function CheckInventoryForCigarette(player)
	local inventoryItems = player:getInventory():getItems()
	
	--do we have cigarette in our pocket ?
	if player:getInventory():containsType('Cigarettes') then 
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
					--We found some
					print ("Found cigarette in a bag")
					return 2
				end
			end
		end
	end
	return 0
end

function TransferCigaretteFromBag(player)
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
