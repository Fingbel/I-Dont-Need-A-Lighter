--NoLighterNeeded Mod by Fingbel

NoLighterNeeded = NoLighterNeeded
local Smokey = {}

local function LightCigOnOven(_player, _context, _worldObjects, _test)

	local player = getSpecificPlayer(_player)
	local stats = player:getStats()
	local inventory = player:getInventory()
	local cigarette = inventory:getItemFromType("Base.Cigarettes")
	
	--Check for cigarette stock
	if inventory:containsType('Cigarettes') then
		
		--We have cigarette, let's see if we have a source of flame where we clicked
		for i,stove in ipairs(_worldObjects) do
			
			--did we clicked a lit  stove which is not a microwave?
			if instanceof(stove, 'IsoStove') and stove:Activated() and not 	stove:isMicrowave() then
				_context:addOption(getText('ContextMenu_LightCigaretteWithOven'), player, OnSmoking, stove, cigarette)
			
			--did we clicked a lit fireplace ?
			elseif instanceof(stove,'IsoFireplace') and stove:isLit() then
				_context:addOption(getText('ContextMenu_LightCigaretteWithFireplace'), player, OnSmoking, stove, cigarette)
			
			--did we clicked a lit barbecue ?
			elseif instanceof(stove,'IsoBarbecue') and stove:isLit() then
				_context:addOption(getText('ContextMenu_LightCigaretteWithBarbecue'), player, OnSmoking, stove, cigarette)
			
			--did we clicked a Campfire ? We check the sprite directly to check if fire is lit
			elseif instanceof(stove, "IsoObject") and stove:getSpriteName() == "camping_01_5" then
				_context:addOption(getText('ContextMenu_LightCigaretteWithCampFire'), player, OnSmoking, stove, cigarette)
				
			end
		end		
	end
end

local function DoWeHaveCigsInBags(inventory)

end




local function OnSmoking (_player, _stove,_cigarette)

	if luautils.walkAdj(_player, _stove:getSquare(), false) then
		ISTimedActionQueue.add(ISSmoking:new(player, stove,_cigarette, 460))
	end
	
end

Events.OnFillWorldObjectContextMenu.Add(LightCigOnOven)