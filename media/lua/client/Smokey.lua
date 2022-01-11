--NoLighterNeeded Mod by Fingbel

NoLighterNeeded = NoLighterNeeded
local Smokey = {}

local function LightCigOnOven(_player, _context, _worldObjects, _test)

	local player = getSpecificPlayer(_player)
	local stats = player:getStats()
	local inventory = player:getInventory()
	local cigarette = inventory:getItemFromType("Base.Cigarettes")

		
	
		--Check for cigarette stock NEED TO EXPAND TO BAGS
	if inventory:containsType('Cigarettes') then
		
		--We have cigarette, let's see if we have a source of flame where we clicked
		for i,stove in ipairs(_worldObjects) do
			print(stove)
			--did we clicked a lit  stove which is not a microwave?
			if instanceof(stove, 'IsoStove') and stove:Activated() and not 	stove:isMicrowave() then
				_context:addOption(getText('ContextMenu_LightCigaretteWithOven'), player, OnStoveSmoking, stove, cigarette)
			
			--did we clicked a lit fireplace ?
			elseif instanceof(stove,'IsoFireplace') and stove:isLit() then
				_context:addOption(getText('ContextMenu_LightCigaretteWithFireplace'), player, OnStoveSmoking, stove, cigarette)
			
			--did we clicked a lit barbecue ?
			elseif instanceof(stove,'IsoBarbecue') and stove:isLit() then
				_context:addOption(getText('ContextMenu_LightCigaretteWithBarbecue'), player, OnStoveSmoking, stove, cigarette)
			
			--did we clicked a Campfire ? We check the sprite directly to check if the campfire is lit or not
			elseif instanceof(stove, "IsoObject") and stove:getSpriteName() == "camping_01_5" then
				_context:addOption(getText('ContextMenu_LightCigaretteWithCampFire'), player, OnStoveSmoking, stove, cigarette)
				
			--did we clicked on a Fire ? You mad man
			elseif instanceof(stove, "IsoFire") then
				_context:addOption(getText('ContextMenu_LightCigaretteWithFire'), player, OnStoveSmoking, stove, cigarette)	
				print("FIRE!")
			end
		end		
	end
end

Events.OnFillWorldObjectContextMenu.Add(LightCigOnOven)

function OnStoveSmoking (_player, _stove,_cigarette)
	if luautils.walkAdj(_player, _stove:getSquare(), false) then
		ISTimedActionQueue.add(IsStoveSmoking:new(_player, _stove,_cigarette, 460))
	end
end
