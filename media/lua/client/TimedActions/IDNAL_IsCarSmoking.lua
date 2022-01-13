--NoLighterNeeded Mod by Fingbel

require "TimedActions/ISBaseTimedAction"

IsCarSmoking = ISBaseTimedAction:derive('IsCarSmoking')

function IsCarSmoking:isValid()
	return self.character:getInventory():contains(self.item)
end

function IsCarSmoking:update()

	--Make progress bar move
	self.item:setJobDelta(self:getJobDelta());
     if self.eatAudio ~= 0 and not self.character:getEmitter():isPlaying(self.eatAudio) then
         self.eatAudio = self.character:getEmitter():playSound(self.eatSound);
     end
end

function IsCarSmoking:start()
	--Start Audio
	if self.eatSound ~= '' then
         self.eatAudio = self.character:getEmitter():playSound(self.eatSound);
	end
	self.item:setJobDelta(0.0);
	
	end

function IsCarSmoking:stop()
    --Stop Audio
   		if self.eatAudio ~= 0 and self.character:getEmitter():isPlaying(self.eatAudio) then
		self.character:stopOrTriggerSound(self.eatAudio);
	end
	
	--Reset Progress Bar
	self.item:setJobDelta(0.0);
	
	--StopTimeBasedAction
	ISBaseTimedAction.stop(self);
	
	--DEBUG
	--print ("STOPPED")
	
	end

function IsCarSmoking:perform()
	--Stop Audio
	if self.eatAudio ~= 0 and self.character:getEmitter():isPlaying(self.eatAudio) then
        self.character:stopOrTriggerSound(self.eatAudio);
    end
	
	--Reset Progress Bar
	self.item:setJobDelta(0.0);
	
	local cigarette = self.character:getInventory():getItemFromType("Cigarettes");
	cigarette:UseItem();
	
	--Reset last smoke timer et Cigarette Stress
	self.character:setTimeSinceLastSmoke(0);
	self.stats:setStressFromCigarettes(0);
	
	--Reset stree if smoker
	if self.character:HasTrait("Smoker") then
		self.stats:setStress(0);
		self.character:getBodyDamage():setUnhappynessLevel(self.character:getBodyDamage():getUnhappynessLevel() - 10);
		
	--Regen 0.05 Stress & Inflict FoodSicknessLevel if non Smoker
	else
		self.stats:setStress(self.stats:getStress() - 0.05 )
		self.character:getBodyDamage():setFoodSicknessLevel(self.character:getBodyDamage():getFoodSicknessLevel() + 13);
	end
	
	--FinishTimeBasedAction
	ISBaseTimedAction.perform(self)
	
	--DEBUG
	--print ("PERFORMED")
end

function IsCarSmoking:new (character, item, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.stats = character:getStats();
	o.item = item;
	o.maxTime = time;
	o.eatSound ="Smoke";
	o.eatAudio = 0;
	if character:isTimedActionInstant() then
		o.maxTime = 1;
	end
	return o
end