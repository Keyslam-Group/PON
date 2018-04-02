local Flux   = require("lib.flux")
local Vector = require("lib.vector")
local Input  = require("lib.input")()
local Shine  = require("lib.moonshine")
local Wave   = require("lib.wave")
local Timer  = require("lib.timer")

local Paddle     = require("src.paddle")
local Ball       = require("src.ball")
local MiddleBeat = require("src.middlebeat")
local Hits       = require("src.hits")
local Particles  = require("src.particles")
local State      = require("src.state")
local Sequence   = require("src.sequence")
local Logo       = require("src.logo")
local Screen     = require("src.screen")

local os = love.system.getOS()
local cornerMargin = 40
local borderMargin =  8
local length = 120
local width  = 20

local totCornerMargin = cornerMargin + length/2
local totBorderMargin = borderMargin +  width/2

local Paddles = {
   Paddle {
      name   = "Top",
      start  = Vector(      totCornerMargin, totBorderMargin),
      finish = Vector(640 - totCornerMargin, totBorderMargin),
      size   = Vector(length, width),
   },
   Paddle {
      name   = "Left",
      start  = Vector(totBorderMargin,       totCornerMargin),
      finish = Vector(totBorderMargin, 640 - totCornerMargin),
      size   = Vector(width, length),
   },
   Paddle {
      name   = "Bottom",
      start  = Vector(640 - totCornerMargin, 640 - totBorderMargin),
      finish = Vector(      totCornerMargin, 640 - totBorderMargin),
      size   = Vector(length, width),
   },
   Paddle {
      name   = "Right",
      start  = Vector(640 - totBorderMargin, 640 - totCornerMargin),
      finish = Vector(640 - totBorderMargin,       totCornerMargin),
      size   = Vector(width, length),
   }
}

local ball = Ball {
   pos = Vector(360, 360),
   vel = Vector(50, -350),
}

Input:registerCallbacks()

local Player = Input:newController {
  activate = {"key:space", "sc:space", "button:a", "mouse:1"},
  quit = {"key:escape", "sc:escape"},
}

Player:setJoystick("all")

Player:setPressedCallback(function (control)
  if control == "quit" then love.event.quit() end
end)

local Track = Wave:newSource("sounds/track2.wav", "static")
Track:setIntensity(20)
Track:setBPM(60)
Track:setLooping(true)
Track:onBeat(function()
   MiddleBeat:onBeat()
end)

local Effect

local Shake = Vector(0, 0)

Sequence.init(Paddles[1], Paddles[2], Paddles[3], Paddles[4], ball, Track, Hits)
Sequence.finish(0)

local Gradient = love.graphics.newImage("assets/gradient.png")
local Die = love.audio.newSource("sounds/die.wav")

love.graphics.setBackgroundColor(183, 28, 28)

function love.update(dt)
   Shake:set(0, 0)

   if State.state == "playing" then
      for _, paddle in ipairs(Paddles) do
         paddle:update(dt)

         if Player:pressed("activate") then
            paddle:activate()
         elseif Player:released("activate") then
            paddle:deactivate()
         end

         Shake:add(paddle.shake:get())
      end
   elseif State.state == "paused" then
      if Player:pressed("activate") then
         Sequence.start()
      end
   end

   Shake:normalizeInplace()
   Shake:mul(4)

   Effect.chromasep.angle  = math.atan2(Shake.y, Shake.x)
   Effect.chromasep.radius = Shake:len() * 2 + 4 * Screen.scale

   local inside = ball:update(dt)
   if not inside and State.state == "playing" then
      Die:play()
      Sequence.finish(1)
   end

   Particles:update(dt)
   Track    :update(dt)

   Flux .update(dt)
   Timer.update(dt)

   Player:endFrame()
end

local draw = function ()
   love.graphics.draw(Gradient, 0, 0, 0, Screen.scale)
   love.graphics.push()
   love.graphics.translate(Shake.x * Screen.scale, Shake.y * Screen.scale)

   MiddleBeat:draw()
   Hits:draw()

   for _, paddle in ipairs(Paddles) do
      paddle:draw()
   end

   ball:draw()

   Logo.draw()

   Particles:draw()
   love.graphics.pop()
end

function love.draw()
   Screen:push()
   Effect(draw)

   if os == "Android" or os == "iOS" then
      love.graphics.setColor(255, 255, 255, 255)

      for _, paddle in ipairs(Paddles) do
         paddle:draw(true)
      end

      ball:draw(true)

      Logo.draw()

      Particles:draw()
   end
   Screen:pop()
end

function love.resize(w, h)
  Screen:resize(w, h)

  if Screen.changed then
    Hits:resize(Screen.scale)

    if os == "Android" or os == "iOS" then
      Effect = Shine(Shine.effects.chromagrain)
      Effect.chromasep.opacity = 0.25
    else
      Effect  = Shine(Shine.effects.filmgrain)
      .chain(Shine.effects.glow)
      .chain(Shine.effects.chromasep)

      Effect.filmgrain.opacity = 0.1
    end

    Screen.changed = false
  end
end

love.resize(love.graphics.getDimensions())
