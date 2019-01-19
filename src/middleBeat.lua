local Vector = require("lib.vector")
local Flux   = require("lib.flux")
local Screen = require("src.screen")

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
   local sc = Screen.scale
   local x, y = self.pos.x * sc, self.pos.y * sc

   love.graphics.setColor(1, 1, 1, 0.549)
   love.graphics.setLineWidth(10 * sc)

   love.graphics.circle("fill", x, y, self.size.x / 2 * sc)

   love.graphics.setColor(love.graphics.getBackgroundColor())
   love.graphics.circle("line", x, y, self.size.x / 2 * sc)
   love.graphics.circle("line", x, y, self.size.x / 3 * sc)
end

MiddleBeat:init()

return MiddleBeat
