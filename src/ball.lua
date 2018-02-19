local Class  = require("lib.class")
local Vector = require("lib.vector")

local World = require("world")

local Ball = Class("Ball")

function Ball:initialize(t)
   t = t or {}

   self.baseSize = t.size or Vector(20, 20)

   self.pos  = t.pos:clone()
   self.vel  = t.vel or Vector(0, 0)
   self.size = self.baseSize:clone()

   World:add(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
end

function Ball:update(dt)
   self.pos:add(self.vel * dt)

   local newx, newy, cols, len = World:move(self, self.pos.x, self.pos.y)
   self.pos:set(newx, newy)

   for i = 1, len do
      self:resolveCollision(cols[i])
   end

   World:update(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
end

function Ball:resolveCollision(col)

end

function Ball:draw()
   love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
end

return Ball
