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

   self.filter = function(item, other)
      return "bounce"
   end

   World:add(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
end

function Ball:update(dt)
   self.pos:add(self.vel * dt)

   local newx, newy, cols, len = World:move(self, self.pos.x, self.pos.y, self.filter)
   self.pos:set(newx, newy)

   for i = 1, len do
      self:resolveCollision(cols[i])
   end

   World:update(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
end

function Ball:resolveCollision(col)
   if col.normal.x ~= 0 then
      self.vel.x = -self.vel.x
   end

   if col.normal.y ~= 0 then
      self.vel.y = -self.vel.y
   end
end

function Ball:draw()
   love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
end

return Ball
