--I Don't Need A Lighter Mod by Fingbel

local StoveSmoking = {}

local function LightCigOnStove(_player, _context, _worldObjects, _test)


	local player = getSpecificPlayer(_player);
	local stats = player:getStats();
	local inventory = player:getInventory();
	
	--Global check for cigarette
	if CheckInventoryForCigarette(player) ~= 0 then
		
		--We have cigarette, let's see if we have a source of flame where we clicked
		for i,stove in ipairs(_worldObjects) do
			
			--did we clicked a lit  stove which is not a microwave?
			if instanceof(stove, 'IsoStove') and stove:Activated() and not 	stove:isMicrowave() then				
				local smokeOption = _context:addOption(getText('ContextMenu_LightCigaretteWithOven'), worldobjects, nil);
				local subMenu = ISContextMenu:getNew(_context)
				subMenu:addOption("Cigarette", player, OnStoveSmoking, stove)
				_context:addSubMenu(smokeOption, subMenu);
				
			--did we clicked a lit fireplace ?
			elseif instanceof(stove,'IsoFireplace') and stove:isLit() then
				local smokeOption = _context:addOption(getText('ContextMenu_LightCigaretteWithFireplace'), player, OnStoveSmoking, stove)
				local subMenu = ISContextMenu:getNew(_context)
				subMenu:addOption("Cigarette", player, OnStoveSmoking, stove)
				_context:addSubMenu(smokeOption, subMenu);
				
			--did we clicked a lit barbecue ?
			elseif instanceof(stove,'IsoBarbecue') and stove:isLit() then
				local smokeOption = _context:addOption(getText('ContextMenu_LightCigaretteWithBarbecue'), player, OnStoveSmoking, stove)
				local subMenu = ISContextMenu:getNew(_context)
				subMenu:addOption("Cigarette", player, OnStoveSmoking, stove)
				_context:addSubMenu(smokeOption, subMenu);
				
			--did we clicked a Campfire ? We check the sprite directly to check if the campfire is lit or not
			elseif instanceof(stove, "IsoObject") and stove:getSpriteName() == "camping_01_5" then
				local smokeOption =_context:addOption(getText('ContextMenu_LightCigaretteWithCampFire'), player, OnStoveSmoking, stove)
				local subMenu = ISContextMenu:getNew(_context)
				subMenu:addOption("Cigarette", player, OnStoveSmoking, stove)
				_context:addSubMenu(smokeOption, subMenu);
				
			--did we clicked on a Fire ? You mad man THIS ONE IS BROKEN
			elseif instanceof(stove, "IsoFire") then
				local smokeOption =_context:addOption(getText('ContextMenu_LightCigaretteWithFire'), player, OnStoveSmoking, stove)	
				local subMenu = ISContextMenu:getNew(_context)
				subMenu:addOption("Cigarette", player, OnStoveSmoking, stove)
				_context:addSubMenu(smokeOption, subMenu);
			end

		end		
	end
end

Events.OnFillWorldObjectContextMenu.Add(LightCigOnStove)
	
function OnStoveSmoking(_player, _stove) 
	local cigarette = _player:getInventory():getItemFromType("Base.Cigarettes")
		
	if luautils.walkAdj(_player, _stove:getSquare(), true) then 
		if CheckInventoryForCigarette (_player) == 2 then
			cigarette = TransferCigaretteFromBag (_player)
		end
	end

	if luautils.walkAdj(_player, _stove:getSquare(), true) then 
		ISTimedActionQueue.add(IsStoveSmoking:new(_player, _stove, cigarette, 460))
	end
end

	

