local states = {}
local activeState = "Start"
local lastState = "Start"

-- Gamepad single key press mapping
local button_press = {
	back = function()
		love.event.quit()
	end,
	start = function()
		if activeState ~= "Paused" then
			lastState = activeState
			activeState = "Paused"
		else
			activeState = lastState
		end
	end, 
	a = function()
		if activeState ~= "Level"  and activeState ~= "Paused" then
			activeState = "Level"
		end
	end,
	b = function()
		states.Level:reset()
		activeState = "Start"
	end
}

-- Keyboard single key press mapping
local key_press = {
	escape = function()
		love.event.quit()
	end,
	space = function()
		if activeState ~= "Paused" then
			lastState = activeState
			activeState = "Paused"
		else
			activeState = lastState
		end
	end,
	a = function()
		if activeState ~= "Level" and activeState ~= "Paused" then
			activeState = "Level"
		end
	end,
	b = function()
		states.Level:reset()
		activeState = "Start"
	end
}

love.load = function()
	states.Start = require("start")
	states.Paused = require("paused")
	states.Level = require("level")
	activeState = "Start"
	
end

love.update = function(dt)
	states[activeState]:update(dt)
end

love.draw = function()
	states[activeState]:draw()
end

love.gamepadpressed = function(joystick, button)
	if button_press[button] then
		button_press[button]()
	end
end

love.keypressed = function(key)
	if key_press[key] then
		key_press[key]()
	end
end