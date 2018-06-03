local Food     = require 'cls_food'
local Obstacle = require 'cls_obstacle'

local map = {}
map.__index = map

function map.new(width, height)
    local self = {}
    setmetatable(self, map)
    self.width     = width
    self.height    = height
    self.obstacles = {
        Obstacle.new({
            position = {6, 6}
        })
    }
    self.food      = {}
    self.ammo      = {}
    return self
end

function map:food_at(x, y)
    for index, food in pairs(self.food) do
        if food.position[1] == x and food.position[2] == y then
            return food, index
        end
    end
    return nil
end

function map:tick()
    if math.random() < 0.2 and #self.food < 3 then
        local x = math.floor(math.random() * self.width) + 1
        local y = math.floor(math.random() * self.width) + 1
        table.insert(self.food, Food.new({
            position = {x, y},    
        }))
    end
end

function map:is_clear(x, y)
    for _, ob in pairs(self.obstacles) do
        if ob.position[1] == x and ob.position[2] == y then
            return false
        end
    end
    return true
end

function map:draw()
    for j = 1, self.height do
        for i = 1, self.width do
            love.graphics.setColor(0, 0, 0.2)
            love.graphics.rectangle("fill", (i-1) * 16, (j-1) * 16, 16, 16)
            love.graphics.setColor(0.1, 0.1, 0.5)
            love.graphics.rectangle("line", (i-1) * 16, (j-1) * 16, 16, 16)
        end
    end
    love.graphics.setColor(0.5, 0, 0)
    for _, obstacle in pairs(self.obstacles) do
        local i, j = unpack(obstacle.position)    
        love.graphics.rectangle("fill", (i-1) * 16, (j-1) * 16, 16, 16)
    end
    love.graphics.setColor(0, 0.5, 0)
    for _, food in pairs(self.food) do
        local i, j = unpack(food.position)    
        love.graphics.circle("fill", (i-0.5) * 16, (j-0.5) * 16, 6)
    end
end

return map