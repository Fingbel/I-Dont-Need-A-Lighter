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
	self.item:getContainer():setDrawDirty(true);
	self.item:setJobDelta(0.0);
	print ("PERFORMED")
	ISBaseTimedAction.perform(self)
end

function ISSmoking:new (character, stove, item, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.stove = stove;
	o.item = item;
	o.maxTime = time;
	o.eatSound = "Smoke";
	o.eatType = Cigarettes;
	o.eatAudio = 0;
	o.stopOnWalk = false;
	o.stopOnRun = true;
	if o.character:isTimedActionInstant() then o.maxTime = 1 end;
	return o
end