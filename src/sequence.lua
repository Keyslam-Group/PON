local Flux  = require("lib.flux")
local Timer = require("lib.timer")

local Sequence = {}

function Sequence.init(paddleUp, paddleLeft, paddleDown, paddleRight, ball)
   Sequence.paddles = {}

   Sequence.paddles.up    = paddleUp
   Sequence.paddles.left  = paddleLeft
   Sequence.paddles.down  = paddleDown
   Sequence.paddles.right = paddleRight

   Sequence.ball = ball
end

function Sequence.start()
   local t = 1

   Flux.to(Sequence.paddles.up.pos,  t, {x = Sequence.paddles.up.start.x, y = Sequence.paddles.up.start.y}):ease("quadout")
   Flux.to(Sequence.paddles.up.size, t, {x = 120, y = 20}):ease("quadout")
   Flux.to(Sequence.paddles.up,  t, {rot = 0}):ease("quadout")
   Sequence.paddles.up.hasFill = true

   Flux.to(Sequence.paddles.left.pos,  t, {x = Sequence.paddles.left.start.x, y = Sequence.paddles.left.start.y}):ease("quadout")
   Flux.to(Sequence.paddles.left.size, t, {x = 20, y = 120}):ease("quadout")
   Flux.to(Sequence.paddles.left,  t, {rot = 0}):ease("quadout")
   Sequence.paddles.up.hasFill = true

   Flux.to(Sequence.paddles.down.pos,  t, {x = Sequence.paddles.down.start.x, y = Sequence.paddles.down.start.y}):ease("quadout")
   Flux.to(Sequence.paddles.down.size, t, {x = 120, y = 20}):ease("quadout")
   Flux.to(Sequence.paddles.down,  t, {rot = 0}):ease("quadout")
   Sequence.paddles.up.hasFill = true

   Flux.to(Sequence.paddles.right.pos,  t, {x = Sequence.paddles.right.start.x, y = Sequence.paddles.right.start.y}):ease("quadout")
   Flux.to(Sequence.paddles.right.size, t, {x = 20, y = 120}):ease("quadout")
   Flux.to(Sequence.paddles.right,  t, {rot = 0}):ease("quadout")
   Sequence.paddles.up.hasFill = true

   Timer.script(function(wait)
      Flux.to(Sequence.ball.size, 0.5, {x = 300, y = 300}):ease("quadout")
      Flux.to(Sequence.ball, 0.5, {rot = math.pi * 3}):ease("quadout")

      wait(0.75)

      Flux.to(Sequence.ball.size, 0.5, {x = 400, y = 400}):ease("quadout")
      Flux.to(Sequence.ball, 0.5, {rot = math.pi * 4}):ease("quadout")

      wait(0.75)

      Flux.to(Sequence.ball.size, 0.5, {x = 500, y = 500}):ease("quadout")
      Flux.to(Sequence.ball, 0.5, {rot = math.pi * 5}):ease("quadout")

      wait(0.75)

      Flux.to(Sequence.ball.size, 0.5, {x = 20, y = 20}):ease("quadout")
      Flux.to(Sequence.ball, 0.5, {rot = 0}):ease("quadout")

      wait(0.25)
      Sequence.ball.vel:set(100, 400)
      Sequence.ball.hasFill = true
      Sequence.ball.colliding = true
   end)

end

function Sequence.finish(t)
   t = t or 1.5

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
end

return Sequence
