local Class  = require("lib.class")
local Vector = require("lib.vector")
local Flux   = require("lib.flux")
local Wave   = require("lib.wave")

local World = require("world")
local hits = require("src.hits")
local Particles = require("src.particles")

local Ball = Class("Ball")

local function isBall (item)
  return item:isInstanceOf(Ball)
end

function Ball:initialize(t)
   t = t or {}

   self.baseSize = t.size or Vector(20, 20)
   self.baseRot  = t.rot  or 0

   self.pos  = t.pos:clone()
   self.vel  = t.vel or Vector(0, 0)
   self.size = self.baseSize:clone()
   self.rot  = self.baseRot

   self.filter = function()
      return "bounce"
   end
   self.colliding = false

   self.hit = Wave:newSource("hit.wav", "static")

   World:add(self, self.pos.x - self.size.x/2, self.pos.y - self.size.y/2, self.size.x, self.size.y)
end

function Ball:update(dt)
   self.pos:add(self.vel * dt)

   if self.colliding then
      local newx, newy, cols, len = World:move(
        self,
        self.pos.x - self.size.x/2, self.pos.y - self.size.y/2,
        self.filter
      )
      self.pos:set(newx + self.size.x/2, newy + self.size.y/2)

      for i = 1, len do
         self:resolveCollision(cols[i])
      end
   end
   --World:update(self, self.pos.x, self.pos.y, self.size.x, self.size.y)

   return #World:queryRect(0, 0, 640, 640, isBall) ~= 0
end

function Ball:resolveCollision(col)
   if col.normal.x ~= 0 then
      self.vel.x = -self.vel.x

      col.other.size.y = col.other.baseSize.y + 50

      Flux.to(col.other.size, 0.25, {
         y = col.other.baseSize.y
      }):ease("quadinout")

      self.vel.y = self.vel.y * (1 + love.math.random(-6, 6)/10)
   end

   if col.normal.y ~= 0 then
      self.vel.y = -self.vel.y

      col.other.size.x = col.other.baseSize.x + 50
      Flux.to(col.other.size, 0.25, {
         x = col.other.baseSize.x
      }):ease("quadinout")

      self.vel.x = self.vel.x * (1 + love.math.random(-6, 6)/10)
   end

   self.vel:mul(1.05)


   Particles:add(col.touch.x, col.touch.y, math.atan2(col.normal.y, col.normal.x))
   hits:count()
   self.hit:play(true)

   col.other.shake:restart()
end

function Ball:draw()
   love.graphics.push()
   love.graphics.translate(self.pos.x, self.pos.y)
   love.graphics.rotate(self.rot)
   if self.hasFill then
    love.graphics.setColor(100, 20, 20)
    love.graphics.rectangle("line", -self.size.x/2 +3, -self.size.y/2 +3, self.size.x, self.size.y, 16, 16)
   end
   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.rectangle("line", -self.size.x/2, -self.size.y/2, self.size.x, self.size.y, 16, 16)
   love.graphics.setColor(255, 255, 255, 30)
   love.graphics.rectangle("fill", -self.size.x/2, -self.size.y/2, self.size.x, self.size.y, 16, 16)
   love.graphics.pop()
end

return Ball
