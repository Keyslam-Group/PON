local Class  = require("lib.class")
local Vector = require("lib.vector")
local Flux   = require("lib.flux")

local World = require("world")

local Paddle = Class("Paddle")

function Paddle:initialize(t)
   t = t or {}

   self.start    = t.start  or Vector(0, 0)
   self.finish   = t.finish or Vector(0, 0)
   self.baseSize = t.size or Vector(100, 20)

   self.pos  = self.start:clone()
   self.size = self.baseSize:clone()

   self.tween = nil

   World:add(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
end

function Paddle:update(dt)
   local newx, newy = World:move(self, self.pos.x, self.pos.y)
   self.pos:set(newx, newy)

   World:update(self, self.pos.x, self.pos.y, self.size.x, self.size.y)
end

function Paddle:draw()
   love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
end

function Paddle:getProgress()
   local xp = (self.pos.x + self.start.x/2) / (self.finish.x + self.start.x/2)
   local yp = (self.pos.y + self.start.y/2) / (self.finish.y + self.start.y/2)

   return xp ~= xp and yp or xp -- NaN hack
end

function Paddle:activate()
   if self.tween then
      self.tween:stop()
   end

   self.tween = Flux.to(self.pos, 1 - self:getProgress(), {x = self.finish.x, y = self.finish.y}):ease("quadinout")
end

function Paddle:deactivate()
   if self.tween then
      self.tween:stop()
   end

   self.tween = Flux.to(self.pos, self:getProgress(), {x = self.start.x, y = self.start.y}):ease("quadinout")
end

return Paddle
