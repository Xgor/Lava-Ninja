playerX = 100
playerY = 300
playerGravity=0
rotation = 0

function love.load()
	rotation = 0
end

function love.update(dt)


	if love.keyboard.isDown('a') then
		playerX = playerX - 2
		rotation =rotation -0.01
	end
	if love.keyboard.isDown('d') then
		playerX = playerX + 2
		rotation =rotation +0.01
	end

	if playerY > getWave(playerX)*50+400 then
		playerY = playerY - 2
	
	--	playerGravity= 0
		if playerGravity > -5 then
			playerGravity = playerGravity - 0.3
		end
	else

		playerGravity = playerGravity + 0.15

	end
	playerY = playerY +playerGravity
end


function love.draw()


	local vertices = {0,640}
	for x = 0, 800,1  do
	--	love.graphics.line(x,getWave(x),x,640)
		table.insert(vertices,x)
		table.insert(vertices,getWave(x)*50+400)
	end
	table.insert(vertices,800)
	table.insert(vertices,640)
	table.insert(vertices,0)
	table.insert(vertices,640)
	love.graphics.setColor(255, 0, 0,255)
	love.graphics.polygon('fill', vertices)
	love.graphics.setColor(255, 255, 255)
--	love.graphics.print(,110,10)
	

	love.graphics.translate(playerX, playerY-32)
	if playerNearWaves() then
		if -math.sin(getWave(playerX)-getWave(playerX+10))*6 < rotation then
			rotation = rotation-0.04
		else
			rotation = rotation+0.04
		end
	end


	
	love.graphics.rotate( rotation)
	love.graphics.setColor(0, 0, 255,255)
	love.graphics.rectangle("fill",0,0,32,32)
--	love.graphics.rotate(0)
end

function love.keypressed( key, scancode, isrepeat )
	if key == 'w' and playerNearWaves() then
		playerGravity = -8
	end

	
end

function playerNearWaves()
	return playerY-370 > 30
end

function getWave(x)
	return love.math.noise(x/300,love.timer.getTime()/2)
end 