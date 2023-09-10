local _type = type
---@param value any
---@return string
return function(value)
    local mt = getmetatable(value)
    if mt and _type(mt.__type) == "string" then
        return mt.__type
    else
        return _type(value)
    end
end
