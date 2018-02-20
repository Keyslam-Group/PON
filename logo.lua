local Logo = {}
Logo.p = love.graphics.newImage("assets/p.png")
Logo.n = love.graphics.newImage("assets/n.png")

Logo.fade = 1

function Logo.draw()
   love.graphics.setColor(255, 255, 255, Logo.fade * 255)
   love.graphics.draw(Logo.p, 65, 190)
   love.graphics.draw(Logo.n, 400, 190)
end

return Logo
