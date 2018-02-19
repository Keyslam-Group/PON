local Class  = require("lib.class")
local Vector = require("lib.vector")

local Ball = Class("Ball")

function Ball:initialize(t)
   t = t or {}

   self.baseSize = t.size or Vector(100, 20)

   self.pos  = self.start:clone()
   self.vel  = t.vel or Vector(0, 0)
   self.size = self.baseSize:clone()
end

function Ball:update(dt)

end

function Ball:draw()
   love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
end

return Ball
