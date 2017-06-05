playerX = 100
playerY = 300
playerGravity=0
rotation = 0
waves = {}
waveAmount = 0

function love.load()
	rotation = 0
end

function love.update(dt)

	updateWave(dt)
	if love.keyboard.isDown('a') then
		playerX = playerX - 2
--		rotation =rotation -0.02
	end
	if love.keyboard.isDown('d') then
		playerX = playerX + 2
	--	rotation =rotation +0.02
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
		if -math.sin(getWave(playerX)-getWave(playerX+10))*5 < rotation then
			rotation = rotation-0.01
		else
			rotation = rotation+0.01
		end
	end


	
	love.graphics.rotate( rotation)
	love.graphics.setColor(0, 0, 255,255)
	love.graphics.rectangle("fill",0-16,0,32,32)

	love.graphics.translate(0,0)
	love.graphics.rotate( 0)
	love.graphics.setColor(255, 255, 255,255)
	if waves[2] ~= nil then 
		love.graphics.print(waves[3].power,20,20) 
	end
end

function love.keypressed( key, scancode, isrepeat )
	if key == 'w' and playerNearWaves() then
		playerGravity = -8
	end
	if key == 'x' then
		addSplash(300,100)
	end
	
end

function addWave(xPos,power,speed)
	local wave = {}
	wave.x = xPos
	wave.power = power
	wave.size = power
	wave.speed = speed
	table.insert(waves,wave)
	waveAmount = waveAmount+ 1
end

function addSplash(xPos,power)
	addWave(xPos,power/2,0)
	addWave(xPos,-power,-20)
	addWave(xPos,-power,20)
--	waveAmount =6
end

function lerp(a, b, t)
	return a + (b - a) * t
end

function updateWave(dt)
	for i = 1,waveAmount do
		local wave = waves[i]
		wave.power = lerp(wave.power ,0, 1)
--		wave.power = wave.power - dt -1
		wave.x = wave.x +wave.speed * dt
		if math.abs( wave.power) < 1 then
	--		break
		end
		waves[i] = wave
	end
end

function playerNearWaves()
	return playerY-380 > 20
end

function getWave(x)
	local height = love.math.noise(x/300,love.timer.getTime()/2)
	
	for i = 1, waveAmount do
		local wave = waves[i]
		print(wave.x )
		if math.abs(wave.x - x) < wave.size then
			local power = math.abs(wave.x -x)/wave.size 
			power = power * power
			power = power- 1
			height = height + power
			print(power)
		end
	end
	
	return height
end 