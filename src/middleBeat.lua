local Vector = require("lib.vector")
local Flux   = require("lib.flux")

local MiddleBeat = {}

function MiddleBeat:init(t)
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
   love.graphics.setColor(255, 255, 255, 140)
   love.graphics.circle("fill", self.pos.x, self.pos.y, self.size.x / 2)

   love.graphics.setColor(love.graphics.getBackgroundColor())
   love.graphics.setLineWidth(10)
   love.graphics.circle("line", self.pos.x, self.pos.y, self.size.x / 2)
   love.graphics.circle("line", self.pos.x, self.pos.y, self.size.x / 3)
end

MiddleBeat:init()

return MiddleBeat
