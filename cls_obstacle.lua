local obstacle = {}
obstacle.__index = obstacle

function obstacle.new(options)
    local self = {}
    setmetatable(self, obstacle)
    self.position = options.position
    return self
end

return obstacle