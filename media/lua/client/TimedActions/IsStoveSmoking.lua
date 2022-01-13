--NoLighterNeeded Mod by Fingbel

require "TimedActions/ISBaseTimedAction"

IsStoveSmoking = ISBaseTimedAction:derive('IsStoveSmoking')

function IsStoveSmoking:isValid()
	return self.character:getInventory():contains(self.item);
end

function IsStoveSmoking:waitToStart()
	--Face the correct direction
	self.character:faceThisObject(self.stove)
	return self.character:shouldBeTurning()
end

function IsStoveSmoking:update()

	--Make progress bar move
	self.item:setJobDelta(self:getJobDelta());
	
	--Audio repeat
     if self.eatAudio ~= 0 and not self.character:getEmitter():isPlaying(self.eatAudio) then
         self.eatAudio = self.character:getEmitter():playSound(self.eatSound);
     end
end

function IsStoveSmoking:start()
	--Start Audio
	if self.eatSound ~= '' then
         self.eatAudio = self.character:getEmitter():playSound(self.eatSound);
	end
	--Initialize progress bar
	self.item:setJobDelta(0.0);
	
	--TODO : fix the animation below
	self.item:setJobType(getText("ContextMenu_Eat"));
	self:setActionAnim("Eat");
	
	end

function IsStoveSmoking:stop()
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

function IsStoveSmoking:perform()
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
	
	--Reset stress and regen 10 unhappyness if smoker 
	if self.character:HasTrait("Smoker") then
		self.stats:setStress(0);
		self.character:getBodyDamage():setUnhappynessLevel(self.character:getBodyDamage():getUnhappynessLevel() - 10);
		
	--Regen 0.05 Stress & Inflict FoodSicknessLevel if non smoker
	else
		self.stats:setStress(self.stats:getStress() - 0.05 )
		self.character:getBodyDamage():setFoodSicknessLevel(self.character:getBodyDamage():getFoodSicknessLevel() + 13);
	end
	
	--FinishTimeBasedAction
	ISBaseTimedAction.perform(self)
	
	--DEBUG
	--print ("PERFORMED")
end

function IsStoveSmoking:new (character, stove, item, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.stats = character:getStats();
	o.stove = stove;
	o.item = item;
	o.maxTime = time;
	o.eatSound ="Smoke";
	o.eatType = Cigarettes;
	o.eatAudio = 0;
	o.stopOnWalk = false;
	o.stopOnRun = true;
	if character:isTimedActionInstant() then
		o.maxTime = 1;
	end
	return o
end