local app = function()
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

    _G.null = require("Null")
    _G.class = require("class")
end

return app
