local _M = {}

_M.getSystemName = function()
  local path = package.cpath
  if path:match("%.so") then
---@diagnostic disable-next-line: undefined-global
    if activity and luajava and this then
      return "Android"
     else
      return "Linux"
    end
   elseif path:match("%.dll") then
    return "Windows"
   elseif path:match("%.dylib") then
    return "macOS"
   else
    error("UnknownOperatingSystemExecption", 0)
  end
end

return _M