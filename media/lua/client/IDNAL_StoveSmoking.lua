--I Don't Need A Lighter Mod by Fingbel

local StoveSmoking = {}

local function LightCigOnStove(_player, _context, _worldObjects, _test)


	local player = getSpecificPlayer(_player);
	local stats = player:getStats();
	local inventory = player:getInventory();
	local smokables = CheckInventoryForCigarette(player)
	
	--Global check for cigarette
	if smokables ~= nil then
		
		--We have cigarettes, let's see if we have a source of flame where we clicked
		for i,stove in ipairs(_worldObjects) do
			
			--did we clicked a lit  stove which is not a microwave?
			if instanceof(stove, 'IsoStove') and stove:Activated() and not 	stove:isMicrowave() then				
				local smokeOption = _context:addOption(getText('ContextMenu_LightCigaretteWithOven'), worldobjects, nil);
				local subMenu = ISContextMenu:getNew(_context)
				
				for i=0,getTableSize(smokables) -1 do
					subMenu:addOption(smokables[i]:getDisplayName(), player, OnStoveSmoking, stove, smokables[i])
					_context:addSubMenu(smokeOption, subMenu);
				end
				
			--did we clicked a lit fireplace ?
			elseif instanceof(stove,'IsoFireplace') and stove:isLit() then
				local smokeOption = _context:addOption(getText('ContextMenu_LightCigaretteWithFireplace'), player, OnStoveSmoking, stove)
				local subMenu = ISContextMenu:getNew(_context)
				
				
				for i=0,getTableSize(smokables) -1 do
					subMenu:addOption(smokables[i]:getDisplayName(), player, OnStoveSmoking, stove, smokables[i])
					_context:addSubMenu(smokeOption, subMenu);
				end
				
			--did we clicked a lit barbecue ?
			elseif instanceof(stove,'IsoBarbecue') and stove:isLit() then
				local smokeOption = _context:addOption(getText('ContextMenu_LightCigaretteWithBarbecue'), player, OnStoveSmoking, stove, smokables[i])
				local subMenu = ISContextMenu:getNew(_context)
				
				
				for i=0,getTableSize(smokables) -1 do
					subMenu:addOption(smokables[i]:getDisplayName(), player, OnStoveSmoking, stove, smokables[i])
					_context:addSubMenu(smokeOption, subMenu);
				end
				
			--did we clicked a Campfire ? We check the sprite directly to check if the campfire is lit or not
			elseif instanceof(stove, "IsoObject") and stove:getSpriteName() == "camping_01_5" then
				local smokeOption =_context:addOption(getText('ContextMenu_LightCigaretteWithCampFire'), player, OnStoveSmoking, stove, smokables[i])
				local subMenu = ISContextMenu:getNew(_context)
				
				
				for i=0,getTableSize(smokables) -1 do
					subMenu:addOption(smokables[i]:getDisplayName(), player, OnStoveSmoking, stove, smokables[i])
					_context:addSubMenu(smokeOption, subMenu);
				end	
				
			--did we clicked on a Fire ? You mad man THIS ONE IS BROKEN, IsoFire is not picked up
			elseif instanceof(stove, "IsoFire") then
				local smokeOption =_context:addOption(getText('ContextMenu_LightCigaretteWithFire'), player, OnStoveSmoking, stove, smokables[i])	
				local subMenu = ISContextMenu:getNew(_context)
				
				
				for i=0,getTableSize(smokables) -1 do
					subMenu:addOption(smokables[i]:getDisplayName(), player, OnStoveSmoking, stove, smokables[i])
					_context:addSubMenu(smokeOption, subMenu);
				end
			end
		end		
	end
end

Events.OnFillWorldObjectContextMenu.Add(LightCigOnStove)
	
function OnStoveSmoking(_player, _stove, _cigarette) 
	if luautils.walkAdj(_player, _stove:getSquare(), true) then 
		--Do we need to transfer cigarette from a bag first ? 
		if _cigarette:getContainer() ~= _player:getInventory() then
			ISTimedActionQueue.add(ISInventoryTransferAction:new (_player,  _cigarette, _cigarette:getContainer(), _player:getInventory(), 5))
		end
	end

	if luautils.walkAdj(_player, _stove:getSquare(), true) then 
		
		ISTimedActionQueue.add(IsStoveSmoking:new(_player, _stove, _cigarette, 460))
	end
end
