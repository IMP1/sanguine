local map = {}
map.__index = map

function map.new(width, height)
    local self = {}
    setmetatable(self, map)
    self.width     = width
    self.height    = height
    self.obstacles = {}
    self.food      = {}
    self.ammo      = {}
    return self
end

function map:draw()
    love.graphics.setColor(0, 0, 0.2)
    for j = 1, self.height do
        for i = 1, self.width do
            love.graphics.rectangle("fill", (i-1) * 16, (j-1) * 16, 15, 15)
        end
    end
end

return map