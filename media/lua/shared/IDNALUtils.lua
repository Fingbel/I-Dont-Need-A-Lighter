--I Don't Need A Lighter Mod by Fingbel

IDNAL = IDNAL

--This function is responsible to confirm the presence of cigarette in the player inventory 
--This function return an array(duplicate removed) of one of each of the possible smokable items

--This is the only place where a Cigarette check need to happen so we can expand to cigarettes from mods

function CheckSmokable(player)
	
	if 	getActivatedMods():contains("Smoker") or getActivatedMods():contains("jiggasGreenFireMod") then 
		return CheckInventoryModdedCigarette(player) 
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


function CheckInventoryModdedCigarette(player)
	
	local inventoryItems = player:getInventory():getItems()
	local smokable = {}
	
	for i=0, inventoryItems:size()-1 do	
		--We look for modded Cigarettes in our pocket	
		
		--This is ugly and need to change / Refactored
		if inventoryItems:get(i):getType() ==  ('SMCigarette') or 
			inventoryItems:get(i):getType() ==  ('SMPCigaretteGold') or 
			inventoryItems:get(i):getType() ==  ('SMCigaretteLight') or 
			inventoryItems:get(i):getType() ==  ('SMPCigaretteMenthol') or 
			inventoryItems:get(i):getType() ==  ('SMHomemadeCigarette') or 
			inventoryItems:get(i):getType() ==  ('SMHomemadeCigarette2') or
			inventoryItems:get(i):getType() ==  ('SMButt') or
			inventoryItems:get(i):getType() ==  ('SMButt2') or
			inventoryItems:get(i):getType() ==  ('Blunt') or
			inventoryItems:get(i):getType() ==  ('BluntCigar') or
			inventoryItems:get(i):getType() ==  ('CannabisCigar') or
			inventoryItems:get(i):getType() ==  ('GFCigar') or
			inventoryItems:get(i):getType() ==  ('GFCigarette') or
			inventoryItems:get(i):getType() ==  ('DelCannaCigar') or
			inventoryItems:get(i):getType() ==  ('HalfBlunt') or
			inventoryItems:get(i):getType() ==  ('HalfBluntCigar') or
			inventoryItems:get(i):getType() ==  ('HalfCannaCigar') or
			inventoryItems:get(i):getType() ==  ('HalfCigar') or
			inventoryItems:get(i):getType() ==  ('HalfDelCannaCigar') or
			inventoryItems:get(i):getType() ==  ('HalfHashBlunt') or
			inventoryItems:get(i):getType() ==  ('HalfHashJoint') or
			inventoryItems:get(i):getType() ==  ('HashJoint') or
			inventoryItems:get(i):getType() ==  ('HalfKiefBlunt') or
			inventoryItems:get(i):getType() ==  ('HalfKiefJoint') or
			inventoryItems:get(i):getType() ==  ('HalfMixedBlunt') or
			inventoryItems:get(i):getType() ==  ('HalfPreCannaCigar') or 
			inventoryItems:get(i):getType() ==  ('HalfResCannaCigar') or 
			inventoryItems:get(i):getType() ==  ('HalfSpaceBlunt') or
			inventoryItems:get(i):getType() ==  ('HashBlunt') or
			inventoryItems:get(i):getType() ==  ('Joint') or
			inventoryItems:get(i):getType() ==  ('KiefBlunt') or
			inventoryItems:get(i):getType() ==  ('KiefJoint') or
			inventoryItems:get(i):getType() ==  ('MixedBlunt') or
			inventoryItems:get(i):getType() ==  ('PreCannaCigar') or
			inventoryItems:get(i):getType() ==  ('ResCannaCigar') or
			inventoryItems:get(i):getType() ==  ('SpaceBlunt') or
			inventoryItems:get(i):getType() ==  ('Spliff') 
			then
				smokable[getTableSize(smokable)] = inventoryItems:get(i)
		end
		
		--And we look for container to search inside
		if inventoryItems:get(i):getCategory() == ("Container") then
		
			--We look inside each container for modded cigarettes				
			local ContainerContent = inventoryItems:get(i):getItemContainer():getItems()					
			for i=0, ContainerContent:size()-1 do		
				
				--This is ugly and need to change / Refactored
				if ContainerContent:get(i):getType() ==  ('SMCigarette') or 
					ContainerContent:get(i):getType() ==  ('SMPCigaretteGold') or 
					ContainerContent:get(i):getType() ==  ('SMCigaretteLight') or
					ContainerContent:get(i):getType() ==  ('SMPCigaretteMenthol') or 
					ContainerContent:get(i):getType() ==  ('SMHomemadeCigarette') or 
					ContainerContent:get(i):getType() ==  ('SMHomemadeCigarette2') or
					ContainerContent:get(i):getType() ==  ('SMButt') or
					ContainerContent:get(i):getType() ==  ('SMButt2') or		
					ContainerContent:get(i):getType() ==  ('Blunt') or
					ContainerContent:get(i):getType() ==  ('BluntCigar') or
					ContainerContent:get(i):getType() ==  ('CannabisCigar') or
					ContainerContent:get(i):getType() ==  ('GFCigar') or
					ContainerContent:get(i):getType() ==  ('GFCigarette') or
					ContainerContent:get(i):getType() ==  ('DelCannaCigar') or
					ContainerContent:get(i):getType() ==  ('HalfBlunt') or
					ContainerContent:get(i):getType() ==  ('HalfBluntCigar') or
					ContainerContent:get(i):getType() ==  ('HalfCannaCigar') or
					ContainerContent:get(i):getType() ==  ('HalfCigar') or
					ContainerContent:get(i):getType() ==  ('HalfDelCannaCigar') or
					ContainerContent:get(i):getType() ==  ('HalfHashBlunt') or
					ContainerContent:get(i):getType() ==  ('HalfHashJoint') or
					ContainerContent:get(i):getType() ==  ('HashJoint') or
					ContainerContent:get(i):getType() ==  ('HalfKiefBlunt') or
					ContainerContent:get(i):getType() ==  ('HalfKiefJoint') or
					ContainerContent:get(i):getType() ==  ('HalfMixedBlunt') or
					ContainerContent:get(i):getType() ==  ('HalfPreCannaCigar') or 
					ContainerContent:get(i):getType() ==  ('HalfResCannaCigar') or
					ContainerContent:get(i):getType() ==  ('HalfSpaceBlunt') or
					ContainerContent:get(i):getType() ==  ('HashBlunt') or
					ContainerContent:get(i):getType() ==  ('Joint') or
					ContainerContent:get(i):getType() ==  ('KiefBlunt') or
					ContainerContent:get(i):getType() ==  ('KiefJoint') or
					ContainerContent:get(i):getType() ==  ('MixedBlunt') or
					ContainerContent:get(i):getType() ==  ('PreCannaCigar') or 
					ContainerContent:get(i):getType() ==  ('ResCannaCigar') or
					ContainerContent:get(i):getType() ==  ('SpaceBlunt') or
					ContainerContent:get(i):getType() ==  ('Spliff')
					then		
						smokable[getTableSize(smokable)] = ContainerContent:get(i)	
				end
			end
		end
	end

if getTableSize(smokable) == 0 then return nil end
return removeDuplicates(smokable)
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