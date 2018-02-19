local Flux = require("lib.flux")

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

end

function Sequence.finish()
   local t = 1

   Flux.to(Sequence.paddles.up.pos,  t, {x = 320, y = 320 - 75})
   Flux.to(Sequence.paddles.up.size, t, {x = 80, y = 20})
   Flux.to(Sequence.paddles.up,  t, {rot = math.pi})
   Sequence.paddles.up.hasFill = false

   Flux.to(Sequence.paddles.left.pos, t, {x = 320 - 75, y = 320})
   Flux.to(Sequence.paddles.left.size, t, {x = 20, y = 80})
   Sequence.paddles.left.hasFill = false

   Flux.to(Sequence.paddles.down.pos, t, {x = 320, y = 320 + 75})
   Flux.to(Sequence.paddles.down.size, t, {x = 80, y = 20})
   Sequence.paddles.down.hasFill = false

   Flux.to(Sequence.paddles.right.pos, t, {x = 320 + 75, y = 320})
   Flux.to(Sequence.paddles.right.size, t, {x = 20, y = 80})
   Sequence.paddles.right.hasFill = false
end

return Sequence
