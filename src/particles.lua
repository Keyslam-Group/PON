local Screen = require("src.screen")

local Particles = {
   list = {},
}

local image = love.graphics.newImage("assets/particle.png")

function Particles:add(x, y, angle)
   for i = 1, 25 do
      local angle = angle - love.math.random(-math.pi/2 * 10, math.pi/2 * 10) / 10

      local particle = {
         x = x, 
         y = y, 
         dx = math.cos(angle) * love.math.random(100, 200),
         dy = math.sin(angle) * love.math.random(100, 200),
      }

      particle.lifeTime = love.math.random(1, 5) / 10
      particle.timeLeft = particle.lifeTime

      table.insert(self.list, particle)
   end
end

function Particles:update(dt)
   for i = #self.list, 1, -1 do
      local particle = self.list[i]

      particle.x = particle.x + particle.dx * dt
      particle.y = particle.y + particle.dy * dt

      particle.timeLeft = particle.timeLeft - dt
      if particle.timeLeft <= 0 then
         table.remove(self.list, i)
      end
   end
end

function Particles:draw()
   local sc = Screen.scale

   

   for i = 1, #self.list do
      local particle = self.list[i]
      love.graphics.setColor(255, 255, 255, particle.timeLeft / particle.lifeTime * 255)

      love.graphics.push()
      love.graphics.translate(particle.x, particle.y)
      love.graphics.rotate(particle.timeLeft * 4)
      love.graphics.rectangle("line", -4, -4, 8, 8)
      love.graphics.pop()
   end
end

return Particles
