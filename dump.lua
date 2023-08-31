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
  elseif type(value) == "table" then
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

---@param t table<any>
---@param seen table
---@param indent string
return function(t, seen, indent)
  seen = seen or {}
  indent = indent or ""


  if type(t) ~= "table" then
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
