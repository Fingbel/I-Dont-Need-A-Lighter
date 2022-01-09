require "TimedActions/ISBaseTimedAction"

ISSmoking = ISBaseTimedAction:derive('ISSmoking')

function ISSmoking:isValid()
	return self.character:getInventory():contains(self.item);
end

function ISSmoking:waitToStart()
	self.character:faceThisObject(self.stove)
	return self.character:shouldBeTurning()
end

function ISSmoking:update()
	self.item:setJobDelta(self:getJobDelta());
     if self.eatAudio ~= 0 and not self.character:getEmitter():isPlaying(self.eatAudio) then
         self.eatAudio = self.character:getEmitter():playSound(self.eatSound);
     end
end

function ISSmoking:start()
	if self.eatSound ~= '' then
         self.eatAudio = self.character:getEmitter():playSound(self.eatSound);
	end
	self.item:setJobDelta(0.0);
	self:setActionAnim("Eat");
	
	end

function ISSmoking:stop()
   	ISBaseTimedAction.stop(self);
	if self.eatAudio ~= 0 and self.character:getEmitter():isPlaying(self.eatAudio) then
		self.character:stopOrTriggerSound(self.eatAudio);
	end
	self.item:setJobDelta(0.0);
	print ("STOPPED")
	end

function ISSmoking:perform()
	if self.eatAudio ~= 0 and self.character:getEmitter():isPlaying(self.eatAudio) then
        self.character:stopOrTriggerSound(self.eatAudio);
    end
	
	local cigarette = self.character:getInventory():getItemFromType("Cigarettes");
	cigarette:UseItem();
	
	--Reset last smoke timer et Cigarette Stress
	self.character:setTimeSinceLastSmoke(0);
	self.stats:setStressFromCigarettes(0);
	
	--Reset stress if smoker, reduce stress by 5  and inflict FoodSicknessLevel if non Smoker
	if self.character:HasTrait("Smoker") then
		self.stats:setStress(0);
		self.character:getBodyDamage():setUnhappynessLevel(self.character:getBodyDamage():getUnhappynessLevel() - 10);
	else
		self.stats:setStress(self.stats:getStress() - 0.05 )
		self.character:getBodyDamage():setFoodSicknessLevel(self.character:getBodyDamage():getFoodSicknessLevel() + 13);
	end
	
	
	
	self.item:setJobDelta(0.0);
	ISBaseTimedAction.perform(self)
	
end

function ISSmoking:new (character, stove, item, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.stats = character:getStats();
	o.stove = stove;
	o.item = item;
	o.maxTime = time;
	o.eatSound = "Smoke";
	o.eatType = Cigarettes;
	o.eatAudio = 0;
	o.stopOnWalk = false;
	o.stopOnRun = true;
	if character:isTimedActionInstant() then
		o.maxTime = 1;
	end
	return o
end