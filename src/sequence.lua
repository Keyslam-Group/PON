local Flux  = require("lib.flux")
local Timer = require("lib.timer")
local Vector = require("lib.vector")

local State = require("src.state")
local Logo = require("src.logo")

local Sequence = {}

function Sequence.init(paddleUp, paddleLeft, paddleDown, paddleRight, ball, track, hits)
   Sequence.paddles = {}

   Sequence.paddles.up    = paddleUp
   Sequence.paddles.left  = paddleLeft
   Sequence.paddles.down  = paddleDown
   Sequence.paddles.right = paddleRight

   Sequence.ball = ball

   Sequence.track = track

   Sequence.track:play()
   Sequence.track:stop()

   Sequence.three = love.audio.newSource("sounds/3.ogg")
   Sequence.two   = love.audio.newSource("sounds/2.ogg")
   Sequence.one   = love.audio.newSource("sounds/1.ogg")
   Sequence.go    = love.audio.newSource("sounds/go.ogg")

   Sequence.hits = hits
end

function Sequence.start()
   State.state = "transition"

   local t = 1

   Flux.to(Logo, t / 2, {fade = 0}):ease("quadout")

   Flux.to(Sequence.paddles.up.pos,  t, {x = Sequence.paddles.up.start.x, y = Sequence.paddles.up.start.y}):ease("quadout")
   Flux.to(Sequence.paddles.up.size, t, {x = 120, y = 20}):ease("quadout")
   Flux.to(Sequence.paddles.up,  t, {rot = 0}):ease("quadout")
   Sequence.paddles.up.hasFill = true

   Flux.to(Sequence.paddles.left.pos,  t, {x = Sequence.paddles.left.start.x, y = Sequence.paddles.left.start.y}):ease("quadout")
   Flux.to(Sequence.paddles.left.size, t, {x = 20, y = 120}):ease("quadout")
   Flux.to(Sequence.paddles.left,  t, {rot = 0}):ease("quadout")
   Sequence.paddles.left.hasFill = true

   Flux.to(Sequence.paddles.down.pos,  t, {x = Sequence.paddles.down.start.x, y = Sequence.paddles.down.start.y}):ease("quadout")
   Flux.to(Sequence.paddles.down.size, t, {x = 120, y = 20}):ease("quadout")
   Flux.to(Sequence.paddles.down,  t, {rot = 0}):ease("quadout")
   Sequence.paddles.down.hasFill = true

   Flux.to(Sequence.paddles.right.pos,  t, {x = Sequence.paddles.right.start.x, y = Sequence.paddles.right.start.y}):ease("quadout")
   Flux.to(Sequence.paddles.right.size, t, {x = 20, y = 120}):ease("quadout")
   Flux.to(Sequence.paddles.right,  t, {rot = 0}):ease("quadout")
   Sequence.paddles.right.hasFill = true

   Timer.script(function(wait)
      Sequence.hits:restart(4)
      Sequence.hits:count(-1)

      Flux.to(Sequence.ball.size, 0.5, {x = 300, y = 300}):ease("quadout")
      Flux.to(Sequence.ball, 0.5, {rot = math.pi * 3}):ease("quadout")
      Sequence.three:play()

      wait(0.85)

      Sequence.hits:count(-1)
      Flux.to(Sequence.ball.size, 0.5, {x = 400, y = 400}):ease("quadout")
      Flux.to(Sequence.ball, 0.5, {rot = math.pi * 4}):ease("quadout")
      Sequence.two:play()

      wait(0.85)

      Sequence.hits:count(-1)
      Flux.to(Sequence.ball.size, 0.5, {x = 500, y = 500}):ease("quadout")
      Flux.to(Sequence.ball, 0.5, {rot = math.pi * 5}):ease("quadout")
      Sequence.one:play()

      wait(0.85)

      Sequence.hits:count(-1)
      Flux.to(Sequence.ball.size, 0.5, {x = 20, y = 20}):ease("quadout")
      Flux.to(Sequence.ball, 0.5, {rot = 0}):ease("quadout")
      Sequence.go:play()

      wait(0.25)

      Sequence.ball:reset()

      Sequence.ball.vel = Vector.randomDirection(200)
      Sequence.ball.hasFill = true
      Sequence.ball.colliding = true

      Sequence.track:play()
      Sequence.track:fadeIn()

      State.state = "playing"
   end)
end

function Sequence.finish(t)
   State.state = "transition"

   Sequence.track:fadeOut()

   t = t or 1.5

   Flux.to(Logo, t, {fade = 1}):ease("quadin")

   Flux.to(Sequence.paddles.up.pos,  t, {x = 320, y = 320 - 75}):ease("quadout")
   Flux.to(Sequence.paddles.up.size, t, {x = 80, y = 20}):ease("quadout")
   Flux.to(Sequence.paddles.up,  t, {rot = math.pi}):ease("quadout")
   Sequence.paddles.up.hasFill = false

   Flux.to(Sequence.paddles.left.pos, t, {x = 320 - 75, y = 320}):ease("quadout")
   Flux.to(Sequence.paddles.left.size, t, {x = 20, y = 80}):ease("quadout")
   Flux.to(Sequence.paddles.left,  t, {rot = math.pi}):ease("quadout")
   Sequence.paddles.left.hasFill = false

   Flux.to(Sequence.paddles.down.pos, t, {x = 320, y = 320 + 75}):ease("quadout")
   Flux.to(Sequence.paddles.down.size, t, {x = 80, y = 20}):ease("quadout")
   Flux.to(Sequence.paddles.down,  t, {rot = math.pi}):ease("quadout")
   Sequence.paddles.down.hasFill = false

   Flux.to(Sequence.paddles.right.pos, t, {x = 320 + 75, y = 320}):ease("quadout")
   Flux.to(Sequence.paddles.right.size, t, {x = 20, y = 80}):ease("quadout")
   Flux.to(Sequence.paddles.right,  t, {rot = math.pi}):ease("quadout")
   Sequence.paddles.right.hasFill = false

   Sequence.ball.colliding = false
   Flux.to(Sequence.ball.pos, t, {x = 320, y = 320}):ease("quadout")
   Flux.to(Sequence.ball.size, t, {x = 200, y = 200}):ease("quadout")
   Flux.to(Sequence.ball, t, {rot = math.pi * 2}):ease("quadout")
   Sequence.ball.vel:set(0, 0)

   Timer.after(t, function()
      State.state = "paused"
   end)
end

return Sequence
