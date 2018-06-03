local food = {}
food.__index = food

function food.new(options)
    local self = {}
    setmetatable(self, food)
    self.position = options.position
    self.duration = options.duration or nil
    return self
end

return food