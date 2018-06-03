local Snake = require 'cls_snake'
local Map   = require 'cls_map'

local base_scene = require 'scn_base'

local game = {}
setmetatable(game, base_scene)
game.__index = game

function game.new()
    local self = {}
    setmetatable(self, game)

    self.tick_duration = 0.1

    return self
end

function game:load()
    self.player = Snake.new(4, 4, 3, 0)
    self.snakes = {self.player}
    self.timer  = 0
    self.map    = Map.new(20, 20)
end

local function wrap_snake(self, snake)
    local x, y = unpack(snake.head_position)
    if x < 1 then
        x = self.map.width
    end
    if y < 1 then
        y = self.map.height
    end
    if x > self.map.width then
        x = 1
    end
    if y > self.map.height then
        y = 1
    end
    snake.head_position = {x, y}
end

local function eat_food(self, snake)
    local x, y = unpack(snake.head_position)
    local food, i = self.map:food_at(x, y)
    if food then
        table.remove(self.map.food, i)
        snake:eat()
    end
end

function game:is_clear(x, y)
    if not self.map:is_clear(x, y) then
        return false
    end
    for _, snake in pairs(self.snakes) do
        if snake:is_over(x, y) then
            return false
        end
    end
    return true
end

function game:tick()
    for _, snake in pairs(self.snakes) do
        snake:tick(self)
        wrap_snake(self, snake)
        eat_food(self, snake)
    end
    self.map:tick()
end

function game:keyPressed(key)
    if key == "up" then
        self.player:turn_to(3)
    end
    if key == "left" then
        self.player:turn_to(2)
    end
    if key == "down" then
        self.player:turn_to(1)
    end
    if key == "right" then
        self.player:turn_to(0)
    end
    if key == "space" then
        self.paused = not self.paused
    end
end

function game:update(dt)
    if self.paused then return end
    self.timer = self.timer + dt
    if self.timer >= self.tick_duration then
        self:tick()
        self.timer = self.timer - self.tick_duration
    end
end

function game:draw()
    self.map:draw()
    for _, snake in pairs(self.snakes) do
        snake:draw()
    end
end

return game