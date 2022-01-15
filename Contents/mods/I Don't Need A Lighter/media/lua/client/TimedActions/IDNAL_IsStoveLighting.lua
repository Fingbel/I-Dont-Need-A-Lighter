--NoLighterNeeded Mod by Fingbel

require "TimedActions/ISBaseTimedAction"


IsStoveLighting = ISBaseTimedAction:derive('IsStoveLighting')

function IsStoveLighting:isValid()
	return self.character:getInventory():contains(self.item);
end


function IsStoveLighting:waitToStart()
	--Face the correct direction
	self.character:faceThisObject(self.stove)
	return self.character:shouldBeTurning()
end

function IsStoveLighting:start()
	self:setActionAnim("Craft");
	print(self.initialState)
	--This bypass the lighter durability drainage
	self.item:setRequireInHandOrInventory(nil)
	if self.initialState == false then
		self.stove:Toggle() 
	end
end

function IsStoveLighting:stop()
	--StopTimeBasedAction
	ISBaseTimedAction.stop(self);	
		if self.initialState == false then
		self.stove:Toggle()
	end
end

function IsStoveLighting:perform()
	if self.initialState == false then
		self.stove:Toggle()
	end
	--FinishTimeBasedAction
	ISBaseTimedAction.perform(self)
end

function IsStoveLighting:new (character, stove, item, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.stove = stove
	o.item = item;
	o.maxTime = time;
	o.initialState = stove:Activated()
	if character:isTimedActionInstant() then
		o.maxTime = 1;
	end
	return o
end