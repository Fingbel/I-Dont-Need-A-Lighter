--NoLighterNeeded Mod by Fingbel

require "TimedActions/ISBaseTimedAction"

IsStoveSmoking = ISBaseTimedAction:derive('IsStoveSmoking')

function IsStoveSmoking:isValid()
	return self.character:getInventory():contains(self.item);
end

function IsStoveSmoking:waitToStart()
	--Face the correct direction
	self.character:faceThisObject(self.worldobject)
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
	
	--This bypass the lighter durability drainage
	self.item:setRequireInHandOrInventory(nil)
	
	--Start Audio
	if self.eatSound ~= '' then
         self.eatAudio = self.character:getEmitter():playSound(self.eatSound);
	end
	--Initialize progress bar
	self.item:setJobDelta(0.0);
	
	--TODO : fix the animation below
	self.item:setJobType(getText("ContextMenu_Eat"));
	self:setActionAnim("Eat");
	
	--TODO : Add an option to allow the automatic turn off of self.stove after the animation started
	
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
	
	end

function IsStoveSmoking:perform()
	--Stop Audio
	if self.eatAudio ~= 0 and self.character:getEmitter():isPlaying(self.eatAudio) then
        self.character:stopOrTriggerSound(self.eatAudio);
    end
	
	--Reset Progress Bar
	self.item:setJobDelta(0.0);
	
	--Eat the cigarette
	self.character:Eat(self.item, 1)
		
	--FinishTimeBasedAction
	ISBaseTimedAction.perform(self)
	
end

function IsStoveSmoking:new (character, worldobject, item, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.stats = character:getStats();
	o.worldobject = worldobject;
	o.item = item;
	o.maxTime = time;
	o.eatSound ="Smoke";
	o.stopOnWalk = false;
	o.stopOnRun = true;
	if character:isTimedActionInstant() then
		o.maxTime = 1;
	end
	return o
end