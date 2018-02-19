--Based on S0lll0s code https://love2d.org/forums/viewtopic.php?f=4&t=79207#p176746
local Class  = require("lib.class")
local Vector = require("lib.vector")
local Flux   = require("lib.flux")

local Shake = Class("Shake")

function Shake:initialize (direction, duration)
  self.direction = direction
  self.duration  = duration
  self.intensity = 0
end

function Shake:restart ()
  self.tween = Flux.to(self, self.duration/2, {intensity = 1})
    :ease('elasticin')
    :after(self, self.duration/2, {intensity = 0})
    :ease('elasticin')
end

function Shake:get ()
	if self.intensity == 0 then return Vector.zero end
	return self.direction * math.sin(self.intensity * math.pi)
end

return Shake
