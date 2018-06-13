local ammo = {}
ammo.__index = ammo

function ammo.new(options)
    local self = {}
    setmetatable(self, ammo)
    self.position = options.position
    self.duration = options.duration or nil
    return self
end

return ammo