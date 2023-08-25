local app = function()
    ---@param orig any
    ---@param copies any|nil
    ---@return any
    function table.clone(orig, copies)
        copies = copies or {} -- 用于存储已拷贝的表及其副本

        if type(orig) ~= "table" then
            return orig
        end

        if copies[orig] then
            return copies[orig] -- 如果已拷贝过该表，则直接返回对应的拷贝表
        end

        local copy = {}
        copies[orig] = copy -- 将原表和拷贝表存储到 copies 表中

        for orig_key, orig_value in pairs(orig) do
            copy[table.clone(orig_key, copies)] = table.clone(orig_value, copies)
        end

        setmetatable(copy, table.clone(getmetatable(orig), copies))
        return copy
    end

    -- 拓展布尔类型
    debug.setmetatable(false,
        {
            __index =
            {
                ---@param self boolean
                ---@return boolean
                ["not"] = function(self)
                    return not self
                end,
                ---@param self boolean
                ---@return string
                toString = function(self)
                    return tostring(self)
                end,
                ---@param x boolean
                ---@param y boolean
                ---@return integer
                compareTo = function(x, y)
                    return (x == y) and 0 or (x and 1 or -1)
                    -- return (x and 1 or 0) - (y and 1 or 0)
                end,
                ---@param x boolean
                ---@param y boolean
                ---@return boolean
                equals = function(x, y)
                    return x == y
                end,
                ---@param x boolean
                ---@param y boolean
                ---@return boolean
                xor = function(x, y)
                    return (x and not y) or (not x and y)
                end,
                ---@param x boolean
                ---@param y boolean
                ---@return boolean
                ["or"] = function(x, y)
                    return x or y
                end
            },
        })

    _G.private = require("annotations.private")
    _G.public = require("annotations.public")
    _G.null = require("Null")
    _G.class = require("class")
end

return app
