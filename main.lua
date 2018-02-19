local Flux   = require("lib.flux")
local Vector = require("lib.vector")
local Baton  = require("lib.baton")
local List   = require("lib.list")

local Paddle = require("src.paddle")
local Ball   = require("src.ball")

local Paddles = List()
Paddles:add(Paddle({
   start  = Vector(0, 0),
   finish = Vector(640 - 100, 0),
}))

local ball = Ball({
   pos = Vector(0, 200),
   vel = Vector(0, -50),
})

local Player = Baton.new({
   controls = {
      activate = {'key:space', 'button:a', 'mouse:1'},
   }
})

love.graphics.setLineWidth(4)

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
