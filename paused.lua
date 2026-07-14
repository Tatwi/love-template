-- R. Bassett Jr. 
-- 2026.07.08
-- Paused screen
-- GNU General Public License (GPLv3) - https://www.gnu.org/licenses/gpl-3.0.html

local paused = {}

-- Gamepad single key press mapping
paused.button_press = {
	back = function()
		states.Level:reset()
		activeState = "Start"
	end,
	start = function()
		if activeState ~= "Paused" then
			lastState = activeState
			activeState = "Paused"
		else
			activeState = lastState
		end
	end
}

-- Keyboard single key press mapping
paused.key_press = {
	escape = function()
		states.Level:reset()
		activeState = "Start"
	end,
	p = function()
		if activeState ~= "Paused" then
			lastState = activeState
			activeState = "Paused"
		else
			activeState = lastState
		end
	end
}

function paused:update(dt)

end

function paused:draw()
	love.graphics.print("GAME PAUSED", 450, 350)
end

return paused