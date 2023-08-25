---@class Null
return setmetatable({}, {
    __tostring = (function()
        return "null"
    end),
    __type = (function()
        return "null"
    end),
    __call = (function()
        return nil
    end),
    __newindex = (function()
        return nil
    end),
    __index = (function()
        return nil
    end),
    __len = (function()
        return nil
    end),
    __concat = (function()
        return nil
    end),
    __metatable = nil,
})
