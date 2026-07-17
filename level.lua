-- R. Bassett Jr. 
-- 2026.07.08
-- A game level with some silly example code
-- GNU General Public License (GPLv3) - https://www.gnu.org/licenses/gpl-3.0.html

local level = {}

-- Game/Window properties
local mX = love.graphics.getWidth()
local mY = love.graphics.getHeight()

--
-- Objects and their properties
--

local player = {}
function level:resetPlayer()
	player = {
		x = mX/2, 
		y = mY-32, 
		size = 16, 
		jumps = diffData[diff].j, 
		speed = 200, 
		health =  diffData[diff].h,
		shotTimer = 0,
		jumpTimer = 0,
		jumping = false,
		shooting = false,
		score = 3434, -- TESTING
		warpSpeed = 2, -- Really this is the radius of a circle ~(=^D)
		warpX = 0,
		warpY = 0
	}
end

local enemies = {
	require("levels/1"),
	require("levels/2"),
	require("levels/3")
}

local enemyDefaultHealth = {} -- Save here to reset at end of level

local enemyPositions = {
	-- row 1
	{
		{{100,60},{200,60},{300,60},{400,60}}, 	-- rowGroup 1
		{{130,60},{230,60},{330,60},{430,60}},		-- rowGroup 2
		{{160,60},{260,60},{360,60},{460,60}},		-- rowGroup 3
		{{190,60},{290,60},{390,60},{490,60}}, 	-- rowGroup 4
		{{220,60},{320,60},{420,60},{520,60}},		-- rowGroup 5
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
local rowGroup = 1 -- Tracks which group of rows is being displayed

enemyColours = {
	{0, 1, 0},
	{0, 0, 1},
	{1, 0, 1},
	{1, 0, 0}
}

local enemyMove = 0
local enemyMoveDir = 1
local enemyShotTimer = 0
local enemiesAlive = {}

local drawEnemyShapes = {
	function(x, y)
		love.graphics.rectangle("fill", x-16, y-16, 32, 32) -- enemy 1
	end,
	function(x, y)
		love.graphics.circle("fill", x, y, 16) -- enemy 2
	end
}

-- 0 is dead/available, 1 is enemy 1, 2 is enemy 2, 3 is the player
local bullets = {
	{owner = 0, x = 0, y = 0},
	{owner = 0, x = 0, y = 0},
	{owner = 0, x = 0, y = 0},
	{owner = 0, x = 0, y = 0},
	{owner = 0, x = 0, y = 0},
	{owner = 0, x = 0, y = 0},
	{owner = 0, x = 0, y = 0},
	{owner = 0, x = 0, y = 0},
	{owner = 0, x = 0, y = 0},
	{owner = 0, x = 0, y = 0},
	{owner = 0, x = 0, y = 0},
	{owner = 0, x = 0, y = 0},
}

local bulletSpec = {
	{speed = 300, size = 3, wobble = -1, dir = 1, c = {0,1,0.5}}, -- enemy 1
	{speed = 150, size = 14, wobble = -2, dir = 1, c = {0,1,1}}, -- enemy 2
	{speed = 700, size = 2, wobble = 1, dir = -1, c = {1,0.72,0}}, -- player
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

--
-- Level Functions
--

-- Called from the Start state or "main menu", where the game starts.
function level:load(lvl)
	currentLevel = lvl
	level:resetEnemiesAlive()
	
	for i = 1, #enemies[currentLevel], 1 do
		enemyDefaultHealth[i] = enemies[currentLevel][i].health
	end
	
	level.resetPlayer()
	mX = love.graphics.getWidth()
	mY = love.graphics.getHeight()
end

function level:reset()
	for i = 1, #enemies[currentLevel], 1 do
		enemies[currentLevel][i].health = enemyDefaultHealth[i]
		enemyDefaultHealth[i] =  0
	end
	
	for i = 1, #bullets, 1 do
		bullets[i].owner = 0
		bullets[i].x = 0
		bullets[i].y = 0
	end

	level:resetPlayer()
	mX = love.graphics.getWidth()
	mY = love.graphics.getHeight()
	enemyMove = 0
	level:resetEnemiesAlive()
end

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

--
-- Player Functions
--

function level:doJump()
	if player.jumping then
		return
	end 
	
	if player.jumps > 0 then
	player.jumps = player.jumps - 1
	player.jumping = true
	
	player.warpX = player.x
	player.warpY = player.y
	
	
	local jumpX = 0
	
	if (mX/2 - player.x) < 0 then
		jumpX = math.random(player.size, mX/4) -- Jump <--
	else
		jumpX = math.random(mX - player.size, mX - mX/4) -- Jump -->
	end
	
	player.x = jumpX
	player.y = math.random(mY - player.size * 6, mY - player.size - 24)
	end
end

function level:doShoot()
	if player.jumping then
		return
	end 

	if player.shooting then
		return
	end 
	
	-- Find an available bullet and shoot
	for i = 1, #bullets, 1 do
		if bullets[i].owner == 0 then
			bullets[i].owner = 3
			bullets[i].x = player.x
			bullets[i].y = player.y
			player.shooting = true
			player.shotTimer = 0
			break
		end	
	end
	
	-- Testing
	local rng = math.random(1, #enemies[currentLevel])
		
	if enemies[currentLevel][rng].health > 0 then
		enemies[currentLevel][rng].health = enemies[currentLevel][rng].health - 1
	end
end

--
-- Enemy Functions
--

function level:resetEnemiesAlive()
	enemiesAlive = {}
	
	for i = 1, #enemies[currentLevel], 1 do
		table.insert(enemiesAlive, i)
	end
end

function level:enemyGetRowSlot(e)
	if enemies[currentLevel][e].row == 2 then
		e = e - 4
	elseif enemies[currentLevel][e].row == 3 then
		e = e - 8
	elseif enemies[currentLevel][e].row == 4 then
		e = e - 12
	end
	
	return e
end

function level:doEnemyShot()
	local rng = enemiesAlive[math.random(1, #enemiesAlive)]
		
	if enemies[currentLevel][rng].health == 0 then
		return
	end
	
	-- Some randomization
	if enemies[currentLevel][rng].shape == 1 and math.random(1, 100) < diffData[diff].e1r then
		return
	end

	if enemies[currentLevel][rng].shape == 2 and math.random(1, 100) < diffData[diff].e2r then
		return
	end
	
	local rowSlot = level:enemyGetRowSlot(rng)
	
	-- Find an available bullet and shoot
	for i = 1, #bullets, 1 do
		if bullets[i].owner == 0 then
			bullets[i].owner = enemies[currentLevel][rng].shape
			bullets[i].x = enemyPositions[enemies[currentLevel][rng].row][rowGroup][rowSlot][1]
			bullets[i].y = enemyPositions[enemies[currentLevel][rng].row][rowGroup][rowSlot][2]
			break
		end	
	end
end

--
-- Game Loop Functions:
--

function level:update(dt)
	-- Check who is alive
	enemiesAlive = {}
	
	for i = 1, #enemies[currentLevel], 1 do
		if enemies[currentLevel][i].health > 0 then
			table.insert(enemiesAlive, i)
		end
	end

	-- Check for win
	if #enemiesAlive == 0 then
		currentLevel = currentLevel + 1
		
		if currentLevel > #enemies then currentLevel = 1 end
		
		states.Level:reset()
		states.Level:load(currentLevel)
	end
	
	-- Update bullets
	local enemyX = 0
	local rowSlot = 1
	
	for i = 1, #bullets, 1 do
		if bullets[i].owner > 0 then
			-- Update position
			bullets[i].y = bullets[i].y + bulletSpec[bullets[i].owner].speed * bulletSpec[bullets[i].owner].dir * dt
			
			-- Kill if off the screen
			if bullets[i].y > mY then
				bullets[i].owner = 0
			elseif bullets[i].y < 0 then
				bullets[i].owner = 0
			end
			
			-- Do collisions
		end
	end
	
	-- Move enemies
	enemyMove = enemyMove + dt
	if math.floor(enemyMove) == 1 then
		if rowGroup == 5 then enemyMoveDir = -1 end
		if rowGroup == 1 then enemyMoveDir = 1 end
	
		rowGroup = rowGroup + enemyMoveDir	
		enemyMove = 0
	end
	
		-- Enemy shots
	enemyShotTimer = enemyShotTimer + dt
	
	if enemyShotTimer > diffData[diff].fr then
		level:doEnemyShot()
		enemyShotTimer = 0
	end
	
	-- Get player input
	if player.jumping then
		player.jumpTimer = player.jumpTimer + dt
		if math.floor(player.jumpTimer) == 2 then
			player.jumping = false
			player.jumpTimer = 0
		end
		
		return
	end
	
	if player.shooting then
		player.shotTimer = player.shotTimer + dt
		
		if player.shotTimer > 0.16 then
			player.shooting = false
			player.shotTimer = 0
		end
	end
	
	local doingKeys = false
	
	-- Keyboard continuous input
	if love.keyboard.isDown("right", "d") then
		player.x = player.x + player.speed * dt
		doingKeys = true
	elseif love.keyboard.isDown("left", "a") then
		player.x = player.x - player.speed * dt
		doingKeys = true
	end
	
	if love.keyboard.isDown("down", "s") then
		player.y = player.y + player.speed * dt
		doingKeys = true
	elseif love.keyboard.isDown("up", "w") then
		player.y = player.y - player.speed * dt
		doingKeys = true
	end	

	-- Don't do gamepad if doing joystick and prevent crash from happening when acting upon a nil object
	if joystick and not doingKeys then 	
		-- Gamepad continuous input
		if joystick:isGamepadDown("dpleft") then
			player.x = player.x - player.speed * dt
		elseif joystick:isGamepadDown("dpright") then
			player.x = player.x + player.speed * dt
		end

		if joystick:isGamepadDown("dpup") then
			player.y = player.y - player.speed * dt
		elseif joystick:isGamepadDown("dpdown") then
			player.y = player.y + player.speed * dt
		end
	end
	
	-- Clamp player position to desired part of the screen
	if player.x > mX - player.size then
		player.x = mX - player.size
	elseif player.x < player.size then
		player.x = player.size
	end
	
	if player.y > mY - player.size - 18 then
		player.y = mY - player.size - 18
	elseif player.y < mY - player.size * 6 then
		player.y = mY - player.size * 6 
	end
end

function level:draw()
	-- Draw bullets
	for i = 1, #bullets, 1 do
		if bullets[i].owner > 0 then
			love.graphics.setColor(bulletSpec[bullets[i].owner].c)
			love.graphics.circle("fill", bullets[i].x, bullets[i].y, bulletSpec[bullets[i].owner].size + math.random(bulletSpec[bullets[i].owner].wobble,2))
		end
	end
	
	-- Draw enemies
	local rowSlot = 1
	for i = 1, #enemies[currentLevel], 1 do
		if enemies[currentLevel][i].health > 0 then			
			love.graphics.setColor(enemyColours[enemies[currentLevel][i].health])
			
			-- enemyPositions[ROW][ROW_GROUP][ROW_SLOT][1] = x, enemyPositions[ROW_GROUP][ROW_SLOT][2] = y
			drawEnemyShapes[enemies[currentLevel][i].shape](
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
		player.warpSpeed = 2
	else
		love.graphics.setColor(0.667, 1, 0.933)
		-- Warp entrance
		love.graphics.circle("line", player.warpX, player.warpY, math.max(2, 20 - player.warpSpeed))
		love.graphics.circle("line", player.warpX, player.warpY, math.max(1, 12 - player.warpSpeed))
		
		-- Warp exit
		love.graphics.circle("line", player.x, player.y, math.min(player.warpSpeed, 10))
		love.graphics.circle("line", player.x, player.y, math.min(player.warpSpeed, 20))
		
		player.warpSpeed = player.warpSpeed + 0.16
	end
	
	-- Bottom background
	love.graphics.setColor(0.2, 0.2, 0.2)
	love.graphics.rectangle("fill", 0, mY-18, mX, 18)
	
	-- Player Health UI
	love.graphics.setColor(0, 1, 0)
	if player.health < 30 then
		love.graphics.setColor(1, 0, 0) -- red
	elseif player.health < 60 then
		love.graphics.setColor(1, 1, 0) -- yellow
	end
	love.graphics.rectangle("fill", 8, mY-16, player.health*2, 14)
	
	-- Player jumps UI
	love.graphics.setColor(0, 0.588, 0.992)
	for i = 1, player.jumps, 1 do
		love.graphics.rectangle("fill", mX - i*20 - 4, mY-16, 14, 14)
	end
	
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Level: ".. currentLevel.. "  ".. diffData[diff].n, 5, 2)
	love.graphics.print("Score: ".. player.score, 5, 18)
end

return level