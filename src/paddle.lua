local Class  = require("lib.class")
local Vector = require("lib.vector")
local Flux   = require("lib.flux")

local World  = require("src.world")
local Shake  = require("src.shake")
local Screen = require("src.screen")

local Paddle = Class("Paddle")

function Paddle:initialize(t)
   t = t or {}

   self.name     = t.name
   self.start    = t.start  or Vector(0, 0)
   self.finish   = t.finish or Vector(0, 0)
   self.baseSize = t.size   or Vector(100, 20)
   self.baseRot  = t.rot    or 0

   local direction = self.finish - self.start
   self.shake = Shake(direction:normalizeInplace(), .1)

   self.pos  = self.start:clone()
   self.size = self.baseSize:clone()
   self.rot  = self.baseRot

   self.hasFill = true
   self.tween   = nil

   World:add(self, self.pos.x - self.size.x/2, self.pos.y - self.size.y/2, self.size.x, self.size.y)
end

function Paddle:update(dt)
   local newx, newy = World:move(self, self.pos.x - self.size.x/2, self.pos.y - self.size.y/2)
   self.pos:set(newx + self.size.x/2, newy + self.size.y/2)

   World:update(self, self.pos.x - self.size.x/2, self.pos.y - self.size.y/2, self.size.x, self.size.y)
end

function Paddle:draw(glow)
   local sc = Screen.scale

   love.graphics.push()
   love.graphics.translate(self.pos.x * sc, self.pos.y * sc)
   love.graphics.rotate(self.rot)

   local x, y = -self.size.x/2 * sc, -self.size.y/2 * sc
   local w, h = self.size.x * sc, self.size.y * sc
   local r = 8 * sc

   love.graphics.setLineWidth(4 * sc)

   if self.hasFill and not glow then
      local off = 3 * sc
      love.graphics.setColor(100, 20, 20)
      love.graphics.rectangle("line", x + off, y + off, w, h, r, r)

      love.graphics.setColor(255, 255, 255, 30)
      love.graphics.rectangle("fill", x, y, w, h, r, r)
   end

   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.rectangle("line", x, y, w, h, r, r)

   love.graphics.pop()
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

   self.tween = Flux.to(self.pos, 1, {x = self.finish.x, y = self.finish.y}):ease("quadout")
end

function Paddle:deactivate()
   if self.tween then
      self.tween:stop()
   end

   self.tween = Flux.to(self.pos, 1, {x = self.start.x, y = self.start.y}):ease("quadout")
end

return Paddle
