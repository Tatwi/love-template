-- R. Bassett Jr. 
-- 2026.07.08
-- Start screen
-- GNU General Public License (GPLv3) - https://www.gnu.org/licenses/gpl-3.0.html

local start = {}

local waitingForSave = false
local waitTimer = 0

-- Gamepad single key press mapping
start.button_press = {
	back = function()
		if not waitingForSave then
			savemgr:writeSaveData()
		end
		
		waitingForSave = true
	end,
	start = function()
		if activeState ~= "Level"  and activeState ~= "Paused" then
			currentLevel = 1
			states.Level:load(currentLevel)
		end
	end,
	x = function()
		diff = diff + 1
		if diff > 4 then diff = 1 end
	end
}

-- Keyboard single key press mapping
start.key_press = {
	escape = function()
		if not waitingForSave then
			savemgr:writeSaveData()
		end
		
		waitingForSave = true
	end,
	space = function()
		if activeState ~= "Level" and activeState ~= "Paused" then
			currentLevel = 1
			states.Level:load(currentLevel)
		end
	end,
	x = function()
		diff = diff + 1
		if diff > 4 then diff = 1 end
	end
}

function start:update(dt)
	if waitingForSave then
		waitTimer = waitTimer + dt
		
		if waitTimer > 2 then
			love.event.quit()
		end
	end
end

function start:draw()
	local txt = ""
	
	if waitingForSave then
		txt = "\n\n\n\n\n\n\n\nSaving..."
	else
		txt = txt .. "Example Game!\n\n\n\n\n\n"
		txt = txt .. "Difficulty: ".. diffData[diff].n .. "\n\n\n"
		txt = txt .. "Press X or (X) to change Difficulty\n\n"
		txt = txt .. "Press SPACE or (Start) to Play\n\n\n\n"
		txt = txt .. "ESC or (Back) to Quit"
	end
	
	love.graphics.printf(txt, 0, 20, mX, "center", 0, 1, 1)
end

return start