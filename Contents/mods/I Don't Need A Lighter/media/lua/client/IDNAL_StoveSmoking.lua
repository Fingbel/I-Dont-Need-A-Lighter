--I Don't Need A Lighter Mod by Fingbel

local StoveSmoking = {}

local function LightCigOnStove(_player, context, worldObjects, _test)
    if _test then return true end

	local player = getSpecificPlayer(_player);
	local smokables = CheckInventoryForCigarette(player)
	ContextDrawing(player, context, whatIsUnderTheMouse(worldObjects), smokables)
end

Events.OnPreFillWorldObjectContextMenu.Add(LightCigOnStove)

--This function is responsible for the drawing of the context depending on the smokable array size
function ContextDrawing(player, context, stove, smokables)
	
	if stove == nill then return end
	
	--If we do not have any smokable, let draw a fake smoke context menu and make it unavailable
	if smokables == nil then 
		local foo = context:addOptionOnTop(getText('ContextMenu_Smoke'), player, stove)
		foo.notAvailable = true
		return	
	--If we have only one smokable type in the array 
	elseif getTableSize(smokables) == 1 then
		option = context:addOptionOnTop(getText('ContextMenu_Smoke') .."  ".. smokables[0]:getDisplayName(), player, OnStoveSmoking, stove, smokables[0])
	return
	end

	--We have more than on type, we need to draw a sub-menu
	local smokeOption = context:addOptionOnTop(getText('ContextMenu_Smoke'), stove, nil);		
	local subMenu = ISContextMenu:getNew(context)
	for i=0,getTableSize(smokables) -1 do	

		option = subMenu:addOptionOnTop(smokables[i]:getDisplayName(), player, OnStoveSmoking, stove, smokables[i])
		context:addSubMenu(smokeOption, subMenu);		
	end
end

function whatIsUnderTheMouse ( worldObjects)
	for i,stove in ipairs(worldObjects) do	
	--did we clicked a stove/microwave?	
		if stove:getObjectName() == ("Stove") and ((SandboxVars.ElecShutModifier > -1 and getGameTime():getNightsSurvived() < SandboxVars.ElecShutModifier) or stove:getSquare():haveElectricity()) then return stove
	--did we clicked a lit fireplace ?
		elseif stove:getObjectName() == ("Fireplace") and stove:isLit() then return stove										
	--did we clicked a lit barbecue ?
		elseif stove:getObjectName() == ("Barbecue") and stove:isLit() then return stove									
	--did we clicked a Campfire ? We check the sprite directly to check if the campfire is lit or not
		elseif stove:getObjectName() == ("IsoObject") and stove:getSpriteName() == "camping_01_5" then return stove						
	--did we clicked on a Fire ? You mad man 
		elseif stove:getSquare():haveFire() then return stove end
	end
end

function OnStoveSmoking(_player, stove, _cigarette) 
	ISWorldObjectContextMenu.Test = true
	--Do we need to transfer cigarette from a bag first ? 
	if luautils.walkAdj(_player, stove:getSquare(), true) then 
		if _cigarette:getContainer() ~= _player:getInventory() then
			ISTimedActionQueue.add(ISInventoryTransferAction:new (_player,  _cigarette, _cigarette:getContainer(), _player:getInventory(), 5))
		end
	end
	 
	--Let's light what we've found
	local time
	if luautils.walkAdj(_player, stove:getSquare(), true) then 
		if instanceof(stove, 'IsoStove') and not stove:isMicrowave() then ISTimedActionQueue.add(IsStoveLighting:new (_player, stove, _cigarette, 100))
		elseif instanceof(stove, 'IsoStove') and stove:isMicrowave() then ISTimedActionQueue.add(IsStoveLighting:new (_player, stove, _cigarette, 3000)) 
		elseif instanceof(stove,'IsoFireplace') and stove:isLit() then ISTimedActionQueue.add(IsStoveLighting:new (_player, stove, _cigarette, 100)) 
		elseif instanceof(stove,'IsoBarbecue') and stove:isLit() then ISTimedActionQueue.add(IsStoveLighting:new (_player, stove, _cigarette, 100)) 
		elseif instanceof(stove, "IsoObject") and stove:getSpriteName() == "camping_01_5" then ISTimedActionQueue.add(IsStoveLighting:new (_player, stove, _cigarette, 120)) 
		elseif stove:getSquare():haveFire() then ISTimedActionQueue.add(IsStoveLighting:new (_player, stove, _cigarette, 10)) end
	end

	--Now it's lit, let's smoke it
	if luautils.walkAdj(_player, stove:getSquare(), true) then 
		
		ISTimedActionQueue.add(IsStoveSmoking:new(_player, stove, _cigarette, 460))
	end
end