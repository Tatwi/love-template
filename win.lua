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
		states.Level:reset()
		states.Level:load(currentLevel + 1)
	end
}

-- Keyboard single key press mapping
win.key_press = {
	escape = function()
		states.Level:doQuit()
	end,
	space = function()
		states.Level:reset()
		states.Level:load(currentLevel + 1)
	end
}

function win:update(dt)

end

function win:draw()
	local txt = ""
	txt = txt .. "Level " .. tostring(currentLevel) .. " Complete!\n\n"
	txt = txt .. "Score:\n" .. states.Level:getScore() .. " / 1000\n\n\n"
	txt = txt .. "Time:\n" .. states.Level:getTimeTakenString() .. "\n\n"
	txt = txt .. "Accuracy:\n " .. states.Level:getAccuracy() .. "%\n\n"
	txt = txt .. "Damage Avoidance:\n" .. states.Level:getDamageString() .. "\n\n\n"
	txt = txt .. "Press SPACE or (A) to Continue\n\n"
	txt = txt .. "ESC or (Back) to Quit"
	
	love.graphics.printf(txt, 0, 20, mX, "center", 0, 1, 1)
end

return win