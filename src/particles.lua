local Screen = require("src.screen")

local Particles = {
   list = {},
   dead = {}
}

local image = love.graphics.newImage("assets/particle.png")
local ps = love.graphics.newParticleSystem(image, 600)

ps:setEmissionRate(50)
ps:setEmitterLifetime(0.4)
ps:setParticleLifetime(0.2, 2.3)
ps:setSizes(0.5, 3)
ps:setSizeVariation(0.07)
ps:setInsertMode('top')
ps:setColors({ 255, 255, 255, 255 }, { 255, 255, 255, 0 })
ps:setAreaSpread('uniform', 30, 30)
ps:setDirection(0)
ps:setSpeed(10, 10)
ps:setLinearAcceleration(250, -75, 300, 75)
ps:setRadialAcceleration(15, 15)
ps:setTangentialAcceleration(5, 5)
ps:setLinearDamping(0, 10)
ps:setRelativeRotation(false)

function Particles:add(x, y, angle)
   local particles = #self.dead > 0 and table.remove(self.dead) or ps:clone()

   particles:stop()
   particles:start()

   table.insert(self.list, {x = x, y = y, angle = angle, ps = particles})
end

function Particles:update(dt)
   for i = #self.list, 1, -1 do
      local particles = self.list[i].ps
      particles:update(dt)

      if not particles:isActive() then
         table.insert(self.dead, particles)
         table.remove(self.list, i)
      end
   end
end

function Particles:draw()
   local sc = Screen.scale

   love.graphics.setColor(255, 255, 255, 200)

   for i = 1, #self.list do
      local particle = self.list[i]
      love.graphics.draw(particle.ps, particle.x * sc, particle.y * sc, particle.angle, sc)
   end
end

return Particles
