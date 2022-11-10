--I Might Need A Lighter Mod by Fingbel
--Here is the code for the optionnal reworked smoker trait
    
    --Planned feature : 
--Reduce the spawn of cigarettes / lighter & matches
--Smoker can no longer be at max endurance
--Each smoked cigarette induce some sort of fitness and/or endurance debuff/ net reduction
--Make the player randomly cough



local function SmokerCheck()
    local player = getPlayer()
    local stats = player:getStats()
    
	if player:getTraits():contains("Smoker") then

    end
end

Events.EveryTenMinutes.Add(SmokerCheck)