--NoLighterNeeded Mod by Fingbel

require "TimedActions/ISBaseTimedAction"

IsStoveSmoking = ISBaseTimedAction:derive('IsStoveSmoking')

function IsStoveSmoking:isValid()
	return true --self.character:getInventory():contains(self.cigarette);
end

function IsStoveSmoking:waitToStart()
	--Face the correct direction
	self.character:faceThisObject(self.stove)
	return self.character:shouldBeTurning()
end

function IsStoveSmoking:update()

	--Make progress bar move
	self.cigarette:setJobDelta(self:getJobDelta());
	
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
	self.cigarette:setJobDelta(0.0);
	
	--TODO : fix the animation below
	self.cigarette:setJobType(getText("ContextMenu_Eat"));
	self:setActionAnim("Eat");
	
	end

function IsStoveSmoking:stop()
    --Stop Audio
   		if self.eatAudio ~= 0 and self.character:getEmitter():isPlaying(self.eatAudio) then
		self.character:stopOrTriggerSound(self.eatAudio);
	end
	
	--Reset Progress Bar
	self.cigarette:setJobDelta(0.0);
	
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
	self.cigarette:setJobDelta(0.0);
	
	--Eat the cigarette
	--self.cigarette:UseItem();
	self.character:Eat(self.cigarette, 1)
		
	--FinishTimeBasedAction
	ISBaseTimedAction.perform(self)
	
	--DEBUG
	--print ("PERFORMED")
end

function IsStoveSmoking:new (character, stove, cigarette, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.stats = character:getStats();
	o.stove = stove;
	o.cigarette = cigarette;
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