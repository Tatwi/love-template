-- R. Bassett Jr. 
-- 2026.07.08
-- Start screen
-- GNU General Public License (GPLv3) - https://www.gnu.org/licenses/gpl-3.0.html

local start = {}

-- Gamepad single key press mapping
start.button_press = {
	back = function()
		love.event.quit()
	end,
	start = function()
		if activeState ~= "Level"  and activeState ~= "Paused" then
			activeState = "Level"
			states.Level:load(1)
		end
	end,
}

-- Keyboard single key press mapping
start.key_press = {
	escape = function()
		love.event.quit()
	end,
	space = function()
		if activeState ~= "Level" and activeState ~= "Paused" then
			activeState = "Level"
			states.Level:load(currentLevel)
		end
	end
}

function start:update(dt)

end

function start:draw()
	love.graphics.print("Press SPACE or (Start) to Play\n\n     ESC or (Back) to Quit", 230, 200)
end

return start