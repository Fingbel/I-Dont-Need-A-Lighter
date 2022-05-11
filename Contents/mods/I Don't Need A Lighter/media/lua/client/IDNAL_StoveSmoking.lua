--I Don't Need A Lighter Mod by Fingbel

local StoveSmoking = {}

local function LightCigOnStove(_player, context, worldObjects, _test)
    if _test then return true end

	local player = getSpecificPlayer(_player);
	local smokables = CheckInventoryForCigarette(player)
	ContextDrawing(player, context, whatIsUnderTheMouse(worldObjects, player), smokables)
end

Events.OnPreFillWorldObjectContextMenu.Add(LightCigOnStove)

--This function is responsible for the drawing of the context depending on the smokable array size
function ContextDrawing(player, context, stove, smokables)
	
	if stove == nil then return end
	
	--If we do not have nothing to smoke then we don't draw anything
	if smokables == nil then return

		--PREVIOUS METHOD : This add a red option not selectable, this create clutter
		--local foo = context:addOptionOnTop(getText('ContextMenu_Smoke'), player, stove)
		--foo.notAvailable = true
		--return	

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

function whatIsUnderTheMouse ( worldObjects, playerObj)
	for i,stove in ipairs(worldObjects) do	

		--Did we click on a player ?
		for x=stove:getSquare():getX()-1,stove:getSquare():getX()+1 do
			for y=stove:getSquare():getY()-1,stove:getSquare():getY()+1 do
				local sq = getCell():getGridSquare(x,y,stove:getSquare():getZ());
				if sq then
					for i=0,sq:getMovingObjects():size()-1 do
						local o = sq:getMovingObjects():get(i)
						if instanceof(o, "IsoPlayer") and (o ~= playerObj) then
							if string.match(o:getAnimationDebug(), "foodtype : Cigarettes") then
							return o
							end
						end
					end
				end
			end
		end
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

	--We need to make sure the clicked player is still smoking
	if instanceof(stove, 'IsoPlayer') then
		if not string.match(stove:getAnimationDebug(), "foodtype : Cigarettes") then return end
	end

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
		elseif stove:getSquare():haveFire() then ISTimedActionQueue.add(IsStoveLighting:new (_player, stove, _cigarette, 10))
		else for i=0,stove:getSquare():getMovingObjects():size()-1 do
				local o = stove:getSquare():getMovingObjects():get(i)
				if instanceof(o, "IsoPlayer") and (o ~= playerObj) then
					if string.match(o:getAnimationDebug(), "foodtype : Cigarettes") then ISTimedActionQueue.add(IsStoveLighting:new (_player, stove, _cigarette, 10)) end
				end		
			end
		end
	end

	--Now it's lit, let's smoke it
	if luautils.walkAdj(_player, stove:getSquare(), true) then 	
		ISTimedActionQueue.add(IsStoveSmoking:new(_player, stove, _cigarette, 460))
	end
end