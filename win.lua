-- R. Bassett Jr. 
-- 2026.07.20
-- Win / Level Complete screen
-- GNU General Public License (GPLv3) - https://www.gnu.org/licenses/gpl-3.0.html

local win = {}

local onload = true
local score = 0
local timeTaken = ""
local accuracy = 0
local damage = ""
local isNewHighScore = false

function win:reset()
	onload = true
	score = 0
	timeTaken = ""
	accuracy = 0
	damage = ""
	isNewHighScore = false
end

-- Gamepad single key press mapping
win.button_press = {
	back = function()
		win:reset()
		states.Level:doQuit()
	end,
	a = function()
		win:reset()
		states.Level:reset()
		states.Level:load(currentLevel + 1)
	end
}

-- Keyboard single key press mapping
win.key_press = {
	escape = function()
		win:reset()
		states.Level:doQuit()
	end,
	space = function()
		win:reset()
		states.Level:reset()
		states.Level:load(currentLevel + 1)
	end
}

function win:update(dt)
	if onload then
		score = states.Level:getScore()
		isNewHighScore = savemgr:compare(diff, currentLevel, score)
		savemgr:setHS(diff, currentLevel, score)
		timeTaken = states.Level:getTimeTakenString()
		accuracy = states.Level:getAccuracy()
		damage = states.Level:getDamageString()
		
		onload = false
	end
end

function win:draw()
	local txt = ""
	txt = txt .. "Level " .. tostring(currentLevel) .. " Complete!\n\n"
	
	if isNewHighScore then
		txt = txt .. "New High Score!\n" .. score .. " / 1000\n\n\n"
	else
		txt = txt .. "Score:\n" .. score .. " / 1000\n\n\n"
	end
	
	txt = txt .. "Time:\n" .. timeTaken .. "\n\n"
	txt = txt .. "Accuracy:\n " .. accuracy .. "%\n\n"
	txt = txt .. "Damage Avoidance:\n" .. damage .. "\n\n\n"
	txt = txt .. "Press SPACE or (A) to Continue\n\n"
	txt = txt .. "ESC or (Back) to Quit"
	
	love.graphics.printf(txt, 0, 20, mX, "center", 0, 1, 1)
end

return win