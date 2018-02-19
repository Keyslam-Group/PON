local Flux   = require("lib.flux")
local Vector = require("lib.vector")
local Baton  = require("lib.baton")

local Paddle = require("src.paddle")

local Paddles = {}
Paddles[1] = Paddle({
   start  = Vector(0, 0),
   finish = Vector(640 - 100, 0),
})

local Player = Baton.new({
   controls = {
      activate = {'key:space', 'button:a', 'mouse:1'},
   }
})

function love.update(dt)
   Player:update()

   if Player:pressed("activate") then
      for _, paddle in ipairs(Paddles) do
         paddle:activate()
      end
   elseif Player:released("activate") then
      for _, paddle in ipairs(Paddles) do
         paddle:deactivate()
      end
   end

   Flux.update(dt)
end

function love.draw()
   for _, paddle in ipairs(Paddles) do
      paddle:draw()
   end
end
