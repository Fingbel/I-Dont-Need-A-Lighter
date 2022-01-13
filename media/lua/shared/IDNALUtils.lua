--I Don't Need A Lighter Mod by Fingbel

IDNAL = IDNAL

--This function is responsible to confirm the presence of cigarette in the player inventory 
--This function return an array of one of each of the possible smokable items

--This is the only place where a Cigarette check need to happen so we can expand to cigarettes from mods

moddedCigaretteType = {}



function CheckSmokable(player)
	
	if 	getActivatedMods():contains("Smoker") then 
		return CheckInventoryForModdedCigarette(player) 
	end
	return CheckInventoryForVanillaCigarette(player)
end

function CheckInventoryForVanillaCigarette(player)
	local inventoryItems = player:getInventory():getItems()
	local smokable = {}
	local smokableList = {}
		--We Check inventory for all items
	for i=0, inventoryItems:size()-1 do	
		
		--We look for Vanilla Cigarettes in our pocket	
		if inventoryItems:get(i):getType() == ('Cigarettes') then
			smokable[getTableSize(smokable)] = inventoryItems:get(i)
		end
		
		--And we look for container to search inside
		if inventoryItems:get(i):getCategory() == ("Container") then
			--We look inside each container for cigarettes				
			local ContainerContent = inventoryItems:get(i):getItemContainer():getItems()					
			for i=0, ContainerContent:size()-1 do		
			
				if ContainerContent:get(i):getType() == ('Cigarettes') then		
					smokable[getTableSize(smokable)] = ContainerContent:get(i)	
				end
			end
		end
	end

	if getTableSize(smokable) == 0 then return nil end
	
	for i=0, getTableSize(smokable) -1 do 
		smokableList[i] = smokable[i]
		
		if smokable[i+1] ~= nil then if smokable[i+1]:getType() == smokableList[i]:getType() then break end end
	end
	return smokableList
end

function CheckInventoryForModdedCigarette(player)
	local inventoryItems = player:getInventory():getItems()
	local smokable = {}
	
	for i=0, inventoryItems:size()-1 do	
		--We look for Smoked Cigarettes in our pocket	
		
		if inventoryItems:get(i):getType() ==  ('SMCigarette') or 
			inventoryItems:get(i):getType() ==  ('SMPCigaretteGold') or 
			inventoryItems:get(i):getType() ==  ('SMCigaretteLight') or 
			inventoryItems:get(i):getType() ==  ('SMPCigaretteMenthol') or 
			inventoryItems:get(i):getType() ==  ('SMHomemadeCigarette') or 
			inventoryItems:get(i):getType() ==  ('SMHomemadeCigarette2') or
			inventoryItems:get(i):getType() ==  ('SMButt') or
			inventoryItems:get(i):getType() ==  ('SMButt2') then
				smokable[getTableSize(smokable)] = inventoryItems:get(i)
		end
		
		--And we look for container to search inside
		if inventoryItems:get(i):getCategory() == ("Container") then
			--We look inside each container for cigarettes				
			local ContainerContent = inventoryItems:get(i):getItemContainer():getItems()					
			for i=0, ContainerContent:size()-1 do		
				
				if ContainerContent:get(i):getType() ==  ('SMCigarette') or 
					ContainerContent:get(i):getType() ==  ('SMPCigaretteGold') or 
					ContainerContent:get(i):getType() ==  ('SMCigaretteLight') or
					ContainerContent:get(i):getType() ==  ('SMPCigaretteMenthol') or 
					ContainerContent:get(i):getType() ==  ('SMHomemadeCigarette') or 
					ContainerContent:get(i):getType() ==  ('SMHomemadeCigarette2') or
					ContainerContent:get(i):getType() ==  ('SMButt') or
					ContainerContent:get(i):getType() ==  ('SMButt2') then		
						smokable[getTableSize(smokable)] = ContainerContent:get(i)	
				end
			end
		end
	end
if getTableSize(smokable) == 0 then return nil end
return removeDuplicates(smokable)
end

--Code to remove duplicate in smokable 
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