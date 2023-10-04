return function()
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

    -- 将math作为number类型的元表
    debug.setmetatable(0, { __index = math })
    -- 将字符串类型的元表修改为utf8和string混合
    debug.setmetatable("", { __index = setmetatable(utf8, { __index = string }) })
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

    --使 type 函数支持读取 __type
    _G.type = require("type")
    _G.dump = require("dump")
    _G.null = require("null")
    _G.extends = require("extends")
    _G.class = require("class")
    _G.object = require("object")
end
