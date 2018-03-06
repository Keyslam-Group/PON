local function new (self, ...)
   local obj = setmetatable({}, self)
   if self.initialize then self.initialize(obj, ...) end
   return obj
end

local mt = { __call = function (self, ...)
   return self:new(...)
end }

return function(name)
   local class = {name  = name, new   = new}

   class.class = class
   class.__index = class
   return setmetatable(class, mt)
end
