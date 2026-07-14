local level = {}
local x = 450
local y = 350
local trigger = 0

function level:update(dt)
	trigger = trigger + dt
	if math.floor(trigger) == 2 then
		x = math.random(10, 800)
		y = math.random(10, 700)
		trigger = 0
	end
end

function level:draw()
	love.graphics.print("GAME LEVEL", x, y)
end

function level:reset()
	x = 450
	y = 350
	trigger = 0
end

return level