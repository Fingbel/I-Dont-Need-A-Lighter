--RealSmoker Mod by Fingbel

RealSmoker = RealSmoker
local Smokey = {}

local function LightCigOnOven(_player, _context, _worldObjects, _test)

	local player = getSpecificPlayer(_player)
	local inventory = player:getInventory()
	local cigarette = inventory:getItemFromType("Base.Cigarettes")
	
	for i,stove in ipairs(_worldObjects) do
		if inventory:containsType('Cigarettes') then
			if instanceof(stove, 'IsoStove') and stove:Activated() then
				_context:addOption(getText('ContextMenu_LightCigaretteWithOven'), player, OnSmoking, stove, cigarette)
			
			elseif instanceof(stove,'IsoFireplace') and stove:isLit() then
				_context:addOption(getText('ContextMenu_LightCigaretteWithFireplace'), player, OnSmoking, stove, cigarette)		
			
			end				
		end		
	end
end

function OnSmoking (player, stove, cigarette)

	if luautils.walkAdj(player, stove:getSquare(), false) then
		ISTimedActionQueue.add(ISSmoking:new(player, stove, cigarette, 460))	
	end
	
end

Events.OnFillWorldObjectContextMenu.Add(LightCigOnOven)