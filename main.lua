require 'player'
require 'bullets'
require 'asteroids'
require 'world'

--called once when game is started up
function love.load()
	world_load()
	debugText = "load" .. "\n"
	show_debug = false
  infinite_mode = false
  skipped_intro = false
end

--updates everything
function love.update(dt)
	world:update(dt)
	player_update(dt)
	bullets_update(dt)
	asteroids_update(dt)
	world_update(dt)

	if string.len(debugText) > 600 then
		debugText = ""
	end
end

--button presses
function love.keypressed(key)
	--shoot bullets
	if key == ("space") then
		bullet_create()
		debugText = debugText .. "shoot" .. "\n"
	end
	
	--exit the game when escape is pushed
	if key == ("escape") then
		love.event.push("quit")
	end

  -- Trigger infinite mode
  if key == ("p") then
    infinite_mode = true
  end
	
  -- Trigger infinite mode
  if key == ("x") then
    skipped_intro = true
  end

	--debug
	if key == ("`") then
		show_debug = not show_debug
	end
end

--draw everything on the screen;
function love.draw()
	love.graphics.setFont(love.graphics.newFont("visitor1.ttf", 30))
  if not skipped_intro then
	  love.graphics.setFont(love.graphics.newFont("visitor1.ttf", 60))
    love.graphics.print("ASTEROIDES", width / 2 - 200, height / 2 - 300)
	  love.graphics.setFont(love.graphics.newFont("visitor1.ttf", 30))
    love.graphics.print("Yendo en barco hacia Menorca", width / 2 - 250, height / 2 - 225)
    love.graphics.print("Te has perdido y has acabado en", width / 2 - 275, height / 2 - 175)
	  love.graphics.setFont(love.graphics.newFont("visitor1.ttf", 60))
    love.graphics.print("ANDRÓMEDA", width / 2 - 175, height / 2 - 100)
	  love.graphics.setFont(love.graphics.newFont("visitor1.ttf", 30))
    love.graphics.print("¡Y está lleno de ALEMANES! Quiero decir, ASTEROIDES!", width / 2 - 450, height / 2 )
    love.graphics.print("¡Pulsa X para comenzar tu aventura!", width / 2 - 300, height / 2 + 250 )
    return
  end
  player_draw()
	bullets_draw()
  if score < 200 or infinite_mode then
	  asteroids_draw()
	  love.graphics.print("Puntuacion: " .. score .. "/200", width - 500, 10)
  else
	  love.graphics.setFont(love.graphics.newFont("visitor1.ttf", 30))
    love.graphics.print("¡FELICIDADES PAPA!", width / 2 - 150, height / 2 - 50)
    love.graphics.print("¡HAS DESTRUIDO UN PAR DE ASTEROIDES!", width / 2 - 300, height / 2 )
    love.graphics.print("¡Pulsa P para jugar en modo infinito!", width / 2 - 300, height / 2 + 50 )
  end
	--debug
	if show_debug then
		love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
		love.graphics.print(debugText, 10, 25)
	end
end
