---@param t table<any>
---@param seen table
---@param indent string
return function (t, seen, indent)
    seen = seen or {}
    indent = indent or ""
    if type (t) ~= "table" then
      return tostring (t)
    end
  
    if seen [t] then
      return "<circular reference>"
    end
    seen [t] = true
  
    local res = {}
    for k, v in pairs (t) do
      local k_str = "<" .. type (k) .. "> [" .. dump (k, seen, indent .. "") .."]"
      local v_str
      if type (v) == "function" then
        -- 如果是函数，同时输出 debug 信息
        local info = debug.getinfo (v, "Slnuf")
        v_str = tostring (v) .. "\n"
        for key, value in pairs (info) do
          v_str = v_str .. indent .. "" .. key ..": ".. tostring (value) .."\n"
        end
       elseif type (v) == "table" then
        -- 如果是表，则递归处理子表
        v_str = dump (v, seen, indent .. " ")
        if getmetatable (v) then
          -- 如果有元表，则额外输出元表
          v_str = v_str .. "\n" .. indent .. "<metatable> =" .. dump (getmetatable (v), seen, indent .. " ")
        end
        v_str = "<" .. type (v) .. ">" .. v_str
       else
        -- 否则直接输出值
        v_str = "<" .. type (v) .. ">" .. tostring (v)
      end
      table.insert (res, indent .. k_str .. "=" .. v_str)
    end
    return "{\n" .. table.concat (res, ",\n") .. "\n".. indent .. "}"
  end