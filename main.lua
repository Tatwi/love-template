-- R. Bassett Jr. 
-- 2026.07.08
-- Starting point for a game that uses game states
-- GNU General Public License (GPLv3) - https://www.gnu.org/licenses/gpl-3.0.html

love.load = function()
	states = {}
	activeState = "Start"
	lastState = "Start"
	states.Start = require("start")
	states.Paused = require("paused")
	states.Level = require("level")
	activeState = "Start"
	
	local joysticks = love.joystick.getJoysticks()
	joystick = joysticks[1]
end


love.update = function(dt)
	states[activeState]:update(dt)
end

love.draw = function()
	states[activeState]:draw()
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