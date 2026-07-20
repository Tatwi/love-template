-- R. Bassett Jr. 
-- 2026.07.20
-- Lose / Game Over screen
-- GNU General Public License (GPLv3) - https://www.gnu.org/licenses/gpl-3.0.html

local lose = {}

-- Gamepad single key press mapping
lose.button_press = {
	back = function()
		states.Level:doQuit()
	end
}

-- Keyboard single key press mapping
lose.key_press = {
	escape = function()
		states.Level:doQuit()
	end
}

function lose:update(dt)

end

function lose:draw()
	local txt = ""
	txt = txt .. "Level Failed\n\n\n\nGame Over\n\n\n\n"
	txt = txt .. "ESC or (Back) to Quit"
	
	love.graphics.printf(txt, 0, 20, love.graphics.getWidth()/2, "center", 0, 2, 2)
end

return lose