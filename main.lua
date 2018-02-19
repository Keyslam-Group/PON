local Flux   = require("lib.flux")
local Vector = require("lib.vector")
local Baton  = require("lib.baton")
local List   = require("lib.list")

local Paddle = require("src.paddle")
local Ball   = require("src.ball")

local Paddles = List()
Paddles:add(Paddle({
   start  = Vector(       20, 0),
   finish = Vector(640 - 120, 0),
   size   = Vector(100, 20),
}))
Paddles:add(Paddle({
   start  = Vector(0,        20),
   finish = Vector(0, 640 - 120),
   size   = Vector(20, 100),
}))
Paddles:add(Paddle({
   start  = Vector(640 - 120, 640 - 20),
   finish = Vector(       20, 640 - 20),
   size   = Vector(100, 20),
}))
Paddles:add(Paddle({
   start  = Vector(640 - 20, 640 - 120),
   finish = Vector(640 - 20, 20),
   size   = Vector(20, 100),
}))

local ball = Ball({
   pos = Vector(200, 400),
   vel = Vector(150, -300),
})

local Player = Baton.new({
   controls = {
      activate = {'key:space', 'button:a', 'mouse:1'},
   }
})

function love.update(dt)
   Player:update()

   for i = 1, Paddles.size do
      Paddles:get(i):update(dt)

      if Player:pressed("activate") then
         Paddles:get(i):activate()
      elseif Player:released("activate") then
         Paddles:get(i):deactivate()
      end
   end

   ball:update(dt)

   Flux.update(dt)
end

function love.draw()
   for i = 1, Paddles.size do
      Paddles:get(i):draw()
   end

   ball:draw()
end
