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
	if(getWorld():getGameMode() ~= "Multiplayer")then
		self.character:getModData().CL = "1"	
		IMNALSPVehicles[self.character:getVehicle():getKeyId()] = "1"
	end
	sendClientCommand(self.character, 'IMNAL', 'Upgrade', {vehicle = self.character:getVehicle():getKeyId(),playerID = self.character:getOnlineID(), newCL = "1"})
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