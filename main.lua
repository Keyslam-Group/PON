local Flux   = require("lib.flux")
local Vector = require("lib.vector")

local Paddle = require("src.paddle")

local Paddles = {}
Paddles[1] = Paddle({
   start  = Vector(0, 0),
   finish = Vector(200, 0),
})

function love.load()
end

function love.update(dt)

   Flux.update(dt)
end

function love.draw()
   for _, paddle in ipairs(Paddles) do
      paddle:draw()
   end
end

function love.keypressed()
   for _, paddle in ipairs(Paddles) do
      paddle:activate()
   end
end

function love.keyreleased()
   for _, paddle in ipairs(Paddles) do
      paddle:deactivate()
   end
end
