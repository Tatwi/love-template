local paused = {}

function paused:update(dt)

end

function paused:draw()
	love.graphics.print("GAME PAUSED", 450, 350)
end

return paused