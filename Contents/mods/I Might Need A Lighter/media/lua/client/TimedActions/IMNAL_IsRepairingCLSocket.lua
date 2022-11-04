--I Might Need A Lighter Mod by Fingbel

require "TimedActions/ISBaseTimedAction"
IsRepairingCLSocket = ISBaseTimedAction:derive('IsRepairingCLSocket')

function IsRepairingCLSocket:isValid()
	return true
end

function IsRepairingCLSocket:start()
	
end

function IsRepairingCLSocket:stop()
	
	--StopTimeBasedAction
	ISBaseTimedAction.stop(self);	
end

function IsRepairingCLSocket:perform()
	self.character:getVehicle():getModData()["CL"] = 1
	self.character:getVehicle()vehicle:transmitModData()
--FinishTimeBasedAction
	ISBaseTimedAction.perform(self)
end

function IsRepairingCLSocket:new (character,  time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.maxTime = time
	if character:isTimedActionInstant() then
		o.maxTime = 1
	end
	return o
end