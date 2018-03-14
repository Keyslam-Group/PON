local Screen = require("src.screen")

local Logo = {
  p = love.graphics.newImage("assets/p.png"),
  n = love.graphics.newImage("assets/n.png"),
  fade = 1
}

function Logo.draw()
   local sc = Screen.scale

   love.graphics.setColor(255, 255, 255, Logo.fade * 255)

   love.graphics.draw(Logo.p,  65 * sc, 190 * sc, 0, sc)
   love.graphics.draw(Logo.n, 400 * sc, 190 * sc, 0, sc)
end

return Logo
