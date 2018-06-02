Snake = require 'cls_snake'

tick_duration = 0.5

function love.load()
    snake = Snake.new(4, 4, 3, 0)
    timer = 0
end

function love.update(dt)
    timer = timer + dt
    if timer >= tick_duration then
        snake:tick()
        timer = timer - tick_duration
    end
end

function love.keypressed(key)
    if key == "up" then
        snake:turn_to(3)
    end
    if key == "left" then
        snake:turn_to(2)
    end
    if key == "down" then
        snake:turn_to(1)
    end
    if key == "right" then
        snake:turn_to(0)
    end
end

function love.draw()
    snake:draw()
end