require "TimedActions/ISBaseTimedAction"


IsUnInstallingCarLighter = ISBaseTimedAction:derive('IsUnInstallingCarLighter')

function IsUnInstallingCarLighter:isValid()
return true
end

function IsUnInstallingCarLighter:start()
	--
end

function IsUnInstallingCarLighter:stop()
	ISBaseTimedAction.stop(self);	
end

function IsUnInstallingCarLighter:perform()
	self.character:getVehicle():getModData()["CL"] = 0
	self.character:getInventory():AddItem("Base.CarLighter")
	--FinishTimeBasedAction
	ISBaseTimedAction.perform(self)
end

function IsUnInstallingCarLighter:new (character, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.maxTime = time;
	if character:isTimedActionInstant() then
		o.maxTime = 1;
	end
	return o
end