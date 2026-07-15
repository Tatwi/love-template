-- R. Bassett Jr. 
-- 2026.07.08
-- Starting point for a game that uses game states
-- GNU General Public License (GPLv3) - https://www.gnu.org/licenses/gpl-3.0.html

-- Convert a CSV string to a Lua table
love.csvToTable = function(str)
	local r = {}
	local i = 1
	local p = 1
	while true do
		local s = str:find(',', p, true)
		if not s then
			r[i] = str:sub(p)
			break
		end
		r[i] = str:sub(p, s - 1)
		p = s + 1
		i = i + 1
	end
	return r
end

love.load = function()
	states = {}
	states.Start = require("start")
	states.Paused = require("paused")
	states.Level = require("level")
	activeState = "Start"
	lastState = "Start"
	currentLevel = 1
	highestLevel = 1
	highScore = 0
	
	-- Manage save data, stored in CSV format
	local saveFile = "gamesave"
	local saveFileContents = love.filesystem.read(saveFile, size)
	
	if saveFileContents then
		print("Loading save data...")
		local saveDataTable = love.csvToTable(saveFileContents)
		
		highestLevel = tonumber(saveDataTable[1])
		highScore = tonumber(saveDataTable[2])
		
		print("highestLevel: ".. highestLevel.. "\nhighScore: ".. highScore)
	else
		print("Save data does not exist. Creating it...")
		
		local saveData = love.filesystem.newFileData(tostring(highestLevel)..","..tostring(highScore) , saveFile)		
		local success, message = love.filesystem.write(saveFile, saveData)
	
		if success then 
			print ('Save file created!')		
		else 
			print ('file not created: '..message)
		end
	end
		
	local joysticks = love.joystick.getJoysticks()
	joystick = joysticks[1]
end


love.update = function(dt)
	states[activeState]:update(dt)
end

love.draw = function()
	states[activeState]:draw()
end

love.gamepadpressed = function(joystick, button)
	if states[activeState].button_press[button] then
		states[activeState].button_press[button]()
	end
end

love.keypressed = function(key)
	if states[activeState].key_press[key] then
		states[activeState].key_press[key]()
	end
end