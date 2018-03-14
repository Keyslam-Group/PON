--[[
Public domain:

Copyright (C) 2017 by Matthias Richter <vrld@vrld.org>

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
]]--

return function(moonshine)
  local noisetex = love.image.newImageData(256,256)
  noisetex:mapPixel(function()
    local l = love.math.random() * 255
    return l,l,l,l
  end)
  noisetex = love.graphics.newImage(noisetex)

  local shader = love.graphics.newShader[[
    extern float opacity;
    extern float size;
    extern vec2 noise;
    extern Image noisetex;
    extern vec2 tex_ratio;
    extern vec2 direction;

    float rand(vec2 co) {
      return Texel(noisetex, mod(co * tex_ratio / vec2(size), vec2(1.0))).r;
    }

    vec4 effect(vec4 color, Image texture, vec2 tc, vec2 _) {
      float colr = Texel(texture, tc - direction).r;
      float colg = Texel(texture, tc).g;
      float colb = Texel(texture, tc + direction).b;
      return color * vec4(colr, colg, colb, 1.0) * mix(1.0, rand(tc+vec2(noise)), opacity);
    }]]

  shader:send("noisetex", noisetex)
  shader:send("tex_ratio", {love.graphics.getWidth() / noisetex:getWidth(),
                            love.graphics.getHeight() / noisetex:getHeight()})

  local setters = {}
  for _,k in ipairs{"opacity", "size"} do
    setters[k] = function(v) shader:send(k, math.max(0, tonumber(v) or 0)) end
  end

  local angle, radius, vec = 0, 0, {}
  setters.angle  = function(v) angle  = tonumber(v) or 0 end
  setters.radius = function(v) radius = tonumber(v) or 0 end

  local defaults = {opacity = .3, size = 1}

  local draw = function(buffer)
    vec[1] = math.cos(angle) * radius / love.graphics.getWidth()
    vec[2] = math.sin(angle) * radius / love.graphics.getHeight()
    shader:send("direction", vec)

    vec[1] = love.math.random()
    vec[2] = love.math.random()
    shader:send("noise", vec)
    moonshine.draw_shader(buffer, shader)
  end

  return moonshine.Effect{
    name = "chromasep",
    draw = draw,
    setters = setters,
    defaults = defaults
  }
end
