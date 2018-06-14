local snake = {}
snake.__index = snake

function snake.new(x, y, length, dir)
    local self = {}
    setmetatable(self, snake)
    self.head_position = {x, y}
    self.direction = dir
    self.next_direction = dir
    self.body = {}
    self.to_grow = {}
    self.ammo = 0
    self:grow(length - 1)
    return self
end

function snake:size()
    return #self.body + 1
end

local function grow(self, x, y)
    for i = #self.to_grow, 1, -1 do
        self.to_grow[i] = self.to_grow[i] + 1
        if self.to_grow[i] == self:size() then
            table.insert(self.body, {x, y})
            table.remove(self.to_grow, i)
        end
    end
end

function snake:eat(food)
    self:grow(1)
end

function snake:collect(ammo)
    -- IDEA: generalise to other items?
    self.ammo = self.ammo + 1
end

function snake:grow(n)
    for i = 1, (n or 1) do
        table.insert(self.to_grow, 0)
    end
end

function snake:shoot()
    if self.ammo == 0 then return nil end
    self.ammo = self.ammo - 1
    local speed = 240
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
    local ox = 16 * dx
    local oy = 16 * dy
    local velocity = {
        dx * speed, dy * speed,
    }
    local i, j = unpack(self.head_position)
    local position = {
        (i-0.5) * 16 + ox, 
        (j-0.5) * 16 + oy,
    }
    return {
        position = position,
        velocity = velocity,
    }
end

function snake:turn_to(dir)
    self.next_direction = dir
end

function snake:is_over(x, y)
    if self:is_at(x, y) then 
        return true 
    end
    for _, point in pairs(self.body) do
        if x == point[1] and y == point[2] then
            return true
        end
    end
    return false
end

function snake:is_at(x, y)
    if x == self.head_position[1] and y == self.head_position[2] then
        return true
    end
    return false
end

function snake:tick(game)
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
    if not game:is_clear(x + dx, y + dy) then
        game:load()
        return
    end
    self.head_position = { x + dx, y + dy }
    local next_x, next_y = x, y
    for i = 1, #self.body do
        x, y = unpack(self.body[i])
        self.body[i] = { next_x, next_y }
        next_x, next_y = x, y
    end
    if #self.to_grow > 0 then
        grow(self, x, y)
    end
end

function snake:draw()
    love.graphics.setColor(1, 1, 1)
    local x, y = unpack(self.head_position)
    love.graphics.rectangle("fill", (x-1) * 16 + 1, (y-1) * 16 + 1, 14, 14)
    love.graphics.setColor(0.8, 0.8, 0.8)
    for i = 1, #self.body do
        local size = 12
        for _, food in pairs(self.to_grow) do
            if i == food then size = size + 2 end
        end
        local x = (self.body[i][1] - 1) * 16 + ((16 - size) / 2)
        local y = (self.body[i][2] - 1) * 16 + ((16 - size) / 2)
        love.graphics.rectangle("fill", x, y, size, size)
    end
    -- TODO: show this somehow (in head of snake? circling round?)
    love.graphics.print(tostring(self.ammo), x, y)
end

return snake