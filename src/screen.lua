local Screen = {}

local os = love.system.getOS()

function Screen:resize (w, h)
  local size = math.min(w, h)
  if size ~= self.size then
    self.changed = true

    self.size = size
    self.scale = self.size/640

    self.canvas = love.graphics.newCanvas(self.size, self.size)
  end

  self.w = w
  self.h = h

  self.tx = (self.w - self.size)/2
  self.ty = (self.h - self.size)/2

  --Portrait in a phone
  if h > w and os == "Android" or os == "iOS" then
    self.ty = 0
  end
end

function Screen:getDimensions ()
  return self.size, self.size
end

function Screen:getVisible ()
  return self.tx, self.ty, self.size, self.size
end

function Screen:push ()
  love.graphics.clear(0, 0, 0)
  love.graphics.setColor(255, 255, 255)
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear(love.graphics.getBackgroundColor())
end

function Screen:pop ()
  love.graphics.setCanvas()
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.draw(self.canvas, self.tx, self.ty)
  love.graphics.setBlendMode("alpha", "alphamultiply")
end

return Screen