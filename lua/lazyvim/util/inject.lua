---@class lazyvim.util.inject
local M = {}

---@generic A: any
---@generic B: any
---@generic C: any
---@generic F: function
---@param fn F|fun(a:A, b:B, c:C)
---@param wrapper fun(a:A, b:B, c:C): boolean?
---@return F
function M.args(fn, wrapper)
  if type(fn) ~= "function" then
    LazyVim.error("LazyVim.inject.args: fn must be a function")
    return function() end
  end
  if type(wrapper) ~= "function" then
    LazyVim.error("LazyVim.inject.args: wrapper must be a function")
    return fn
  end
  
  return function(...)
    local ok, result = pcall(wrapper, ...)
    if not ok then
      LazyVim.error(("LazyVim.inject.args: wrapper error: %s"):format(result))
      return fn(...)
    end
    if result == false then
      return
    end
    return fn(...)
  end
end

function M.get_upvalue(func, name)
  if type(func) ~= "function" then
    return nil
  end
  if not name or type(name) ~= "string" or name == "" then
    return nil
  end
  
  local i = 1
  while true do
    local n, v = debug.getupvalue(func, i)
    if not n then
      break
    end
    if n == name then
      return v
    end
    i = i + 1
  end
  return nil
end

function M.set_upvalue(func, name, value)
  if type(func) ~= "function" then
    LazyVim.error("LazyVim.inject.set_upvalue: func must be a function")
    return false
  end
  if not name or type(name) ~= "string" or name == "" then
    LazyVim.error("LazyVim.inject.set_upvalue: name must be a non-empty string")
    return false
  end
  
  local i = 1
  while true do
    local n = debug.getupvalue(func, i)
    if not n then
      break
    end
    if n == name then
      debug.setupvalue(func, i, value)
      return true
    end
    i = i + 1
  end
  LazyVim.error("upvalue not found: " .. name)
  return false
end

return M
