Snake = require 'cls_snake'
Map   = require 'cls_map'

tick_duration = 0.5

function love.load()
    snake = Snake.new(4, 4, 3, 0)
    timer = 0
    map   = Map.new(20, 20)
end

function love.update(dt)
    timer = timer + dt
    if timer >= tick_duration then
        tick()
        timer = timer - tick_duration
    end
end

function tick()
    snake:tick()
    -- check collision
    local x, y = unpack(snake.head_position)
    if x < 1 then
        x = map.width
    end
    if y < 1 then
        y = map.height
    end
    if x > map.width then
        x = 1
    end
    if y > map.height then
        y = 1
    end
    snake.head_position = {x, y}
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
    map:draw()
    snake:draw()
end