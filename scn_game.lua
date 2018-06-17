local Snake  = require 'cls_snake'
local Bullet = require 'cls_bullet'
local Map    = require 'cls_map'

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
    self.player  = Snake.new(4, 4, 3, 0)
    self.snakes  = {self.player}
    self.bullets = {}
    self.timer   = 0
    self.map     = Map.new(20, 20)
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
        snake:eat(food)
    end
end

local function collect_ammo(self, snake)
    local x, y = unpack(snake.head_position)
    local ammo, i = self.map:ammo_at(x, y)
    if ammo then
        table.remove(self.map.ammo, i)
        snake:collect(ammo)
    end
end

local function handle_bullet_impact(self, bullet)
    local i, j = unpack(bullet.next_tile)
    for _, snake in pairs(self.snakes) do
        if snake:is_over(i, j) then
            print("Bullet hitting snake...")
            local split_snake = snake:split(i, j)
            if split_snake then
                table.insert(self.snakes, split_snake)
            end
        end
    end
    -- @TODO: play little impact animation 
    --        (explosion on tiles, something else on snakes?)
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
        collect_ammo(self, snake)
    end
    self.map:tick()
end

function game:keyPressed(key)
    if key == "up" or key == "w" then
        self.player:turn_to(3)
    end
    if key == "left" or key == "a" then
        self.player:turn_to(2)
    end
    if key == "down" or key == "s" then
        self.player:turn_to(1)
    end
    if key == "right" or key == "d" then
        self.player:turn_to(0)
    end
    if key == "lctrl" or key == "rctrl" then
        local b = self.player:shoot()
        if b then
            table.insert(self.bullets, Bullet.new(b))
        end
    end
    if key == "p" or key == "escape" then
        self.paused = not self.paused
    end
end

-- @TODO: remove DEBUGGING
function game:mousePressed(mx, my, key)
    local i = math.floor(mx / 16) + 1
    local j = math.floor(my / 16) + 1
    local speed = 240

    table.insert(self.bullets, Bullet.new({
        position = {mx, my},
        velocity = {speed, 0}
    }))
    table.insert(self.bullets, Bullet.new({
        position = {mx, my},
        velocity = {0, speed}
    }))
    table.insert(self.bullets, Bullet.new({
        position = {mx, my},
        velocity = {-speed, 0}
    }))
    table.insert(self.bullets, Bullet.new({
        position = {mx, my},
        velocity = {0, -speed}
    }))
end



function game:update(dt)
    if self.paused then return end
    local bullet_impacts = {}
    for index, bullet in pairs(self.bullets) do
        bullet:update(self, dt)
        if bullet.is_finished then
            table.insert(bullet_impacts, index)
        end
    end
    for _, index in pairs(bullet_impacts) do
        local bullet = table.remove(self.bullets, index)
        handle_bullet_impact(self, bullet)
    end
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
    for _, bullet in pairs(self.bullets) do
        bullet:draw()
    end

    love.graphics.print(self.player:size(), 256, 0)

end

return game