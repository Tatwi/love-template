-- R. Bassett Jr. 
-- 2026.07.08
-- A game level with some silly example code
-- GNU General Public License (GPLv3) - https://www.gnu.org/licenses/gpl-3.0.html

local level = {}
local trigger = 0
local action = ""
local fun = {x = 450, y = 350}
local player = {x = 100, y = 100}
local	speed = 300

-- Gamepad single key press mapping
level.button_press = {
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
	end, 
	a = function()
		action = "Jump"
	end,
	b = function()
		action = "Shoot"
	end
}

-- Keyboard single key press mapping
level.key_press = {
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
	end,
	space = function()
		action = "Jump"
	end,
	lshift = function()
		action = "Shoot"
	end
}

function level:update(dt)
	trigger = trigger + dt
	if math.floor(trigger) == 2 then
		fun.x = math.random(10, 800)
		fun.y = math.random(10, 700)
		trigger = 0
	end
	
	local doingKeys = false
	
	-- Keyboard continuous input
	if love.keyboard.isDown("right", "d") then
		player.x = player.x + speed * dt
		doingKeys = true
	elseif love.keyboard.isDown("left", "a") then
		player.x = player.x - speed * dt
		doingKeys = true
	end

	if love.keyboard.isDown("down", "s") then
		player.y = player.y + speed * dt
		doingKeys = true
	elseif love.keyboard.isDown("up", "w") then
		player.y = player.y - speed * dt
		doingKeys = true
	end
	
	-- When both gamepad and keyboard are pressed, only do the keyboard input
	if doingKeys then
		return
	end

	-- Prevents crash from happening when acting upon a nil object
	if not joystick then 
		return 
	end
	
	-- Gamepad continuous input
	if joystick:isGamepadDown("dpleft") then
		player.x = player.x - speed * dt
	elseif joystick:isGamepadDown("dpright") then
		player.x = player.x + speed * dt
	end

	if joystick:isGamepadDown("dpup") then
		player.y = player.y - speed * dt
	elseif joystick:isGamepadDown("dpdown") then
		player.y = player.y + speed * dt
	end
end

function level:draw()
	love.graphics.print("GAME LEVEL", fun.x, fun.y)
	love.graphics.print("Last Pressed Action: "..action, 5, 2)
	love.graphics.circle("line", player.x, player.y, 16)
end

function level:reset()
	fun = {x = 450, y = 350}
	trigger = 0
	action = ""
	player = {x = 100, y = 100}
	speed = 300
end

return level