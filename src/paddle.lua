local Class  = require("lib.class")
local Vector = require("lib.vector")
local Flux   = require("lib.flux")

local Paddle = Class("Paddle")

function Paddle:initialize(t)
   t = t or {}

   self.start    = t.start  or Vector(0, 0)
   self.finish   = t.finish or Vector(0, 0)
   self.baseSize = t.size or Vector(100, 20)

   self.pos  = self.start:clone()
   self.size = self.baseSize:clone()

   self.tween = nil
end

function Paddle:draw()
   love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
end

function Paddle:activate()
   if self.tween then
      self.tween:stop()
   end

   self.tween = Flux.to(self.pos, 2, {x = self.finish.x, y = self.finish.y})
end

function Paddle:deactivate()
   if self.tween then
      self.tween:stop()
   end

   self.tween = Flux.to(self.pos, 2, {x = self.start.x, y = self.start.y})
end

return Paddle
