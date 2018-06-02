local snake = {}
snake.__index = snake

function snake.new(x, y, length, dir)
    local self = {}
    setmetatable(self, snake)
    self.head_position = {x, y}
    self.direction = dir
    self.next_direction = dir
    self.body = {}
    self.to_grow = 0
    self.ammo = 0
    self:grow(length - 1)
    return self
end

function snake:size()
    return #self.body + 1
end

function snake:grow(n)
    self.to_grow = self.to_grow + (n or 1)
end

function snake:turn_to(dir)
    self.next_direction = dir
end

function snake:tick()
    -- Turn
    if (self.direction % 2) ~= (self.next_direction % 2) then
        self.direction = self.next_direction
    end
    -- Move
    local dx, dy = 0, 0
    if self.direction == 0 then
        dx = 1
    elseif self.direction == 1 then
        dy = 1
    elseif self.direction == 2 then
        dx = -1
    elseif self.direction == 3 then
        dy = -1
    end
    local x, y = unpack(self.head_position)
    self.head_position = { x + dx, y + dy }
    local next_x, next_y = x, y
    for i = 1, #self.body do
        x, y = unpack(self.body[i])
        self.body[i] = { next_x, next_y }
        next_x, next_y = x, y
    end
    -- Grow
    if self.to_grow > 0 then
        table.insert(self.body, {x, y})
        self.to_grow = self.to_grow - 1
    end
end

function snake:draw()
    love.graphics.setColor(1, 1, 1)
    local x, y = unpack(self.head_position)
    love.graphics.rectangle("fill", (x-1) * 16, (y-1) * 16, 15, 15)
    love.graphics.setColor(0.8, 0.8, 0.8)
    for i = 1, #self.body do
        x, y = unpack(self.body[i])
        love.graphics.rectangle("fill", (x-1) * 16, (y-1) * 16, 15, 15)
    end
end

return snake