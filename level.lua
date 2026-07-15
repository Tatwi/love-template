-- R. Bassett Jr. 
-- 2026.07.08
-- A game level with some silly example code
-- GNU General Public License (GPLv3) - https://www.gnu.org/licenses/gpl-3.0.html
local mX = love.graphics.getWidth()
local mY = love.graphics.getHeight()
local level = {}
local player = {}
local	speed = 200
local enemies = {
	require("levels/1"),
	require("levels/2"),
	require("levels/3")
}

local enemyDefaultHealth = {}

local enemyPositions = {
	-- row 1
	{
		{{100,60},{200,60},{300,60},{400,60}}, 	-- 1,2,3,4
		{{130,60},{230,60},{330,60},{430,60}},		-- 5,6,7,8
		{{160,60},{260,60},{360,60},{460,60}},		-- 9,10,11,12
		{{190,60},{290,60},{390,60},{490,60}}, 	-- 13,4,15,16
		{{220,60},{320,60},{420,60},{520,60}},		-- 17,18,19,20
	},
	-- row 2
	{
		{{100,120},{200,120},{300,120},{400,120}},
		{{130,120},{230,120},{330,120},{430,120}},
		{{160,120},{260,120},{360,120},{460,120}},
		{{190,120},{290,120},{390,120},{490,120}},
		{{220,120},{320,120},{420,120},{520,120}},
	},
	-- row 3
	{
		{{100,180},{200,180},{300,180},{400,180}},
		{{130,180},{230,180},{330,180},{430,180}},
		{{160,180},{260,180},{360,180},{460,180}},
		{{190,180},{290,180},{390,180},{490,180}},
		{{220,180},{320,180},{420,180},{520,180}},
	},
}
local rowGroup = 1

enemyColours = {
	{r=0, g=255, b=0}, 		-- green
	{r=0, g=0, b=255}, 		-- blue
	{r=128, g=0, b=128},		-- purple
	{r=225, g=0, b=0},		-- red
}

local enemyMove = 0
local enemiesAlive = 0
local jumpTimer = 0

level.drawEnemy = {
	function(x, y)
		love.graphics.rectangle("fill", x-16, y-16, 32, 32)
	end,
	function(x, y)
		love.graphics.circle("fill", x, y, 16)
	end
}

-- Gamepad single key press mapping
level.button_press = {
	back = function()
		level:doQuit()
	end,
	start = function()
		level:doPause()
	end, 
	a = function()
		level:doJump()
	end,
	b = function()
		level:doShoot()
	end
}

-- Keyboard single key press mapping
level.key_press = {
	escape = function()
		level:doQuit()
	end,
	p = function()
		level:doPause()
	end,
	space = function()
		level:doJump()
	end,
	lshift = function()
		level:doShoot()
	end
}

function level:doQuit()
	currentLevel = 1
	states.Level:reset()
	activeState = "Start"
end

function level:doPause()
	if activeState ~= "Paused" then
		lastState = activeState
		activeState = "Paused"
	else
		activeState = lastState
	end
end

function level:doJump()
	if player.jumping then
		return
	end 
	
	if player.jumps > 0 then
	player.jumps = player.jumps - 1
	player.jumping = true
	
	player.x = math.random(player.size, mX - player.size)
	player.y = math.random(mY - player.size * 6, mY - player.size)
	end
end

function level:doShoot()
	local rng = math.random(1, #enemies[currentLevel])
		
	if enemies[currentLevel][rng].health > 0 then
		enemies[currentLevel][rng].health = enemies[currentLevel][rng].health - 1
	end
end

function level:reset()
	for i = 1, #enemies[currentLevel], 1 do
		enemies[currentLevel][i].health = enemyDefaultHealth[i]
		enemyDefaultHealth[i] =  0
	end

	mX = love.graphics.getWidth()
	mY = love.graphics.getHeight()
	player = {x = mX/2, y = mY-16, size = 16, jumps = 4, jumping = false}
	speed = 200
	enemyMove = 0
	enemiesAlive = 0
end

-- Called from the Start state or "main menu", where the game starts.
function level:load(lvl)
	currentLevel = lvl
	enemiesAlive = #enemies[currentLevel]
	
	for i = 1, #enemies[currentLevel], 1 do
		enemyDefaultHealth[i] = enemies[currentLevel][i].health
	end
	
	mX = love.graphics.getWidth()
	mY = love.graphics.getHeight()
	player = {x = mX/2, y = mY-16, size = 16, jumps = 4, jumping = false}
	speed = 200
end

function level:update(dt)
	-- Check for win
	if enemiesAlive == 0 then
		currentLevel = currentLevel + 1
		
		if currentLevel > 3 then currentLevel = 1 end
		
		states.Level:reset()
		states.Level:load(currentLevel)
	end

	-- Move enemies
	enemyMove = enemyMove + dt
	if math.floor(enemyMove) == 1 then
		rowGroup = rowGroup + 1
		if rowGroup > 4 then rowGroup = 1 end
		
		enemyMove = 0
	end

	-- Get player input
	if player.jumping then
		jumpTimer = jumpTimer + dt
		if math.floor(jumpTimer) == 2 then
			player.jumping = false
			jumpTimer = 0
		end
		
		return
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

	-- Don't do gamepad if doing joystick and prevent crash from happening when acting upon a nil object
	if joystick and not doingKeys then 	
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
	
	-- Clamp player position to desired part of the screen
	if player.x > mX - player.size then
		player.x = mX - player.size
	elseif player.x < player.size then
		player.x = player.size
	end
	
	if player.y > mY - player.size then
		player.y = mY - player.size
	elseif player.y < mY - player.size * 6 then
		player.y = mY - player.size * 6 
	end
end

function level:draw()
	love.graphics.print("Jumps: ".. player.jumps, 5, 2)
	love.graphics.print("Level: ".. currentLevel, 5, 20)
	
	-- Draw enemies
	local rowSlot = 1
	local h = 0
	enemiesAlive = 0
	for i = 1, #enemies[currentLevel], 1 do
		h = enemies[currentLevel][i].health
		if h > 0 then
			enemiesAlive = enemiesAlive + 1
			
			love.graphics.setColor(enemyColours[h].r, enemyColours[h].g, enemyColours[h].b, 1)
			
			-- enemyPositions[ROW][ROW_GROUP][ROW_SLOT][1] = x, enemyPositions[ROW_GROUP][ROW_SLOT][2] = y
			level.drawEnemy[enemies[currentLevel][i].shape](
				enemyPositions[enemies[currentLevel][i].row][rowGroup][rowSlot][1],
				enemyPositions[enemies[currentLevel][i].row][rowGroup][rowSlot][2]
			)
		end
		
		rowSlot = rowSlot + 1
		if rowSlot > 4 then rowSlot = 1 end
	end
	
	-- Draw Player
	if not player.jumping then
		love.graphics.setColor(0.3, 0, 0.3, 1)
		love.graphics.circle("fill", player.x, player.y, player.size)
		love.graphics.setColor(1, 0.4, 0.2, 1)
		love.graphics.circle("line", player.x, player.y, player.size)
		love.graphics.rectangle("fill", player.x-5, player.y-24, 10, 40)
		love.graphics.rectangle("fill", player.x-2, player.y-28, 4, 4)
		love.graphics.setColor(0.5, 0, 0.5, 1)
		love.graphics.rectangle("line", player.x-5, player.y-24, 10, 40)
	end
	
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("Press SHIFT or (A) to randomly hit an enemy!", 160, 260)
end

return level