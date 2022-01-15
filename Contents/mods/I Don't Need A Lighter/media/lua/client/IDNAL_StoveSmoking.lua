--I Don't Need A Lighter Mod by Fingbel

local StoveSmoking = {}

local function LightCigOnStove(player, context, worldObjects, _test)

	local player = getSpecificPlayer(player);
	local stats = player:getStats();
	local inventory = player:getInventory();
	local smokables = CheckInventoryForCigarette(player)
	
	--Global check for cigarette
	if smokables ~= nil then
		
		--We have cigarettes, let's see if we have a source of flame where we clicked
		for i,stove in ipairs(worldObjects) do
			
			--did we clicked a lit  stove which is not a microwave?
			if instanceof(stove, 'IsoStove') and stove:Activated() and not 	stove:isMicrowave() then 
				
				ContextDrawing(player, context, stove, smokables)
				
			--did we clicked a lit fireplace ?
			elseif instanceof(stove,'IsoFireplace') and stove:isLit() then
				
				ContextDrawing(player, context, stove, smokables)
				
			--did we clicked a lit barbecue ?
			elseif instanceof(stove,'IsoBarbecue') and stove:isLit() then
				
				ContextDrawing(player, context, stove, smokables)
				
			--did we clicked a Campfire ? We check the sprite directly to check if the campfire is lit or not
			elseif instanceof(stove, "IsoObject") and stove:getSpriteName() == "camping_01_5" then
				
				ContextDrawing(player, context, stove, smokables)
				
			--did we clicked on a Fire ? You mad man THIS ONE IS BROKEN, IsoFire is not picked up
			elseif instanceof(stove, "IsoFire") then

				ContextDrawing(player, context, stove, smokables)
			end
		end		
	end
end

Events.OnFillWorldObjectContextMenu.Add(LightCigOnStove)

--This function is responsible for the drawing of the context depending on the smokable array size
function ContextDrawing(player, context, stove, smokables)

	--If we have only one smokable type in the array 
	if getTableSize(smokables) == 1 then 
		context:addOption(getText('ContextMenu_Smoke') .." ".. smokables[0]:getDisplayName(), player, OnStoveSmoking, stove, smokables[0])
		return
	end

	--We have more than on type, we need to draw a sub-menu
	local smokeOption = context:addOption(getText('ContextMenu_Smoke'), stove, nil);		
	local subMenu = ISContextMenu:getNew(context)
	for i=0,getTableSize(smokables) -1 do				
		subMenu:addOption(smokables[i]:getDisplayName(), player, OnStoveSmoking, stove, smokables[i])
		context:addSubMenu(smokeOption, subMenu);
	end
end
	
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
