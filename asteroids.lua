asteroids = {
	img = {love.graphics.newImage("sprites/a1.png"),
         love.graphics.newImage("sprites/a2.png")},
  ang_speed = 1         
}

function asteroid_create(size, x, y)
	--big asteroid
	if size == "big" then
		table.insert(asteroids, {})
			asteroids[#asteroids].size = 1
			asteroids[#asteroids].health = 4
			asteroids[#asteroids].score = 20
	end
	
	--medium asteroid
	if size == "medium" then
		table.insert(asteroids, {})
			asteroids[#asteroids].size = 2
			asteroids[#asteroids].health = 2
			asteroids[#asteroids].score = 50
	end
	
	--small asteroid
	if size == "small" then
		table.insert(asteroids, {})
			asteroids[#asteroids].size = 3
			asteroids[#asteroids].health = 1
			asteroids[#asteroids].score = 100
	end
  --Random image index assigned to this asteroid
	asteroids[#asteroids].idx = love.math.random(#asteroids.img)
  --Rotation configuration, from 0 to 360 deg
	asteroids[#asteroids].angle = love.math.random(360)
	asteroids[#asteroids].ang_speed = 
    asteroids.ang_speed * love.math.random() * love.math.random(-1, 1)
	asteroids[#asteroids].body = 
    love.physics.newBody(world, x, y, "dynamic")
	asteroids[#asteroids].shape = 
    love.physics.newRectangleShape(100/asteroids[#asteroids].size, 100/asteroids[#asteroids].size)
	asteroids[#asteroids].fixture = 
    love.physics.newFixture(asteroids[#asteroids].body, asteroids[#asteroids].shape)
	asteroids[#asteroids].speed = 
    player.body:getLinearVelocity() + 10 
	asteroids[#asteroids].fixture:setUserData("asteroid")

end

function asteroids_update(dt)
	for i, o in ipairs(asteroids) do
		--screen looping
		if o.body:getX() <0 then
			o.body:setPosition(width, o.body:getY())
		elseif o.body:getX() > width then
			o.body:setPosition(0, o.body:getY())
		end
		if o.body:getY() <0 then
			o.body:setPosition(o.body:getX(), height)
		elseif o.body:getY() > height then
			o.body:setPosition(o.body:getX(), 0)
		end

		--damage check
		if o.fixture:getUserData() == "asteroid_D" then
			o.health = o.health - 1
			o.fixture:setUserData("asteroid")
		end
				
		--health check
		if o.health <= 0 and o.size == 1 then	--big
			score = score + o.score
			x, y = o.body:getX(), o.body:getY()
			o.body:destroy()
			table.remove(asteroids, i)

			r = math.random(0.5 * math.pi)
			asteroid_create("medium", x, y)
			asteroids[#asteroids].body:applyForce(1000 * math.cos(r), 1000 * math.sin(r))
			r = math.random(0.5 * math.pi)
			asteroid_create("medium", x, y)
			asteroids[#asteroids].body:applyForce(1000 * math.cos(r), 1000 * math.sin(r))

		end
		
		if o.health <= 0 and o.size == 2 then	--medium
			score = score + o.score
			x, y = o.body:getX(), o.body:getY()
			o.body:destroy()
			table.remove(asteroids, i)

			r = math.random(0.5 * math.pi)
			asteroid_create("small", x, y)
			asteroids[#asteroids].body:applyForce(1500 * math.cos(r), 1500 * math.sin(r))
			r = math.random(0.5 * math.pi)
			asteroid_create("small", x, y)
			asteroids[#asteroids].body:applyForce(1500 * math.cos(r), 1500 * math.sin(r))
		end

		if o.health <= 0 and o.size == 3 then	--small
			score = score + o.score
			o.body:destroy()
			table.remove(asteroids, i)
		end
    
    --Rotation
    o.angle = o.angle + o.ang_speed * dt
	end
end

function asteroids_draw()
	for i, o in ipairs(asteroids) do
    -- todo: apply rotation
		love.graphics.draw(asteroids.img[o.idx], o.body:getX(), o.body:getY(), o.angle, 1/o.size, 1/o.size, 50, 50)
	end
end
