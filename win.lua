-- R. Bassett Jr. 
-- 2026.07.20
-- Win / Level Complete screen
-- GNU General Public License (GPLv3) - https://www.gnu.org/licenses/gpl-3.0.html

local win = {}

-- Gamepad single key press mapping
win.button_press = {
	back = function()
		states.Level:doQuit()
	end,
	a = function()
		activeState = "Level"
		states.Level:load(currentLevel)
	end
}

-- Keyboard single key press mapping
win.key_press = {
	escape = function()
		states.Level:doQuit()
	end,
	space = function()
		states.Level:reset()
		currentLevel = currentLevel + 1
		activeState = "Level"
		states.Level:load(currentLevel)
	end
}

function win:update(dt)

end

function win:draw()
	local txt = ""
	txt = txt .. "Level " .. tostring(currentLevel).. " Complete!\n\n\n\n"
	txt = txt .. "Press SPACE or (A) to Continue\n\n"
	txt = txt .. "ESC or (Back) to Quit"
	
	love.graphics.printf(txt, 0, 20, love.graphics.getWidth()/2, "center", 0, 2, 2)
end

return win