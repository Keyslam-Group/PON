local Flux   = require("lib.flux")
local Vector = require("lib.vector")
local Baton  = require("lib.baton")
local List   = require("lib.list")
local Shine  = require("lib.moonshine")
local Wave   = require("lib.wave")

local Paddle     = require("src.paddle")
local Ball       = require("src.ball")
local MiddleBeat = require("src.middlebeat")
local hits       = require("src.hits")

local cornerMargin = 40
local borderMargin =  8
local length = 120
local width  = 20

local totCornerMargin = cornerMargin + length/2
local totBorderMargin = borderMargin +  width/2

local Paddles = List()
Paddles:add(Paddle({
   start  = Vector(      totCornerMargin, totBorderMargin),
   finish = Vector(640 - totCornerMargin, totBorderMargin),
   size   = Vector(length, width),
}))
Paddles:add(Paddle({
   start  = Vector(totBorderMargin,       totCornerMargin),
   finish = Vector(totBorderMargin, 640 - totCornerMargin),
   size   = Vector(width, length),
}))
Paddles:add(Paddle({
   start  = Vector(640 - totCornerMargin, 640 - totBorderMargin),
   finish = Vector(      totCornerMargin, 640 - totBorderMargin),
   size   = Vector(length, width),
}))
Paddles:add(Paddle({
   start  = Vector(640 - totBorderMargin, 640 - totCornerMargin),
   finish = Vector(640 - totBorderMargin,       totCornerMargin),
   size   = Vector(width, length),
}))

local ball = Ball({
   pos = Vector(360, 360),
   vel = Vector(50, -350),
})

local middleBeat = MiddleBeat({

})

local Player = Baton.new({
   controls = {
      activate = {'key:space', 'button:a', 'mouse:1'},
   }
})

local Effect = Shine(Shine.effects.filmgrain)
   .chain(Shine.effects.glow)
   .chain(Shine.effects.chromasep)
Effect.filmgrain.opacity = 0.1

local Gradient = love.graphics.newImage("assets/gradient.png")

love.graphics.setBackgroundColor(183, 28, 28)

local Track = Wave:newSource("track.wav", "static")
Track:setIntensity(20)
Track:setBPM(70)
Track:play()
Track:setVolume(0)

Track:onBeat(function()
   middleBeat:onBeat()
end)

local Shake = Vector(0, 0)

local Sequence = require("src.sequence")
Sequence.init(Paddles:get(1), Paddles:get(2), Paddles:get(3), Paddles:get(4), Ball)
--Sequence.finish()

function love.update(dt)
   Player:update()

   Shake:set(0, 0)

   for i = 1, Paddles.size do
      local paddle = Paddles:get(i)
      paddle:update(dt)

      if Player:pressed("activate") then
         paddle:activate()
      elseif Player:released("activate") then
         paddle:deactivate()
      end

      Shake:add(paddle.shake:get())
   end

   Shake:normalizeInplace()
   Shake:mul(4)

   Effect.chromasep.angle  = math.atan2(Shake.y, Shake.x)
   Effect.chromasep.radius = Shake:len() + 2

   ball:update(dt)

   Flux.update(dt)

   Track:update(dt)
end

local draw = function ()
   love.graphics.draw(Gradient)
   love.graphics.push()
   love.graphics.translate(Shake.x, Shake.y)

   middleBeat:draw()
   hits:draw()

   love.graphics.setLineWidth(4)

   for i = 1, Paddles.size do
      Paddles:get(i):draw()
   end

   ball:draw()
   love.graphics.pop()
end

function love.draw()
   love.graphics.setColor(255, 255, 255)
   Effect(draw)
end
