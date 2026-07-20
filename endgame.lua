-- R. Bassett Jr. 
-- 2026.07.20
-- End Game screen
-- GNU General Public License (GPLv3) - https://www.gnu.org/licenses/gpl-3.0.html

local endgame = {}

-- Gamepad single key press mapping
endgame.button_press = {
	back = function()
		states.Level:doQuit()
	end
}

-- Keyboard single key press mapping
endgame.key_press = {
	escape = function()
		states.Level:doQuit()
	end
}

function endgame:update(dt)

end

function endgame:draw()
	local txt = ""
	txt = txt .. "Final Level Complete\n\n\n\nYou Win!\n\n\n\n"
	txt = txt .. "ESC or (Back) to Quit"
	
	love.graphics.printf(txt, 0, 20, love.graphics.getWidth()/2, "center", 0, 2, 2)
end

return endgame