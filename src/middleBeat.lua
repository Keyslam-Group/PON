local Class  = require("lib.class")
local Vector = require("lib.vector")
local Flux   = require("lib.flux")

local MiddleBeat = Class("MiddleBeat")

function MiddleBeat:initialize(t)
   t = t or {}

   self.baseSize = t.size or Vector(360, 360)

   self.pos  = t.pos or Vector(320, 320)
   self.size = self.baseSize:clone()

   self.increase     = 200
   self.increaseTime = 0.075

   self.fadeTime = 0.25

   self.tween = nil
end

function MiddleBeat:onBeat()
   if self.tween then
      self.tween:stop()
   end

   Flux.to(self.size, self.increaseTime, {
      x = self.baseSize.x + self.increase,
      y = self.baseSize.y + self.increase,
   }):after(self.size, self.fadeTime, {
      x = self.baseSize.x,
      y = self.baseSize.y,
   })
end

function MiddleBeat:draw()
   love.graphics.setColor(255, 255, 255)
   love.graphics.rectangle("line", self.pos.x - self.size.x/2, self.pos.y - self.size.y/2, self.size.x, self.size.y, self.size.x/3, self.size.y/3)

   love.graphics.setColor(255, 255, 255)
   love.graphics.rectangle("line", self.pos.x - self.size.x/3, self.pos.y - self.size.y/3, self.size.x / 1.5, self.size.y / 1.5, self.size.x/4, self.size.y/4)
end

return MiddleBeat
