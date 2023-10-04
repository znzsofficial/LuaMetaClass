-- 一个还不完善的注解
---@param var any
---@param param string
---@return any<table>
local function annotation(var, param)
    if type(var) == "function" then
        return setmetatable({ param = param },
            {
                __call = function(_, ...)
                    return var(...)
                end,
                __type = type(var),
                __newindex = (function()
                    return nil
                end),
                __index = (function()
                    return nil
                end),
                __len = (function()
                    return nil
                end),
            })
    elseif type(var) == "table" then
        error("InvalidArgumentException : Attempt to annotate a table value")
    else
        return setmetatable({ param = param },
            {
                __tostring = (function()
                    return var
                end),
                __type = type(var),
                __newindex = (function()
                    return nil
                end),
                __index = (function()
                    return nil
                end),
                __len = (function()
                    return #var
                end),
            })
    end
end

return annotation
