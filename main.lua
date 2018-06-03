Snake = require 'cls_snake'
Map   = require 'cls_map'

tick_duration = 0.1

function love.load()
    snake = Snake.new(4, 4, 3, 0)
    timer = 0
    map   = Map.new(20, 20)
end

local function wrap_snake()
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

local function eat_food()
    local x, y = unpack(snake.head_position)
    local food, i = map:food_at(x, y)
    if food then
        table.remove(map.food, i)
        snake:eat()
    end
end

local function tick()
    snake:tick()
    wrap_snake()
    eat_food()
    map:tick()
end

function love.update(dt)
    timer = timer + dt
    if timer >= tick_duration then
        tick()
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
    map:draw()
    snake:draw()
end