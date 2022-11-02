--This is where we should keep track of car lighters
local Json = require("Json");
local carLighters = {}


function CarLighterCheck(vehicleID)
	if(carLighters[tostring(vehicleID)] == null ) then	
		carLighters[tostring(vehicleID)] = CarLighterRandomizer()
	end
	return carLighters[tostring(vehicleID)]
end

function CarLighterRandomizer()
	local rand = ZombRand(100)
	if rand >50 then return 1 end
	return 0 
end

local function Save()
    local fileWriterObj = getFileWriter("file_carLighters.json", true, false);
    local json = Json.Encode(carLighters);
    fileWriterObj:write(json);
    fileWriterObj:close();
end

local function OnSaveCL()
    print("Saving CL listing")
	Save()
end

Events.OnSave.Add(OnSaveCL)

local function Load()
    local fileReaderObj = getFileReader("file_carLighters.json", true);
    local json = "";
    local line = fileReaderObj:readLine();
    while line ~= nil do
        json = json .. line;
        line = fileReaderObj:readLine()
    end
    fileReaderObj:close();

    if json and json ~= "" then
        carLighters = Json.Decode(json);
    end
end

local function OnLoadCL()
print("Loading existing CL listing")
	Load()
end

Events.OnLoad.Add(OnLoadCL)

