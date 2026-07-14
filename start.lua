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
	a = function()
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
	a = function()
		if activeState ~= "Level" and activeState ~= "Paused" then
			activeState = "Level"
			states.Level:load(1)
		end
	end
}

function start:update(dt)

end

function start:draw()
	love.graphics.print("   Press A to Start\n\nESC or BACK to Quit", 450, 350)
end

return start