local bullet = {}
bullet.__index = bullet

function bullet.new(options)
    local self = {}
    setmetatable(self, bullet)
    self.position = options.position
    self.velocity = options.velocity
    self.is_finished = false
    return self
end

function bullet:update(game, dt)
    local x, y = unpack(self.position)
    x = x + self.velocity[1] * dt
    y = y + self.velocity[2] * dt

    local i = math.floor(x / 16) + 1
    local j = math.floor(y / 16) + 1
    if game:is_clear(i, j) then
        self.position = {x, y}
    else
        self.is_finished = true
    end
end

function bullet:draw()
    local x, y = unpack(self.position)
    love.graphics.circle("fill", x, y, 3)
end

return bullet