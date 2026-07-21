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
	-- Max window size
	mX = 640
	mY = 480
	
	canvas = love.graphics.newCanvas(mX, mY)
	
	font = love.graphics.newFont(18)
	love.graphics.setFont(font)
	
	states = {}
	states.Start = require("start")
	states.Paused = require("paused")
	states.Level = require("level")
	states.Win = require("win")
	states.Lose	= require("lose")
	states.EndGame = require("endgame")
	activeState = "Start"
	lastState = "Start"
	
	currentLevel = 1
	
	highestLevel = 1
	highScore = 0
	
	-- Difficulty
	diff = 1
	
	-- fr: How quickly the enemies have a chance to fire
	-- er: The likelihood an enemy will fire when given the chance
	-- h: The player's health
	-- j: How many jumps/warps the player can make
	-- ed: Enemy damage, Square, Circles
	-- n: The name of the difficulty setting
	-- tb: Time(s) per enemy health point the player has to earn the full 250 time bonus points
	diffData = {
		{fr = 0.33, h = 200, j = 6, tb = 1.5, n = "Normal", ed = {8, 15}, er = {50, 30}},
		{fr = 1.2, h = 200, j = 10, tb = 2, n = "Easy", ed = {2, 8}, er = {70, 50}},
		{fr = 0.28, h = 150, j = 4, tb = 1.2, n = "Hard", ed = {8, 20}, er = {40, 20}},
		{fr = 0.24, h = 100, j = 3, tb = 0.7, n = "Crazy", ed = {10,25}, er = {30, 15}},
	}
	
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
	love.graphics.setCanvas(canvas)
		love.graphics.clear(0, 0, 0, 0)
		states[activeState]:draw()
	love.graphics.setCanvas()
	
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(1, 1, 1, 1)
	
	love.graphics.draw(canvas, 0, 0)
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