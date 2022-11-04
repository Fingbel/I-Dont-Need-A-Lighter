--I Don't Need A Lighter Mod by Fingbel


-- if getCore():isDedicated()

if getActivatedMods():contains("Smoker") or getActivatedMods():contains("jiggasGreenfireMod") then 
	IDNAL="MODDEDIDNAL"
else IDNAL="IDNAL"
end

--This function is responsible to confirm the presence of cigarette in the player inventory 
--This function return an array(duplicate removed) of one of each of the possible smokable items

function CheckInventoryForCigarette(player)
	local inventoryItems = player:getInventory():getItems()
	local smokable = {}
	
	--Do we have smokable in our pocket
	for i=0, inventoryItems:size()-1 do			
		if inventoryItems:get(i):getEatType() ==  ('Cigarettes') or inventoryItems:get(i):getEatType() == ('CigarettesOne') then
		--
			--if inventoryItems:get(i):getDisplayName() ~= ('Candy Cigarette') then
				smokable[getTableSize(smokable)] = inventoryItems:get(i)
			--end
		end	
	end

	--Now we look for container to search inside
	for i=0, inventoryItems:size()-1 do	
		if inventoryItems:get(i):getCategory() == ("Container") then
		
			--We look inside each container for smokable
			local ContainerContent = inventoryItems:get(i):getItemContainer():getItems()				
			for i=0, ContainerContent:size()-1 do				
				if ContainerContent:get(i):getEatType() ==  ('Cigarettes') or ContainerContent:get(i):getEatType() == ('CigarettesOne')  then
					--if inventoryItems:get(i):getDisplayName() ~= ('Candy Cigarette') then
						smokable[getTableSize(smokable)] = ContainerContent:get(i)
					--end
				end
			end
		end
	end
	if getTableSize(smokable) == 0 then return nil end
	return removeDuplicates(smokable)
end

function CheckInventoryForCarLighter(player)
	local inventoryItems = player:getInventory():getItems()
	local carLighter
	
	--Do we have a car lighter in our pocket
	for i=0, inventoryItems:size()-1 do			
		if inventoryItems:get(i):getType() ==  ('CarLighter') then			
				return inventoryItems:get(i)		
		end	
	end

	--Now we look for container to search inside
	for i=0, inventoryItems:size()-1 do	
		if inventoryItems:get(i):getCategory() == ("Container") then
		
			--We look inside each container for carLighter
			local ContainerContent = inventoryItems:get(i):getItemContainer():getItems()				
			for i=0, ContainerContent:size()-1 do				
				if ContainerContent:get(i):getType() ==  ('CarLighter')  then					
						return ContainerContent:get(i)
				end
			end
		end
	end
	return CarLighter
end


--Utility functions
function inArray(arr, element)
	for i=0,getTableSize(arr) -1 do
		if arr[i]:getType() == element:getType()
			then return true 
		end
	end
	return false
end
	 
function removeDuplicates(arr)
	local newArray = {}
	for i=0, getTableSize(arr) -1 do

		if not inArray(newArray, arr[i]) then
			newArray[getTableSize(newArray)] = arr[i]
		end
	end
	return newArray
end

function getTableSize(t)
    local count = 0
    for _, __ in pairs(t) do
        count = count + 1
    end
    return count
end

function CarLighterRandomizer()
	--is the socket broken ?
	local rand2 = ZombRand(100)
	if(rand2 >50) then return 0 end
	--is it in good shape but empty ?
	local rand3 = ZombRand(100)
	if(rand3 >50) then return 1 end
	--is it in good shape and populated ?
	return 2
end