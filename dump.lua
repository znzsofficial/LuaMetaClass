---@param t table
---@param seen table|nil
---@param indent string|nil
return function(t, seen, indent)
  seen = seen or {}
  indent = indent or ""

  local function processValue(value)
    if type(value) == "function" then
      -- 函数类型处理
      local info = debug.getinfo(value, "Slnuf")
      local infoStr = ""
      for key, value in pairs(info) do
        if key ~= "func" and value ~= "" then
          infoStr = infoStr .. indent .. "" .. key .. ": " .. tostring(value) .. "\n"
        end
      end
      return "<function>" .. tostring(value) .. "\n" .. infoStr
    elseif type(value) == "table" or type(value) == "class" or type(value) == "object" then
      -- 表类型处理
      local str = dump(value, seen, indent .. " ")
      if getmetatable(value) then
        str = str .. "\n" .. indent .. "<metatable> =" .. dump(getmetatable(value), seen, indent .. " ")
      end
      return "<table>" .. str
    elseif type(value) == "string" then
      -- 字符串类型处理
      return "<string> \"" .. tostring(value) .. "\""
    else
      -- 其他类型直接返回
      return "<" .. type(value) .. ">" .. tostring(value)
    end
  end

  if not (type(t) == "table" or type(t) == "class" or type(t) == "object") then
    return tostring(t)
  end

  if seen[t] then
    return "<circular reference>"
  end
  seen[t] = true

  local res = {}
  for k, v in pairs(t) do
    local kStr = processValue(k)
    local vStr = processValue(v)
    table.insert(res, indent .. kStr .. "=" .. vStr)
  end

  return "{\n" .. table.concat(res, ",\n") .. "\n" .. indent .. "}"
end
