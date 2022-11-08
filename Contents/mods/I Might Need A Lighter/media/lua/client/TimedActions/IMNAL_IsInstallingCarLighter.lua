--I Might Need A Lighter Mod by Fingbel

require "TimedActions/ISBaseTimedAction"
IsInstallingCarLighter = ISBaseTimedAction:derive('IsInstallingCarLighter')

function IsInstallingCarLighter:isValid()
	return self.character:getInventory():contains(self.item);
end

function IsInstallingCarLighter:start()
	self.character:getEmitter():playSound("CarLighter_Plug");
end

function IsInstallingCarLighter:stop()
	ISBaseTimedAction.stop(self);	
end

function IsInstallingCarLighter:perform()
	sendClientCommand(self.character, 'IMNAL', 'Upgrade', {vehicle = self.character:getVehicle():toString(),playerID = self.character:getOnlineID(), newCL = "2"})
	self.item:Use()
	--FinishTimeBasedAction
	ISBaseTimedAction.perform(self)
end

function IsInstallingCarLighter:new (character, item, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.item = item;
	o.maxTime = time;
	if character:isTimedActionInstant() then
		o.maxTime = 1;
	end
	return o
end