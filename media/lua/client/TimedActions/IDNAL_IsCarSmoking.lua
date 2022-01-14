--NoLighterNeeded Mod by Fingbel

require "TimedActions/ISBaseTimedAction"

IsCarSmoking = ISBaseTimedAction:derive('IsCarSmoking')

function IsCarSmoking:isValid()
	return true
end

function IsCarSmoking:update()

	--Make progress bar move
	self.cigarette:setJobDelta(self:getJobDelta());
	
     if self.eatAudio ~= 0 and not self.character:getEmitter():isPlaying(self.eatAudio) then
         self.eatAudio = self.character:getEmitter():playSound(self.eatSound);
     end
end

function IsCarSmoking:start()
	--This bypass the lighter durability drainage
	self.cigarette:setRequireInHandOrInventory(nil)
	
	--Start Audio
	if self.eatSound ~= '' then
         self.eatAudio = self.character:getEmitter():playSound(self.eatSound);
	end
	self.cigarette:setJobDelta(0.0);
	
	end

function IsCarSmoking:stop()
    --Stop Audio
   		if self.eatAudio ~= 0 and self.character:getEmitter():isPlaying(self.eatAudio) then
		self.character:stopOrTriggerSound(self.eatAudio);
	end
	
	--Reset Progress Bar
	self.cigarette:setJobDelta(0.0);
	
	--StopTimeBasedAction
	ISBaseTimedAction.stop(self);
	
	end

function IsCarSmoking:perform()
	--Stop Audio
	if self.eatAudio ~= 0 and self.character:getEmitter():isPlaying(self.eatAudio) then
        self.character:stopOrTriggerSound(self.eatAudio);
    end
	
	--Reset Progress Bar
	self.cigarette:setJobDelta(0.0);
	self.character:Eat(self.cigarette, 1)
	
	--FinishTimeBasedAction
	ISBaseTimedAction.perform(self)
	
end

function IsCarSmoking:new (character, cigarette, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.stats = character:getStats();
	o.cigarette = cigarette;
	o.maxTime = time;
	o.eatSound ="Smoke";
	o.eatAudio = 0;
	if character:isTimedActionInstant() then
		o.maxTime = 1;
	end
	return o
end