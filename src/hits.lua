local Flux  = require("lib.flux")

local Hits = {}
local size = 140
local font = love.graphics.newFont("assets/numbers.ttf", size)

function Hits:restart (c)
   if self.tween then self.tween:stop() end

   self.n = c or 0
   self.scale = .5
   self.tween = nil
end

function Hits:count (c)
   if self.tween then self.tween:stop() end

   self.n = self.n + (c or 1)
   self.scale = 1.5
   self.tween = Flux.to(self, .4, {scale = .5}):ease('quadout')
end

function Hits:draw ()
   local w, h = love.graphics.getDimensions()
   w, h = w / self.scale, h / self.scale

   love.graphics.push("all")
      love.graphics.scale(self.scale)
      love.graphics.setColor(love.graphics.getBackgroundColor())
      love.graphics.setFont(font)
      love.graphics.printf(tostring(self.n), 0, (h - size -10)/2, w, "center")
   love.graphics.pop()
end

Hits:restart()

return Hits
