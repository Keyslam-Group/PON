local Class  = require("lib.class")
local Vector = require("lib.vector")
local Flux   = require("lib.flux")

local World = require("world")
local hits = require("src.hits")

local Ball = Class("Ball")

function Ball:initialize(t)
   t = t or {}

   self.baseSize = t.size or Vector(20, 20)
   self.baseRot  = t.rot  or 0

   self.pos  = t.pos:clone()
   self.vel  = t.vel or Vector(0, 0)
   self.size = self.baseSize:clone()
   self.rot  = self.baseRot

   self.filter = function(item, other)
      return "bounce"
   end

   World:add(self, self.pos.x - self.size.x/2, self.pos.y - self.size.y/2, self.size.x, self.size.y)
end

function Ball:update(dt)
   self.pos:add(self.vel * dt)

   local newx, newy, cols, len = World:move(self, self.pos.x - self.size.x/2, self.pos.y - self.size.y/2, self.filter)
   self.pos:set(newx + self.size.x/2, newy + self.size.y/2)

   for i = 1, len do
      self:resolveCollision(cols[i])
   end

   --World:update(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
end

function Ball:resolveCollision(col)
   if col.normal.x ~= 0 then
      self.vel.x = -self.vel.x

      col.other.size.y = col.other.baseSize.y + 50

      Flux.to(col.other.size, 0.25, {
         y = col.other.baseSize.y
      }):ease("quadinout")
   end

   if col.normal.y ~= 0 then
      self.vel.y = -self.vel.y

      col.other.size.x = col.other.baseSize.x + 50
      Flux.to(col.other.size, 0.25, {
         x = col.other.baseSize.x
      }):ease("quadinout")
   end

   hits:count()
   col.other.shake:restart()
end

function Ball:draw()
   love.graphics.push()
   love.graphics.translate(self.pos.x, self.pos.y)
   love.graphics.rotate(self.rot)
   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.rectangle("line", -self.size.x/2, -self.size.y/2, self.size.x, self.size.y, 16, 16)
   love.graphics.setColor(255, 255, 255, 30)
   love.graphics.rectangle("fill", -self.size.x/2, -self.size.y/2, self.size.x, self.size.y, 16, 16)
   love.graphics.pop()
end

return Ball
